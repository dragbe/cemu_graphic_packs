Attribute VB_Name = "Cemu"
Option Explicit
Public Enum CEMU_DUMP_FILES
    CEMU_DUMP_00010000 = &H10000
    CEMU_DUMP_00E00000 = &HE00000
    CEMU_DUMP_01800000 = &H1800000
    CEMU_DUMP_02000000 = &H2000000
    CEMU_DUMP_0E000000 = &HE000000
    CEMU_DUMP_10000000 = &H10000000
    CEMU_DUMP_A0000000 = &HA0000000
    CEMU_DUMP_E0000000 = &HE0000000
    CEMU_DUMP_E8000000 = &HE8000000
    CEMU_DUMP_F4000000 = &HF4000000
    CEMU_DUMP_F6000000 = &HF6000000
    CEMU_DUMP_F8000000 = &HF8000000
    CEMU_DUMP_FFC00000 = &HFFC00000
    CEMU_DUMP_FFC40000 = &HFFC40000
    CEMU_DUMP_FFC80000 = &HFFC80000
    CEMU_DUMP_FFFFF000 = &HFFFFF000
End Enum
'reverse order (same order in the Cemu worksheet)
Public Enum CEMU_LOG_DATAS
    CEMU_LOG_ACTIVATEDGFXPACKS = 1
    CEMU_LOG_GFXPACKSCODECAVE = 2
    CEMU_LOG_RPLMODULECHECKSUM = 4
    CEMU_LOG_BASERPXHASH = 8
    CEMU_LOG_UPDATEDRPXHASH = 16
    CEMU_LOG_GAMEPROFILEPATH = 32
    CEMU_LOG_SHADERCACHEFILE = 64
    CEMU_LOG_SAVEPATH = 128
    CEMU_LOG_TITLEVERSION = 256
    CEMU_LOG_TITLEID = 512
    CEMU_LOG_DLCPATH = 1024
    CEMU_LOG_UPDATEPATH = 2048
    CEMU_LOG_BASEPATH = 4096
    CEMU_LOG_MLC01PATH = 8192
    CEMU_LOG_WIIUMEMORYBASE = 16384
End Enum
Public Enum CEMU_SETTING_DATAS
    CEMU_SETTING_PATH = 0
    CEMU_SETTING_MLC01PATH = 1
    CEMU_SETTING_DLCPATH = 2
    CEMU_SETTING_TITLEID = 3
End Enum
Public Type stMemorySearcherDatas
    btData As Byte
    intData As Integer
    lngData As Long
    lnglngData As LongLong
    sngData As Single
    dblData As Double
    ptrData(1 To 6) As LongPtr
End Type
Public Sub Cemu_InitMemorySearcherDataMap(Optional ByRef lngDataCount As Long = 0)
    With stGameDataMaps(6)
    If lngDataCount > 0 Then
        ReDim .stGameDatas(1 To lngDataCount)
        For .lngDataCount = 5 To 1 Step -1
            ReDim stGameDataMaps(.lngDataCount).stGameDatas(1 To lngDataCount)
        Next .lngDataCount
    Else
        .lngDataCount = 0
    End If
    .strDataType = "double"
    .intDataTypeSize = 8
    End With
    With stGameDataMaps(1)
    .strDataType = "int8"
    .intDataTypeSize = 1
    .lngDataCount = 0
    End With
    With stGameDataMaps(2)
    .strDataType = "int16"
    .intDataTypeSize = 2
    .lngDataCount = 0
    End With
    With stGameDataMaps(3)
    .strDataType = "int32"
    .intDataTypeSize = 4
    .lngDataCount = 0
    End With
    With stGameDataMaps(4)
    .strDataType = "int64"
    .intDataTypeSize = 8
    .lngDataCount = 0
    End With
    With stGameDataMaps(5)
    .strDataType = "float"
    .intDataTypeSize = 4
    .lngDataCount = 0
    End With
End Sub
Public Sub Cemu_RedimMemorySearcherDataMap()
    With stGameDataMaps(1)
        If .lngDataCount > 0 Then ReDim Preserve .stGameDatas(1 To .lngDataCount)
    End With
    With stGameDataMaps(2)
        If .lngDataCount > 0 Then ReDim Preserve .stGameDatas(1 To .lngDataCount)
    End With
    With stGameDataMaps(3)
        If .lngDataCount > 0 Then ReDim Preserve .stGameDatas(1 To .lngDataCount)
    End With
    With stGameDataMaps(4)
        If .lngDataCount > 0 Then ReDim Preserve .stGameDatas(1 To .lngDataCount)
    End With
    With stGameDataMaps(5)
        If .lngDataCount > 0 Then ReDim Preserve .stGameDatas(1 To .lngDataCount)
    End With
    With stGameDataMaps(6)
        If .lngDataCount > 0 Then ReDim Preserve .stGameDatas(1 To .lngDataCount)
    End With
