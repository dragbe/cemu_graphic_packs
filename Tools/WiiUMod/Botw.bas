Attribute VB_Name = "Botw"
Option Explicit
Public Enum BOTW_INVENTORYITEM_FILTERS
    BOTW_WEAPONSONLY = 1
    BOTW_BOWSONLY = 2
    BOTW_ARROWSONLY = 4
    BOTW_SHIELDSONLY = 8
    BOTW_HEADARMORSONLY = 16
    BOTW_UPPERARMORSONLY = 32
    BOTW_LOWERARMORSONLY = 64
    BOTW_MATERIALSONLY = 128
    BOTW_FOODSONLY = 256
    BOTW_KEYITEMSONLY = 512
    BOTW_ALLITEMS = BOTW_WEAPONSONLY Or BOTW_BOWSONLY Or BOTW_ARROWSONLY Or BOTW_SHIELDSONLY Or BOTW_HEADARMORSONLY Or BOTW_UPPERARMORSONLY Or BOTW_LOWERARMORSONLY Or BOTW_MATERIALSONLY Or BOTW_FOODSONLY Or BOTW_KEYITEMSONLY
End Enum
Public Type stRecipeIngredient
    lngIdAddress As Long
    lngLessUsefulField As Long
    lngStr64TypeSize As Long
    strId As String * 64
End Type
Public Type stRecipe
    stIngredients(1 To 5) As stRecipeIngredient
    lngIngredientsAddresses(1 To 5) As Long
End Type
Public Type stInventoryItem
    lngPreviousItemAddress As Long
    lngNextItemAddress As Long
    lngType As Long
    lngSubType As Long
    lngQtyDur As Long
    lngEquippedFlag As Long
    lngIdAddress As Long
    lngLessUsefulField As Long
    lngStr64TypeSize As Long
    strId As String * 64
    lngBonusValue As Long
    lngBonusDuration As Long
    lngBonusType As Long
    lngEffectType As Long
    lngEffectLevel As Long
    btLessUsefulData(1 To 8) As Byte
    lngRecipeIngredientsAddressesArrayPointer As Long
    lngZeroField As Long
    lngRecipeAddress As Long
    objRecipe As stRecipe
    lngUselessField As Long
End Type
Public Type stGameData
    strDataName As String
    strHash As String
    lngHash As Long
End Type
Private Type stGameDataMap
    stGameDatas() As stGameData
    intDataCount As Integer
    strDataType As String
    intDataTypeSize As Integer
    intDataHashOffset As Integer
End Type
Public Type stMapObjectDataMap
    btDataCount As Byte
    ptrData(1 To 4) As LongPtr
    btDataSize(0 To 4) As Byte
    strDataLabel(1 To 4) As String * 1
End Type
Public Type stMapObject
    lngHashId As Long
    strHashId As String
    lngRotationFactors(1 To 3) As Long
    lngSRTHash As Long
    lngScaleFactors(1 To 3) As Long
    lngCoordinates(1 To 3) As Long
    strUnitConfigName As String
    stMapUnitObjectDataMap As stMapObjectDataMap
End Type
Public Enum BOTW_GAMEDATAS
    BOTW_BOOLGAMEDATA = 1
    BOTW_S32GAMEDATA = 2
    BOTW_F32GAMEDATA = 3
    BOTW_STR32GAMEDATA = 4
    BOTW_STR64GAMEDATA = 5
    BOTW_STR256GAMEDATA = 6
    BOTW_VECTOR2FGAMEDATA = 7
    BOTW_VECTOR3FGAMEDATA = 8
    BOTW_VECTOR4FGAMEDATA = 9
    BOTW_BOOLARRAYGAMEDATA = 10
    BOTW_S32ARRAYGAMEDATA = 11
    BOTW_F32ARRAYGAMEDATA = 12
    BOTW_STR32ARRAYGAMEDATA = 13
    BOTW_STR64ARRAYGAMEDATA = 14
    BOTW_STR256ARRAYGAMEDATA = 15
    BOTW_VECTOR2FARRAYGAMEDATA = 16
    BOTW_VECTOR3FARRAYGAMEDATA = 17
    BOTW_VECTOR4FARRAYGAMEDATA = 18
End Enum
Public Type stGameBinDataMap
    lngCount As Long
    lngSize As Long
    lngAddress As Long
End Type
Private stGameDataMaps(1 To 18) As stGameDataMap
Private stGameBinDataMaps(1 To 18) As stGameBinDataMap

Public Function Botw_readInventoryBinData(ByRef stMemoryDataMap As stDataMap, Optional ByVal strCemuFolderPath As String = "") As Long
Dim stProcess As PROCESSENTRY32
Dim stCemuLogData() As stExtractedTextData
Dim lngLngMemoryBase As LongLong
    Botw_readInventoryBinData = 0
    strCemuFolderPath = Cemu_GetRootFolderPath(strCemuFolderPath)
    Call Memory_InitDataMap("MemoryData.A4:C4", stMemoryDataMap)
    stProcess.dwSize = Cemu_openProcess(SYSTEM_PROC_VMREAD, stProcess)
    If stProcess.dwSize <> 0 Then
        If System_ToogleProcessById(stProcess.th32ProcessID, True) > 0 Then
            stProcess.dwFlags = File_ExtractText("Cemu.A2:C32", stCemuLogData, strCemuFolderPath + "log.txt", CEMU_LOG_WIIUMEMORYBASE)
            If stProcess.dwFlags = 1 Then
                lngLngMemoryBase = CLngLng("&H" + stCemuLogData(1).objData.Item(0).SubMatches(0))
                Botw_readInventoryBinData = Memory_getMappedDataAddress(stProcess.dwSize, lngLngMemoryBase, stMemoryDataMap.lngLowerOffsets)
                If ReadProcessMemory(stProcess.dwSize, lngLngMemoryBase + Botw_readInventoryBinData, VarPtr(stMemoryDataMap.btData(0)), stMemoryDataMap.lngDataSize, 0) = 0 Then Botw_readInventoryBinData = 0
                Set stCemuLogData(1).objData = Nothing
                Erase stCemuLogData
            End If
            System_ToogleProcessById stProcess.th32ProcessID, False
        End If
        CloseHandle stProcess.dwSize
    Else
        strCemuFolderPath = Cemu_GetDumpFolderPath(strCemuFolderPath)
        If strCemuFolderPath <> "" Then
            stProcess.dwSize = Cemu_openDumpFile(strCemuFolderPath, stProcess.dwFlags)
            Botw_readInventoryBinData = File_getMappedDataAddress(stProcess.dwSize, stProcess.dwFlags, stMemoryDataMap.lngLowerOffsets)
            Get stProcess.dwSize, Botw_readInventoryBinData - stProcess.dwFlags + 1, stMemoryDataMap.btData
            Close stProcess.dwSize
        End If
    End If
End Function

Private Sub Botw_InitGameDataMap(ByVal intNamesColumn As Integer)
Dim i As Integer
Dim xlsWorksheet As Worksheet
Dim xlsUserDataRange As Range
Dim xlsRange As Range
Dim btGameDataCount As Byte
Dim stCurrentGameData As stGameData
    btGameDataCount = UBound(stGameDataMaps)
    Set xlsWorksheet = ThisWorkbook.Worksheets("GameData")
    Set xlsRange = xlsWorksheet.Range("A2:E" + CStr(btGameDataCount + 1)).Cells
    If intNamesColumn = 1 Then
        Do Until btGameDataCount = 0
            With stGameDataMaps(btGameDataCount)
            ReDim .stGameDatas(1 To 1)
            .stGameDatas(1).strDataName = xlsRange.Item(btGameDataCount, 1).Text
            .intDataCount = 1
            .strDataType = xlsRange.Item(btGameDataCount, 2).Text
            .intDataTypeSize = xlsRange.Item(btGameDataCount, 3).Value
            .intDataHashOffset = xlsRange.Item(btGameDataCount, 4).Value
            End With
            btGameDataCount = btGameDataCount - 1
        Loop
    Else
        Set xlsUserDataRange = xlsWorksheet.Range(Chr(64 + intNamesColumn) + "2:" + Chr(63 + intNamesColumn + btGameDataCount) + "32767").Cells
        Do
            With stGameDataMaps(btGameDataCount)
            .intDataCount = xlsRange.Item(btGameDataCount, 5).Value
            If .intDataCount > 0 Then
                ReDim .stGameDatas(1 To .intDataCount)
                For .intDataCount = 1 To 32766
                    stCurrentGameData.strDataName = xlsUserDataRange.Item(.intDataCount, btGameDataCount).Text
                    If stCurrentGameData.strDataName = "" Then
                        .intDataCount = .intDataCount - 1
                        If .intDataCount = 0 Then Erase .stGameDatas
                        Exit For
                    Else
                        stCurrentGameData.lngHash = Crc_CRC32(stCurrentGameData.strDataName)
                        stCurrentGameData.strHash = Right("0000000" + Hex(stCurrentGameData.lngHash), 8)
                        For i = .intDataCount - 1 To 1 Step -1
                            If stCurrentGameData.strHash > .stGameDatas(i).strHash Then
                                Exit For
                            Else
                                intNamesColumn = i + 1
                                .stGameDatas(intNamesColumn) = .stGameDatas(i)
                                xlsUserDataRange.Item(intNamesColumn, btGameDataCount).Value = .stGameDatas(i).strDataName
                            End If
                        Next i
                        intNamesColumn = i + 1
                        .stGameDatas(intNamesColumn) = stCurrentGameData
                        xlsUserDataRange.Item(intNamesColumn, btGameDataCount).Value = stCurrentGameData.strDataName
                    End If
                Next .intDataCount
            End If
            .strDataType = xlsRange.Item(btGameDataCount, 2).Text
            .intDataTypeSize = xlsRange.Item(btGameDataCount, 3).Value
            .intDataHashOffset = xlsRange.Item(btGameDataCount, 4).Value
            End With
            btGameDataCount = btGameDataCount - 1
        Loop Until btGameDataCount = 0
        Set xlsUserDataRange = Nothing
    End If
    Set xlsRange = Nothing
    Set xlsWorksheet = Nothing
