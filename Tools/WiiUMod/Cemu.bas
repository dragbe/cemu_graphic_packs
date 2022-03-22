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
Public Type stMemorySearcherDatas
    btdata As Byte
    intData As Integer
    lngData As Long
    lngLngData As LongLong
    sngData As Single
    dblData As Double
    ptrData(1 To 6) As LongPtr
End Type

Public Sub Cemu_InitMemorySearcherDataMap(ByRef strWsName As String)
Dim i As Integer
Dim intId As Integer
Dim xlsWorksheet As Worksheet
Dim xlsUserDataRange As Range
Dim xlsRange As Range
Dim btGameDataCount As Byte
Dim strDataType As String
    Set xlsWorksheet = ThisWorkbook.Worksheets(strWsName)
    Set xlsRange = xlsWorksheet.Range("A2:D32767").Cells
    stGameDataMaps(1).strDataType = "int8"
    stGameDataMaps(1).intDataTypeSize = 1
    stGameDataMaps(1).intDataCount = 0
    stGameDataMaps(2).strDataType = "int16"
    stGameDataMaps(2).intDataTypeSize = 2
    stGameDataMaps(2).intDataCount = 0
    stGameDataMaps(3).strDataType = "int32"
    stGameDataMaps(3).intDataTypeSize = 4
    stGameDataMaps(3).intDataCount = 0
    stGameDataMaps(4).strDataType = "int64"
    stGameDataMaps(4).intDataTypeSize = 8
    stGameDataMaps(4).intDataCount = 0
    stGameDataMaps(5).strDataType = "float"
    stGameDataMaps(5).intDataTypeSize = 4
    stGameDataMaps(5).intDataCount = 0
    stGameDataMaps(6).strDataType = "double"
    stGameDataMaps(6).intDataTypeSize = 8
    stGameDataMaps(6).intDataCount = 0
    For i = 1 To 32767
        strDataType = xlsRange.Item(i, 2).Text
        If strDataType <> "" Then
            If strDataType > "i" Then
                intId = Log(CInt(Mid(strDataType, 4))) / Log(2) - 2
            Else
                intId = Len(strDataType)
            End If
            With stGameDataMaps(intId)
                If xlsRange.Item(i, 3).Value = .intDataTypeSize Then
                    .intDataCount = .intDataCount + 1
                    ReDim Preserve .stGameDatas(1 To .intDataCount)
                    .stGameDatas(.intDataCount).strDataName = xlsRange.Item(i, 1).Text
                    .stGameDatas(.intDataCount).lngHash = xlsRange.Item(i, 4).Value
                End If
            End With
        Else
            Exit For
        End If
    Next i
    Set xlsRange = Nothing
    Set xlsWorksheet = Nothing
End Sub

Public Function Cemu_GetRootFolderPath(Optional ByRef strUserDefinedPath As String = "")
'Usage example with the immediate window: ?Cemu_GetRootFolderPath()
    If strUserDefinedPath = "" Then
        If Dir(ThisWorkbook.Path + "\Cemu.exe") = "" Then
            Cemu_GetRootFolderPath = Cemu_GetRootFolderPath(Worksheets("Settings").Range("B1").Text)
        Else
            Cemu_GetRootFolderPath = ThisWorkbook.Path + "\"
        End If
    Else
        If Dir(strUserDefinedPath + "Cemu.exe") <> "" Then Cemu_GetRootFolderPath = strUserDefinedPath
    End If
End Function

Public Function Cemu_GetDumpFolderPath(Optional ByVal strCemuFolderPath As String = "", Optional ByVal lngLngMinFileTimestamp As LongLong = 0) As String
'Usage example with the immediate window: ?Cemu_GetDumpFolderPath()
Dim lngLngCurrentFileTimestamp As LongLong
Dim strDumpFileName As String
    strCemuFolderPath = Cemu_GetRootFolderPath(strCemuFolderPath) + "dump\"
    strDumpFileName = Dir(strCemuFolderPath + "ramDump*", vbDirectory)
    If strDumpFileName <> "" Then
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

