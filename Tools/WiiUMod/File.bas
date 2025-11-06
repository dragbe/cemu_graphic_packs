Attribute VB_Name = "File"
Option Explicit
Private Declare PtrSafe Function SHFileOperation Lib "shell32.dll" Alias "SHFileOperationW" (lpFileOp As FILE_SHFILEOPSTRUCT) As Long
Private Declare PtrSafe Function GetTempFileName Lib "kernel32" Alias "GetTempFileNameA" (ByVal lpszPath As String, ByVal lpPrefixString As String, ByVal wUnique As Long, ByVal lpTempFileName As String) As Long
Private Declare PtrSafe Function CreateFile Lib "kernel32.dll" Alias "CreateFileA" (ByVal lpFileName As String, ByVal dwDesiredAccess As Long, ByVal dwShareMode As Long, ByVal lpSecurityAttributes As LongPtr, ByVal dwCreationDisposition As Long, ByVal dwFlagsAndAttributes As Long, ByVal hTemplateFile As Long) As Long
Private Declare PtrSafe Function GetFileTime Lib "kernel32.dll" (ByVal hFile As Long, ByVal lpCreationTime As LongPtr, ByVal lpLastAccessTime As LongPtr, ByVal lpLastWriteTime As LongPtr) As Long
Public Declare PtrSafe Function GetPrivateProfileString Lib "kernel32" Alias "GetPrivateProfileStringA" (ByVal lpApplicationName As String, ByVal lpKeyName As Any, ByVal lpDefault As String, ByVal lpReturnedString As String, ByVal nSize As Long, ByVal lpFileName As String) As Long
Public Declare PtrSafe Function CopyFile Lib "kernel32.dll" Alias "CopyFileA" (ByVal lpExistingFileName As String, ByVal lpNewFileName As String, ByVal bFailIfExists As Long) As Long
Public Const FILE_ACCESS_GENERIC_READ As Long = &H80000000
Public Const FILE_SHARE_READ As Long = &H1
Public Const FILE_OPEN_EXISTING As Long = 3
Public Const FILE_ATTRIBUTE_ARCHIVE As Long = &H20
Public Const FILE_MAXPATH As Long = 260
Public Const FILE_READ_BUFFERSIZE As Long = &H4000
Private Type FILE_SHFILEOPSTRUCT
    hWnd As LongPtr
    wFunc As Long
    pFrom As LongPtr
    pTo As LongPtr
    fFlags As Integer
    fAnyOperationsAborted As Boolean
    hNameMappings As LongPtr
    lpszProgressTitle As LongPtr
End Type
Public Enum FILE_SHELL_OPERATIONS
    SHELL_MOVE_OPERATION = &H1
    SHELL_COPY_OPERATION = &H2
    SHELL_DELETE_OPERATION = &H3
    SHELL_RENAME_OPERATION = &H4
End Enum
Public Enum FILE_TIMESTAMPS
    FILE_TIMESTAMP_CREATION = 1
    FILE_TIMESTAMP_ACCESS = 2
    FILE_TIMESTAMP_WRITE = 3
End Enum
Private Type stTextFilterRule
    strRegexp As String
    intMatchesMaxCount As Integer
End Type
Private Type stTextFilterRules
    stFilters(0 To 255) As stTextFilterRule
    intFiltersCount As Integer
End Type
Public Type stExtractedTextData
    lngLine As Long
    objData As Object
End Type
Private Type stBytes
    btBytes() As Byte
End Type
Private stTextFilters As stTextFilterRules
Public btReadBuffer(0 To FILE_READ_BUFFERSIZE - 1) As Byte
Public Function FILE_DoShellOperation(ByVal SHELL_OPERATION As FILE_SHELL_OPERATIONS, ByVal strSrcShellItemPath As String, Optional ByVal strDestShellItemPath As String = "") As Long
'https://learn.microsoft.com/en-us/windows/win32/debug/system-error-codes--0-499-?redirectedfrom=MSDN for returned result values
Dim stShFileOperation As FILE_SHFILEOPSTRUCT
    strSrcShellItemPath = strSrcShellItemPath + VBSTRING_WIDENULLCHAR
    strDestShellItemPath = strDestShellItemPath + VBSTRING_WIDENULLCHAR
    With stShFileOperation
        .hWnd = 0 'No UI
        .wFunc = SHELL_OPERATION
        .pFrom = StrPtr(strSrcShellItemPath)
        .pTo = StrPtr(strDestShellItemPath)
        .fFlags = &H14 '&H10 or &H4 (no confirmation + silent)
        .fAnyOperationsAborted = False 'Tracks if the operation was aborted
        .hNameMappings = 0
        .lpszProgressTitle = 0
    End With
    FILE_DoShellOperation = SHFileOperation(stShFileOperation)
End Function
Public Sub File_DeleteFolders(ParamArray varFolderPaths() As Variant)
Dim i As Long
    For i = UBound(varFolderPaths) To 0 Step -1
        FILE_DoShellOperation SHELL_DELETE_OPERATION, varFolderPaths(i)
    Next i
End Sub
Public Sub File_DeleteFiles(ParamArray varFilePaths() As Variant)
Dim i As Long
    For i = UBound(varFilePaths) To 0 Step -1
        Kill varFilePaths(i)
    Next i