End Sub

Public Function Botw_ReadGameBinData(ByRef stMemoryDataMap As stDataMap, Optional ByVal strCemuFolderPath As String = "") As Long
Dim stProcess As PROCESSENTRY32
Dim stCemuLogData() As stExtractedTextData
Dim lngLngMemoryBase As LongLong
Dim stSwapGameData As stGameData
Dim lngVectorDataAddresses() As Long
Static lngDataArrayInfos(1 To 4) As Long
    Botw_ReadGameBinData = 0
    strCemuFolderPath = Cemu_GetRootFolderPath(strCemuFolderPath)
    Call Memory_InitDataMap("MemoryData.A2:C2", stMemoryDataMap)
    stProcess.dwSize = Cemu_openProcess(SYSTEM_PROC_VMREAD, stProcess)
    If stProcess.dwSize <> 0 Then
        If System_ToogleProcessById(stProcess.th32ProcessID, True) > 0 Then
            stProcess.dwFlags = File_ExtractText("Cemu.A2:C32", stCemuLogData, strCemuFolderPath + "log.txt", CEMU_LOG_WIIUMEMORYBASE)
            If stProcess.dwFlags = 1 Then
                lngLngMemoryBase = CLngLng("&H" + stCemuLogData(1).objData.Item(0).SubMatches(0))
                Botw_ReadGameBinData = Memory_getMappedDataAddress(stProcess.dwSize, lngLngMemoryBase, stMemoryDataMap.lngLowerOffsets)
                If Botw_ReadGameBinData <> 0 Then
                    If ReadProcessMemory(stProcess.dwSize, lngLngMemoryBase + Botw_ReadGameBinData + 4, VarPtr(stGameBinDataMaps(1)), stMemoryDataMap.lngDataSize, 0) <> 0 Then
                        Call Botw_InitGameDataMap(7)
                        stProcess.dwFlags = UBound(stGameDataMaps)
                        Do
                            If stGameBinDataMaps(stProcess.dwFlags).lngCount <> 0 Then
                                stGameBinDataMaps(stProcess.dwFlags).lngCount = Converter_SwapEndian(stGameBinDataMaps(stProcess.dwFlags).lngCount)
                                With stGameDataMaps(stProcess.dwFlags)
                                If System_ReadProcessLongMemoryDataSegment(stProcess.dwSize, lngLngMemoryBase + Converter_SwapEndian(stGameBinDataMaps(stProcess.dwFlags).lngAddress), stGameBinDataMaps(stProcess.dwFlags).lngCount, lngVectorDataAddresses) <> 0 Then
                                    If .intDataHashOffset < 0 Then
                                        .intDataHashOffset = 8 - .intDataHashOffset
                                        For stGameBinDataMaps(stProcess.dwFlags).lngSize = stGameBinDataMaps(stProcess.dwFlags).lngCount To 1 Step -1
                                            If ReadProcessMemory(stProcess.dwSize, lngLngMemoryBase + Converter_SwapEndian(lngVectorDataAddresses(stGameBinDataMaps(stProcess.dwFlags).lngSize)), VarPtr(lngDataArrayInfos(1)), 16, 0) <> 0 Then
                                                lngDataArrayInfos(4) = Converter_SwapEndian(lngDataArrayInfos(4)) + Converter_SwapEndian(lngDataArrayInfos(1)) * .intDataHashOffset - 8
                                                If lngDataArrayInfos(4) > stMemoryDataMap.lngDataSize Then stMemoryDataMap.lngDataSize = lngDataArrayInfos(4)
                                                If ReadProcessMemory(stProcess.dwSize, lngLngMemoryBase + lngDataArrayInfos(4), VarPtr(lngDataArrayInfos(2)), 4, 0) <> 0 Then
                                                    lngDataArrayInfos(2) = Converter_SwapEndian(lngDataArrayInfos(2))
                                                    For lngDataArrayInfos(3) = .intDataCount To 1 Step -1
                                                        If .stGameDatas(lngDataArrayInfos(3)).lngHash = lngDataArrayInfos(2) Then
                                                            .stGameDatas(lngDataArrayInfos(3)).lngHash = lngDataArrayInfos(4)
                                                            If lngDataArrayInfos(3) <> .intDataCount Then
                                                                stSwapGameData = .stGameDatas(lngDataArrayInfos(3))
                                                                .stGameDatas(lngDataArrayInfos(3)) = .stGameDatas(.intDataCount)
                                                                .stGameDatas(.intDataCount) = stSwapGameData
                                                            End If
                                                            .intDataCount = .intDataCount - 1
                                                            Exit For
                                                        End If
                                                    Next lngDataArrayInfos(3)
                                                End If
                                            End If
                                        Next stGameBinDataMaps(stProcess.dwFlags).lngSize
                                    Else
                                        For stGameBinDataMaps(stProcess.dwFlags).lngSize = stGameBinDataMaps(stProcess.dwFlags).lngCount To 1 Step -1
                                            lngVectorDataAddresses(stGameBinDataMaps(stProcess.dwFlags).lngSize) = Converter_SwapEndian(lngVectorDataAddresses(stGameBinDataMaps(stProcess.dwFlags).lngSize)) + .intDataHashOffset
                                            If lngVectorDataAddresses(stGameBinDataMaps(stProcess.dwFlags).lngSize) > stMemoryDataMap.lngDataSize Then stMemoryDataMap.lngDataSize = lngVectorDataAddresses(stGameBinDataMaps(stProcess.dwFlags).lngSize)
                                            If .intDataCount <> 0 Then
                                                If ReadProcessMemory(stProcess.dwSize, lngLngMemoryBase + lngVectorDataAddresses(stGameBinDataMaps(stProcess.dwFlags).lngSize), VarPtr(lngDataArrayInfos(2)), 4, 0) <> 0 Then
                                                    If Converter_SwapEndian(lngDataArrayInfos(2)) = .stGameDatas(.intDataCount).lngHash Then
                                                        .stGameDatas(.intDataCount).lngHash = lngVectorDataAddresses(stGameBinDataMaps(stProcess.dwFlags).lngSize)
                                                        .intDataCount = .intDataCount - 1
                                                    End If
                                                End If
                                            End If
                                        Next stGameBinDataMaps(stProcess.dwFlags).lngSize
                                    End If
                                End If
                                Erase lngVectorDataAddresses
                                End With
                            End If
                            stProcess.dwFlags = stProcess.dwFlags - 1
                        Loop Until stProcess.dwFlags = 0
                        stMemoryDataMap.lngDataSize = stMemoryDataMap.lngDataSize + 8 - Botw_ReadGameBinData
                        ReDim stMemoryDataMap.btData(0 To stMemoryDataMap.lngDataSize - 1)
                        If ReadProcessMemory(stProcess.dwSize, lngLngMemoryBase + Botw_ReadGameBinData, VarPtr(stMemoryDataMap.btData(0)), stMemoryDataMap.lngDataSize, 0) = 0 Then
                            Botw_ReadGameBinData = 0
                            Erase stMemoryDataMap.btData
                            Erase stMemoryDataMap.lngLowerOffsets
                        End If
                    End If
                End If
                Set stCemuLogData(1).objData = Nothing
                Erase stCemuLogData
            End If
            System_ToogleProcessById stProcess.th32ProcessID, False
        End If
        CloseHandle stProcess.dwSize
    Else
        strCemuFolderPath = Cemu_GetDumpFolderPath(strCemuFolderPath)
        If strCemuFolderPath <> "" Then
            stProcess.dwSize = Cemu_openDumpFile(strCemuFolderPath, stProcess.th32ProcessID)
            Botw_ReadGameBinData = File_getMappedDataAddress(stProcess.dwSize, stProcess.th32ProcessID, stMemoryDataMap.lngLowerOffsets)
            If Botw_ReadGameBinData <> 0 Then
                Get stProcess.dwSize, Botw_ReadGameBinData - stProcess.th32ProcessID + 5, stGameBinDataMaps
                Call Botw_InitGameDataMap(7)
                stProcess.dwFlags = UBound(stGameDataMaps)
                Do
                    If stGameBinDataMaps(stProcess.dwFlags).lngCount <> 0 Then
                        stGameBinDataMaps(stProcess.dwFlags).lngCount = Converter_SwapEndian(stGameBinDataMaps(stProcess.dwFlags).lngCount)
                        With stGameDataMaps(stProcess.dwFlags)
                        Call File_ReadLongDataSegment(stProcess.dwSize, Converter_SwapEndian(stGameBinDataMaps(stProcess.dwFlags).lngAddress) - stProcess.th32ProcessID + 1, stGameBinDataMaps(stProcess.dwFlags).lngCount, lngVectorDataAddresses)
                        If .intDataHashOffset < 0 Then
                            .intDataHashOffset = 8 - .intDataHashOffset
                            For stGameBinDataMaps(stProcess.dwFlags).lngSize = stGameBinDataMaps(stProcess.dwFlags).lngCount To 1 Step -1
                                Get stProcess.dwSize, Converter_SwapEndian(lngVectorDataAddresses(stGameBinDataMaps(stProcess.dwFlags).lngSize)) - stProcess.th32ProcessID + 1, lngDataArrayInfos
                                lngDataArrayInfos(4) = Converter_SwapEndian(lngDataArrayInfos(4)) + Converter_SwapEndian(lngDataArrayInfos(1)) * .intDataHashOffset - 8
                                If lngDataArrayInfos(4) > stMemoryDataMap.lngDataSize Then stMemoryDataMap.lngDataSize = lngDataArrayInfos(4)
                                Get stProcess.dwSize, lngDataArrayInfos(4) - stProcess.th32ProcessID + 1, lngDataArrayInfos(2)
                                lngDataArrayInfos(2) = Converter_SwapEndian(lngDataArrayInfos(2))
                                For lngDataArrayInfos(3) = .intDataCount To 1 Step -1
                                    If .stGameDatas(lngDataArrayInfos(3)).lngHash = lngDataArrayInfos(2) Then
                                        .stGameDatas(lngDataArrayInfos(3)).lngHash = lngDataArrayInfos(4)
                                        If lngDataArrayInfos(3) <> .intDataCount Then
                                            stSwapGameData = .stGameDatas(lngDataArrayInfos(3))
                                            .stGameDatas(lngDataArrayInfos(3)) = .stGameDatas(.intDataCount)
                                            .stGameDatas(.intDataCount) = stSwapGameData
                                        End If
                                        .intDataCount = .intDataCount - 1
                                        Exit For
                                    End If
                                Next lngDataArrayInfos(3)
                            Next stGameBinDataMaps(stProcess.dwFlags).lngSize
                        Else
                            For stGameBinDataMaps(stProcess.dwFlags).lngSize = stGameBinDataMaps(stProcess.dwFlags).lngCount To 1 Step -1
                                lngVectorDataAddresses(stGameBinDataMaps(stProcess.dwFlags).lngSize) = Converter_SwapEndian(lngVectorDataAddresses(stGameBinDataMaps(stProcess.dwFlags).lngSize)) + .intDataHashOffset
                                If lngVectorDataAddresses(stGameBinDataMaps(stProcess.dwFlags).lngSize) > stMemoryDataMap.lngDataSize Then stMemoryDataMap.lngDataSize = lngVectorDataAddresses(stGameBinDataMaps(stProcess.dwFlags).lngSize)
                                If .intDataCount <> 0 Then
                                    Get stProcess.dwSize, lngVectorDataAddresses(stGameBinDataMaps(stProcess.dwFlags).lngSize) - stProcess.th32ProcessID + 1, lngDataArrayInfos(2)
                                    If Converter_SwapEndian(lngDataArrayInfos(2)) = .stGameDatas(.intDataCount).lngHash Then
                                        .stGameDatas(.intDataCount).lngHash = lngVectorDataAddresses(stGameBinDataMaps(stProcess.dwFlags).lngSize)
                                        .intDataCount = .intDataCount - 1
                                    End If
                                End If
                            Next stGameBinDataMaps(stProcess.dwFlags).lngSize
                        End If
                        Erase lngVectorDataAddresses
                        End With
                    End If
                    stProcess.dwFlags = stProcess.dwFlags - 1
                Loop Until stProcess.dwFlags = 0
                stMemoryDataMap.lngDataSize = stMemoryDataMap.lngDataSize + 8 - Botw_ReadGameBinData
                ReDim stMemoryDataMap.btData(0 To stMemoryDataMap.lngDataSize - 1)
                Get stProcess.dwSize, Botw_ReadGameBinData - stProcess.th32ProcessID + 1, stMemoryDataMap.btData
            End If
            Close stProcess.dwSize
        End If
    End If