Public Function Cemu_openDumpFile(ByRef strDumpFolderPath As String, ByRef CEMU_DUMP_FILE As CEMU_DUMP_FILES) As Integer
Dim strCemuDumpFile As String
    Cemu_openDumpFile = FreeFile
    strCemuDumpFile = strDumpFolderPath + Right("0000000" + Hex(CEMU_DUMP_FILE), 8) + ".bin"
    If Dir(strCemuDumpFile) = "" Then
        Open strDumpFolderPath + "02000000.bin" For Binary As Cemu_openDumpFile
        CEMU_DUMP_FILE = CEMU_DUMP_02000000
    Else
        Open strCemuDumpFile For Binary As Cemu_openDumpFile
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

Public Function Cemu_FgetMemorySearcherInteger(ByVal intFile As Integer, ByVal lngDataAddress As Long, ByVal btDataSize As Byte) As LongLong
Static btBytes(1 To 8) As Byte
    Get intFile, lngDataAddress, btBytes
    Call CopyMemory(VarPtr(Cemu_FgetMemorySearcherInteger), VarPtr(btBytes(1)), btDataSize)
    Call Converter_SwapEndianX(VarPtr(Cemu_FgetMemorySearcherInteger), btDataSize)
End Function

Public Function Cemu_PgetMemorySearcherInteger(ByRef lngProcess As Long, ByRef lngLngDataAddress As LongLong, ByVal btDataSize As Byte) As LongLong
Static btBytes(1 To 8) As Byte
    If ReadProcessMemory(lngProcess, lngLngDataAddress, VarPtr(btBytes(1)), 8, 0) <> 0 Then
        Call CopyMemory(VarPtr(Cemu_PgetMemorySearcherInteger), VarPtr(btBytes(1)), btDataSize)
        Call Converter_SwapEndianX(VarPtr(Cemu_PgetMemorySearcherInteger), btDataSize)
    End If
End Function

