Attribute VB_Name = "File"
Option Explicit
Private Declare PtrSafe Function GetTempFileName Lib "kernel32" Alias "GetTempFileNameA" (ByVal lpszPath As String, ByVal lpPrefixString As String, ByVal wUnique As Long, ByVal lpTempFileName As String) As Long
Private Declare PtrSafe Function CreateFile Lib "kernel32.dll" Alias "CreateFileA" (ByVal lpFileName As String, ByVal dwDesiredAccess As Long, ByVal dwShareMode As Long, ByVal lpSecurityAttributes As LongPtr, ByVal dwCreationDisposition As Long, ByVal dwFlagsAndAttributes As Long, ByVal hTemplateFile As Long) As Long
Private Declare PtrSafe Function GetFileTime Lib "kernel32.dll" (ByVal hFile As Long, ByVal lpCreationTime As LongPtr, ByVal lpLastAccessTime As LongPtr, ByVal lpLastWriteTime As LongPtr) As Long
Public Declare PtrSafe Function GetPrivateProfileString Lib "kernel32" Alias "GetPrivateProfileStringA" (ByVal lpApplicationName As String, ByVal lpKeyName As Any, ByVal lpDefault As String, ByVal lpReturnedString As String, ByVal nSize As Long, ByVal lpFileName As String) As Long
Public Const FILE_ACCESS_GENERIC_READ As Long = &H80000000
Public Const FILE_SHARE_READ As Long = &H1
Public Const FILE_OPEN_EXISTING As Long = 3
Public Const FILE_ATTRIBUTE_ARCHIVE As Long = &H20
Public Const FILE_MAXPATH As Long = 260
Public Enum FILE_TIMESTAMPS
    FILE_TIMESTAMP_CREATION = 1
    FILE_TIMESTAMP_ACCESS = 2
    FILE_TIMESTAMP_WRITE = 3
End Enum
Private Type stTextFilterRule
    strRegExp As String
    intMatchesMaxCount As Integer
End Type
Private Type stTextFilterRules
    stFilters(0 To 255) As stTextFilterRule
    intFiltersCount As Integer
End Type
Public Type stExtractedTextData
    intLine As Integer
    objData As Object
End Type
Private Type stBytes
    btBytes() As Byte
End Type
Private stTextFilters As stTextFilterRules
Public Const FILE_READ_BUFFERSIZE As Long = &H4000
Public btReadBuffer(0 To FILE_READ_BUFFERSIZE - 1) As Byte
Public Function File_GetTimestamp(ByRef strFilename As String, Optional ByRef lngType As FILE_TIMESTAMPS = FILE_TIMESTAMP_WRITE) As LongLong
Static lngLngTimestamps(FILE_TIMESTAMP_CREATION To FILE_TIMESTAMP_WRITE) As LongLong
Dim lngHFile As Long
    lngHFile = CreateFile(strFilename, FILE_ACCESS_GENERIC_READ, FILE_SHARE_READ, 0, FILE_OPEN_EXISTING, FILE_ATTRIBUTE_ARCHIVE, 0)
    If lngHFile = -1 Then
        lngLngTimestamps(lngType) = 0
    Else
        GetFileTime lngHFile, VarPtr(lngLngTimestamps(FILE_TIMESTAMP_CREATION)), VarPtr(lngLngTimestamps(FILE_TIMESTAMP_ACCESS)), VarPtr(lngLngTimestamps(FILE_TIMESTAMP_WRITE))
        CloseHandle lngHFile
    End If
    File_GetTimestamp = lngLngTimestamps(lngType)
End Function
Private Function File_InitTextFilters(ByVal strTextFiltersSource As String, Optional ByVal lngTargetDataMask As Long = 0) As Integer
Dim lngFiltersCount As Long
Dim xlsTextFiltersRange As Range
Dim lngFile As Long
Dim lngPos As Long
    stTextFilters.intFiltersCount = 0
    If lngTargetDataMask = 0 Then
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
    .strRegExp = xlsTextFiltersRange.Item(lngFiltersCount, 2).Text
    .intMatchesMaxCount = xlsTextFiltersRange.Item(lngFiltersCount, 3).Value
    File_InitTextFilters = File_InitTextFilters + .intMatchesMaxCount
    End With
    stTextFilters.intFiltersCount = stTextFilters.intFiltersCount + 1
    Return