End Function

Public Function Botw_MemorySearcherInventoryDataIniFile(Optional ByVal strCemuFolderPath As String = "", Optional ByVal ITEMTYPEFILTER As BOTW_INVENTORYITEM_FILTERS = BOTW_ALLITEMS, Optional ByVal strItemIdFilter As String = "*") As Long
'Usage example with the immediate window: ?Botw_MemorySearcherInventoryDataIniFile("", BOTW_ALLITEMS)
'Output: D:\WiiU\1.23.0\memorySearcher\00050000101c9<3|4|5|X>00.ini
Dim objInventoryItem As stInventoryItem
Dim stMemoryDataMap As stDataMap
    strCemuFolderPath = Cemu_GetRootFolderPath(strCemuFolderPath)
    Botw_MemorySearcherInventoryDataIniFile = Botw_readInventoryBinData(stMemoryDataMap, strCemuFolderPath)
    If Botw_MemorySearcherInventoryDataIniFile <> 0 Then
        objInventoryItem.strId = Cemu_GetBotwTitleId
        stMemoryDataMap.lngLowerOffsets(0) = FreeFile
        Open strCemuFolderPath + "memorySearcher\" + Left(objInventoryItem.strId, 8) + Mid(objInventoryItem.strId, 10, 8) + ".ini" For Output As stMemoryDataMap.lngLowerOffsets(0)
        For stMemoryDataMap.lngDataSize = 228044 To 108 Step -544
            If stMemoryDataMap.btData(stMemoryDataMap.lngDataSize + 36) <> 0 Then
                Call CopyMemory(VarPtr(objInventoryItem), VarPtr(stMemoryDataMap.btData(stMemoryDataMap.lngDataSize)), 544)
                If (ITEMTYPEFILTER And (2^ ^ Converter_SwapEndian(objInventoryItem.lngType))) <> 0 Then
                    strCemuFolderPath = Left(objInventoryItem.strId, InStr(objInventoryItem.strId, Chr(0)) - 1)
                    If strCemuFolderPath Like strItemIdFilter Then
                        Print #stMemoryDataMap.lngLowerOffsets(0), "[Entry]" + vbCrLf + "description=" + strCemuFolderPath + " (Qty|Dur)" + vbCrLf + "address=0x" + Hex(Botw_MemorySearcherInventoryDataIniFile + stMemoryDataMap.lngDataSize + &H10) + vbCrLf + "type=int32" + vbCrLf + "value=" + vbCrLf
                        'Add other inventory item data here
                    End If
                End If
            End If
        Next stMemoryDataMap.lngDataSize
        Close stMemoryDataMap.lngLowerOffsets(0)
        Erase stMemoryDataMap.lngLowerOffsets
        Erase stMemoryDataMap.btData
    End If
End Function

Public Function Botw_SaveDataCmp() As Long
'TODO
End Function

Private Function Botw_FGameDataCmp(ByVal intFile1 As Integer, ByVal intFile2 As Integer, ByVal lngOffset As Long, ByVal intDataSize As Integer, ByRef lngDataHash) As Long
Static btBinData1(0 To 255) As Byte
Static btBinData2(0 To 255) As Byte
    Get intFile1, lngOffset, btBinData1
    Get intFile2, lngOffset, btBinData2
    Call CopyMemory(VarPtr(lngDataHash), VarPtr(btBinData1(intDataSize - 4)), 4)
    lngDataHash = Converter_SwapEndian(lngDataHash)
    Botw_FGameDataCmp = CompareMemory(VarPtr(btBinData1(0)), VarPtr(btBinData2(0)), intDataSize)
End Function

Private Function Botw_FgetGameROMPlayerDataAddress(ByVal intFile As Integer, ByVal lngDeltaOffset As Long) As Long
Static lngLowerOffsets(0 To 1) As Long
    If lngLowerOffsets(1) = 0 Then
        lngLowerOffsets(0) = 48 '0x30
        lngLowerOffsets(1) = 273039160 '0x10460000 + 0x3F38
    End If
    Botw_FgetGameROMPlayerDataAddress = File_getMappedDataAddress(intFile, lngDeltaOffset, lngLowerOffsets)
End Function

Public Function Botw_FgetGameDataAddress(ByVal intFile As Integer, ByVal lngDeltaOffset As Long) As Long
Static lngLowerOffsets(0 To 2) As Long
    If lngLowerOffsets(2) = 0 Then
        lngLowerOffsets(0) = 0
        lngLowerOffsets(1) = 1808 '0x710
        lngLowerOffsets(2) = 273077680 '0x10470000 - 0x2a50
    End If
    Botw_FgetGameDataAddress = File_getMappedDataAddress(intFile, lngDeltaOffset, lngLowerOffsets)
End Function

Public Function Botw_PgetGameDataAddress(ByRef lngProcess As Long, ByRef lngLngMemoryBase As LongLong) As Long
Static lngLowerOffsets(0 To 2) As Long
    If lngLowerOffsets(2) = 0 Then
        lngLowerOffsets(0) = 0
        lngLowerOffsets(1) = 1808 '0x710
        lngLowerOffsets(2) = 273077680 '0x10470000 - 0x2a50
    End If
    Botw_PgetGameDataAddress = Memory_getMappedDataAddress(lngProcess, lngLngMemoryBase, lngLowerOffsets)
End Function

