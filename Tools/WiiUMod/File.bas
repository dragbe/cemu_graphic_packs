Attribute VB_Name = "File"
Option Explicit
Private Declare PtrSafe Function GetTempFileName Lib "kernel32" Alias "GetTempFileNameA" (ByVal lpszPath As String, ByVal lpPrefixString As String, ByVal wUnique As Long, ByVal lpTempFileName As String) As Long
Private Declare PtrSafe Function CreateFile Lib "kernel32.dll" Alias "CreateFileA" (ByVal lpFileName As String, ByVal dwDesiredAccess As Long, ByVal dwShareMode As Long, ByVal lpSecurityAttributes As LongPtr, ByVal dwCreationDisposition As Long, ByVal dwFlagsAndAttributes As Long, ByVal hTemplateFile As Long) As Long
Private Declare PtrSafe Function GetFileTime Lib "kernel32.dll" (ByVal hFile As Long, ByVal lpCreationTime As LongPtr, ByVal lpLastAccessTime As LongPtr, ByVal lpLastWriteTime As LongPtr) As Long
Public Const GENERIC_READ = &H80000000
Public Const FILE_SHARE_READ = &H1
Public Const OPEN_EXISTING = 3
Public Const FILE_ATTRIBUTE_ARCHIVE = &H20
Public Const MAXPATH = 260
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
Private stTextFilters As stTextFilterRules

Public Function File_getTimestamp(ByRef strFileName As String, Optional ByRef lngType As FILE_TIMESTAMPS = FILE_TIMESTAMP_WRITE) As LongLong
Static lngLngTimestamps(FILE_TIMESTAMP_CREATION To FILE_TIMESTAMP_WRITE) As LongLong
Dim lngHFile As Long
    lngHFile = CreateFile(strFileName, GENERIC_READ, FILE_SHARE_READ, 0, OPEN_EXISTING, FILE_ATTRIBUTE_ARCHIVE, 0)
    If lngHFile = -1 Then
        lngLngTimestamps(lngType) = 0
    Else
        GetFileTime lngHFile, VarPtr(lngLngTimestamps(FILE_TIMESTAMP_CREATION)), VarPtr(lngLngTimestamps(FILE_TIMESTAMP_ACCESS)), VarPtr(lngLngTimestamps(FILE_TIMESTAMP_WRITE))
        CloseHandle lngHFile
    End If
    File_getTimestamp = lngLngTimestamps(lngType)
End Function