Public Sub Cemu_WriteMemorySearcherIniFile(ByVal intFile As Integer, ByVal lngDataSource As Long, ByRef lngBaseAddress As Long, ByVal lngDeltaOffset As LongLong)
Dim i As Byte
Dim lngData As Long
Dim dblVar As Double
    If lngDeltaOffset < &H10000001 Then
        For i = 1 To 4
            With stGameDataMaps(i)
                If .intDataCount > 0 Then
                    .strDataType = vbCrLf + "type=" + .strDataType + vbCrLf + "value=" + vbCrLf
                    .stGameDatas(1).strHash = "[Entry]" + vbCrLf + "Description="
                    Do Until .intDataCount = 0
                        Print #intFile, .stGameDatas(1).strHash + .stGameDatas(.intDataCount).strDataName + "[" + CStr(Cemu_FgetMemorySearcherInteger(lngDataSource, lngBaseAddress - CLng(lngDeltaOffset) + 1 + .stGameDatas(.intDataCount).lngHash, .intDataTypeSize)) + "]" + vbCrLf + "address=0x" + Hex(lngBaseAddress + .stGameDatas(.intDataCount).lngHash) + .strDataType
                        .intDataCount = .intDataCount - 1
                    Loop
                End If
            End With
        Next i
        With stGameDataMaps(5)
            If .intDataCount > 0 Then
                .strDataType = vbCrLf + "type=" + .strDataType + vbCrLf + "value=" + vbCrLf
                .stGameDatas(1).strHash = "[Entry]" + vbCrLf + "Description="
                Do Until .intDataCount = 0
                    Get lngDataSource, lngBaseAddress - CLng(lngDeltaOffset) + 1 + .stGameDatas(.intDataCount).lngHash, lngData
                    Print #intFile, .stGameDatas(1).strHash + .stGameDatas(.intDataCount).strDataName + "[" + CStr(Converter_Lng2SngVar(Converter_SwapEndian(lngData))) + "]" + vbCrLf + "address=0x" + Hex(lngBaseAddress + .stGameDatas(.intDataCount).lngHash) + .strDataType
                    .intDataCount = .intDataCount - 1
                Loop
            End If
        End With
        With stGameDataMaps(6)
            If .intDataCount > 0 Then
                .strDataType = vbCrLf + "type=" + .strDataType + vbCrLf + "value=" + vbCrLf
                .stGameDatas(1).strHash = "[Entry]" + vbCrLf + "Description="
                Do Until .intDataCount = 0
                    Get lngDataSource, lngBaseAddress - CLng(lngDeltaOffset) + 1 + .stGameDatas(.intDataCount).lngHash, dblVar
                    Call Converter_SwapEndianX(VarPtr(dblVar), .intDataTypeSize)
                    Print #intFile, .stGameDatas(1).strHash + .stGameDatas(.intDataCount).strDataName + "[" + CStr(dblVar) + "]" + vbCrLf + "address=0x" + Hex(lngBaseAddress + .stGameDatas(.intDataCount).lngHash) + .strDataType
                    .intDataCount = .intDataCount - 1
                Loop
            End If
        End With
    Else
        For i = 1 To 4
            With stGameDataMaps(i)
                If .intDataCount > 0 Then
                    .strDataType = vbCrLf + "type=" + .strDataType + vbCrLf + "value=" + vbCrLf
                    .stGameDatas(1).strHash = "[Entry]" + vbCrLf + "Description="
                    Do Until .intDataCount = 0
                        Print #intFile, .stGameDatas(1).strHash + .stGameDatas(.intDataCount).strDataName + "[" + CStr(Cemu_PgetMemorySearcherInteger(lngDataSource, lngBaseAddress + lngDeltaOffset + .stGameDatas(.intDataCount).lngHash, .intDataTypeSize)) + "]" + vbCrLf + "address=0x" + Hex(lngBaseAddress + .stGameDatas(.intDataCount).lngHash) + .strDataType
                        .intDataCount = .intDataCount - 1
                    Loop
                End If
            End With
        Next i
        With stGameDataMaps(5)
            If .intDataCount > 0 Then
                .strDataType = vbCrLf + "type=" + .strDataType + vbCrLf + "value=" + vbCrLf
                .stGameDatas(1).strHash = "[Entry]" + vbCrLf + "Description="
                Do Until .intDataCount = 0
                    If ReadProcessMemory(lngDataSource, lngDeltaOffset + lngBaseAddress + .stGameDatas(.intDataCount).lngHash, VarPtr(lngData), 4, 0) <> 0 Then
                        Print #intFile, .stGameDatas(1).strHash + .stGameDatas(.intDataCount).strDataName + "[" + CStr(Converter_Lng2SngVar(Converter_SwapEndian(lngData))) + "]" + vbCrLf + "address=0x" + Hex(lngBaseAddress + .stGameDatas(.intDataCount).lngHash) + .strDataType
                    Else
                        Print #intFile, .stGameDatas(1).strHash + .stGameDatas(.intDataCount).strDataName + vbCrLf + "address=0x" + Hex(lngBaseAddress + .stGameDatas(.intDataCount).lngHash) + .strDataType
                    End If
                    .intDataCount = .intDataCount - 1
                Loop
            End If
        End With
        With stGameDataMaps(6)
            If .intDataCount > 0 Then
                .strDataType = vbCrLf + "type=" + .strDataType + vbCrLf + "value=" + vbCrLf
                .stGameDatas(1).strHash = "[Entry]" + vbCrLf + "Description="
                Do Until .intDataCount = 0
                    If ReadProcessMemory(lngDataSource, lngDeltaOffset + lngBaseAddress + .stGameDatas(.intDataCount).lngHash, VarPtr(dblVar), 8, 0) <> 0 Then
                        Call Converter_SwapEndianX(VarPtr(dblVar), .intDataTypeSize)
                        Print #intFile, .stGameDatas(1).strHash + .stGameDatas(.intDataCount).strDataName + "[" + CStr(dblVar) + "]" + vbCrLf + "address=0x" + Hex(lngBaseAddress + .stGameDatas(.intDataCount).lngHash) + .strDataType
                    Else
                        Print #intFile, .stGameDatas(1).strHash + .stGameDatas(.intDataCount).strDataName + vbCrLf + "address=0x" + Hex(lngBaseAddress + .stGameDatas(.intDataCount).lngHash) + .strDataType
                    End If
                    .intDataCount = .intDataCount - 1
                Loop
            End If
        End With
    End If
End Sub

