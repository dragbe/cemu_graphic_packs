Attribute VB_Name = "Cemu"
Option Explicit
Public Enum CEMU_LOG_DATAS
    CEMU_LOG_ACTIVATEDGFXPACKS = 1
    CEMU_LOG_GFXPACKSCODECAVE = 2
    CEMU_LOG_BASERPXHASH = 4
    CEMU_LOG_UPDATEDRPXHASH = 8
    CEMU_LOG_GAMEPROFILEPATH = 16
    CEMU_LOG_SHADERCACHEFILE = 32
    CEMU_LOG_SAVEPATH = 64
    CEMU_LOG_AOCPATH = 128
    CEMU_LOG_UPDATEPATH = 256
    CEMU_LOG_TITLEVERSION = 512
    CEMU_LOG_TITLEID = 1024
    CEMU_LOG_RPLMODULECHECKSUM = 2048
    CEMU_LOG_MLC01PATH = 4096
    CEMU_LOG_WIIUMEMORYBASE = 8192
End Enum
Public Enum CEMU_SETTING_DATAS
    CEMU_SETTING_PATH = 0
    CEMU_SETTING_MLC01PATH = 1
    CEMU_SETTING_TITLEID = 2
End Enum

Public Function Cemu_GetRootFolderPath(Optional ByRef strUserDefinedPath = "")
'Usage example with the immediate window: ?Cemu_GetRootFolderPath()
    If strUserDefinedPath = "" Then
        If Dir(ThisWorkbook.Path + "\Cemu.exe") = "" Then
            Cemu_GetRootFolderPath = Cemu_GetRootFolderPath(Worksheets("Settings").Range("B1").Text)
        Else
            Cemu_GetRootFolderPath = ThisWorkbook.Path + "\"
        End If
    Else
        If Dir(strUserDefinedPath + "Cemu.exe") = "" Then
            Cemu_GetRootFolderPath = ""
        Else
            Cemu_GetRootFolderPath = strUserDefinedPath
        End If
    End If
End Function

Public Function Cemu_GetDumpFolderPath(Optional ByVal strCemuFolderPath As String = "", Optional ByVal lngLngMinFileTimestamp = 0) As String
'Usage example with the immediate window: ?Cemu_GetDumpFolderPath()
Dim lngLngCurrentFileTimestamp As LongLong
Dim strDumpFileName As String
    strCemuFolderPath = Cemu_GetRootFolderPath(strCemuFolderPath) + "dump\"
    strDumpFileName = Dir(strCemuFolderPath + "ramDump*", vbDirectory)
    If strDumpFileName = "" Then
        Cemu_GetDumpFolderPath = ""
    Else
        Do
            strDumpFileName = strCemuFolderPath + strDumpFileName + "\"
            lngLngCurrentFileTimestamp = File_getTimestamp(strDumpFileName + "02000000.bin")
            If lngLngCurrentFileTimestamp > lngLngMinFileTimestamp Then
                Cemu_GetDumpFolderPath = strDumpFileName
                lngLngMinFileTimestamp = lngLngCurrentFileTimestamp
            End If
            strDumpFileName = Dir
        Loop Until strDumpFileName = ""
    End If
End Function

Public Function Cemu_openDumpFile(ByRef strDumpFolderPath As String, ByRef lngDeltaOffset As Long) As Integer
Dim strCemuDumpFile As String
    Cemu_openDumpFile = FreeFile
    strCemuDumpFile = strDumpFolderPath + "10000000.bin"
    If Dir(strCemuDumpFile) = "" Then
        Open strDumpFolderPath + "02000000.bin" For Binary As Cemu_openDumpFile
        lngDeltaOffset = &H2000000
    Else
        Open strCemuDumpFile For Binary As Cemu_openDumpFile
        lngDeltaOffset = &H10000000
    End If
End Function

Public Function Cemu_openProcess(ByRef lngProcAccess As SYSTEM_PROC_ACCESS, ByRef stProcess As PROCESSENTRY32) As Long
    Cemu_openProcess = System_OpenProcessByName("Cemu.exe", lngProcAccess, stProcess)
    If Cemu_openProcess = 0 Then
        Cemu_openProcess = System_OpenProcessByName("ALZP01.exe", lngProcAccess, stProcess)
        If Cemu_openProcess = 0 Then
            Cemu_openProcess = System_OpenProcessByName("ALZE01.exe", lngProcAccess, stProcess)
            If Cemu_openProcess = 0 Then Cemu_openProcess = System_OpenProcessByName("ALZJ01.exe", lngProcAccess, stProcess)
        End If
    End If
End Function

Private Sub Cemu_GetSettingsFromLog(ByRef xlsSettingsRange As Range, Optional ByRef strCemuFolderPath As String = "")
Dim stCemuLogData() As stExtractedTextData
Dim intExtractedDataCount As Integer
    intExtractedDataCount = File_ExtractText("Cemu.A2:C32", stCemuLogData(), Cemu_GetRootFolderPath(strCemuFolderPath) + "log.txt", CEMU_LOG_TITLEID Or CEMU_LOG_MLC01PATH)
    With xlsSettingsRange
    Do Until intExtractedDataCount = 0
        .Item(intExtractedDataCount, 2).Value = stCemuLogData(intExtractedDataCount).objData.Item(0).SubMatches(0)
        Set stCemuLogData(intExtractedDataCount).objData = Nothing
        intExtractedDataCount = intExtractedDataCount - 1
    Loop
    End With
    Erase stCemuLogData
End Sub

Public Function Cemu_GetMlc01Path(Optional ByRef strCemuFolderPath As String = "") As String
Dim xlsSettingsRange As Range
    Set xlsSettingsRange = ThisWorkbook.Worksheets("Settings").Range("A2:B3").Cells
    Cemu_GetMlc01Path = xlsSettingsRange.Item(CEMU_SETTING_MLC01PATH, 2).Text
    If Cemu_GetMlc01Path = "" Then
        Call Cemu_GetSettingsFromLog(xlsSettingsRange, strCemuFolderPath)
        Cemu_GetMlc01Path = xlsSettingsRange.Item(CEMU_SETTING_MLC01PATH, 2).Text
    End If
    Set xlsSettingsRange = Nothing
End Function

Public Function Cemu_GetTitleId(Optional ByRef strCemuFolderPath As String = "") As String
Dim xlsSettingsRange As Range
    Set xlsSettingsRange = ThisWorkbook.Worksheets("Settings").Range("A2:B3").Cells
    Cemu_GetTitleId = xlsSettingsRange.Item(CEMU_SETTING_TITLEID, 2).Text
    If Cemu_GetTitleId = "" Then
        Call Cemu_GetSettingsFromLog(xlsSettingsRange, strCemuFolderPath)
        Cemu_GetTitleId = xlsSettingsRange.Item(CEMU_SETTING_TITLEID, 2).Text
    End If
    Set xlsSettingsRange = Nothing
End Function

Public Function Cemu_GetBotwTitleId(Optional ByRef strCemuFolderPath As String = "") As String
    Cemu_GetBotwTitleId = Cemu_GetTitleId(strCemuFolderPath)
    If (Arithmetic_StrNandCmp(Cemu_GetBotwTitleId, "00050000-101c9X00") Or 4) <> 4 Then Cemu_GetBotwTitleId = "00050000-101c9X00"
End Function