Private Function File_InitTextFilters(ByVal strTextFiltersSource As String, Optional ByVal lngTargetDataMask As Long = 0) As Integer
Dim lngFiltersCount As Long
Dim xlsTextFiltersRange As Range
Dim intFile As Integer
    stTextFilters.intFiltersCount = 0
    If lngTargetDataMask = 0 Then
        If InStr(strTextFiltersSource, ":") < 3 Then
            intFile = FreeFile
            Open strTextFiltersSource For Input As intFile
            Do Until EOF(intFile) Or stTextFilters.intFiltersCount = 256
                Line Input #intFile, strTextFiltersSource
                lngFiltersCount = InStr(strTextFiltersSource, " ")
                With stTextFilters.stFilters(stTextFilters.intFiltersCount)
                .strRegExp = Mid(strTextFiltersSource, lngFiltersCount + 1)
                .intMatchesMaxCount = CInt(Left(strTextFiltersSource, lngFiltersCount - 1))
                File_InitTextFilters = File_InitTextFilters + .intMatchesMaxCount
                End With
                stTextFilters.intFiltersCount = stTextFilters.intFiltersCount + 1
            Loop
            Close intFile
        Else
            lngFiltersCount = InStr(strTextFiltersSource, ".")
            Set xlsTextFiltersRange = Worksheets(Left(strTextFiltersSource, lngFiltersCount - 1)).Range(Mid(strTextFiltersSource, lngFiltersCount + 1)).Cells
            For lngFiltersCount = 1 To 256
                strTextFiltersSource = xlsTextFiltersRange.Item(lngFiltersCount, 1).Text
                If strTextFiltersSource <> "" Then
                    With stTextFilters.stFilters(stTextFilters.intFiltersCount)
                    .strRegExp = xlsTextFiltersRange.Item(lngFiltersCount, 2).Text
                    .intMatchesMaxCount = xlsTextFiltersRange.Item(lngFiltersCount, 3).Value
                    File_InitTextFilters = File_InitTextFilters + .intMatchesMaxCount
                    End With
                    stTextFilters.intFiltersCount = stTextFilters.intFiltersCount + 1
                Else
                    Exit For
                End If
            Next lngFiltersCount
            Set xlsTextFiltersRange = Nothing
        End If
    Else
        If InStr(strTextFiltersSource, ":") < 3 Then
            intFile = FreeFile
            Open strTextFiltersSource For Input As intFile
            lngFiltersCount = 0
            Do Until EOF(intFile) Or lngFiltersCount = 31
                Line Input #intFile, strTextFiltersSource
                If (lngTargetDataMask And (2^ ^ lngFiltersCount)) <> 0 Then
                    With stTextFilters.stFilters(stTextFilters.intFiltersCount)
                    .intMatchesMaxCount = InStr(strTextFiltersSource, " ")
                    .strRegExp = Mid(strTextFiltersSource, .intMatchesMaxCount + 1)
                    .intMatchesMaxCount = CInt(Left(strTextFiltersSource, .intMatchesMaxCount - 1))
                    File_InitTextFilters = File_InitTextFilters + .intMatchesMaxCount
                    End With
                    stTextFilters.intFiltersCount = stTextFilters.intFiltersCount + 1
                End If
                lngFiltersCount = lngFiltersCount + 1
            Loop
            Close intFile
        Else
            lngFiltersCount = InStr(strTextFiltersSource, ".")
            Set xlsTextFiltersRange = Worksheets(Left(strTextFiltersSource, lngFiltersCount - 1)).Range(Mid(strTextFiltersSource, lngFiltersCount + 1)).Cells
            For lngFiltersCount = 1 To 31
                strTextFiltersSource = xlsTextFiltersRange.Item(lngFiltersCount, 1).Text
                If strTextFiltersSource <> "" Then
                    If (lngTargetDataMask And (2^ ^ (lngFiltersCount - 1))) <> 0 Then
                        With stTextFilters.stFilters(stTextFilters.intFiltersCount)
                        .strRegExp = xlsTextFiltersRange.Item(lngFiltersCount, 2).Text
                        .intMatchesMaxCount = xlsTextFiltersRange.Item(lngFiltersCount, 3).Value
                        File_InitTextFilters = File_InitTextFilters + .intMatchesMaxCount
                        End With
                        stTextFilters.intFiltersCount = stTextFilters.intFiltersCount + 1
                    End If
                Else
                    Exit For
                End If
            Next lngFiltersCount
            Set xlsTextFiltersRange = Nothing
        End If
    End If
End Function

Public Function File_ExtractText(ByVal strTextFiltersSource As String, ByRef stExtractedTextDatas() As stExtractedTextData, Optional ByVal strFilePath As String = "", Optional ByVal lngTargetDataMask As Long = 0) As Integer
Dim objRegExp As Object
Dim i As Integer
Dim objMatchCollection As Object
Dim intOffset As Integer
Dim intNextOffset As Integer
    File_ExtractText = File_InitTextFilters(strTextFiltersSource, lngTargetDataMask)
    If File_ExtractText > 0 Then
        ReDim stExtractedTextDatas(1 To File_ExtractText)
        lngTargetDataMask = 0
        Set objRegExp = CreateObject("VBScript.RegExp")
        File_ExtractText = 0
        If strFilePath = "" Then
            strTextFiltersSource = System_Clipboard
            intOffset = 1
            intNextOffset = InStr(1, strTextFiltersSource, vbCrLf)
            Do Until intNextOffset = 0 Or stTextFilters.stFilters(0).intMatchesMaxCount = 0
                strFilePath = Mid(strTextFiltersSource, intOffset, intNextOffset - intOffset)
                GoSub File_ExtractTextSub
                intOffset = intNextOffset + 1
                intNextOffset = InStr(intOffset, strTextFiltersSource, vbCrLf)
            Loop
            strFilePath = Mid(strTextFiltersSource, intOffset)
            GoSub File_ExtractTextSub
        Else
            intOffset = FreeFile
            Open strFilePath For Input As intOffset
            Do Until EOF(intOffset) Or stTextFilters.stFilters(0).intMatchesMaxCount = 0
                Line Input #intOffset, strFilePath
                GoSub File_ExtractTextSub
            Loop
            Close intOffset
        End If
        Set objRegExp = Nothing
    End If
    Exit Function