Public Function Cemu_MemorySearcherIniFile(ByVal CEMU_DUMP_FILE As CEMU_DUMP_FILES, Optional ByVal strCemuFolderPath As String = "") As Long
'Usage example with the immediate window: ?Cemu_MemorySearcherIniFile(CEMU_DUMP_10000000)
'Output: D:\WiiU\1.23.0\memorySearcher\00050000101c9<3|4|5|X>00.ini
Dim stProcess As PROCESSENTRY32
Dim stCemuLogData() As stExtractedTextData
    strCemuFolderPath = Cemu_GetRootFolderPath(strCemuFolderPath)
    stProcess.dwFlags = File_ExtractText("Cemu.A2:C32", stCemuLogData, strCemuFolderPath + "log.txt", CEMU_LOG_WIIUMEMORYBASE Or CEMU_LOG_TITLEID)
    If stProcess.dwFlags = 2 Then
        stProcess.dwSize = Cemu_openProcess(SYSTEM_PROC_VMREAD, stProcess)
        If stProcess.dwSize <> 0 Then
            If System_ToogleProcessById(stProcess.th32ProcessID, True) > 0 Then
                Call Cemu_InitMemorySearcherDataMap(Right("0000000" + Hex(CEMU_DUMP_FILE), 8))
                stProcess.cntUsage = FreeFile
                Open strCemuFolderPath + "memorySearcher\" + Left(stCemuLogData(2).objData.Item(0).SubMatches(0), 8) + Mid(stCemuLogData(2).objData.Item(0).SubMatches(0), 10) + ".ini" For Output As stProcess.cntUsage
                Call Cemu_WriteMemorySearcherIniFile(stProcess.cntUsage, stProcess.dwSize, Cemu_MemorySearcherIniFile, CLngLng("&H" + stCemuLogData(1).objData.Item(0).SubMatches(0)))
                Close stProcess.cntUsage
                System_ToogleProcessById stProcess.th32ProcessID, False
            End If
            CloseHandle stProcess.dwSize
        Else
            strCemuFolderPath = Cemu_GetDumpFolderPath(strCemuFolderPath)
            If strCemuFolderPath <> "" Then
                stProcess.dwSize = Cemu_openDumpFile(strCemuFolderPath, CEMU_DUMP_FILE)
                Call Cemu_InitMemorySearcherDataMap(Right("0000000" + Hex(CEMU_DUMP_FILE), 8))
                stProcess.cntUsage = FreeFile
                Open strCemuFolderPath + "..\..\memorySearcher\" + Left(stCemuLogData(2).objData.Item(0).SubMatches(0), 8) + Mid(stCemuLogData(2).objData.Item(0).SubMatches(0), 10) + ".ini" For Output As stProcess.cntUsage
                Call Cemu_WriteMemorySearcherIniFile(stProcess.cntUsage, stProcess.dwSize, Cemu_MemorySearcherIniFile, CEMU_DUMP_FILE)
                Close stProcess.cntUsage
                Close stProcess.dwSize
            End If
        End If
        Set stCemuLogData(1).objData = Nothing
        Set stCemuLogData(2).objData = Nothing
        Erase stCemuLogData
    End If
End Function