Public Function Botw_GameDataCmp(ByVal strDumpFolderPath1 As String, ByVal strDumpFolderPath2 As String) As Long
'Usage example with the immediate window: ?Botw_GameDataCmp("D:\WiiU\bcml\dump\ramDump1623276340\", "D:\WiiU\bcml\dump\ramDump1624645914\")
'Output: D:\WiiU\1.23.0\dump\ramDump1623276340-ramDump1624645914.txt
Dim btGameDataMapsLength As Byte
Dim intInputFile As Integer
Dim intOutputFile As Integer
Dim lngDeltaOffset As Long
Dim lngVectorDataAddresses() As Long
Static lngDataArrayInfos(1 To 4) As Long
    Botw_GameDataCmp = 0
    intInputFile = Cemu_openDumpFile(strDumpFolderPath1, lngDeltaOffset)
    lngDataArrayInfos(1) = Botw_FgetGameDataAddress(intInputFile, lngDeltaOffset)
    If lngDataArrayInfos(1) <> 0 Then
        Get intInputFile, lngDataArrayInfos(1) - lngDeltaOffset + 5, stGameBinDataMaps
        Call Botw_InitGameDataMap(1)
        Botw_GameDataCmp = Cemu_openDumpFile(strDumpFolderPath2, lngDeltaOffset)
        btGameDataMapsLength = UBound(stGameDataMaps)
        strDumpFolderPath1 = Left(strDumpFolderPath1, Len(strDumpFolderPath1) - 1)
        lngDataArrayInfos(1) = InStrRev(strDumpFolderPath1, "\")
        strDumpFolderPath2 = Mid(strDumpFolderPath2, lngDataArrayInfos(1) + 1)
        intOutputFile = FreeFile
        Open Left(strDumpFolderPath1, lngDataArrayInfos(1)) + Mid(strDumpFolderPath1, lngDataArrayInfos(1) + 1) + "-" + Left(strDumpFolderPath2, Len(strDumpFolderPath2) - 1) + ".txt" For Output As intOutputFile
        Do
            If stGameBinDataMaps(btGameDataMapsLength).lngCount <> 0 Then
                stGameBinDataMaps(btGameDataMapsLength).lngCount = Converter_SwapEndian(stGameBinDataMaps(btGameDataMapsLength).lngCount)
                Call File_ReadLongDataSegment(intInputFile, Converter_SwapEndian(stGameBinDataMaps(btGameDataMapsLength).lngAddress) - lngDeltaOffset + 1, stGameBinDataMaps(btGameDataMapsLength).lngCount, lngVectorDataAddresses)
                With stGameDataMaps(btGameDataMapsLength)
                Print #intOutputFile, vbCrLf + "[" + .stGameDatas(1).strDataName + "]"
                Erase .stGameDatas
                .intDataTypeSize = .intDataTypeSize + 4
                If .intDataHashOffset < 0 Then
                    .intDataHashOffset = 8 - .intDataHashOffset
                    For stGameBinDataMaps(btGameDataMapsLength).lngSize = stGameBinDataMaps(btGameDataMapsLength).lngCount To 1 Step -1
                        Get intInputFile, Converter_SwapEndian(lngVectorDataAddresses(stGameBinDataMaps(btGameDataMapsLength).lngSize)) - lngDeltaOffset + 1, lngDataArrayInfos
                        lngDataArrayInfos(1) = Converter_SwapEndian(lngDataArrayInfos(1))
                        lngDataArrayInfos(4) = Converter_SwapEndian(lngDataArrayInfos(4)) + lngDataArrayInfos(1) * .intDataHashOffset - 3
                        Do
                            If Botw_FGameDataCmp(intInputFile, Botw_GameDataCmp, lngDataArrayInfos(4) - .intDataTypeSize, .intDataTypeSize, lngDataArrayInfos(2)) <> .intDataTypeSize Then Print #intOutputFile, Right("0000000" + Hex(lngDataArrayInfos(2)), 8) + " (" + CStr(lngDataArrayInfos(2)) + ") [" + CStr(lngDataArrayInfos(1)) + "]"
                            lngDataArrayInfos(4) = lngDataArrayInfos(4) - stGameDataMaps(btGameDataMapsLength).intDataHashOffset
                            lngDataArrayInfos(1) = lngDataArrayInfos(1) - 1
                        Loop Until lngDataArrayInfos(1) = 0
                    Next stGameBinDataMaps(btGameDataMapsLength).lngSize
                Else
                    For stGameBinDataMaps(btGameDataMapsLength).lngSize = stGameBinDataMaps(btGameDataMapsLength).lngCount To 1 Step -1
                        If Botw_FGameDataCmp(intInputFile, Botw_GameDataCmp, Converter_SwapEndian(lngVectorDataAddresses(stGameBinDataMaps(btGameDataMapsLength).lngSize)) - lngDeltaOffset + 5 + .intDataHashOffset - stGameDataMaps(btGameDataMapsLength).intDataTypeSize, stGameDataMaps(btGameDataMapsLength).intDataTypeSize, lngDataArrayInfos(2)) <> stGameDataMaps(btGameDataMapsLength).intDataTypeSize Then Print #intOutputFile, Right("0000000" + Hex(lngDataArrayInfos(2)), 8) + " (" + CStr(lngDataArrayInfos(2)) + ")"
                    Next stGameBinDataMaps(btGameDataMapsLength).lngSize
                End If
                End With
                Erase lngVectorDataAddresses
            End If
            btGameDataMapsLength = btGameDataMapsLength - 1
        Loop Until btGameDataMapsLength = 0
        Close intOutputFile
        Close Botw_GameDataCmp
    End If
    Close intInputFile
End Function

Public Function Botw_MemorySearcherGameDataIniFile(Optional ByVal strCemuFolderPath As String = "") As Long
'Usage example with the immediate window: ?Botw_MemorySearcherGameDataIniFile()
'Output: D:\WiiU\1.23.0\memorySearcher\00050000101c9<3|4|5|X>00.ini
Dim stProcess As PROCESSENTRY32
Dim stCemuLogData() As stExtractedTextData
Dim lngLngMemoryBase As LongLong
Dim lngVectorDataAddresses() As Long
Static lngDataArrayInfos(1 To 4) As Long
    Botw_MemorySearcherGameDataIniFile = 0
    strCemuFolderPath = Cemu_GetRootFolderPath(strCemuFolderPath)
    stProcess.dwFlags = File_ExtractText("Cemu.A2:C32", stCemuLogData, strCemuFolderPath + "log.txt", CEMU_LOG_WIIUMEMORYBASE Or CEMU_LOG_TITLEID)
    If stProcess.dwFlags = 2 Then
        stProcess.dwSize = Cemu_openProcess(SYSTEM_PROC_VMREAD, stProcess)
        If stProcess.dwSize <> 0 Then
            If System_ToogleProcessById(stProcess.th32ProcessID, True) > 0 Then
                lngLngMemoryBase = CLngLng("&H" + stCemuLogData(1).objData.Item(0).SubMatches(0))
                Botw_MemorySearcherGameDataIniFile = Botw_PgetGameDataAddress(stProcess.dwSize, lngLngMemoryBase)
                If Botw_MemorySearcherGameDataIniFile <> 0 Then
                    If ReadProcessMemory(stProcess.dwSize, lngLngMemoryBase + Botw_MemorySearcherGameDataIniFile + 4, VarPtr(stGameBinDataMaps(1)), 216, 0) <> 0 Then
                        Call Botw_InitGameDataMap(7)
                        stCemuLogData(1).intLine = UBound(stGameDataMaps)
                        stProcess.cntUsage = FreeFile
                        Open strCemuFolderPath + "memorySearcher\" + Left(stCemuLogData(2).objData.Item(0).SubMatches(0), 8) + Mid(stCemuLogData(2).objData.Item(0).SubMatches(0), 10) + ".ini" For Output As stProcess.cntUsage
                        Do
                            If stGameDataMaps(stCemuLogData(1).intLine).intDataCount <> 0 Then
                                If stGameBinDataMaps(stCemuLogData(1).intLine).lngCount <> 0 Then
                                    stGameBinDataMaps(stCemuLogData(1).intLine).lngCount = Converter_SwapEndian(stGameBinDataMaps(stCemuLogData(1).intLine).lngCount)
                                    If System_ReadProcessLongMemoryDataSegment(stProcess.dwSize, lngLngMemoryBase + Converter_SwapEndian(stGameBinDataMaps(stCemuLogData(1).intLine).lngAddress), stGameBinDataMaps(stCemuLogData(1).intLine).lngCount, lngVectorDataAddresses) <> 0 Then
                                        If stGameDataMaps(stCemuLogData(1).intLine).intDataHashOffset < 0 Then
                                            stGameDataMaps(stCemuLogData(1).intLine).intDataHashOffset = 8 - stGameDataMaps(stCemuLogData(1).intLine).intDataHashOffset
                                            For stGameBinDataMaps(stCemuLogData(1).intLine).lngSize = stGameBinDataMaps(stCemuLogData(1).intLine).lngCount To 1 Step -1
                                                If ReadProcessMemory(stProcess.dwSize, lngLngMemoryBase + Converter_SwapEndian(lngVectorDataAddresses(stGameBinDataMaps(stCemuLogData(1).intLine).lngSize)), VarPtr(lngDataArrayInfos(1)), 16, 0) <> 0 Then
                                                    lngDataArrayInfos(1) = Converter_SwapEndian(lngDataArrayInfos(1))
                                                    lngDataArrayInfos(4) = Converter_SwapEndian(lngDataArrayInfos(4)) + lngDataArrayInfos(1) * stGameDataMaps(stCemuLogData(1).intLine).intDataHashOffset - 8
                                                    If ReadProcessMemory(stProcess.dwSize, lngLngMemoryBase + lngDataArrayInfos(4), VarPtr(lngDataArrayInfos(2)), 4, 0) <> 0 Then
                                                        lngDataArrayInfos(2) = Converter_SwapEndian(lngDataArrayInfos(2))
                                                        GoSub Botw_MemorySearcherGameDataIniFileSub0
                                                        If stGameDataMaps(stCemuLogData(1).intLine).intDataCount = 0 Then Exit For
                                                    End If
                                                End If
                                            Next stGameBinDataMaps(stCemuLogData(1).intLine).lngSize
                                        Else
                                            For stGameBinDataMaps(stCemuLogData(1).intLine).lngSize = stGameBinDataMaps(stCemuLogData(1).intLine).lngCount To 1 Step -1
                                                lngVectorDataAddresses(stGameBinDataMaps(stCemuLogData(1).intLine).lngSize) = Converter_SwapEndian(lngVectorDataAddresses(stGameBinDataMaps(stCemuLogData(1).intLine).lngSize)) + stGameDataMaps(stCemuLogData(1).intLine).intDataHashOffset
                                                If ReadProcessMemory(stProcess.dwSize, lngLngMemoryBase + lngVectorDataAddresses(stGameBinDataMaps(stCemuLogData(1).intLine).lngSize), VarPtr(lngDataArrayInfos(2)), 4, 0) <> 0 Then
                                                    If Converter_SwapEndian(lngDataArrayInfos(2)) = stGameDataMaps(stCemuLogData(1).intLine).stGameDatas(stGameDataMaps(stCemuLogData(1).intLine).intDataCount).lngHash Then
                                                        GoSub Botw_MemorySearcherGameDataIniFileSub1
                                                        stGameDataMaps(stCemuLogData(1).intLine).intDataCount = stGameDataMaps(stCemuLogData(1).intLine).intDataCount - 1
                                                        If stGameDataMaps(stCemuLogData(1).intLine).intDataCount = 0 Then Exit For
                                                    End If
                                                End If
                                            Next stGameBinDataMaps(stCemuLogData(1).intLine).lngSize
                                        End If
                                    End If
                                    Erase lngVectorDataAddresses
                                End If
                            End If
                            stCemuLogData(1).intLine = stCemuLogData(1).intLine - 1
                        Loop Until stCemuLogData(1).intLine = 0
                        Close stProcess.cntUsage
                    End If
                End If
                System_ToogleProcessById stProcess.th32ProcessID, False
            End If
            CloseHandle stProcess.dwSize
        Else
            strCemuFolderPath = Cemu_GetDumpFolderPath(strCemuFolderPath)
            If strCemuFolderPath <> "" Then
                stProcess.dwSize = Cemu_openDumpFile(strCemuFolderPath, stProcess.th32ProcessID)
                Botw_MemorySearcherGameDataIniFile = Botw_FgetGameDataAddress(stProcess.dwSize, stProcess.th32ProcessID)
                If Botw_MemorySearcherGameDataIniFile <> 0 Then
                    Get stProcess.dwSize, Botw_MemorySearcherGameDataIniFile - stProcess.th32ProcessID + 5, stGameBinDataMaps
                    Call Botw_InitGameDataMap(7)
                    stCemuLogData(1).intLine = UBound(stGameDataMaps)
                    stProcess.cntUsage = FreeFile
                    Open strCemuFolderPath + "..\..\memorySearcher\" + Left(stCemuLogData(2).objData.Item(0).SubMatches(0), 8) + Mid(stCemuLogData(2).objData.Item(0).SubMatches(0), 10) + ".ini" For Output As stProcess.cntUsage
                    Do
                        If stGameDataMaps(stCemuLogData(1).intLine).intDataCount <> 0 Then
                            If stGameBinDataMaps(stCemuLogData(1).intLine).lngCount <> 0 Then
                                stGameBinDataMaps(stCemuLogData(1).intLine).lngCount = Converter_SwapEndian(stGameBinDataMaps(stCemuLogData(1).intLine).lngCount)
                                Call File_ReadLongDataSegment(stProcess.dwSize, Converter_SwapEndian(stGameBinDataMaps(stCemuLogData(1).intLine).lngAddress) - stProcess.th32ProcessID + 1, stGameBinDataMaps(stCemuLogData(1).intLine).lngCount, lngVectorDataAddresses)
                                If stGameDataMaps(stCemuLogData(1).intLine).intDataHashOffset < 0 Then
                                    stGameDataMaps(stCemuLogData(1).intLine).intDataHashOffset = 8 - stGameDataMaps(stCemuLogData(1).intLine).intDataHashOffset
                                    For stGameBinDataMaps(stCemuLogData(1).intLine).lngSize = stGameBinDataMaps(stCemuLogData(1).intLine).lngCount To 1 Step -1
                                        Get stProcess.dwSize, Converter_SwapEndian(lngVectorDataAddresses(stGameBinDataMaps(stCemuLogData(1).intLine).lngSize)) - stProcess.th32ProcessID + 1, lngDataArrayInfos
                                        lngDataArrayInfos(1) = Converter_SwapEndian(lngDataArrayInfos(1))
                                        lngDataArrayInfos(4) = Converter_SwapEndian(lngDataArrayInfos(4)) + lngDataArrayInfos(1) * stGameDataMaps(stCemuLogData(1).intLine).intDataHashOffset - 8
                                        Get stProcess.dwSize, lngDataArrayInfos(4) - stProcess.th32ProcessID + 1, lngDataArrayInfos(2)
                                        lngDataArrayInfos(2) = Converter_SwapEndian(lngDataArrayInfos(2))
                                        GoSub Botw_MemorySearcherGameDataIniFileSub0
                                        If stGameDataMaps(stCemuLogData(1).intLine).intDataCount = 0 Then Exit For
                                    Next stGameBinDataMaps(stCemuLogData(1).intLine).lngSize
                                Else
                                    For stGameBinDataMaps(stCemuLogData(1).intLine).lngSize = stGameBinDataMaps(stCemuLogData(1).intLine).lngCount To 1 Step -1
                                        lngVectorDataAddresses(stGameBinDataMaps(stCemuLogData(1).intLine).lngSize) = Converter_SwapEndian(lngVectorDataAddresses(stGameBinDataMaps(stCemuLogData(1).intLine).lngSize)) + stGameDataMaps(stCemuLogData(1).intLine).intDataHashOffset
                                        Get stProcess.dwSize, lngVectorDataAddresses(stGameBinDataMaps(stCemuLogData(1).intLine).lngSize) - stProcess.th32ProcessID + 1, lngDataArrayInfos(2)
                                        If Converter_SwapEndian(lngDataArrayInfos(2)) = stGameDataMaps(stCemuLogData(1).intLine).stGameDatas(stGameDataMaps(stCemuLogData(1).intLine).intDataCount).lngHash Then
                                            GoSub Botw_MemorySearcherGameDataIniFileSub1
                                            stGameDataMaps(stCemuLogData(1).intLine).intDataCount = stGameDataMaps(stCemuLogData(1).intLine).intDataCount - 1
                                            If stGameDataMaps(stCemuLogData(1).intLine).intDataCount = 0 Then Exit For
                                        End If
                                    Next stGameBinDataMaps(stCemuLogData(1).intLine).lngSize
                                End If
                                Erase lngVectorDataAddresses
                            End If
                        End If
                        stCemuLogData(1).intLine = stCemuLogData(1).intLine - 1
                    Loop Until stCemuLogData(1).intLine = 0
                    Close stProcess.cntUsage
                End If
                Close stProcess.dwSize
            End If
        End If
        Set stCemuLogData(1).objData = Nothing
        Set stCemuLogData(2).objData = Nothing
        Erase stCemuLogData
    End If
    Exit Function
Botw_MemorySearcherGameDataIniFileSub0:
    With stGameDataMaps(stCemuLogData(1).intLine)
    For lngDataArrayInfos(3) = .intDataCount To 1 Step -1
        If .stGameDatas(lngDataArrayInfos(3)).lngHash = lngDataArrayInfos(2) Then
            .stGameDatas(lngDataArrayInfos(3)).strDataName = "[Entry]" + vbCrLf + "description=" + .stGameDatas(lngDataArrayInfos(3)).strDataName + "["
            .stGameDatas(lngDataArrayInfos(3)).strHash = "]," + .stGameDatas(lngDataArrayInfos(3)).strHash + "(" + CStr(lngDataArrayInfos(2)) + ")" + vbCrLf + "address=0x"
            If Left(.strDataType, 3) = "str" Then
                strCemuFolderPath = vbCrLf + "type=int64" + vbCrLf + "value=" + vbCrLf
                Do
                    For stProcess.dwFlags = .intDataTypeSize To 8 Step -8
                        Print #stProcess.cntUsage, .stGameDatas(lngDataArrayInfos(3)).strDataName + CStr(lngDataArrayInfos(1)) + .stGameDatas(lngDataArrayInfos(3)).strHash + Hex(lngDataArrayInfos(4) - stProcess.dwFlags) + strCemuFolderPath
                    Next stProcess.dwFlags
                    lngDataArrayInfos(4) = lngDataArrayInfos(4) - .intDataHashOffset
                    lngDataArrayInfos(1) = lngDataArrayInfos(1) - 1
                Loop Until lngDataArrayInfos(1) = 0
            Else
                strCemuFolderPath = vbCrLf + "type=" + .strDataType + vbCrLf + "value=" + vbCrLf
                If .intDataTypeSize > 4 Then
                    Do
                        For stProcess.dwFlags = .intDataTypeSize To 4 Step -4
                            Print #stProcess.cntUsage, .stGameDatas(lngDataArrayInfos(3)).strDataName + CStr(lngDataArrayInfos(1)) + .stGameDatas(lngDataArrayInfos(3)).strHash + Hex(lngDataArrayInfos(4) - stProcess.dwFlags) + strCemuFolderPath
                        Next stProcess.dwFlags
                        lngDataArrayInfos(4) = lngDataArrayInfos(4) - .intDataHashOffset
                        lngDataArrayInfos(1) = lngDataArrayInfos(1) - 1
                    Loop Until lngDataArrayInfos(1) = 0
                Else
                    lngDataArrayInfos(4) = lngDataArrayInfos(4) - .intDataTypeSize
                    Do
                        Print #stProcess.cntUsage, .stGameDatas(lngDataArrayInfos(3)).strDataName + CStr(lngDataArrayInfos(1)) + .stGameDatas(lngDataArrayInfos(3)).strHash + Hex(lngDataArrayInfos(4)) + strCemuFolderPath
                        lngDataArrayInfos(4) = lngDataArrayInfos(4) - .intDataHashOffset
                        lngDataArrayInfos(1) = lngDataArrayInfos(1) - 1
                    Loop Until lngDataArrayInfos(1) = 0
                End If
            End If
            If lngDataArrayInfos(3) <> .intDataCount Then .stGameDatas(lngDataArrayInfos(3)) = .stGameDatas(.intDataCount)
            .intDataCount = .intDataCount - 1
            Exit For
        End If
    Next lngDataArrayInfos(3)
    End With
    Return
Botw_MemorySearcherGameDataIniFileSub1:
    With stGameDataMaps(stCemuLogData(1).intLine)
    .stGameDatas(.intDataCount).strDataName = "[Entry]" + vbCrLf + "description=" + .stGameDatas(.intDataCount).strDataName
    .stGameDatas(.intDataCount).strHash = "," + .stGameDatas(.intDataCount).strHash + "(" + CStr(.stGameDatas(.intDataCount).lngHash) + ")" + vbCrLf + "address=0x"
    If Left(.strDataType, 3) = "str" Then
        strCemuFolderPath = vbCrLf + "type=int64" + vbCrLf + "value=" + vbCrLf
        For stProcess.dwFlags = .intDataTypeSize To 8 Step -8
            Print #stProcess.cntUsage, .stGameDatas(.intDataCount).strDataName + .stGameDatas(.intDataCount).strHash + Hex(lngVectorDataAddresses(stGameBinDataMaps(stCemuLogData(1).intLine).lngSize) - stProcess.dwFlags) + strCemuFolderPath
        Next stProcess.dwFlags
    Else
        strCemuFolderPath = vbCrLf + "type=" + .strDataType + vbCrLf + "value=" + vbCrLf
        If .intDataTypeSize > 4 Then
            For stProcess.dwFlags = .intDataTypeSize To 4 Step -4
                Print #stProcess.cntUsage, .stGameDatas(.intDataCount).strDataName + .stGameDatas(.intDataCount).strHash + Hex(lngVectorDataAddresses(stGameBinDataMaps(stCemuLogData(1).intLine).lngSize) - stProcess.dwFlags) + strCemuFolderPath
            Next stProcess.dwFlags
        Else
            Print #stProcess.cntUsage, .stGameDatas(.intDataCount).strDataName + .stGameDatas(.intDataCount).strHash + Hex(lngVectorDataAddresses(stGameBinDataMaps(stCemuLogData(1).intLine).lngSize) - .intDataTypeSize) + strCemuFolderPath
        End If
    End If
    End With
    Return
End Function

Public Function Deprecated_MemorySearcherGameDataIniFile(ByVal strDumpFolderPath As String) As Long
Dim i As Integer
Dim btGameDataMapsLength As Byte
Dim lngBuffer As Long
Dim lngDataSize As Long
Dim lngDataAddress As Long
Dim lngDataHash As Long
Dim lngGameDataAddress As Long
Dim lngDeltaOffset As Long
Dim intInputFile As Integer
Dim intOutputFile As Integer
    intInputFile = Cemu_openDumpFile(strDumpFolderPath, lngDeltaOffset)
    lngGameDataAddress = Botw_FgetGameDataAddress(intInputFile, lngDeltaOffset)
    If lngGameDataAddress <> 0 Then
        Call Botw_InitGameDataMap(7)
        btGameDataMapsLength = UBound(stGameDataMaps)
        lngGameDataAddress = lngGameDataAddress - lngDeltaOffset + 9 + CLng(btGameDataMapsLength) * 12
        intOutputFile = FreeFile
        Open strDumpFolderPath + "00050000101c9X00.gamedata.ini" For Output As intOutputFile
        Do
            lngGameDataAddress = lngGameDataAddress - 12
            Get intInputFile, lngGameDataAddress, lngDataSize
            If lngDataSize <> 0 Then
                With stGameDataMaps(btGameDataMapsLength)
                If .intDataCount <> 0 Then
                    Get intInputFile, , lngBuffer
                    lngDataSize = Converter_SwapEndian(lngDataSize) * 4
                    lngDataAddress = Converter_SwapEndian(lngBuffer) - lngDeltaOffset + 1
                    If .intDataHashOffset < 0 Then
                        .intDataHashOffset = 8 - .intDataHashOffset
                        Do Until lngDataSize = 0 Or .intDataCount = 0
                            lngDataSize = lngDataSize - 4
                            Get intInputFile, lngDataAddress + lngDataSize, lngBuffer
                            lngBuffer = Converter_SwapEndian(lngBuffer) - lngDeltaOffset + 1
                            Get intInputFile, lngBuffer, Deprecated_MemorySearcherGameDataIniFile
                            Deprecated_MemorySearcherGameDataIniFile = Converter_SwapEndian(Deprecated_MemorySearcherGameDataIniFile)
                            Get intInputFile, lngBuffer + 12, lngBuffer
                            lngBuffer = Converter_SwapEndian(lngBuffer) + Deprecated_MemorySearcherGameDataIniFile * .intDataHashOffset - 8
                            Get intInputFile, lngBuffer - lngDeltaOffset + 1, lngDataHash
                            lngDataHash = Converter_SwapEndian(lngDataHash)
                            For i = .intDataCount To 1 Step -1
                                If .stGameDatas(i).lngHash = lngDataHash Then
                                    .stGameDatas(i).strDataName = "[Entry]" + vbCrLf + "description=" + .stGameDatas(i).strDataName + "["
                                    .stGameDatas(i).strHash = "]," + .stGameDatas(i).strHash + "(" + CStr(lngDataHash) + ")" + vbCrLf + "address=0x"
                                    If Left(.strDataType, 3) = "str" Then
                                        strDumpFolderPath = vbCrLf + "type=int64" + vbCrLf + "value=" + vbCrLf
                                        Do
                                            For lngDataHash = .intDataTypeSize To 8 Step -8
                                                Print #intOutputFile, .stGameDatas(i).strDataName + CStr(Deprecated_MemorySearcherGameDataIniFile) + .stGameDatas(i).strHash + Hex(lngBuffer - lngDataHash) + strDumpFolderPath
                                            Next lngDataHash
                                            lngBuffer = lngBuffer - .intDataHashOffset
                                            Deprecated_MemorySearcherGameDataIniFile = Deprecated_MemorySearcherGameDataIniFile - 1
                                        Loop Until Deprecated_MemorySearcherGameDataIniFile = 0
                                    Else
                                        strDumpFolderPath = vbCrLf + "type=" + .strDataType + vbCrLf + "value=" + vbCrLf
                                        If .intDataTypeSize > 4 Then
                                            Do
                                                For lngDataHash = .intDataTypeSize To 4 Step -4
                                                    Print #intOutputFile, .stGameDatas(i).strDataName + CStr(Deprecated_MemorySearcherGameDataIniFile) + .stGameDatas(i).strHash + Hex(lngBuffer - lngDataHash) + strDumpFolderPath
                                                Next lngDataHash
                                                lngBuffer = lngBuffer - .intDataHashOffset
                                                Deprecated_MemorySearcherGameDataIniFile = Deprecated_MemorySearcherGameDataIniFile - 1
                                            Loop Until Deprecated_MemorySearcherGameDataIniFile = 0
                                        Else
                                            lngBuffer = lngBuffer - .intDataTypeSize
                                            Do
                                                Print #intOutputFile, .stGameDatas(i).strDataName + CStr(Deprecated_MemorySearcherGameDataIniFile) + .stGameDatas(i).strHash + Hex(lngBuffer) + strDumpFolderPath
                                                lngBuffer = lngBuffer - .intDataHashOffset
                                                Deprecated_MemorySearcherGameDataIniFile = Deprecated_MemorySearcherGameDataIniFile - 1
                                            Loop Until Deprecated_MemorySearcherGameDataIniFile = 0
                                        End If
                                    End If
                                    If i <> .intDataCount Then .stGameDatas(i) = .stGameDatas(.intDataCount)
                                    .intDataCount = .intDataCount - 1
                                    Exit For
                                End If
                            Next i
                        Loop
                    Else
                        Do Until lngDataSize = 0 Or .intDataCount = 0
                            lngDataSize = lngDataSize - 4
                            Get intInputFile, lngDataAddress + lngDataSize, lngBuffer
                            lngBuffer = Converter_SwapEndian(lngBuffer) + .intDataHashOffset
                            Get intInputFile, lngBuffer - lngDeltaOffset + 1, lngDataHash
                            lngDataHash = Converter_SwapEndian(lngDataHash)
                            If lngDataHash = .stGameDatas(.intDataCount).lngHash Then
                                .stGameDatas(.intDataCount).strDataName = "[Entry]" + vbCrLf + "description=" + .stGameDatas(.intDataCount).strDataName
                                .stGameDatas(.intDataCount).strHash = "," + .stGameDatas(.intDataCount).strHash + "(" + CStr(lngDataHash) + ")" + vbCrLf + "address=0x"
                                If Left(.strDataType, 3) = "str" Then
                                    strDumpFolderPath = vbCrLf + "type=int64" + vbCrLf + "value=" + vbCrLf
                                    For i = .intDataTypeSize To 8 Step -8
                                        Print #intOutputFile, .stGameDatas(.intDataCount).strDataName + .stGameDatas(.intDataCount).strHash + Hex(lngBuffer - i) + strDumpFolderPath
                                    Next i
                                Else
                                    strDumpFolderPath = vbCrLf + "type=" + .strDataType + vbCrLf + "value=" + vbCrLf
                                    If .intDataTypeSize > 4 Then
                                        For i = .intDataTypeSize To 4 Step -4
                                            Print #intOutputFile, .stGameDatas(.intDataCount).strDataName + .stGameDatas(.intDataCount).strHash + Hex(lngBuffer - i) + strDumpFolderPath
                                        Next i
                                    Else
                                        Print #intOutputFile, .stGameDatas(.intDataCount).strDataName + .stGameDatas(.intDataCount).strHash + Hex(lngBuffer - .intDataTypeSize) + strDumpFolderPath
                                    End If
                                End If
                                .intDataCount = .intDataCount - 1
                            End If
                        Loop
                    End If
                    Erase .stGameDatas
                End If
                End With
            End If
            btGameDataMapsLength = btGameDataMapsLength - 1
        Loop Until btGameDataMapsLength = 0
        Close intOutputFile
    End If
    Close intInputFile
End Function

Private Function Botw_NextMapUnitObject(ByRef stMapUnitObjects() As stMapObject, ByVal intStartIndex As Integer, ByRef btSearchByte As Byte) As Integer
    Botw_NextMapUnitObject = intStartIndex
    Do Until Botw_NextMapUnitObject = 0
        If stMapUnitObjects(Botw_NextMapUnitObject).stMapUnitObjectDataMap.btDataCount <> 0 Then
            btSearchByte = stMapUnitObjects(Botw_NextMapUnitObject).lngHashId And &HFF
            Exit Function
        End If
        Botw_NextMapUnitObject = Botw_NextMapUnitObject - 1
    Loop
End Function

Public Function Botw_LoadMapObjectsData(ByVal strWkSheetName As String, ByRef stMapObjects() As stMapObject) As Integer
Dim stCurrentMapObject As stMapObject
Dim xlsRange As Range
Dim i As Integer
Dim strMapObjectPropertyValues() As String
Dim xlsWkSheet As Worksheet
    Set xlsWkSheet = ThisWorkbook.Worksheets(strWkSheetName)
    Set xlsRange = xlsWkSheet.Range("A2:J32767").Cells
    Botw_LoadMapObjectsData = xlsWkSheet.Range("K2").Value
    If Botw_LoadMapObjectsData > 0 Then
        ReDim stMapObjects(1 To Botw_LoadMapObjectsData)
        With stCurrentMapObject
        For Botw_LoadMapObjectsData = 1 To 32766
            .strHashId = xlsRange.Item(Botw_LoadMapObjectsData, 1).Text
            If .strHashId = "" Then
                Botw_LoadMapObjectsData = Botw_LoadMapObjectsData - 1
                If Botw_LoadMapObjectsData = 0 Then Erase stMapObjects
                Exit For
            Else
                .strHashId = Right("0000000" + .strHashId, 8)
                .lngHashId = Converter_SwapEndian(CLng("&H" + .strHashId))
                For i = Botw_LoadMapObjectsData - 1 To 1 Step -1
                    If .strHashId < stMapObjects(i).strHashId Then
                        Exit For
                    Else
                        stMapObjects(i + 1) = stMapObjects(i)
                    End If
                Next i
                stMapObjects(i + 1) = stCurrentMapObject
            End If
        Next Botw_LoadMapObjectsData
        End With
        i = Botw_LoadMapObjectsData
        Open ThisWorkbook.Path + "\data\" + strWkSheetName + ".yml" For Input As #1
        Do Until EOF(1) Or i = 0
            Line Input #1, strWkSheetName
            With stMapObjects(i)
            If Right(strWkSheetName, 22) = " HashId: !u 0x" + .strHashId Then
                .lngSRTHash = -266111927
                .stMapUnitObjectDataMap.btDataCount = 0
                .stMapUnitObjectDataMap.btDataSize(0) = 0
                Line Input #1, strWkSheetName
                Do Until Left(strWkSheetName, 18) = "  UnitConfigName: "
                    If Left(strWkSheetName, 13) = "  Translate: " Then
                        '.stMapUnitObjectDataMap.btDataCount = .stMapUnitObjectDataMap.btDataCount + 1
                        '.stMapUnitObjectDataMap.ptrData(.stMapUnitObjectDataMap.btDataCount) = VarPtr(.lngCoordinates(1))
                        '.stMapUnitObjectDataMap.strDataLabel(.stMapUnitObjectDataMap.btDataCount) = "C"
                        '.stMapUnitObjectDataMap.btDataSize(.stMapUnitObjectDataMap.btDataCount) = 12
                        strWkSheetName = Mid(strWkSheetName, 15, Len(strWkSheetName) - 15)
                        xlsRange.Item(i, 8).Value = strWkSheetName
                        strMapObjectPropertyValues = Split(strWkSheetName, ", ")
                        .lngCoordinates(1) = Converter_Sng2Lng(CSng(strMapObjectPropertyValues(0)))
                        .lngCoordinates(2) = Converter_Sng2Lng(CSng(strMapObjectPropertyValues(1)))
                        .lngCoordinates(3) = Converter_Sng2Lng(CSng(strMapObjectPropertyValues(2)))
                        xlsRange.Item(i, 9).Value = Right("0000000" + Hex(.lngCoordinates(1)), 8) + Right(Hex(.lngCoordinates(2)), 8) + Right(Hex(.lngCoordinates(3)), 8)
                        .lngCoordinates(1) = Converter_SwapEndian(.lngCoordinates(1))
                        .lngCoordinates(2) = Converter_SwapEndian(.lngCoordinates(2))
                        .lngCoordinates(3) = Converter_SwapEndian(.lngCoordinates(3))
                        Erase strMapObjectPropertyValues
                    Else
                        If Left(strWkSheetName, 10) = "  Rotate: " Then
                            Botw_LoadMapObjectsData = -Abs(Botw_LoadMapObjectsData)
                            .stMapUnitObjectDataMap.btDataCount = .stMapUnitObjectDataMap.btDataCount + 1
                            .stMapUnitObjectDataMap.ptrData(.stMapUnitObjectDataMap.btDataCount) = VarPtr(.lngRotationFactors(1))
                            .stMapUnitObjectDataMap.strDataLabel(.stMapUnitObjectDataMap.btDataCount) = "R"
                            strWkSheetName = Mid(strWkSheetName, 11)
                            If strWkSheetName > "[" Then
                                .stMapUnitObjectDataMap.btDataSize(.stMapUnitObjectDataMap.btDataCount) = 12
                                strWkSheetName = Mid(strWkSheetName, 2, Len(strWkSheetName) - 2)
                                strMapObjectPropertyValues = Split(strWkSheetName, ", ")
                                .lngRotationFactors(1) = Converter_Sng2Lng(CSng(strMapObjectPropertyValues(0)))
                                .lngRotationFactors(2) = Converter_Sng2Lng(CSng(strMapObjectPropertyValues(1)))
                                .lngRotationFactors(3) = Converter_Sng2Lng(CSng(strMapObjectPropertyValues(2)))
                                xlsRange.Item(i, 3).Value = Right("0000000" + Hex(.lngRotationFactors(1)), 8) + Right("0000000" + Hex(.lngRotationFactors(2)), 8) + Right("0000000" + Hex(.lngRotationFactors(3)), 8)
                                .lngRotationFactors(1) = Converter_SwapEndian(.lngRotationFactors(1))
                                .lngRotationFactors(2) = Converter_SwapEndian(.lngRotationFactors(2))
                                .lngRotationFactors(3) = Converter_SwapEndian(.lngRotationFactors(3))
                                Erase strMapObjectPropertyValues
                            Else
                                .stMapUnitObjectDataMap.btDataSize(.stMapUnitObjectDataMap.btDataCount) = 4
                                .lngRotationFactors(1) = Converter_Sng2Lng(CSng(strWkSheetName))
                                .lngRotationFactors(2) = -266111927
                                .lngRotationFactors(3) = -266111927
                                xlsRange.Item(i, 3).Value = Right("0000000" + Hex(.lngRotationFactors(1)), 8)
                                .lngRotationFactors(1) = Converter_SwapEndian(.lngRotationFactors(1))
                            End If
                            xlsRange.Item(i, 2).Value = strWkSheetName
                        Else
                            If Left(strWkSheetName, 9) = "  Scale: " Then
                                Botw_LoadMapObjectsData = -Abs(Botw_LoadMapObjectsData)
                                .stMapUnitObjectDataMap.btDataCount = .stMapUnitObjectDataMap.btDataCount + 1
                                .stMapUnitObjectDataMap.ptrData(.stMapUnitObjectDataMap.btDataCount) = VarPtr(.lngScaleFactors(1))
                                .stMapUnitObjectDataMap.strDataLabel(.stMapUnitObjectDataMap.btDataCount) = "S"
                                strWkSheetName = Mid(strWkSheetName, 10)
                                If strWkSheetName > "[" Then
                                    .stMapUnitObjectDataMap.btDataSize(.stMapUnitObjectDataMap.btDataCount) = 12
                                    strWkSheetName = Mid(strWkSheetName, 2, Len(strWkSheetName) - 2)
                                    strMapObjectPropertyValues = Split(strWkSheetName, ", ")
                                    .lngScaleFactors(1) = Converter_Sng2Lng(CSng(strMapObjectPropertyValues(0)))
                                    .lngScaleFactors(2) = Converter_Sng2Lng(CSng(strMapObjectPropertyValues(1)))
                                    .lngScaleFactors(3) = Converter_Sng2Lng(CSng(strMapObjectPropertyValues(2)))
                                    xlsRange.Item(i, 7).Value = Right("0000000" + Hex(.lngScaleFactors(1)), 8) + Right("0000000" + Hex(.lngScaleFactors(2)), 8) + Right("0000000" + Hex(.lngScaleFactors(3)), 8)
                                    .lngScaleFactors(1) = Converter_SwapEndian(.lngScaleFactors(1))
                                    .lngScaleFactors(2) = Converter_SwapEndian(.lngScaleFactors(2))
                                    .lngScaleFactors(3) = Converter_SwapEndian(.lngScaleFactors(3))
                                    Erase strMapObjectPropertyValues
                                Else
                                    .stMapUnitObjectDataMap.btDataSize(.stMapUnitObjectDataMap.btDataCount) = 4
                                    .lngScaleFactors(1) = Converter_Sng2Lng(CSng(strWkSheetName))
                                    .lngScaleFactors(2) = -266111927
                                    .lngScaleFactors(3) = -266111927
                                    xlsRange.Item(i, 7).Value = Right("0000000" + Hex(.lngScaleFactors(1)), 8)
                                    .lngScaleFactors(1) = Converter_SwapEndian(.lngScaleFactors(1))
                                End If
                                xlsRange.Item(i, 6).Value = strWkSheetName
                            Else
                                If Left(strWkSheetName, 11) = "  SRTHash: " Then
                                    '.stMapUnitObjectDataMap.btDataCount = .stMapUnitObjectDataMap.btDataCount + 1
                                    '.stMapUnitObjectDataMap.ptrData(.stMapUnitObjectDataMap.btDataCount) = VarPtr(.lngSRTHash)
                                    '.stMapUnitObjectDataMap.strDataLabel(.stMapUnitObjectDataMap.btDataCount) = " "
                                    '.stMapUnitObjectDataMap.btDataSize(.stMapUnitObjectDataMap.btDataCount) = 4
                                    strWkSheetName = Mid(strWkSheetName, 12)
                                    .lngSRTHash = CLng(strWkSheetName)
                                    xlsRange.Item(i, 4).Value = strWkSheetName
                                    xlsRange.Item(i, 5).Value = Right("0000000" + Hex(.lngSRTHash), 8)
                                    .lngSRTHash = Converter_SwapEndian(CLng(strWkSheetName))
                                End If
                            End If
                        End If
                    End If
                    Line Input #1, strWkSheetName
                Loop
                .strUnitConfigName = Mid(strWkSheetName, 19)
                xlsRange.Item(i, 10).Value = .strUnitConfigName
                xlsRange.Item(i, 1).Value = .strHashId
                i = i - 1
            End If
            End With
        Loop
        Close #1
    End If
    Set xlsRange = Nothing
    Set xlsWkSheet = Nothing
End Function

Public Function Botw_MemorySearcherMapObjectsIniFile(ByVal strDumpFolderPath As String, ByVal strWkSheetName As String, Optional ByVal lngMapUnitDataOffset As Long = &H13000000, Optional ByVal lngTranslateDataOffset As Long = &H30000000) As Integer
'TODO
'strWkSheetName: MainField_I-7_Dynamic for example
Dim stMapObjects() As stMapObject
Dim btbuffer(1 To 1024) As Byte
Dim btSearchByte As Byte
Dim lngHashId As Long
Dim i As Integer
Dim intIndex As Integer
Dim lngMapUnitDataAddresses(0 To 3) As Long
Dim btMapUnitDataBytes() As Byte
Dim intInputFile As Integer
Dim intOutputFile As Integer
Dim lngDeltaOffset As Long
    Botw_MemorySearcherMapObjectsIniFile = Botw_LoadMapObjectsData(strWkSheetName, stMapObjects)
    intInputFile = Cemu_openDumpFile(strDumpFolderPath, lngDeltaOffset)
    intOutputFile = FreeFile
    Open strDumpFolderPath + "00050000101c9X00.mapobjects.ini" For Output As intOutputFile
    If Botw_MemorySearcherMapObjectsIniFile < 0 Then
        Botw_MemorySearcherMapObjectsIniFile = Abs(Botw_MemorySearcherMapObjectsIniFile)
        lngMapUnitDataAddresses(0) = 1
        Seek intInputFile, lngMapUnitDataOffset
        intIndex = Botw_NextMapUnitObject(stMapObjects, Botw_MemorySearcherMapObjectsIniFile, btSearchByte)
        Do Until EOF(intInputFile) Or intIndex = 0
            Get intInputFile, , btbuffer
            For i = 1 To 1024
                If btbuffer(i) = btSearchByte Then
                    lngMapUnitDataOffset = Seek(1) - 1025 + i
                    Get intInputFile, lngMapUnitDataOffset, lngHashId
                    If lngHashId = stMapObjects(intIndex).lngHashId Then
                        Get intInputFile, , btbuffer
                        lngHashId = 0
                        With stMapObjects(intIndex)
                        Do
                            lngHashId = lngHashId + 1
                            btMapUnitDataBytes = Converter_Var2Bytes(.stMapUnitObjectDataMap.ptrData(lngHashId), .stMapUnitObjectDataMap.btDataSize(lngHashId))
                            lngMapUnitDataAddresses(lngHashId) = Vector_InBytes(lngMapUnitDataAddresses(lngHashId - 1) + .stMapUnitObjectDataMap.btDataSize(lngHashId - 1), btbuffer, btMapUnitDataBytes)
                            Erase btMapUnitDataBytes
                        Loop Until lngHashId = .stMapUnitObjectDataMap.btDataCount Or lngMapUnitDataAddresses(lngHashId) = 0
                        End With
                        If lngMapUnitDataAddresses(lngHashId) <> 0 Then
                            lngHashId = lngMapUnitDataOffset
                            strWkSheetName = vbCrLf + "type=float" + vbCrLf + "value=" + vbCrLf
                            With stMapObjects(intIndex)
                            strDumpFolderPath = "[Entry]" + vbCrLf + "description=" + .strUnitConfigName + "_" + .strHashId + "_"
                            lngMapUnitDataOffset = lngMapUnitDataOffset + lngMapUnitDataAddresses(.stMapUnitObjectDataMap.btDataCount) + .stMapUnitObjectDataMap.btDataSize(.stMapUnitObjectDataMap.btDataCount) + 1
                            Do
                                If .stMapUnitObjectDataMap.strDataLabel(.stMapUnitObjectDataMap.btDataCount) <> " " Then
                                    Do
                                        .stMapUnitObjectDataMap.btDataSize(.stMapUnitObjectDataMap.btDataCount) = .stMapUnitObjectDataMap.btDataSize(.stMapUnitObjectDataMap.btDataCount) - 4
                                        Print #intOutputFile, strDumpFolderPath + .stMapUnitObjectDataMap.strDataLabel(.stMapUnitObjectDataMap.btDataCount) + Chr(90 - .stMapUnitObjectDataMap.btDataSize(.stMapUnitObjectDataMap.btDataCount) / 4) + vbCrLf + "address=0x" + Hex(lngDeltaOffset + 2 + lngHashId + .stMapUnitObjectDataMap.btDataSize(.stMapUnitObjectDataMap.btDataCount) + lngMapUnitDataAddresses(.stMapUnitObjectDataMap.btDataCount)) + strWkSheetName
                                    Loop Until .stMapUnitObjectDataMap.btDataSize(.stMapUnitObjectDataMap.btDataCount) = 0
                                End If
                                .stMapUnitObjectDataMap.btDataCount = .stMapUnitObjectDataMap.btDataCount - 1
                            Loop Until .stMapUnitObjectDataMap.btDataCount = 0
                            End With
                            intIndex = Botw_NextMapUnitObject(stMapObjects, intIndex - 1, btSearchByte)
                        End If
                    End If
                    Seek intInputFile, lngMapUnitDataOffset + 1
                    Exit For
                End If
            Next i
        Loop
    End If
    btSearchByte = stMapObjects(Botw_MemorySearcherMapObjectsIniFile).lngHashId And &HFF
    Seek intInputFile, lngTranslateDataOffset
    Do Until EOF(intInputFile) Or Botw_MemorySearcherMapObjectsIniFile = 0
        Get intInputFile, , btbuffer
        For i = 1 To 1024
            If btbuffer(i) = btSearchByte Then
                lngTranslateDataOffset = Seek(1) - 1025 + i
                Get intInputFile, lngTranslateDataOffset, lngHashId
                If lngHashId = stMapObjects(Botw_MemorySearcherMapObjectsIniFile).lngHashId Then
                    If File_ReadCmp256(1, VarPtr(stMapObjects(Botw_MemorySearcherMapObjectsIniFile).lngCoordinates(1)), 12) = 12 Then
                        With stMapObjects(Botw_MemorySearcherMapObjectsIniFile)
                        strDumpFolderPath = "[Entry]" + vbCrLf + "description=" + .strUnitConfigName + "_" + .strHashId + "_"
                        strWkSheetName = vbCrLf + "type=float" + vbCrLf + "value=" + vbCrLf
                        Print #intOutputFile, strDumpFolderPath + "X" + vbCrLf + "address=0x" + Hex(lngDeltaOffset + 3 + lngTranslateDataOffset) + strWkSheetName
                        Print #intOutputFile, strDumpFolderPath + "Y" + vbCrLf + "address=0x" + Hex(lngDeltaOffset + 7 + lngTranslateDataOffset) + strWkSheetName
                        Print #intOutputFile, strDumpFolderPath + "Z" + vbCrLf + "address=0x" + Hex(lngDeltaOffset + 11 + lngTranslateDataOffset) + strWkSheetName
                        End With
                        Botw_MemorySearcherMapObjectsIniFile = Botw_MemorySearcherMapObjectsIniFile - 1
                        Do Until EOF(intInputFile) Or Botw_MemorySearcherMapObjectsIniFile = 0
                            lngTranslateDataOffset = lngTranslateDataOffset + 76
                            Get intInputFile, lngTranslateDataOffset, lngHashId
                            If lngHashId = stMapObjects(Botw_MemorySearcherMapObjectsIniFile).lngHashId Then
                                If File_ReadCmp256(1, VarPtr(stMapObjects(Botw_MemorySearcherMapObjectsIniFile).lngCoordinates(1)), 12) = 12 Then
                                    With stMapObjects(Botw_MemorySearcherMapObjectsIniFile)
                                    strDumpFolderPath = "[Entry]" + vbCrLf + "description=" + .strUnitConfigName + "_" + .strHashId + "_"
                                    strWkSheetName = vbCrLf + "type=float" + vbCrLf + "value=" + vbCrLf
                                    Print #intOutputFile, strDumpFolderPath + "X" + vbCrLf + "address=0x" + Hex(lngDeltaOffset + 3 + lngTranslateDataOffset) + strWkSheetName
                                    Print #intOutputFile, strDumpFolderPath + "Y" + vbCrLf + "address=0x" + Hex(lngDeltaOffset + 7 + lngTranslateDataOffset) + strWkSheetName
                                    Print #intOutputFile, strDumpFolderPath + "Z" + vbCrLf + "address=0x" + Hex(lngDeltaOffset + 11 + lngTranslateDataOffset) + strWkSheetName
                                    End With
                                    Botw_MemorySearcherMapObjectsIniFile = Botw_MemorySearcherMapObjectsIniFile - 1
                                End If
                            End If
                        Loop
                        Exit For
                    End If
                End If
                Seek intInputFile, lngTranslateDataOffset + 1
                Exit For
            End If
        Next i
    Loop
    lngHashId = Botw_FgetGameROMPlayerDataAddress(intInputFile, lngDeltaOffset)
    strDumpFolderPath = "[Entry]" + vbCrLf + "description="
    strWkSheetName = vbCrLf + "type=float" + vbCrLf + "value=" + vbCrLf
    With ThisWorkbook.Worksheets("GameROMPlayer").Cells
    Print #intOutputFile, strDumpFolderPath + .Item(2, 1).Text + vbCrLf + "address=0x" + Hex(lngHashId + .Item(2, 4).Value) + strWkSheetName
    Print #intOutputFile, strDumpFolderPath + .Item(3, 1).Text + vbCrLf + "address=0x" + Hex(lngHashId + .Item(3, 4).Value) + strWkSheetName
    Print #intOutputFile, strDumpFolderPath + .Item(4, 1).Text + vbCrLf + "address=0x" + Hex(lngHashId + .Item(4, 4).Value) + strWkSheetName
    End With
    Close intOutputFile
    Close intInputFile
    Erase stMapObjects
End Function