File_ExtractTextSub:
    lngTargetDataMask = lngTargetDataMask + 1
    For i = stTextFilters.intFiltersCount - 1 To 0 Step -1
        objRegExp.Pattern = stTextFilters.stFilters(i).strRegExp
        Set objMatchCollection = objRegExp.Execute(strFilePath)
        If objMatchCollection.Count = 0 Then
            Set objMatchCollection = Nothing
        Else
            File_ExtractText = File_ExtractText + 1
            stExtractedTextDatas(File_ExtractText).intLine = lngTargetDataMask
            Set stExtractedTextDatas(File_ExtractText).objData = objMatchCollection
            stTextFilters.stFilters(i).intMatchesMaxCount = stTextFilters.stFilters(i).intMatchesMaxCount - 1
            If i <> 0 Then
                If stTextFilters.stFilters(i).intMatchesMaxCount = 0 Then
                    stTextFilters.intFiltersCount = stTextFilters.intFiltersCount - 1
                    stTextFilters.stFilters(i) = stTextFilters.stFilters(stTextFilters.intFiltersCount)
                End If
            End If
            Set objMatchCollection = Nothing
            Exit For
        End If
    Next i
    Return
End Function

Public Sub File_ReadLongDataSegment(ByVal intFile As Integer, ByVal lngOffset As Long, ByVal lngDataCount As Long, ByRef lngDataSegment() As Long)
    ReDim lngDataSegment(1 To lngDataCount)
    Get intFile, lngOffset, lngDataSegment
End Sub

Public Function File_getMappedDataAddress(ByVal intFile As Integer, ByVal lngDeltaOffset As Long, ByRef lngLowerOffsets() As Long) As Long
Dim i As Integer
    For i = UBound(lngLowerOffsets) To 0 Step -1
        Get intFile, File_getMappedDataAddress + lngLowerOffsets(i) - lngDeltaOffset + 1, File_getMappedDataAddress
        File_getMappedDataAddress = Converter_SwapEndian(File_getMappedDataAddress)
    Next i
End Function

Public Function File_ReadCmp256(ByVal intInFile As Integer, ByRef ptrData As LongPtr, ByVal intDataSize As Integer) As Long
Static btBytes(0 To 255) As Byte
    Get #intInFile, , btBytes
    File_ReadCmp256 = CompareMemory(VarPtr(btBytes(0)), ptrData, intDataSize)
End Function

Public Function File_getDumpOffset(ByRef strDumpFileBasename As String) As Long
Dim objRegExp As Object
    Set objRegExp = CreateObject("VBScript.RegExp")
    objRegExp.Pattern = "^[0-9a-fA-F]{8}.bin$"
    If objRegExp.test(strDumpFileBasename) Then File_getDumpOffset = CLng("&H" + Left(strDumpFileBasename, 8))
    Set objRegExp = Nothing
End Function

Public Function File_getTempFilePath(Optional ByRef strPrefix As String = "tmp") As String
    File_getTempFilePath = Space(MAXPATH)
    If GetTempFileName(System_GetTempFolderPath(), strPrefix, 0, File_getTempFilePath) = 0 Then
        File_getTempFilePath = ""
    Else
        File_getTempFilePath = Left(File_getTempFilePath, InStr(File_getTempFilePath, Chr(0)) - 1)
    End If
End Function