Public Function Cemu_Dump(ByRef lngStartAddress As Long, ByVal lngEndAddress As Long, Optional ByVal btDumpSlot As Byte = 0, Optional ByVal strCemuFolderPath As String = "") As Long
'Usage example with the immediate window: ?Cemu_Dump(&H41BC6540, &H41BC7560)
Dim stProcess As PROCESSENTRY32
Dim stCemuLogData() As stExtractedTextData
Dim btBytes() As Byte
Dim xlsRange As Range
Dim strValues As String
Dim lngLngVar As LongLong
    strCemuFolderPath = Cemu_GetRootFolderPath(strCemuFolderPath)
    stProcess.dwFlags = File_ExtractText("Cemu.A2:C32", stCemuLogData, strCemuFolderPath + "log.txt", CEMU_LOG_WIIUMEMORYBASE)
    If stProcess.dwFlags = 1 Then
        stProcess.dwSize = Cemu_openProcess(SYSTEM_PROC_VMREAD, stProcess)
        If stProcess.dwSize <> 0 Then
            If System_ToogleProcessById(stProcess.th32ProcessID, True) > 0 Then
                stProcess.dwFlags = (lngEndAddress - lngStartAddress) / 16 + 1
                lngEndAddress = stProcess.dwFlags * 16
                ReDim btBytes(0 To lngEndAddress - 1)
                If ReadProcessMemory(stProcess.dwSize, CLngLng("&H" + stCemuLogData(1).objData.Item(0).SubMatches(0)) + lngStartAddress, VarPtr(btBytes(0)), lngEndAddress, 0) <> 0 Then
                    With Worksheets("Dump" + CStr(btDumpSlot))
                        .Range("A2:X1048576").ClearContents
                        .Range("A1").Value = lngEndAddress
                        Set xlsRange = .Range("A2:X" + CStr(1 + stProcess.dwFlags)).Cells
                        Do
                            strCemuFolderPath = ""
                            strValues = ""
                            For Cemu_Dump = 17 To 2 Step -1
                                lngEndAddress = lngEndAddress - 1
                                xlsRange.Item(stProcess.dwFlags, Cemu_Dump).Value = Right("0" + Hex(btBytes(lngEndAddress)), 2)
                                strCemuFolderPath = CStr(btBytes(lngEndAddress)) + " " + strCemuFolderPath
                                strValues = IIf(btBytes(lngEndAddress) < 32, ".", Chr(btBytes(lngEndAddress))) + strValues
                            Next Cemu_Dump
                            xlsRange.Item(stProcess.dwFlags, 18).Value = strValues
                            xlsRange.Item(stProcess.dwFlags, 19).Value = strCemuFolderPath
                            xlsRange.Item(stProcess.dwFlags, 1).Value = Right("0000000" + Hex(lngStartAddress + lngEndAddress), 8)
                            stProcess.cntUsage = 0
                            strValues = ""
                            For Cemu_Dump = lngEndAddress + 14 To lngEndAddress Step -2
                                Call CopyMemory(VarPtr(stProcess.cntUsage), VarPtr(btBytes(Cemu_Dump)), 2)
                                Call Converter_SwapEndianX(VarPtr(stProcess.cntUsage), 2)
                                strValues = CStr(stProcess.cntUsage) + " " + strValues
                            Next Cemu_Dump
                            xlsRange.Item(stProcess.dwFlags, 20).Value = strValues
                            strCemuFolderPath = ""
                            strValues = ""
                            For Cemu_Dump = lngEndAddress + 12 To lngEndAddress Step -4
                                Call CopyMemory(VarPtr(stProcess.cntUsage), VarPtr(btBytes(Cemu_Dump)), 4)
                                stProcess.cntUsage = Converter_SwapEndian(stProcess.cntUsage)
                                strValues = CStr(stProcess.cntUsage) + " " + strValues
                                strCemuFolderPath = CStr(Converter_Lng2SngVar(stProcess.cntUsage)) + " " + strCemuFolderPath
                            Next Cemu_Dump
                            xlsRange.Item(stProcess.dwFlags, 21).Value = strValues
                            xlsRange.Item(stProcess.dwFlags, 23).Value = strCemuFolderPath
                            strCemuFolderPath = ""
                            strValues = ""
                            For Cemu_Dump = lngEndAddress + 8 To lngEndAddress Step -8
                                Call CopyMemory(VarPtr(lngLngVar), VarPtr(btBytes(Cemu_Dump)), 8)
                                Call Converter_SwapEndianX(VarPtr(lngLngVar), 8)
                                strValues = CStr(lngLngVar) + " " + strValues
                                strCemuFolderPath = CStr(Converter_Lnglng2DblVar(lngLngVar)) + " " + strCemuFolderPath
                            Next Cemu_Dump
                            xlsRange.Item(stProcess.dwFlags, 22).Value = strValues
                            xlsRange.Item(stProcess.dwFlags, 24).Value = strCemuFolderPath
                            stProcess.dwFlags = stProcess.dwFlags - 1
                        Loop Until stProcess.dwFlags = 0
                        Set xlsRange = Nothing
                    End With
                End If
                Erase btBytes
                System_ToogleProcessById stProcess.th32ProcessID, False
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
Dim i As Integer
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