File_InitTextFiltersSub2:
    With stTextFilters.stFilters(stTextFilters.intFiltersCount)
    .intMatchesMaxCount = InStr(strTextFiltersSource, " ")
    .strRegExp = Mid(strTextFiltersSource, .intMatchesMaxCount + 1)
    .intMatchesMaxCount = CInt(Left(strTextFiltersSource, .intMatchesMaxCount - 1))
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
Public Function File_ExtractText(ByVal strTextFiltersSource As String, ByRef stExtractedTextDatas() As stExtractedTextData, Optional ByVal strFilePath As String = "", Optional ByVal lngTargetDataMask As Long = 0) As Integer
Dim objRegExp As Object
Dim i As Integer
Dim objMatchCollection As Object
Dim lngOffset As Long
Dim lngNextOffset As Long
    File_ExtractText = File_InitTextFilters(strTextFiltersSource, lngTargetDataMask)
    If File_ExtractText > 0 Then
        ReDim stExtractedTextDatas(1 To File_ExtractText)
        lngTargetDataMask = 0
        Set objRegExp = CreateObject("VBScript.RegExp")
        File_ExtractText = 0
        If strFilePath = "" Then
            strTextFiltersSource = System_Clipboard
            lngOffset = 1
            lngNextOffset = InStr(1, strTextFiltersSource, vbCrLf)
            Do Until lngNextOffset = 0 Or stTextFilters.stFilters(0).intMatchesMaxCount = 0
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
            Do Until EOF(lngOffset) Or stTextFilters.stFilters(0).intMatchesMaxCount = 0
                Line Input #lngOffset, strFilePath
                GoSub File_ExtractTextSub
            Loop
            Close lngOffset
        End If
        Set objRegExp = Nothing
    End If
    Exit Function
File_ExtractTextSub:
    lngTargetDataMask = lngTargetDataMask + 1
    For i = stTextFilters.intFiltersCount - 1 To 0 Step -1
        With stTextFilters.stFilters(i)
        objRegExp.Pattern = .strRegExp
        Set objMatchCollection = objRegExp.Execute(strFilePath)
        If objMatchCollection.Count = 0 Then
            Set objMatchCollection = Nothing
        Else
            File_ExtractText = File_ExtractText + 1
            stExtractedTextDatas(File_ExtractText).intLine = lngTargetDataMask
            Set stExtractedTextDatas(File_ExtractText).objData = objMatchCollection
            .intMatchesMaxCount = .intMatchesMaxCount - 1
            If i <> 0 Then
                If .intMatchesMaxCount = 0 Then
                    stTextFilters.intFiltersCount = stTextFilters.intFiltersCount - 1
                    stTextFilters.stFilters(i) = stTextFilters.stFilters(stTextFilters.intFiltersCount)
                End If
                i = 0
            End If
            Set objMatchCollection = Nothing
        End If
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
    .lngDataSize = Vector_Cbytes(strByteSequences(0), .btdata)
    ReDim .lngLowerOffsets(0 To 0)
    .lngLowerOffsets(0) = 1
    intFile = FreeFile
    Open strFile For Binary Access Read As intFile
    Do Until EOF(intFile)
        Get intFile, .lngLowerOffsets(File_SearchNeighborBinData), btReadBuffer
        lngOffset = Vector_InBytes(1, btReadBuffer, .btdata, -32768)
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
        Erase .btdata
        ReDim .btdata(1 To (2 - Abs(intNeighborhoodType)) * intNeighborhoodWindowOffset + .lngDataSize)
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
            Get intFile, IIf(.lngLowerOffsets(File_SearchNeighborBinData) < 1, 1, .lngLowerOffsets(File_SearchNeighborBinData)), .btdata
            For lngOffset = .lngDataSize To 1 Step -1
                If Vector_InBytes(1, .btdata, stSearchBytes(lngOffset).btBytes) = 0 Then Exit For
            Next lngOffset
            If lngOffset = 0 Then Debug.Print strByteSequences(0)
        Loop Until File_SearchNeighborBinData = 0
        For lngOffset = .lngDataSize To 1 Step -1
            Erase stSearchBytes(lngOffset).btBytes
        Next lngOffset
        Erase stSearchBytes
    End If
    Close intFile
    Erase .btdata
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
                If Dir(strFilename) <> "" Then Kill strFilename
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
Public Function File_GetFolder(ByRef strFilename As String) As String
Dim lngLastSlash As Long
Dim lngSlash As Long
    lngLastSlash = InStrRev(strFilename, "\")
    If lngLastSlash <> 0 Then
        lngSlash = InStrRev(strFilename, "\", lngLastSlash - 1) + 1
        File_GetFolder = Mid(strFilename, lngSlash, lngLastSlash - lngSlash)
    End If
End Function