End Sub
Public Function Cemu_GetMemorySearcherDataIndex(ByRef strDataType As String) As Byte
    If Left(strDataType, 1) = "i" Then
        Cemu_GetMemorySearcherDataIndex = Log(CInt(Mid(strDataType, 4))) / Log(2) - 2
    Else
        Cemu_GetMemorySearcherDataIndex = Len(strDataType)
    End If
End Function
Public Sub Cemu_AddMemorySearcherDataMap(ByRef strDataName As String, ByVal btDataTypeIndex As Byte, ByVal lngDataSize As Long, ByVal lngDataOffset As Long)
    If btDataTypeIndex > 0 Then
        With stGameDataMaps(btDataTypeIndex)
            If lngDataSize = .intDataTypeSize Then
                .lngDataCount = .lngDataCount + 1
                'ReDim Preserve .stGameDatas(1 To .lngDataCount)
                .stGameDatas(.lngDataCount).strDataName = strDataName
                .stGameDatas(.lngDataCount).lngHash = lngDataOffset
            End If
        End With
    End If
End Sub
Public Function Cemu_LoadMemorySearcherDataMap(ByRef strDataSource As String, Optional ByRef strSeparator As String = "") As Long
Dim xlsWorksheet As Worksheet
    If strSeparator = "" Then
        Set xlsWorksheet = ThisWorkbook.Worksheets(strDataSource)
        Cemu_LoadMemorySearcherDataMap = xlsWorksheet.Range("F1").Value - 1
        If Cemu_LoadMemorySearcherDataMap > 0 Then
            Call Cemu_InitMemorySearcherDataMap(Cemu_LoadMemorySearcherDataMap)
            With xlsWorksheet.Range("A2:D" + xlsWorksheet.Range("F1").Text).Cells
            Do
                Call Cemu_AddMemorySearcherDataMap(.Item(Cemu_LoadMemorySearcherDataMap, 1).Text, Cemu_GetMemorySearcherDataIndex(.Item(Cemu_LoadMemorySearcherDataMap, 2).Text), .Item(Cemu_LoadMemorySearcherDataMap, 3).Value, .Item(Cemu_LoadMemorySearcherDataMap, 4).Value)
                Cemu_LoadMemorySearcherDataMap = Cemu_LoadMemorySearcherDataMap - 1
            Loop Until Cemu_LoadMemorySearcherDataMap = 0
            Cemu_LoadMemorySearcherDataMap = .Rows.Count
            End With
            Cemu_RedimMemorySearcherDataMap
        End If
        Set xlsWorksheet = Nothing
    Else
        'TODO
    End If
End Function
Public Function Cemu_GetRootFolderPath(Optional ByRef strUserDefinedPath As String = "")
'Usage example with the immediate window: ?Cemu_GetRootFolderPath()
    If strUserDefinedPath = "" Then
        If Dir(ThisWorkbook.Path + "\Cemu.exe", vbNormal) = "" Then
            Cemu_GetRootFolderPath = Cemu_GetRootFolderPath(Worksheets("Settings").Range("B1").Text)
        Else
            Cemu_GetRootFolderPath = ThisWorkbook.Path + "\"
        End If
    Else
        If Dir(strUserDefinedPath + "Cemu.exe", vbNormal) <> "" Then Cemu_GetRootFolderPath = strUserDefinedPath
    End If