End Sub
Public Function File_GetTimestamp(ByRef strFilename As String, Optional ByRef FILE_TIMESTAMP_TYPE As FILE_TIMESTAMPS = FILE_TIMESTAMP_WRITE) As LongLong
Static lngLngTimestamps(FILE_TIMESTAMP_CREATION To FILE_TIMESTAMP_WRITE) As LongLong
Dim lngHFile As Long
    lngHFile = CreateFile(strFilename, FILE_ACCESS_GENERIC_READ, FILE_SHARE_READ, 0, FILE_OPEN_EXISTING, FILE_ATTRIBUTE_ARCHIVE, 0)
    If lngHFile = -1 Then
        lngLngTimestamps(FILE_TIMESTAMP_TYPE) = 0
    Else
        GetFileTime lngHFile, VarPtr(lngLngTimestamps(FILE_TIMESTAMP_CREATION)), VarPtr(lngLngTimestamps(FILE_TIMESTAMP_ACCESS)), VarPtr(lngLngTimestamps(FILE_TIMESTAMP_WRITE))
        CloseHandle lngHFile
    End If
    File_GetTimestamp = lngLngTimestamps(FILE_TIMESTAMP_TYPE)
End Function
Private Function File_InitTextFilters(ByVal strTextFiltersSource As String, Optional ByVal lngTargetDataMask As Long = 0) As Integer
Dim lngFiltersCount As Long
Dim xlsTextFiltersRange As Range
Dim lngFile As Long
Dim lngPos As Long
    stTextFilters.intFiltersCount = 0
    If lngTargetDataMask <= 0 Then
        If Left(strTextFiltersSource, 1) = vbLf Then
            lngFile = 2
            lngFiltersCount = InStr(2, strTextFiltersSource, vbLf)
            Do Until lngFiltersCount = 0 Or stTextFilters.intFiltersCount = 256
                strTextFiltersSource = Mid(strTextFiltersSource, lngFile, lngFiltersCount - lngFile)
                GoSub File_InitTextFiltersSub2
                lngFile = lngFiltersCount + 1
                lngFiltersCount = InStr(lngFile, strTextFiltersSource, vbLf)
            Loop
            If stTextFilters.intFiltersCount < 256 Then
                strTextFiltersSource = Mid(strTextFiltersSource, lngFile)
                GoSub File_InitTextFiltersSub2
            End If
        ElseIf InStr(strTextFiltersSource, "\") <> 0 Then
            lngFile = FreeFile
            Open strTextFiltersSource For Input As lngFile
            Do Until EOF(lngFile) Or stTextFilters.intFiltersCount = 256
                Line Input #lngFile, strTextFiltersSource
                GoSub File_InitTextFiltersSub2
            Loop
            Close lngFile
        Else
            GoSub File_InitTextFiltersSub3
            Do Until strTextFiltersSource = "" Or stTextFilters.intFiltersCount = 256 Or lngFiltersCount > xlsTextFiltersRange.Rows.Count
                GoSub File_InitTextFiltersSub1
                lngFiltersCount = lngFiltersCount + 1
                strTextFiltersSource = xlsTextFiltersRange.Item(lngFiltersCount, 1).Text
            Loop
            Set xlsTextFiltersRange = Nothing
        End If
    Else
        If Left(strTextFiltersSource, 1) = vbLf Then
            lngFile = 2
            lngPos = InStr(2, strTextFiltersSource, vbLf)
            Do Until lngPos = 0 Or stTextFilters.intFiltersCount = 256 Or lngFiltersCount = 31
                strTextFiltersSource = Mid(strTextFiltersSource, lngFile, lngPos - lngFile)
                If (lngTargetDataMask And (2^ ^ lngFiltersCount)) <> 0 Then GoSub File_InitTextFiltersSub2
                lngFiltersCount = lngFiltersCount + 1
                lngFile = lngPos + 1
                lngPos = InStr(lngFile, strTextFiltersSource, vbLf)
            Loop
            If stTextFilters.intFiltersCount < 256 And lngFiltersCount < 31 Then
                If (lngTargetDataMask And (2^ ^ lngFiltersCount)) <> 0 Then
                    strTextFiltersSource = Mid(strTextFiltersSource, lngFile)
                    GoSub File_InitTextFiltersSub2
                End If
            End If
        ElseIf InStr(strTextFiltersSource, "\") <> 0 Then
            lngFile = FreeFile
            Open strTextFiltersSource For Input As lngFile
            Do Until EOF(lngFile) Or lngFiltersCount = 31
                Line Input #lngFile, strTextFiltersSource
                If (lngTargetDataMask And (2^ ^ lngFiltersCount)) <> 0 Then GoSub File_InitTextFiltersSub2
                lngFiltersCount = lngFiltersCount + 1
            Loop
            Close lngFile
        Else
            GoSub File_InitTextFiltersSub3
            Do Until strTextFiltersSource = "" Or lngFiltersCount = 32 Or lngFiltersCount > xlsTextFiltersRange.Rows.Count
                If (lngTargetDataMask And (2^ ^ (lngFiltersCount - 1))) <> 0 Then GoSub File_InitTextFiltersSub1
                lngFiltersCount = lngFiltersCount + 1
                strTextFiltersSource = xlsTextFiltersRange.Item(lngFiltersCount, 1).Text
            Loop
            Set xlsTextFiltersRange = Nothing
        End If
    End If
    Exit Function
File_InitTextFiltersSub1:
    With stTextFilters.stFilters(stTextFilters.intFiltersCount)
    .strRegexp = xlsTextFiltersRange.Item(lngFiltersCount, 2).Text
    .intMatchesMaxCount = xlsTextFiltersRange.Item(lngFiltersCount, 3).Value
    File_InitTextFilters = File_InitTextFilters + .intMatchesMaxCount
    End With
    stTextFilters.intFiltersCount = stTextFilters.intFiltersCount + 1
    Return
File_InitTextFiltersSub2:
    With stTextFilters.stFilters(stTextFilters.intFiltersCount)
    .intMatchesMaxCount = InStr(strTextFiltersSource, " ")
    If .intMatchesMaxCount = 0 Then
        .intMatchesMaxCount = 1
        .strRegexp = strTextFiltersSource
    Else
        .strRegexp = Left(strTextFiltersSource, .intMatchesMaxCount - 1)
        If IsNumeric(.strRegexp) Then
            .intMatchesMaxCount = CInt(.strRegexp)
            .strRegexp = Mid(strTextFiltersSource, .intMatchesMaxCount + 1)
        Else
            .intMatchesMaxCount = 1
            .strRegexp = strTextFiltersSource
        End If
    End If
    File_InitTextFilters = File_InitTextFilters + .intMatchesMaxCount
    End With
    stTextFilters.intFiltersCount = stTextFilters.intFiltersCount + 1
    Return
File_InitTextFiltersSub3:
    lngFiltersCount = InStr(strTextFiltersSource, ".")
    Set xlsTextFiltersRange = Worksheets(Left(strTextFiltersSource, lngFiltersCount - 1)).Range(Mid(strTextFiltersSource, lngFiltersCount + 1)).Cells
    lngFiltersCount = 1
    strTextFiltersSource = xlsTextFiltersRange.Item(1, 1).Text
    Return
End Function
Public Function File_ExtractText(ByVal strTextFiltersSource As String, ByRef stExtractedTextDatas() As stExtractedTextData, Optional ByVal strFilePath As String = "", Optional ByVal lngTargetDataMask As Long = 0) As Long
Dim objRegExp As Object
Dim i As Integer
Dim objMatchCollection As Object
Dim lngOffset As Long
Dim lngNextOffset As Long
Dim lngCurrentLine As Long
    File_ExtractText = File_InitTextFilters(strTextFiltersSource, lngTargetDataMask)
    If File_ExtractText > 0 Then
        If lngTargetDataMask < 0 Then
            lngTargetDataMask = -lngTargetDataMask
        Else
            lngTargetDataMask = -1
        End If
        ReDim stExtractedTextDatas(1 To File_ExtractText)
        Set objRegExp = CreateObject("VBScript.RegExp")
        File_ExtractText = 0
        If strFilePath = "" Then
            strTextFiltersSource = System_Clipboard
            lngOffset = 1
            lngNextOffset = InStr(1, strTextFiltersSource, vbCrLf)
            Do Until lngNextOffset = 0 Or stTextFilters.stFilters(0).intMatchesMaxCount = 0 Or File_ExtractText = lngTargetDataMask
                strFilePath = Mid(strTextFiltersSource, lngOffset, lngNextOffset - lngOffset)
                GoSub File_ExtractTextSub
                lngOffset = lngNextOffset + 2
                lngNextOffset = InStr(lngOffset, strTextFiltersSource, vbCrLf)
            Loop
            strFilePath = Mid(strTextFiltersSource, lngOffset)
            GoSub File_ExtractTextSub
        Else
            lngOffset = FreeFile
            Open strFilePath For Input As lngOffset
            Do Until EOF(lngOffset) Or stTextFilters.stFilters(0).intMatchesMaxCount = 0 Or File_ExtractText = lngTargetDataMask
                Line Input #lngOffset, strFilePath
                GoSub File_ExtractTextSub
            Loop
            Close lngOffset
        End If
        Set objRegExp = Nothing
    End If
    Exit Function
File_ExtractTextSub:
    lngCurrentLine = lngCurrentLine + 1
    For i = stTextFilters.intFiltersCount - 1 To 0 Step -1
        With stTextFilters.stFilters(i)
        objRegExp.Pattern = .strRegexp
        Set objMatchCollection = objRegExp.Execute(strFilePath)
        If objMatchCollection.Count <> 0 Then
            File_ExtractText = File_ExtractText + 1
            stExtractedTextDatas(File_ExtractText).lngLine = lngCurrentLine
            Set stExtractedTextDatas(File_ExtractText).objData = objMatchCollection
            .intMatchesMaxCount = .intMatchesMaxCount - 1
            If i <> 0 Then
                If .intMatchesMaxCount = 0 Then
                    stTextFilters.intFiltersCount = stTextFilters.intFiltersCount - 1
                    stTextFilters.stFilters(i) = stTextFilters.stFilters(stTextFilters.intFiltersCount)
                End If
                i = 0
            End If
        End If
        Set objMatchCollection = Nothing
        End With
    Next i
    Return
End Function
Public Sub File_ReadLongDataSegment(ByVal intFile As Integer, ByVal lngOffset As Long, ByVal lngDataCount As Long, ByRef lngDataSegment() As Long, Optional ByVal lngStartIndex As Long = 1)
    ReDim lngDataSegment(lngStartIndex To lngDataCount + lngStartIndex - 1)
    Get intFile, lngOffset, lngDataSegment
End Sub
Public Function File_GetMappedData(ByVal intFile As Integer, ByVal lngDeltaOffset As Long, ByRef lngLowerOffsets() As Long) As Long
Dim i As Long
    For i = UBound(lngLowerOffsets) To 0 Step -1
        Get intFile, File_GetMappedData + lngLowerOffsets(i) - lngDeltaOffset + 1, File_GetMappedData
        File_GetMappedData = Converter_SwapEndian32(File_GetMappedData)
    Next i
End Function
Public Function File_ReadCmp256(ByVal intInFile As Integer, ByRef ptrData As LongPtr, ByVal intDataSize As Integer) As Long
Static btBytes(0 To 255) As Byte
    Get intInFile, , btBytes
    File_ReadCmp256 = CompareMemory(VarPtr(btBytes(0)), ptrData, intDataSize)
End Function
Public Function File_GetDumpOffset(ByRef strDumpFileBasename As String) As Long
Dim objRegExp As Object
    Set objRegExp = CreateObject("VBScript.RegExp")
    With objRegExp
    .Pattern = "^[0-9a-fA-F]{8}.bin$"
    If .test(strDumpFileBasename) Then File_GetDumpOffset = CLng("&H" + Left(strDumpFileBasename, 8))
    End With
    Set objRegExp = Nothing
End Function
Public Sub File_SkipLines(ByVal intFile As Integer, ByVal lngSkipLinesCount As Long)
Dim strLine As String
    Do Until EOF(intFile) Or lngSkipLinesCount < 1
        Line Input #intFile, strLine
        lngSkipLinesCount = lngSkipLinesCount - 1
    Loop
End Sub
Public Function File_GetTempFilePath(Optional ByRef strPrefix As String = "tmp") As String
    File_GetTempFilePath = Space(FILE_MAXPATH)
    If GetTempFileName(System_GetTempFolderPath(), strPrefix, 0, File_GetTempFilePath) = 0 Then
        File_GetTempFilePath = ""
    Else
        File_GetTempFilePath = Left(File_GetTempFilePath, InStr(File_GetTempFilePath, vbNullChar) - 1)
    End If
End Function
Public Function File_SearchNeighborBinData(ByRef strFile As String, ByRef strSearchByteSequences As String, ByRef strByteSequencesDelimiter As String, Optional ByVal intNeighborhoodWindowOffset As Integer = 160, Optional ByVal intNeighborhoodType As Integer = 0) As Long
'Usage example with the immediate window: ?File_SearchNeighborBinData("D:\WiiU\default\dump\02000000.bin","$2E20|$1054","|")
'Possible minor bugs due to a simplified algorithm
Dim stSearchByteSequence As stDataMap
Dim stSearchBytes() As stBytes
Dim strByteSequences() As String
Dim intFile As Integer
Dim lngOffset As Long
    strByteSequences = Split(strSearchByteSequences, strByteSequencesDelimiter)
    With stSearchByteSequence
    .lngDataSize = Vector_Cbytes(strByteSequences(0), .btData)
    ReDim .lngLowerOffsets(0 To 0)
    .lngLowerOffsets(0) = 1
    intFile = FreeFile
    Open strFile For Binary Access Read As intFile
    Do Until EOF(intFile)
        Get intFile, .lngLowerOffsets(File_SearchNeighborBinData), btReadBuffer
        lngOffset = Vector_InBytes(1, btReadBuffer, .btData, -32768)
        If lngOffset = -32768 Then
            .lngLowerOffsets(File_SearchNeighborBinData) = .lngLowerOffsets(File_SearchNeighborBinData) + FILE_READ_BUFFERSIZE
        Else
            .lngLowerOffsets(File_SearchNeighborBinData) = .lngLowerOffsets(File_SearchNeighborBinData) + lngOffset
            File_SearchNeighborBinData = File_SearchNeighborBinData + 1
            ReDim Preserve .lngLowerOffsets(0 To File_SearchNeighborBinData)
            .lngLowerOffsets(File_SearchNeighborBinData) = .lngLowerOffsets(File_SearchNeighborBinData - 1) + .lngDataSize
        End If
    Loop
    If File_SearchNeighborBinData <> 0 Then
        Erase .btData
        ReDim .btData(1 To (2 - Abs(intNeighborhoodType)) * intNeighborhoodWindowOffset + .lngDataSize)
        If intNeighborhoodType > 0 Then intNeighborhoodWindowOffset = 0
        .lngDataSize = UBound(strByteSequences)
        ReDim stSearchBytes(1 To .lngDataSize)
        For lngOffset = .lngDataSize To 1 Step -1
            Vector_Cbytes strByteSequences(lngOffset), stSearchBytes(lngOffset).btBytes
        Next lngOffset
        Do
            File_SearchNeighborBinData = File_SearchNeighborBinData - 1
            strByteSequences(0) = Hex(.lngLowerOffsets(File_SearchNeighborBinData))
            .lngLowerOffsets(File_SearchNeighborBinData) = .lngLowerOffsets(File_SearchNeighborBinData) - intNeighborhoodWindowOffset
            If .lngLowerOffsets(File_SearchNeighborBinData) < 1 Then
                Get intFile, 1, .btData
            Else
                Get intFile, .lngLowerOffsets(File_SearchNeighborBinData), .btData
            End If
            For lngOffset = .lngDataSize To 1 Step -1
                If Vector_InBytes(1, .btData, stSearchBytes(lngOffset).btBytes) = 0 Then Exit For
            Next lngOffset
            If lngOffset = 0 Then Debug.Print strByteSequences(0)
        Loop Until File_SearchNeighborBinData = 0
        For lngOffset = .lngDataSize To 1 Step -1
            Erase stSearchBytes(lngOffset).btBytes
        Next lngOffset
        Erase stSearchBytes
    End If
    Close intFile
    Erase .btData
    Erase .lngLowerOffsets
    Erase strByteSequences
    End With
End Function
Public Function File_Create(ByRef strFilename As String, Optional ByRef btMode As Byte = 0, Optional ByRef blnOverwrite As Boolean = True) As Integer
    File_Create = FreeFile
    Select Case btMode
        Case 0 'text mode access write
            If blnOverwrite Then
                Open strFilename For Output As File_Create
            Else
                Open strFilename For Append As File_Create
            End If
        Case 1 'binary mode access write
            If blnOverwrite Then
                If Dir(strFilename, vbNormal) <> "" Then Kill strFilename
            End If
            Open strFilename For Binary Access Write As File_Create
        Case Else
    End Select
End Function
Public Function File_IniReadSetting(ByRef strIniFilename As String, ByRef strAppName As String, ByRef strKeyName As String, Optional ByRef strDefault As String = "") As String
    File_IniReadSetting = String(256, 0)
    File_IniReadSetting = Left(File_IniReadSetting, GetPrivateProfileString(strAppName, strKeyName, strDefault, File_IniReadSetting, 256, strIniFilename))
End Function
Public Sub File_ReadContent(ByRef strFilename As String, ByRef btContent() As Byte)
Dim intFile As Integer
    intFile = FreeFile
    Open strFilename For Binary Access Read As intFile
    Get intFile, , btContent
    Close intFile
End Sub
Public Function File_GetContent(ByRef strFilename As String, ByRef btContent() As Byte, Optional ByRef lngBaseIndex As Long = 0) As Long
    File_GetContent = FileLen(strFilename)
    ReDim btContent(lngBaseIndex To File_GetContent - 1 + lngBaseIndex)
    Call File_ReadContent(strFilename, btContent)
End Function
Public Function File_GetLines(ByVal strFilename As String, Optional ByVal lngSkipLinesCount As Long = 0, Optional ByVal lngMaxLinesCount As Long = 0) As String()
Dim intFile As Integer
Dim varout() As String
Dim lngUbound As Long
Dim lngTemp As Long
Dim lngNewUbound As Long
    intFile = FreeFile
    Open strFilename For Input As intFile
    If lngSkipLinesCount < 0 Then
        lngSkipLinesCount = -lngSkipLinesCount
        If lngMaxLinesCount > 0 Then
            GoSub File_GetLinesSub0
            If lngUbound <> lngMaxLinesCount Then
                GoSub File_GetLinesSub2
            Else
                lngTemp = lngMaxLinesCount
                lngMaxLinesCount = lngMaxLinesCount + lngSkipLinesCount
                GoSub File_GetLinesSub0
                If lngUbound <> lngMaxLinesCount Then
                    GoSub File_GetLinesSub2
                    If lngTemp < lngNewUbound Then
                        lngMaxLinesCount = lngNewUbound - lngTemp
                        For lngSkipLinesCount = 1 To lngTemp
                            varout(lngSkipLinesCount) = varout(lngMaxLinesCount + lngSkipLinesCount)
                        Next lngSkipLinesCount
                        ReDim Preserve varout(1 To lngTemp)
                    End If
                Else
                    ReDim Preserve varout(1 To lngTemp)
                End If
            End If
        ElseIf lngMaxLinesCount = 0 Then
            GoSub File_GetLinesSub1
            GoSub File_GetLinesSub2
        Else
            lngTemp = -lngMaxLinesCount
            lngMaxLinesCount = lngSkipLinesCount - lngMaxLinesCount
            GoSub File_GetLinesSub0
            If lngUbound <> lngMaxLinesCount Then
                GoSub File_GetLinesSub2
            Else
                GoSub File_GetLinesSub3
                ReDim Preserve varout(1 To lngTemp)
            End If
        End If
    Else
        Call File_SkipLines(intFile, lngSkipLinesCount)
        If lngMaxLinesCount > 0 Then
            GoSub File_GetLinesSub0
            If lngUbound <> lngMaxLinesCount Then GoSub File_GetLinesSub4
        ElseIf lngMaxLinesCount = 0 Then
            GoSub File_GetLinesSub1
        Else
            lngMaxLinesCount = -lngMaxLinesCount
            GoSub File_GetLinesSub0
            If lngUbound <> lngMaxLinesCount Then
                GoSub File_GetLinesSub4
            Else
                GoSub File_GetLinesSub3
            End If
        End If
    End If
    Close intFile
    File_GetLines = varout
    Exit Function
File_GetLinesSub0:
    ReDim Preserve varout(1 To lngMaxLinesCount)
    Do Until EOF(intFile) Or lngUbound = lngMaxLinesCount
        lngUbound = lngUbound + 1
        Line Input #intFile, varout(lngUbound)
    Loop
    Return
File_GetLinesSub1:
    Do Until EOF(intFile)
        lngUbound = lngUbound + 1
        ReDim Preserve varout(1 To lngUbound)
        Line Input #intFile, varout(lngUbound)
    Loop
    Return
File_GetLinesSub2:
    lngNewUbound = lngUbound - lngSkipLinesCount
    If lngSkipLinesCount < lngUbound Then
        ReDim Preserve varout(1 To lngNewUbound)
    Else
        Erase varout
    End If
    Return
File_GetLinesSub3:
    Do Until EOF(intFile)
        For lngSkipLinesCount = 2 To lngMaxLinesCount
            varout(lngSkipLinesCount - 1) = varout(lngSkipLinesCount)
        Next lngSkipLinesCount
        Line Input #intFile, varout(lngUbound)
    Loop
    Return
File_GetLinesSub4:
    If lngUbound = 0 Then
        Erase varout
    Else
        ReDim Preserve varout(1 To lngUbound)
    End If
    Return
End Function
Public Function File_GetMostRecentFileDir(ByRef strDirectory As String, ByVal strFolderName As String, ByRef strFileBasename As String, Optional ByVal lngLngMinFileTimestamp As LongLong = 0) As String
Dim lngLngCurrentFileTimestamp As LongLong
    strFolderName = Dir(strDirectory + strFolderName, vbDirectory)
    If strFolderName <> "" Then
        Do
            strFolderName = strDirectory + strFolderName + "\"
            lngLngCurrentFileTimestamp = File_GetTimestamp(strFolderName + strFileBasename)
            If lngLngCurrentFileTimestamp > lngLngMinFileTimestamp Then
                File_GetMostRecentFileDir = strFolderName
                lngLngMinFileTimestamp = lngLngCurrentFileTimestamp
            End If
            strFolderName = Dir
        Loop Until strFolderName = ""
    End If
End Function
Public Function File_GetInteger(ByVal intFile As Integer, ByVal lngDataAddress As Long, ByVal btDataSize As Byte) As LongLong
    Get intFile, lngDataAddress, File_GetInteger
    If btDataSize < 8 Then File_GetInteger = File_GetInteger And (256^ ^ btDataSize - 1)
End Function
Public Sub File_WriteContent(ByRef strFilename As String, ByRef btContent() As Byte)
Dim intFile As Integer
    intFile = FreeFile
    Open strFilename For Binary Access Write As intFile
    Put intFile, , btContent
    Close intFile
End Sub
Public Sub File_WriteTextContent(ByRef strFilename As String, ByRef strContent As String, Optional ByRef blnOverwrite As Boolean = True)
Dim intFile As Integer
    intFile = FreeFile
    If blnOverwrite Then
        Open strFilename For Output As intFile
    Else
        Open strFilename For Append As intFile
    End If
    Print #intFile, strContent
    Close intFile
End Sub
Public Function File_GetFolder(ByRef strFilename As String) As String
Dim lngLastSlash As Long
Dim lngSlash As Long
    lngLastSlash = InStrRev(strFilename, "\")
    If lngLastSlash <> 0 Then
        lngSlash = InStrRev(strFilename, "\", lngLastSlash - 1) + 1
        File_GetFolder = Mid(strFilename, lngSlash, lngLastSlash - lngSlash)
    End If
End Function
Public Function File_GetTextContent(ByRef strFilename As String, Optional ByVal blnUnixFormat As Boolean = False) As String
Dim intFile As Integer
    intFile = FreeFile
    If blnUnixFormat Then
        Open strFilename For Input As intFile
        Line Input #intFile, File_GetTextContent
    Else
        Open strFilename For Binary Access Read As intFile
        File_GetTextContent = Space(LOF(intFile))
        Get intFile, , File_GetTextContent
    End If
    Close intFile
End Function
Public Function File_PatchText(ByVal strSrcFilePath As String, ByVal strDestFilePath As String, ByVal strPatchesFilePath As String) As Long
Dim objRegExp As Object
Dim objMatchCollection As Object
Dim intSrcFile As Integer
Dim intDestFile As Integer
Dim intPatchesFile As Integer
Dim lngOffset As Long
Dim lngChar41Offset As Long
Dim lngOldChar41Offset As Long
Dim i As Long
Dim objSubRegExp As Object
Dim strPatchLines() As String
Dim j As Long
Dim lngStartOffset As Long
Dim lngUbound As Long
    Set objRegExp = CreateObject("VBScript.RegExp")
    intSrcFile = FreeFile
    Open strSrcFilePath For Input As intSrcFile
    intDestFile = FreeFile
    Open strDestFilePath For Output As intDestFile
    intPatchesFile = FreeFile
    Open strPatchesFilePath For Input As intPatchesFile
    Do Until EOF(intPatchesFile) Or EOF(intSrcFile)
        Line Input #intPatchesFile, strPatchesFilePath
        objRegExp.Pattern = strPatchesFilePath
        Do
            Line Input #intSrcFile, strSrcFilePath
            If objRegExp.test(strSrcFilePath) Then
                File_PatchText = File_PatchText + 1
                Line Input #intPatchesFile, strPatchesFilePath
                i = CLng(strPatchesFilePath)
                If i = 0 Then
                    'Replace the matched line
                    GoSub File_PatchTextSub0
                ElseIf i < 0 Then
                    If i = -2147483648# Then
                        Set objMatchCollection = objRegExp.Execute(strSrcFilePath)
                        i = objMatchCollection.Item(0).SubMatches.Count
                        Set objMatchCollection = Nothing
                        If i = 0 Then
                            'Add before the matched line
                            GoSub File_PatchTextSub0
                            Print #intDestFile, strSrcFilePath
                        Else
                            'Replace parts of the matched line
                            lngOffset = 1
                            lngChar41Offset = 0
                            lngOldChar41Offset = 0
                            Set objSubRegExp = CreateObject("VBScript.RegExp")
                            Do
                                With objRegExp
                                Do
                                    lngChar41Offset = InStr(lngChar41Offset + 1, .Pattern, ")")
                                Loop Until Mid(.Pattern, lngChar41Offset - 1, 1) <> "\"
                                objSubRegExp.Pattern = Mid(.Pattern, lngOldChar41Offset + 1, lngChar41Offset - lngOldChar41Offset)
                                End With
                                Set objMatchCollection = objSubRegExp.Execute(Mid(strSrcFilePath, lngOffset))
                                With objMatchCollection.Item(0)
                                Print #intDestFile, Mid(strSrcFilePath, lngOffset, .Length - Len(.SubMatches(0)));
                                Line Input #intPatchesFile, strPatchesFilePath
                                Print #intDestFile, strPatchesFilePath;
                                lngOffset = lngOffset + .Length
                                End With
                                Set objMatchCollection = Nothing
                                lngOldChar41Offset = lngChar41Offset
                                i = i - 1
                            Loop Until i = 0
                            Set objSubRegExp = Nothing
                            Print #intDestFile, Mid(strSrcFilePath, lngOffset)
                            GoSub File_PatchTextSub1
                        End If
                    ElseIf i = -1 Then
                        'Add before the matched line
                        GoSub File_PatchTextSub0
                        Print #intDestFile, strSrcFilePath
                    Else
                        lngOldChar41Offset = -i - 1
                        i = 0
                        ReDim strPatchLines(0 To lngOldChar41Offset, 0 To 2)
                        strPatchLines(0, 0) = strSrcFilePath
                        Line Input #intPatchesFile, strSrcFilePath
                        j = InStr(strSrcFilePath, "")
                        strPatchLines(0, 1) = Left(strSrcFilePath, j - 1)
                        strPatchLines(0, 2) = Mid(strSrcFilePath, j + 1)
                        j = -1
                        Do
                            i = i + 1
                            If EOF(intSrcFile) Then
                                i = i - 1
                                For j = 0 To i
                                    Print #intDestFile, strPatchLines(j, 0)
                                Next
                                Exit Do
                            Else
                                Line Input #intSrcFile, strPatchLines(i, 0)
                                Line Input #intPatchesFile, strSrcFilePath
                                lngChar41Offset = InStr(strSrcFilePath, "")
                                strPatchLines(i, 1) = Left(strSrcFilePath, lngChar41Offset - 1)
                                strPatchLines(i, 2) = Mid(strSrcFilePath, lngChar41Offset + 1)
                                objRegExp.Pattern = strPatchLines(i, 1)
                                If Not objRegExp.test(strPatchLines(i, 0)) Then
                                    For j = 0 To i
                                        Print #intDestFile, strPatchLines(j, 0)
                                    Next
                                    lngChar41Offset = 0
                                    Do Until EOF(intSrcFile)
                                        Line Input #intSrcFile, strPatchLines(lngChar41Offset, 0)
                                        objRegExp.Pattern = strPatchLines(lngChar41Offset, 1)
                                        If objRegExp.test(strPatchLines(lngChar41Offset, 0)) Then
                                            If (lngChar41Offset = i) Then
                                                j = -1
                                                Exit Do
                                            Else
                                                lngChar41Offset = lngChar41Offset + 1
                                            End If
                                        Else
                                            For lngOffset = 0 To lngChar41Offset
                                                Print #intDestFile, strPatchLines(lngOffset, 0)
                                            Next
                                            lngChar41Offset = 0
                                        End If
                                    Loop
                                    If (lngChar41Offset <> 0) And (j <> -1) Then
                                        lngChar41Offset = lngChar41Offset - 1
                                        For lngOffset = 0 To lngChar41Offset
                                            Print #intDestFile, strPatchLines(lngOffset, 0)
                                        Next
                                    End If
                                End If
                            End If
                        Loop Until i = lngOldChar41Offset
                        lngUbound = i
                        Do While j < lngUbound
                            j = j + 1
                            If strPatchLines(j, 2) = "" Then
                                'Keep original line
                                Print #intDestFile, strPatchLines(j, 0)
                            Else
                                objRegExp.Pattern = strPatchLines(j, 1)
                                Set objMatchCollection = objRegExp.Execute(strPatchLines(j, 0))
                                i = objMatchCollection.Item(0).SubMatches.Count
                                Set objMatchCollection = Nothing
                                lngOffset = 1
                                If i = 0 Then
                                    'Replace the matched line
                                    lngChar41Offset = InStr(strPatchLines(j, 2), "")
                                    Do Until lngChar41Offset = 0
                                        Print #intDestFile, Mid(strPatchLines(j, 2), lngOffset, lngChar41Offset - lngOffset)
                                        lngOffset = lngChar41Offset + 1
                                        lngChar41Offset = InStr(lngOffset, strPatchLines(j, 2), "")
                                    Loop
                                    Print #intDestFile, Mid(strPatchLines(j, 2), lngOffset)
                                Else
                                    'Replace parts of the matched line
                                    lngChar41Offset = 0
                                    lngOldChar41Offset = 0
                                    lngStartOffset = 1
                                    Set objSubRegExp = CreateObject("VBScript.RegExp")
                                    Do
                                        With objRegExp
                                        Do
                                            lngChar41Offset = InStr(lngChar41Offset + 1, .Pattern, ")")
                                        Loop Until Mid(.Pattern, lngChar41Offset - 1, 1) <> "\"
                                        objSubRegExp.Pattern = Mid(.Pattern, lngOldChar41Offset + 1, lngChar41Offset - lngOldChar41Offset)
                                        End With
                                        Set objMatchCollection = objSubRegExp.Execute(Mid(strPatchLines(j, 0), lngOffset))
                                        With objMatchCollection.Item(0)
                                        Print #intDestFile, Mid(strPatchLines(j, 0), lngOffset, .Length - Len(.SubMatches(0)));
                                        If lngStartOffset <> 0 Then
                                            lngOldChar41Offset = InStr(lngStartOffset, strPatchLines(j, 2), "")
                                            If lngOldChar41Offset = 0 Then
                                                Print #intDestFile, Mid(strPatchLines(j, 2), lngStartOffset);
                                                lngStartOffset = 0
                                            Else
                                                Print #intDestFile, Mid(strPatchLines(j, 2), lngStartOffset, lngOldChar41Offset - lngStartOffset);
                                                lngStartOffset = lngOldChar41Offset + 1
                                            End If
                                        End If
                                        lngOffset = lngOffset + .Length
                                        End With
                                        Set objMatchCollection = Nothing
                                        lngOldChar41Offset = lngChar41Offset
                                        i = i - 1
                                    Loop Until i = 0
                                    Set objSubRegExp = Nothing
                                    Print #intDestFile, Mid(strPatchLines(j, 0), lngOffset)
                                End If
                            End If
                        Loop
                        GoSub File_PatchTextSub1
                        Erase strPatchLines
                    End If
                Else
                    'Skip i-1 lines after the matched line and add
                    Print #intDestFile, strSrcFilePath
                    Do Until i = 1 Or EOF(intSrcFile)
                        Line Input #intSrcFile, strSrcFilePath
                        Print #intDestFile, strSrcFilePath
                        i = i - 1
                    Loop
                    GoSub File_PatchTextSub0
                End If
                Exit Do
            Else
                Print #intDestFile, strSrcFilePath
            End If
        Loop Until EOF(intSrcFile)
    Loop
    Do Until EOF(intSrcFile)
        Line Input #intSrcFile, strSrcFilePath
        Print #intDestFile, strSrcFilePath
    Loop
    If Not EOF(intPatchesFile) Then
        File_PatchText = File_PatchText + 1
        Do
            Line Input #intPatchesFile, strPatchesFilePath
            Print #intDestFile, strPatchesFilePath
        Loop Until EOF(intPatchesFile)
    End If
    Close intPatchesFile
    Close intDestFile
    Close intSrcFile
    Set objRegExp = Nothing
    Exit Function
File_PatchTextSub0:
    Do Until EOF(intPatchesFile)
        Line Input #intPatchesFile, strPatchesFilePath
        If strPatchesFilePath = "" Then Exit Do
        Print #intDestFile, strPatchesFilePath
    Loop
    Return
File_PatchTextSub1:
    Do Until EOF(intPatchesFile)
        Line Input #intPatchesFile, strPatchesFilePath
        If strPatchesFilePath = "" Then Exit Do
    Loop
    Return
End Function
Public Sub File_CpyLines(ByVal intDestFile As Integer, ByVal intSrcFile As Integer, Optional ByVal lngLinesCount As Long = -1)
Dim strLine As String
    Do Until EOF(intSrcFile) Or lngLinesCount = 0
        lngLinesCount = lngLinesCount - 1
        Line Input #intSrcFile, strLine
        Print #intDestFile, strLine
    Loop
End Sub
Public Sub File_CpyBytes(ByVal intDestFile As Integer, ByVal intSrcFile As Integer, ByVal lngBytesCount As Long, Optional ByVal lngStartOffset As Long = 0)
Dim btTmpBuffer() As Byte
Dim lngTmpBufferSize As Long
    If lngBytesCount > 0 Then
        lngTmpBufferSize = lngBytesCount Mod FILE_READ_BUFFERSIZE
        If lngTmpBufferSize = 0 Then
            lngBytesCount = lngBytesCount - FILE_READ_BUFFERSIZE
            If lngStartOffset = 0 Then
                Get intSrcFile, , btReadBuffer
            Else
                Get intSrcFile, lngStartOffset, btReadBuffer
            End If
            Put intDestFile, , btReadBuffer
        Else
            ReDim btTmpBuffer(1 To lngTmpBufferSize)
            lngBytesCount = lngBytesCount - lngTmpBufferSize
            If lngStartOffset = 0 Then
                Get intSrcFile, , btTmpBuffer
            Else
                Get intSrcFile, lngStartOffset, btTmpBuffer
            End If
            Put intDestFile, , btTmpBuffer
            Erase btTmpBuffer
        End If
        Do Until lngBytesCount = 0
            Get intSrcFile, , btReadBuffer
            Put intDestFile, , btReadBuffer
            lngBytesCount = lngBytesCount - FILE_READ_BUFFERSIZE
        Loop
    End If
End Sub
Public Sub File_CopyContent(ByVal intDestFile As Integer, ByRef strSrcFile As String)
Dim intFreefile As Integer
    intFreefile = FreeFile
    Open strSrcFile For Binary Access Read As intFreefile
    Call File_CpyBytes(intDestFile, intFreefile, LOF(intFreefile))
    Close intFreefile
End Sub
Public Sub File_CopyBytes(ByVal intDestFile As Integer, ByVal intSrcFile As Integer, Optional ByVal lngStartOffset As Long = 1, Optional ByVal lngBytesCount As Long = 0)
Dim lngTmpBufferSize As Long
    lngTmpBufferSize = LOF(intSrcFile)
    If lngTmpBufferSize <> 0 Then
        If lngStartOffset < 1 Then lngStartOffset = lngTmpBufferSize + lngStartOffset
        If lngBytesCount < 1 Then lngBytesCount = lngTmpBufferSize + lngBytesCount
        lngTmpBufferSize = lngTmpBufferSize - lngStartOffset - lngBytesCount + 1
        If lngTmpBufferSize < 0 Then lngBytesCount = lngBytesCount + lngTmpBufferSize
        Call File_CpyBytes(intDestFile, intSrcFile, lngBytesCount, lngStartOffset)
    End If
End Sub
Public Sub File_Convert2Unix(ByVal strFilePath As String)
Dim intSrcFile As Integer
Dim strTmpFilePath As String
Dim intTmpFile As Integer
    strTmpFilePath = File_GetTempFilePath
    Kill strTmpFilePath
    Name strFilePath As strTmpFilePath
    intTmpFile = FreeFile
    Open strTmpFilePath For Input As intTmpFile
    intSrcFile = FreeFile
    Open strFilePath For Output As intSrcFile
    Do Until EOF(intTmpFile)
        Line Input #intTmpFile, strFilePath
        Print #intSrcFile, strFilePath + vbLf;
    Loop
    Close intSrcFile
    Close intTmpFile
    Kill strTmpFilePath
End Sub