End Function
Public Function Cemu_GetDumpFolderPath(Optional ByRef strCemuFolderPath As String = "", Optional ByRef lngLngMinFileTimestamp As LongLong = 0) As String
'Usage example with the immediate window: ?Cemu_GetDumpFolderPath()
    Cemu_GetDumpFolderPath = File_GetMostRecentFileDir(Cemu_GetRootFolderPath(strCemuFolderPath) + "dump\", "ramDump*", "02000000.bin", lngLngMinFileTimestamp)
End Function
Public Function Cemu_OpenDumpFile(ByRef strDumpFolderPath As String, ByRef CEMU_DUMP_FILE As CEMU_DUMP_FILES) As Integer
Dim strCemuDumpFile As String
    Cemu_OpenDumpFile = FreeFile
    strCemuDumpFile = strDumpFolderPath + Right("0000000" + Hex(CEMU_DUMP_FILE), 8) + ".bin"
    If Dir(strCemuDumpFile, vbNormal) = "" Then
        Open strDumpFolderPath + "02000000.bin" For Binary Access Read As Cemu_OpenDumpFile
        CEMU_DUMP_FILE = CEMU_DUMP_02000000
    Else
        Open strCemuDumpFile For Binary Access Read As Cemu_OpenDumpFile
    End If
End Function
Public Function Cemu_OpenProcess(ByRef lngProcAccess As SYSTEM_PROC_ACCESS, ByRef stProcess As PROCESSENTRY32) As Long
    Cemu_OpenProcess = System_OpenProcessByName("Cemu.exe", lngProcAccess, stProcess)
    If Cemu_OpenProcess = 0 Then
        Cemu_OpenProcess = System_OpenProcessByName("ALZP01.exe", lngProcAccess, stProcess)
        If Cemu_OpenProcess = 0 Then
            Cemu_OpenProcess = System_OpenProcessByName("ALZE01.exe", lngProcAccess, stProcess)
            If Cemu_OpenProcess = 0 Then Cemu_OpenProcess = System_OpenProcessByName("ALZJ01.exe", lngProcAccess, stProcess)
        End If
    End If
End Function
Private Sub Cemu_GetSettingsFromLog(ByRef xlsSettingsRange As Range, Optional ByRef strCemuFolderPath As String = "")
Dim stCemuLogData() As stExtractedTextData
Dim lngExtractedDataCount As Long
    With xlsSettingsRange
    For lngExtractedDataCount = File_ExtractText("Cemu.A2:C32", stCemuLogData(), Cemu_GetRootFolderPath(strCemuFolderPath) + "log.txt", CEMU_LOG_TITLEID Or CEMU_LOG_MLC01PATH Or CEMU_LOG_DLCPATH) To 1 Step -1
        .Item(lngExtractedDataCount, 2).Value = stCemuLogData(lngExtractedDataCount).objData.Item(0).SubMatches(0)
        Set stCemuLogData(lngExtractedDataCount).objData = Nothing
    Next lngExtractedDataCount
    End With
    Erase stCemuLogData
End Sub
Public Function Cemu_ReadSettingsFromXml(ByRef strSettingPath As String, Optional ByRef strMatchPattern As String = ".*", Optional ByRef strCemuFolderPath As String = "") As Object()
Dim xmlDoc As Object
Dim strNodes() As String
    Set xmlDoc = CreateObject("MSXML2.DOMDocument")
    xmlDoc.async = False
    If xmlDoc.Load(Cemu_GetRootFolderPath(strCemuFolderPath) + "settings.xml") Then
        strNodes = Split(strSettingPath, " ")
        Cemu_ReadSettingsFromXml = Tools_MatchXmlNodes(xmlDoc, strNodes, UBound(strNodes), strMatchPattern)
        Erase strNodes
    End If
    Set xmlDoc = Nothing
End Function
Private Function Cemu_GetSettingFromLog(ByRef CEMU_SETTING_DATA As CEMU_SETTING_DATAS, Optional ByRef strCemuFolderPath As String = "") As String
Dim xlsSettingsRange As Range
    Set xlsSettingsRange = ThisWorkbook.Worksheets("Settings").Range("A2:B4").Cells
    With xlsSettingsRange
    Cemu_GetSettingFromLog = .Item(CEMU_SETTING_DATA, 2).Text
    If Cemu_GetSettingFromLog = "" Then
        Call Cemu_GetSettingsFromLog(xlsSettingsRange, strCemuFolderPath)
        Cemu_GetSettingFromLog = .Item(CEMU_SETTING_DATA, 2).Text
    End If
    End With
    Set xlsSettingsRange = Nothing
End Function
Public Function Cemu_GetMlc01Path(Optional ByRef strCemuFolderPath As String = "") As String
    Cemu_GetMlc01Path = Replace(Cemu_GetSettingFromLog(CEMU_SETTING_MLC01PATH, strCemuFolderPath), "/", "\")
End Function
Public Function Cemu_GetTitleId(Optional ByRef strCemuFolderPath As String = "") As String
    Cemu_GetTitleId = Cemu_GetSettingFromLog(CEMU_SETTING_TITLEID, strCemuFolderPath)
End Function
Public Function Cemu_GetDlcPath(Optional ByRef strCemuFolderPath As String = "") As String
    Cemu_GetDlcPath = Replace(Cemu_GetSettingFromLog(CEMU_SETTING_DLCPATH, strCemuFolderPath), "/", "\")
End Function
Public Function Cemu_GetBotwTitleId(Optional ByRef strCemuFolderPath As String = "") As String
    Cemu_GetBotwTitleId = Cemu_GetTitleId(strCemuFolderPath)
    If (Arithmetic_StrNandCmp(Cemu_GetBotwTitleId, "00050000-101c9X00") Or 4) <> 4 Then Cemu_GetBotwTitleId = "00050000-101c9X00"
End Function
Public Sub Cemu_WriteMemorySearcherEntry(ByVal intFile As Integer, ByRef strDataName As String, ByRef lngAddress As Long, ByRef strDataType As String)
    Print #intFile, "[Entry]"
    Print #intFile, "description=";
    Print #intFile, strDataName
    Print #intFile, "address=0x";
    Print #intFile, Hex(lngAddress)
    Print #intFile, "type=";
    Print #intFile, strDataType
    Print #intFile, "value="
    Print #intFile, vbCrLf;
End Sub
Public Sub Cemu_WriteMemorySearcherIniFile(ByVal intFile As Integer, ByVal lngDataSource As Long, ByVal lngBaseAddress As Long, ByVal lngDeltaOffset As LongLong)
Dim i As Byte
Dim lngData As Long
Dim dblVar As Double
Dim lnglngValue As LongLong
    If lngDeltaOffset < &H10000001 Then
        lngDeltaOffset = lngDeltaOffset - 1
        For i = 1 To 4
            With stGameDataMaps(i)
                If .lngDataCount > 0 Then
                    Do
                        .stGameDatas(.lngDataCount).lngHash = lngBaseAddress + .stGameDatas(.lngDataCount).lngHash
                        lnglngValue = File_GetInteger(lngDataSource, .stGameDatas(.lngDataCount).lngHash - CLng(lngDeltaOffset), .intDataTypeSize)
                        Call Converter_SwapEndianX(VarPtr(lnglngValue), .intDataTypeSize)
                        Call Cemu_WriteMemorySearcherEntry(intFile, .stGameDatas(.lngDataCount).strDataName + "|" + Hex(lnglngValue), .stGameDatas(.lngDataCount).lngHash, .strDataType)
                        .lngDataCount = .lngDataCount - 1
                    Loop Until .lngDataCount = 0
                    Erase stGameDataMaps(i).stGameDatas
                End If
            End With
        Next i
        With stGameDataMaps(5)
            If .lngDataCount > 0 Then
                Do
                    .stGameDatas(.lngDataCount).lngHash = lngBaseAddress + .stGameDatas(.lngDataCount).lngHash
                    Get lngDataSource, .stGameDatas(.lngDataCount).lngHash - CLng(lngDeltaOffset), lngData
                    Call Cemu_WriteMemorySearcherEntry(intFile, .stGameDatas(.lngDataCount).strDataName + "|" + CStr(Converter_Lng2SngVar(Converter_SwapEndian32(lngData))), .stGameDatas(.lngDataCount).lngHash, .strDataType)
                    .lngDataCount = .lngDataCount - 1
                Loop Until .lngDataCount = 0
                Erase stGameDataMaps(5).stGameDatas
            End If
        End With
        With stGameDataMaps(6)
            If .lngDataCount > 0 Then
                Do
                    .stGameDatas(.lngDataCount).lngHash = lngBaseAddress + .stGameDatas(.lngDataCount).lngHash
                    Get lngDataSource, .stGameDatas(.lngDataCount).lngHash - CLng(lngDeltaOffset), dblVar
                    Call Converter_SwapEndianX(VarPtr(dblVar), .intDataTypeSize)
                    Call Cemu_WriteMemorySearcherEntry(intFile, .stGameDatas(.lngDataCount).strDataName + "|" + CStr(dblVar), .stGameDatas(.lngDataCount).lngHash, .strDataType)
                    .lngDataCount = .lngDataCount - 1
                Loop Until .lngDataCount = 0
                Erase stGameDataMaps(6).stGameDatas
            End If
        End With
    Else
        For i = 1 To 4
            With stGameDataMaps(i)
                If .lngDataCount > 0 Then
                    Do
                        .stGameDatas(.lngDataCount).lngHash = lngBaseAddress + .stGameDatas(.lngDataCount).lngHash
                        lnglngValue = Memory_GetInteger(lngDataSource, lngDeltaOffset + .stGameDatas(.lngDataCount).lngHash, .intDataTypeSize)
                        Call Converter_SwapEndianX(VarPtr(lnglngValue), .intDataTypeSize)
                        Call Cemu_WriteMemorySearcherEntry(intFile, .stGameDatas(.lngDataCount).strDataName + "|" + Hex(lnglngValue), .stGameDatas(.lngDataCount).lngHash, .strDataType)
                        .lngDataCount = .lngDataCount - 1
                    Loop Until .lngDataCount = 0
                    Erase stGameDataMaps(i).stGameDatas
                End If
            End With
        Next i
        With stGameDataMaps(5)
            If .lngDataCount > 0 Then
                Do
                    .stGameDatas(.lngDataCount).lngHash = lngBaseAddress + .stGameDatas(.lngDataCount).lngHash
                    If ReadProcessMemory(lngDataSource, lngDeltaOffset + .stGameDatas(.lngDataCount).lngHash, VarPtr(lngData), 4, 0) <> 0 Then
                        Call Cemu_WriteMemorySearcherEntry(intFile, .stGameDatas(.lngDataCount).strDataName + "|" + CStr(Converter_Lng2SngVar(Converter_SwapEndian32(lngData))), .stGameDatas(.lngDataCount).lngHash, .strDataType)
                    Else
                        Call Cemu_WriteMemorySearcherEntry(intFile, .stGameDatas(.lngDataCount).strDataName, .stGameDatas(.lngDataCount).lngHash, .strDataType)
                    End If
                    .lngDataCount = .lngDataCount - 1
                Loop Until .lngDataCount = 0
                Erase stGameDataMaps(5).stGameDatas
            End If
        End With
        With stGameDataMaps(6)
            If .lngDataCount > 0 Then
                Do
                    .stGameDatas(.lngDataCount).lngHash = lngBaseAddress + .stGameDatas(.lngDataCount).lngHash
                    If ReadProcessMemory(lngDataSource, lngDeltaOffset + .stGameDatas(.lngDataCount).lngHash, VarPtr(dblVar), 8, 0) <> 0 Then
                        Call Converter_SwapEndianX(VarPtr(dblVar), .intDataTypeSize)
                        Call Cemu_WriteMemorySearcherEntry(intFile, .stGameDatas(.lngDataCount).strDataName + "|" + CStr(dblVar), .stGameDatas(.lngDataCount).lngHash, .strDataType)
                    Else
                        Call Cemu_WriteMemorySearcherEntry(intFile, .stGameDatas(.lngDataCount).strDataName, .stGameDatas(.lngDataCount).lngHash, .strDataType)
                    End If
                    .lngDataCount = .lngDataCount - 1
                Loop Until .lngDataCount = 0
                Erase stGameDataMaps(6).stGameDatas
            End If
        End With
    End If
End Sub
Public Function Cemu_MemorySearcherIniFile(ByVal CEMU_DUMP_FILE As CEMU_DUMP_FILES, Optional ByVal strCemuFolderPath As String = "") As Long
'Usage example with the immediate window: ?Cemu_MemorySearcherIniFile(CEMU_DUMP_10000000)
'Output: D:\WiiU\Default\memorySearcher\00050000101c9<3|4|5|X>00.ini
Dim stProcess As PROCESSENTRY32
Dim stCemuLogData() As stExtractedTextData
    strCemuFolderPath = Cemu_GetRootFolderPath(strCemuFolderPath)
    With stProcess
    .dwFlags = File_ExtractText("Cemu.A2:C32", stCemuLogData, strCemuFolderPath + "log.txt", CEMU_LOG_WIIUMEMORYBASE Or CEMU_LOG_TITLEID)
    If .dwFlags = 2 Then
        .dwSize = Cemu_OpenProcess(SYSTEM_PROC_VMREAD, stProcess)
        If .dwSize <> 0 Then
            If System_ToogleProcessById(.th32ProcessID, -1) > 0 Then
                Cemu_LoadMemorySearcherDataMap Right("0000000" + Hex(CEMU_DUMP_FILE), 8)
                .cntUsage = FreeFile
                Open strCemuFolderPath + "memorySearcher\" + Left(stCemuLogData(2).objData.Item(0).SubMatches(0), 8) + Mid(stCemuLogData(2).objData.Item(0).SubMatches(0), 10) + ".ini" For Output As .cntUsage
                Call Cemu_WriteMemorySearcherIniFile(.cntUsage, .dwSize, 0, CLngLng("&H" + stCemuLogData(1).objData.Item(0).SubMatches(0)))
                Close .cntUsage
                System_ToogleProcessById .th32ProcessID, 1
            End If
            CloseHandle .dwSize
        Else
            strCemuFolderPath = Cemu_GetDumpFolderPath(strCemuFolderPath)
            If strCemuFolderPath <> "" Then
                .dwSize = Cemu_OpenDumpFile(strCemuFolderPath, CEMU_DUMP_FILE)
                Cemu_LoadMemorySearcherDataMap Right("0000000" + Hex(CEMU_DUMP_FILE), 8)
                .cntUsage = FreeFile
                Open strCemuFolderPath + "..\..\memorySearcher\" + Left(stCemuLogData(2).objData.Item(0).SubMatches(0), 8) + Mid(stCemuLogData(2).objData.Item(0).SubMatches(0), 10) + ".ini" For Output As .cntUsage
                Call Cemu_WriteMemorySearcherIniFile(.cntUsage, .dwSize, 0, CEMU_DUMP_FILE)
                Close .cntUsage
                Close .dwSize
            End If
        End If
        Set stCemuLogData(1).objData = Nothing
        Set stCemuLogData(2).objData = Nothing
        Erase stCemuLogData
    End If
    End With
End Function
Public Function Cemu_Dump(ByRef lngStartAddress As Long, ByVal lngEndAddress As Long, Optional ByRef btDumpSlot As Byte = 0, Optional ByVal strCemuFolderPath As String = "") As Long
'Usage example with the immediate window: ?Cemu_Dump(&H1800000, &H1800100)
Dim stProcess As PROCESSENTRY32
Dim stCemuLogData() As stExtractedTextData
Dim btBytes() As Byte
Dim xlsWkSheet As Worksheet
Dim strValues As String
Dim lngLngVar As LongLong
    strCemuFolderPath = Cemu_GetRootFolderPath(strCemuFolderPath)
    stProcess.dwFlags = File_ExtractText("Cemu.A2:C32", stCemuLogData, strCemuFolderPath + "log.txt", CEMU_LOG_WIIUMEMORYBASE)
    If stProcess.dwFlags = 1 Then
        stProcess.dwSize = Cemu_OpenProcess(SYSTEM_PROC_VMREAD, stProcess)
        If stProcess.dwSize <> 0 Then
            If System_ToogleProcessById(stProcess.th32ProcessID, -1) > 0 Then
                stProcess.dwFlags = (lngEndAddress - lngStartAddress) / 16 + 1
                lngEndAddress = stProcess.dwFlags * 16
                ReDim btBytes(0 To lngEndAddress - 1)
                If ReadProcessMemory(stProcess.dwSize, CLngLng("&H" + stCemuLogData(1).objData.Item(0).SubMatches(0)) + lngStartAddress, VarPtr(btBytes(0)), lngEndAddress, 0) <> 0 Then
                    Set xlsWkSheet = Worksheets("Dump" + CStr(btDumpSlot))
                    xlsWkSheet.Range("A2:X1048576").ClearContents
                    xlsWkSheet.Range("A1").Value = lngEndAddress
                    With xlsWkSheet.Range("A2:X" + CStr(1 + stProcess.dwFlags)).Cells
                    Do
                        strCemuFolderPath = ""
                        strValues = ""
                        For Cemu_Dump = 17 To 2 Step -1
                            lngEndAddress = lngEndAddress - 1
                            .Item(stProcess.dwFlags, Cemu_Dump).Value = Right("0" + Hex(btBytes(lngEndAddress)), 2)
                            strCemuFolderPath = CStr(btBytes(lngEndAddress)) + " " + strCemuFolderPath
                            If btBytes(lngEndAddress) < 32 Then
                                strValues = "." + strValues
                            Else
                                strValues = Chr(btBytes(lngEndAddress)) + strValues
                            End If
                        Next Cemu_Dump
                        .Item(stProcess.dwFlags, 18).Value = strValues
                        .Item(stProcess.dwFlags, 19).Value = strCemuFolderPath
                        .Item(stProcess.dwFlags, 1).Value = Right("0000000" + Hex(lngStartAddress + lngEndAddress), 8)
                        stProcess.cntUsage = 0
                        strValues = ""
                        For Cemu_Dump = lngEndAddress + 14 To lngEndAddress Step -2
                            Call CopyMemory(VarPtr(stProcess.cntUsage), VarPtr(btBytes(Cemu_Dump)), 2)
                            Call Converter_SwapEndianX(VarPtr(stProcess.cntUsage), 2)
                            strValues = CStr(stProcess.cntUsage) + " " + strValues
                        Next Cemu_Dump
                        .Item(stProcess.dwFlags, 20).Value = strValues
                        strCemuFolderPath = ""
                        strValues = ""
                        For Cemu_Dump = lngEndAddress + 12 To lngEndAddress Step -4
                            Call CopyMemory(VarPtr(stProcess.cntUsage), VarPtr(btBytes(Cemu_Dump)), 4)
                            stProcess.cntUsage = Converter_SwapEndian32(stProcess.cntUsage)
                            strValues = CStr(stProcess.cntUsage) + " " + strValues
                            strCemuFolderPath = CStr(Converter_Lng2SngVar(stProcess.cntUsage)) + " " + strCemuFolderPath
                        Next Cemu_Dump
                        .Item(stProcess.dwFlags, 21).Value = strValues
                        .Item(stProcess.dwFlags, 23).Value = strCemuFolderPath
                        strCemuFolderPath = ""
                        strValues = ""
                        For Cemu_Dump = lngEndAddress + 8 To lngEndAddress Step -8
                            Call CopyMemory(VarPtr(lngLngVar), VarPtr(btBytes(Cemu_Dump)), 8)
                            Call Converter_SwapEndianX(VarPtr(lngLngVar), 8)
                            strValues = CStr(lngLngVar) + " " + strValues
                            strCemuFolderPath = CStr(Converter_Lnglng2DblVar(lngLngVar)) + " " + strCemuFolderPath
                        Next Cemu_Dump
                        .Item(stProcess.dwFlags, 22).Value = strValues
                        .Item(stProcess.dwFlags, 24).Value = strCemuFolderPath
                        stProcess.dwFlags = stProcess.dwFlags - 1
                    Loop Until stProcess.dwFlags = 0
                    End With
                    Set xlsWkSheet = Nothing
                End If
                Erase btBytes
                System_ToogleProcessById stProcess.th32ProcessID, 1
            End If
            CloseHandle stProcess.dwSize
        End If
        Set stCemuLogData(1).objData = Nothing
        Erase stCemuLogData
    End If
End Function
Public Function Cemu_DiffDump(Optional ByVal btDumpSlotX As Byte = 0, Optional ByVal btDumpSlotY As Byte = 1) As Long
'Usage example with the immediate window: ?Cemu_DiffDump()
Dim wsDumpX As Worksheet
Dim wsDumpY As Worksheet
Dim wsDiffDump As Worksheet
Dim xlsDumpRangeX As Range
Dim xlsDumpRangeY As Range
Dim xlsDiffDumpRange As Range
Dim strValuesX() As String
Dim strValuesY() As String
Dim strValues As String
Dim strAsc As String
Dim strMid As String
Dim strAscDiff As String
Dim i As Long
Dim btDataSize(19 To 24) As Byte
Dim j As Byte
    btDataSize(19) = 1
    btDataSize(20) = 2
    btDataSize(21) = 4
    btDataSize(22) = 8
    btDataSize(23) = 4
    btDataSize(24) = 8
    Set wsDumpX = Worksheets("Dump" + CStr(btDumpSlotX))
    Set wsDumpY = Worksheets("Dump" + CStr(btDumpSlotY))
    Cemu_DiffDump = wsDumpX.Range("A1").Value
    If Cemu_DiffDump = wsDumpY.Range("A1").Value And wsDumpX.Range("A2").Text = wsDumpY.Range("A2").Text Then
        Cemu_DiffDump = Cemu_DiffDump / 16
        strValues = "A2:X" + CStr(1 + Cemu_DiffDump)
        Set xlsDumpRangeX = wsDumpX.Range(strValues).Cells
        Set xlsDumpRangeY = wsDumpY.Range(strValues).Cells
        Set wsDiffDump = Worksheets("DiffDump")
        wsDiffDump.Range("A2:X1048576").ClearContents
        Set xlsDiffDumpRange = wsDiffDump.Range(strValues).Cells
        Do Until Cemu_DiffDump = 0
            xlsDiffDumpRange.Item(Cemu_DiffDump, 1).Value = xlsDumpRangeX.Item(Cemu_DiffDump, 1).Text
            btDumpSlotX = 17
            strAscDiff = ""
            strAsc = xlsDumpRangeX.Item(Cemu_DiffDump, 18).Text
            strValues = xlsDumpRangeY.Item(Cemu_DiffDump, 18).Text
            Do
                btDumpSlotY = btDumpSlotX - 2
                With xlsDiffDumpRange.Item(Cemu_DiffDump, btDumpSlotX)
                    If xlsDumpRangeX.Item(Cemu_DiffDump, btDumpSlotX).Text = xlsDumpRangeY.Item(Cemu_DiffDump, btDumpSlotX).Text Then
                        .Font.Color = vbBlack
                        i = btDumpSlotY + 2
                        strMid = Mid(strAsc, i)
                        If strMid <> "" Then strAscDiff = "|" + strMid + "|" + Mid(strValues, i) + "| " + strAscDiff
                        strAsc = Left(strAsc, btDumpSlotY)
                        strValues = Left(strValues, btDumpSlotY)
                    Else
                        .Font.Color = vbRed
                    End If
                    .Value = xlsDumpRangeY.Item(Cemu_DiffDump, btDumpSlotX).Text
                End With
                btDumpSlotX = btDumpSlotX - 1
            Loop Until btDumpSlotX = 1
            If strAsc <> "" Then strAscDiff = "|" + strAsc + "|" + strValues + "| " + strAscDiff
            xlsDiffDumpRange.Item(Cemu_DiffDump, 18).Value = strAscDiff
            btDumpSlotX = 24
            Do
                strValuesX = Split(xlsDumpRangeX.Item(Cemu_DiffDump, btDumpSlotX).Text, " ")
                strValuesY = Split(xlsDumpRangeY.Item(Cemu_DiffDump, btDumpSlotX).Text, " ")
                strValues = ""
                For i = UBound(strValuesY) - 1 To 0 Step -1
                    If strValuesX(i) <> strValuesY(i) Then
                        btDumpSlotY = 2 + i * btDataSize(btDumpSlotX)
                        j = btDumpSlotY + btDataSize(btDumpSlotX)
                        strAsc = ""
                        strMid = ""
                        Do
                            j = j - 1
                            strAsc = xlsDumpRangeX.Item(Cemu_DiffDump, j).Text + strAsc
                            strMid = xlsDumpRangeY.Item(Cemu_DiffDump, j).Text + strMid
                        Loop Until btDumpSlotY = j
                        strValues = "|" + strAsc + "|" + strValuesX(i) + "|" + strValuesY(i) + "|" + strMid + "| " + strValues
                    End If
                Next i
                xlsDiffDumpRange.Item(Cemu_DiffDump, btDumpSlotX).Value = strValues
                Erase strValuesX
                Erase strValuesY
                btDumpSlotX = btDumpSlotX - 1
            Loop Until btDumpSlotX = 18
            Cemu_DiffDump = Cemu_DiffDump - 1
        Loop
        Set xlsDumpRangeX = Nothing
        Set xlsDumpRangeY = Nothing
        Set xlsDiffDumpRange = Nothing
        Set wsDiffDump = Nothing
    End If
    Set wsDumpX = Nothing
    Set wsDumpY = Nothing
End Function
Public Function Cemu_ReadWiiuMappedData(ByRef stMemoryDataMap As stDataMap, ByRef strOffsets As String, Optional ByVal intDataOffset = 0, Optional ByVal strCemuFolderPath As String = "") As Long
Dim stProcess As PROCESSENTRY32
Dim stCemuLogData() As stExtractedTextData
Dim lngLngMemoryBase As LongLong
    strCemuFolderPath = Cemu_GetRootFolderPath(strCemuFolderPath)
    Call Memory_InitDataMap(strOffsets, stMemoryDataMap)
    With stProcess
    .dwSize = Cemu_OpenProcess(SYSTEM_PROC_VMREAD, stProcess)
    If .dwSize <> 0 Then
        If System_ToogleProcessById(.th32ProcessID, -1) > 0 Then
            .dwFlags = File_ExtractText("Cemu.A2:C32", stCemuLogData, strCemuFolderPath + "log.txt", CEMU_LOG_WIIUMEMORYBASE)
            If .dwFlags = 1 Then
                lngLngMemoryBase = CLngLng("&H" + stCemuLogData(1).objData.Item(0).SubMatches(0))
                Cemu_ReadWiiuMappedData = Memory_GetMappedData(.dwSize, lngLngMemoryBase, stMemoryDataMap.lngLowerOffsets)
                If ReadProcessMemory(.dwSize, lngLngMemoryBase + Cemu_ReadWiiuMappedData + intDataOffset, VarPtr(stMemoryDataMap.btData(0)), stMemoryDataMap.lngDataSize, 0) = 0 Then Cemu_ReadWiiuMappedData = 0
                Set stCemuLogData(1).objData = Nothing
                Erase stCemuLogData
            End If
            System_ToogleProcessById .th32ProcessID, 1
        End If
        CloseHandle .dwSize
    Else
        strCemuFolderPath = Cemu_GetDumpFolderPath(strCemuFolderPath)
        If strCemuFolderPath <> "" Then
            .dwSize = Cemu_OpenDumpFile(strCemuFolderPath, CEMU_DUMP_10000000)
            Cemu_ReadWiiuMappedData = File_GetMappedData(.dwSize, CEMU_DUMP_10000000, stMemoryDataMap.lngLowerOffsets)
            Get .dwSize, Cemu_ReadWiiuMappedData - CEMU_DUMP_10000000 + 1 + intDataOffset, stMemoryDataMap.btData
            Close .dwSize
        End If
    End If
    End With
End Function
Public Function Cemu_DumpWiiuMappedData(ByRef strOffsets As String, Optional ByVal intDataOffset = 0, Optional ByVal strCemuFolderPath As String = "") As Long
'Usage example with the immediate window: ?Cemu_DumpWiiuMappedData("4 &h14 &h43853C9C",&hac)
Dim stMemoryDataMap As stDataMap
    Debug.Print Hex(Cemu_ReadWiiuMappedData(stMemoryDataMap, strOffsets, intDataOffset, strCemuFolderPath))
    With stMemoryDataMap
    .lngDataSize = .lngDataSize - 1
    For Cemu_DumpWiiuMappedData = 0 To .lngDataSize
        Debug.Print Right("0" + Hex(.btData(Cemu_DumpWiiuMappedData)), 2) + " ";
    Next Cemu_DumpWiiuMappedData
    Erase .btData
    End With
End Function
