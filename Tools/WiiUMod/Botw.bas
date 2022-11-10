Attribute VB_Name = "Botw"
Option Explicit
Private Const BOTW_GAMEDATASCOUNT As Byte = 18
Private Const BOTW_INVENTORYITEM_PROPERTIESCOUNT = 11
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
Public Enum BOTW_INVENTORYITEM_PROPERTIES
    BOTW_PREVIOUSITEM_PROPERTY = 1
    BOTW_NEXTITEM_PROPERTY = 2
    BOTW_ITEMTYPE_PROPERTY = 4
    BOTW_ITEMSUBTYPE_PROPERTY = 8
    BOTW_ITEMQTYDUR_PROPERTY = 16
    BOTW_ITEMEQUIPPEDFLAG_PROPERTY = 32
    BOTW_ITEMBONUSVALUE_PROPERTY = 64
    BOTW_ITEMBONUSDURATION_PROPERTY = 128
    BOTW_ITEMBONUSTYPE_PROPERTY = 256
    BOTW_ITEMEFFECTTYPE_PROPERTY = 512
    BOTW_ITEMEFFECTLEVEL_PROPERTY = 1024
    BOTW_ITEM_ALLPROPERTIES = BOTW_ITEMEFFECTLEVEL_PROPERTY Or BOTW_ITEMEFFECTTYPE_PROPERTY Or BOTW_ITEMBONUSTYPE_PROPERTY Or BOTW_ITEMBONUSDURATION_PROPERTY Or BOTW_ITEMBONUSVALUE_PROPERTY Or BOTW_ITEMEQUIPPEDFLAG_PROPERTY Or BOTW_ITEMQTYDUR_PROPERTY Or BOTW_ITEMSUBTYPE_PROPERTY Or BOTW_ITEMTYPE_PROPERTY Or BOTW_NEXTITEM_PROPERTY Or BOTW_PREVIOUSITEM_PROPERTY
End Enum
Public Type stRecipeIngredient
    lngIdAddress As Long
    lngLessUsefulField As Long
    lngStr64TypeSize As Long
    btActorName(1 To 64)
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
    btActorName(1 To 64) As Byte
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
    lngDataCount As Long
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
    BOTW_ALLGAMEDATA = &H3FFFF
End Enum
Public Enum BOTW_MEMORYDATAS
    BOTW_MEMORY_GAMEDATA = 1
    BOTW_MEMORY_GAMEROMPLAYER = 2
    BOTW_MEMORY_INVENTORY = 3
    BOTW_MEMORY_LOCATIONMARKER = 4
    BOTW_MEMORY_SAVEDATA = 5
    BOTW_MEMORY_REMOTEBOMBTIMERS = 6
    BOTW_MEMORY_NONAME = 7
    BOTW_MEMORY_GAMESPEED = 8
    BOTW_MEMORY_MASTERCYCLEZERO = 9
End Enum
Public Type stGameBinDataMap
    lngCount As Long
    lngSize As Long
    lngAddress As Long
End Type
Public stGameDataMaps(1 To BOTW_GAMEDATASCOUNT) As stGameDataMap
Private stGameBinDataMaps(1 To BOTW_GAMEDATASCOUNT) As stGameBinDataMap
Private Sub Botw_InitGameDataMap(ByVal lngNamesColumn As Long, Optional ByVal lngGameData As Long = BOTW_ALLGAMEDATA)
Dim i As Long
Dim xlsWorksheet As Worksheet
Dim xlsUserDataRange As Range
Dim xlsRange As Range
Dim btGameDataCount As Byte
Dim stCurrentGameData As stGameData
Dim lngForcedDataCount As Long
Dim lngCurrentRow As Long
    btGameDataCount = BOTW_GAMEDATASCOUNT
    Set xlsWorksheet = ThisWorkbook.Worksheets("GameData")
    Set xlsRange = xlsWorksheet.Range("A2:F" + CStr(btGameDataCount + 1)).Cells
    If lngNamesColumn = 1 Then
        Do
            If (lngGameData And (2^ ^ (btGameDataCount - 1))) <> 0 Then
                With stGameDataMaps(btGameDataCount)
                ReDim .stGameDatas(1 To 1)
                .stGameDatas(1).strDataName = xlsRange.Item(btGameDataCount, 1).Text
                .lngDataCount = 1
                .strDataType = xlsRange.Item(btGameDataCount, 2).Text
                .intDataTypeSize = xlsRange.Item(btGameDataCount, 3).Value
                .intDataHashOffset = xlsRange.Item(btGameDataCount, 4).Value
                End With
            End If
            btGameDataCount = btGameDataCount - 1
        Loop Until btGameDataCount = 0
    Else
        Set xlsUserDataRange = xlsWorksheet.Range(Chr(64 + lngNamesColumn) + "2:" + Chr(63 + lngNamesColumn + btGameDataCount) + xlsWorksheet.Range("E" + CStr(2 + BOTW_GAMEDATASCOUNT)).Text).Cells
        Do
            If (lngGameData And (2^ ^ (btGameDataCount - 1))) Then
                With stGameDataMaps(btGameDataCount)
                lngForcedDataCount = xlsRange.Item(btGameDataCount, 5).Value
                i = xlsRange.Item(btGameDataCount, 6).Value
                If lngForcedDataCount > i Then lngForcedDataCount = i
                If lngForcedDataCount > 0 Then
                    ReDim .stGameDatas(1 To lngForcedDataCount)
                    .lngDataCount = 0
                    Do
                        .lngDataCount = .lngDataCount + 1
                        lngCurrentRow = Xlsdata_SkipRowBlankCells(xlsUserDataRange, lngCurrentRow + 1, btGameDataCount, stCurrentGameData.strDataName, .lngDataCount)
                        stCurrentGameData.lngHash = Crc_CRC32(stCurrentGameData.strDataName)
                        stCurrentGameData.strHash = Right("0000000" + Hex(stCurrentGameData.lngHash), 8)
                        For i = .lngDataCount - 1 To 1 Step -1
                            If stCurrentGameData.strHash > .stGameDatas(i).strHash Then
                                Exit For
                            Else
                                lngNamesColumn = i + 1
                                .stGameDatas(lngNamesColumn) = .stGameDatas(i)
                                xlsUserDataRange.Item(lngNamesColumn, btGameDataCount).Value = .stGameDatas(i).strDataName
                            End If
                        Next i
                        lngNamesColumn = i + 1
                        .stGameDatas(lngNamesColumn) = stCurrentGameData
                        xlsUserDataRange.Item(lngNamesColumn, btGameDataCount).Value = stCurrentGameData.strDataName
                    Loop Until .lngDataCount = lngForcedDataCount
                End If
                .strDataType = xlsRange.Item(btGameDataCount, 2).Text
                .intDataTypeSize = xlsRange.Item(btGameDataCount, 3).Value
                .intDataHashOffset = xlsRange.Item(btGameDataCount, 4).Value
                End With
            End If
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
    strCemuFolderPath = Cemu_GetRootFolderPath(strCemuFolderPath)
    Call Memory_InitDataMap("MemoryData.A2:C2", stMemoryDataMap)
    stProcess.dwSize = Cemu_OpenProcess(SYSTEM_PROC_VMREAD, stProcess)
    If stProcess.dwSize <> 0 Then
        If System_ToogleProcessById(stProcess.th32ProcessID, -1) > 0 Then
            stProcess.dwFlags = File_ExtractText("Cemu.A2:C32", stCemuLogData, strCemuFolderPath + "log.txt", CEMU_LOG_WIIUMEMORYBASE)
            If stProcess.dwFlags = 1 Then
                lngLngMemoryBase = CLngLng("&H" + stCemuLogData(1).objData.Item(0).SubMatches(0))
                Botw_ReadGameBinData = Memory_GetMappedData(stProcess.dwSize, lngLngMemoryBase, stMemoryDataMap.lngLowerOffsets)
                If Botw_ReadGameBinData <> 0 Then
                    If ReadProcessMemory(stProcess.dwSize, lngLngMemoryBase + Botw_ReadGameBinData + 4, VarPtr(stGameBinDataMaps(1)), stMemoryDataMap.lngDataSize, 0) <> 0 Then
                        Call Botw_InitGameDataMap(7)
                        stProcess.dwFlags = BOTW_GAMEDATASCOUNT
                        Do
                            If stGameBinDataMaps(stProcess.dwFlags).lngCount <> 0 Then
                                stGameBinDataMaps(stProcess.dwFlags).lngCount = Converter_SwapEndian32(stGameBinDataMaps(stProcess.dwFlags).lngCount)
                                With stGameDataMaps(stProcess.dwFlags)
                                If Memory_ReadProcessLongMemoryDataSegment(stProcess.dwSize, lngLngMemoryBase + Converter_SwapEndian32(stGameBinDataMaps(stProcess.dwFlags).lngAddress), stGameBinDataMaps(stProcess.dwFlags).lngCount, lngVectorDataAddresses) <> 0 Then
                                    If .intDataHashOffset < 0 Then
                                        .intDataHashOffset = 8 - .intDataHashOffset
                                        For stGameBinDataMaps(stProcess.dwFlags).lngSize = stGameBinDataMaps(stProcess.dwFlags).lngCount To 1 Step -1
                                            If ReadProcessMemory(stProcess.dwSize, lngLngMemoryBase + Converter_SwapEndian32(lngVectorDataAddresses(stGameBinDataMaps(stProcess.dwFlags).lngSize)), VarPtr(lngDataArrayInfos(1)), 16, 0) <> 0 Then
                                                lngDataArrayInfos(4) = Converter_SwapEndian32(lngDataArrayInfos(4)) + Converter_SwapEndian32(lngDataArrayInfos(1)) * .intDataHashOffset - 8
                                                If lngDataArrayInfos(4) > stMemoryDataMap.lngDataSize Then stMemoryDataMap.lngDataSize = lngDataArrayInfos(4)
                                                If ReadProcessMemory(stProcess.dwSize, lngLngMemoryBase + lngDataArrayInfos(4), VarPtr(lngDataArrayInfos(2)), 4, 0) <> 0 Then
                                                    lngDataArrayInfos(2) = Converter_SwapEndian32(lngDataArrayInfos(2))
                                                    For lngDataArrayInfos(3) = .lngDataCount To 1 Step -1
                                                        If .stGameDatas(lngDataArrayInfos(3)).lngHash = lngDataArrayInfos(2) Then
                                                            .stGameDatas(lngDataArrayInfos(3)).lngHash = lngDataArrayInfos(4)
                                                            If lngDataArrayInfos(3) <> .lngDataCount Then
                                                                stSwapGameData = .stGameDatas(lngDataArrayInfos(3))
                                                                .stGameDatas(lngDataArrayInfos(3)) = .stGameDatas(.lngDataCount)
                                                                .stGameDatas(.lngDataCount) = stSwapGameData
                                                            End If
                                                            .lngDataCount = .lngDataCount - 1
                                                            Exit For
                                                        End If
                                                    Next lngDataArrayInfos(3)
                                                End If
                                            End If
                                        Next stGameBinDataMaps(stProcess.dwFlags).lngSize
                                    Else
                                        For stGameBinDataMaps(stProcess.dwFlags).lngSize = stGameBinDataMaps(stProcess.dwFlags).lngCount To 1 Step -1
                                            lngVectorDataAddresses(stGameBinDataMaps(stProcess.dwFlags).lngSize) = Converter_SwapEndian32(lngVectorDataAddresses(stGameBinDataMaps(stProcess.dwFlags).lngSize)) + .intDataHashOffset
                                            If lngVectorDataAddresses(stGameBinDataMaps(stProcess.dwFlags).lngSize) > stMemoryDataMap.lngDataSize Then stMemoryDataMap.lngDataSize = lngVectorDataAddresses(stGameBinDataMaps(stProcess.dwFlags).lngSize)
                                            If .lngDataCount <> 0 Then
                                                If ReadProcessMemory(stProcess.dwSize, lngLngMemoryBase + lngVectorDataAddresses(stGameBinDataMaps(stProcess.dwFlags).lngSize), VarPtr(lngDataArrayInfos(2)), 4, 0) <> 0 Then
                                                    If Converter_SwapEndian32(lngDataArrayInfos(2)) = .stGameDatas(.lngDataCount).lngHash Then
                                                        .stGameDatas(.lngDataCount).lngHash = lngVectorDataAddresses(stGameBinDataMaps(stProcess.dwFlags).lngSize)
                                                        .lngDataCount = .lngDataCount - 1
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
                        ReDim stMemoryDataMap.btdata(0 To stMemoryDataMap.lngDataSize - 1)
                        If ReadProcessMemory(stProcess.dwSize, lngLngMemoryBase + Botw_ReadGameBinData, VarPtr(stMemoryDataMap.btdata(0)), stMemoryDataMap.lngDataSize, 0) = 0 Then
                            Botw_ReadGameBinData = 0
                            Erase stMemoryDataMap.btdata
                            Erase stMemoryDataMap.lngLowerOffsets
                        End If
                    End If
                End If
                Set stCemuLogData(1).objData = Nothing
                Erase stCemuLogData
            End If
            System_ToogleProcessById stProcess.th32ProcessID, 1
        End If
        CloseHandle stProcess.dwSize
    Else
        strCemuFolderPath = Cemu_GetDumpFolderPath(strCemuFolderPath)
        If strCemuFolderPath <> "" Then
            stProcess.dwSize = Cemu_OpenDumpFile(strCemuFolderPath, CEMU_DUMP_10000000)
            Botw_ReadGameBinData = File_GetMappedData(stProcess.dwSize, CEMU_DUMP_10000000, stMemoryDataMap.lngLowerOffsets)
            If Botw_ReadGameBinData <> 0 Then
                Get stProcess.dwSize, Botw_ReadGameBinData - CEMU_DUMP_10000000 + 5, stGameBinDataMaps
                Call Botw_InitGameDataMap(7)
                stProcess.dwFlags = BOTW_GAMEDATASCOUNT
                Do
                    If stGameBinDataMaps(stProcess.dwFlags).lngCount <> 0 Then
                        stGameBinDataMaps(stProcess.dwFlags).lngCount = Converter_SwapEndian32(stGameBinDataMaps(stProcess.dwFlags).lngCount)
                        With stGameDataMaps(stProcess.dwFlags)
                        Call File_ReadLongDataSegment(stProcess.dwSize, Converter_SwapEndian32(stGameBinDataMaps(stProcess.dwFlags).lngAddress) - CEMU_DUMP_10000000 + 1, stGameBinDataMaps(stProcess.dwFlags).lngCount, lngVectorDataAddresses)
                        If .intDataHashOffset < 0 Then
                            .intDataHashOffset = 8 - .intDataHashOffset
                            For stGameBinDataMaps(stProcess.dwFlags).lngSize = stGameBinDataMaps(stProcess.dwFlags).lngCount To 1 Step -1
                                Get stProcess.dwSize, Converter_SwapEndian32(lngVectorDataAddresses(stGameBinDataMaps(stProcess.dwFlags).lngSize)) - CEMU_DUMP_10000000 + 1, lngDataArrayInfos
                                lngDataArrayInfos(4) = Converter_SwapEndian32(lngDataArrayInfos(4)) + Converter_SwapEndian32(lngDataArrayInfos(1)) * .intDataHashOffset - 8
                                If lngDataArrayInfos(4) > stMemoryDataMap.lngDataSize Then stMemoryDataMap.lngDataSize = lngDataArrayInfos(4)
                                Get stProcess.dwSize, lngDataArrayInfos(4) - CEMU_DUMP_10000000 + 1, lngDataArrayInfos(2)
                                lngDataArrayInfos(2) = Converter_SwapEndian32(lngDataArrayInfos(2))
                                For lngDataArrayInfos(3) = .lngDataCount To 1 Step -1
                                    If .stGameDatas(lngDataArrayInfos(3)).lngHash = lngDataArrayInfos(2) Then
                                        .stGameDatas(lngDataArrayInfos(3)).lngHash = lngDataArrayInfos(4)
                                        If lngDataArrayInfos(3) <> .lngDataCount Then
                                            stSwapGameData = .stGameDatas(lngDataArrayInfos(3))
                                            .stGameDatas(lngDataArrayInfos(3)) = .stGameDatas(.lngDataCount)
                                            .stGameDatas(.lngDataCount) = stSwapGameData
                                        End If
                                        .lngDataCount = .lngDataCount - 1
                                        Exit For
                                    End If
                                Next lngDataArrayInfos(3)
                            Next stGameBinDataMaps(stProcess.dwFlags).lngSize
                        Else
                            For stGameBinDataMaps(stProcess.dwFlags).lngSize = stGameBinDataMaps(stProcess.dwFlags).lngCount To 1 Step -1
                                lngVectorDataAddresses(stGameBinDataMaps(stProcess.dwFlags).lngSize) = Converter_SwapEndian32(lngVectorDataAddresses(stGameBinDataMaps(stProcess.dwFlags).lngSize)) + .intDataHashOffset
                                If lngVectorDataAddresses(stGameBinDataMaps(stProcess.dwFlags).lngSize) > stMemoryDataMap.lngDataSize Then stMemoryDataMap.lngDataSize = lngVectorDataAddresses(stGameBinDataMaps(stProcess.dwFlags).lngSize)
                                If .lngDataCount <> 0 Then
                                    Get stProcess.dwSize, lngVectorDataAddresses(stGameBinDataMaps(stProcess.dwFlags).lngSize) - CEMU_DUMP_10000000 + 1, lngDataArrayInfos(2)
                                    If Converter_SwapEndian32(lngDataArrayInfos(2)) = .stGameDatas(.lngDataCount).lngHash Then
                                        .stGameDatas(.lngDataCount).lngHash = lngVectorDataAddresses(stGameBinDataMaps(stProcess.dwFlags).lngSize)
                                        .lngDataCount = .lngDataCount - 1
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
                ReDim stMemoryDataMap.btdata(0 To stMemoryDataMap.lngDataSize - 1)
                Get stProcess.dwSize, Botw_ReadGameBinData - CEMU_DUMP_10000000 + 1, stMemoryDataMap.btdata
            End If
            Close stProcess.dwSize
        End If
    End If
End Function
Public Function Botw_MemorySearcherInventoryDataIniFile(Optional ByVal strCemuFolderPath As String = "", Optional ByVal BOTW_ITEM_PROPERTIES As BOTW_INVENTORYITEM_PROPERTIES = BOTW_ITEM_ALLPROPERTIES, Optional ByVal ITEMTYPEFILTER As BOTW_INVENTORYITEM_FILTERS = BOTW_ALLITEMS, Optional ByVal strItemIdFilter As String = "*") As Long
'Usage example with the immediate window: ?Botw_MemorySearcherInventoryDataIniFile("", BOTW_ITEMSUBTYPE_PROPERTY Or BOTW_ITEMQTYDUR_PROPERTY, BOTW_WEAPONSONLY)
'Output: D:\WiiU\Default\memorySearcher\00050000101c9<3|4|5|X>00.ini
Dim objInventoryItem As stInventoryItem
Dim stMemoryDataMap As stDataMap
Dim lngItemDataAddress As Long
Dim stMemorySearcherEntries(0 To BOTW_INVENTORYITEM_PROPERTIESCOUNT - 1) As stGameData
    strCemuFolderPath = Cemu_GetRootFolderPath(strCemuFolderPath)
    Botw_MemorySearcherInventoryDataIniFile = Cemu_ReadWiiuMappedData(stMemoryDataMap, "MemoryData.A4:C4", 0, strCemuFolderPath)
    If Botw_MemorySearcherInventoryDataIniFile <> 0 Then
        With stMemorySearcherEntries(Log(BOTW_PREVIOUSITEM_PROPERTY) / Log(2))
        .strHash = Cemu_GetBotwTitleId
        stMemoryDataMap.lngLowerOffsets(0) = FreeFile
        Open strCemuFolderPath + "memorySearcher\" + Left(.strHash, 8) + Mid(.strHash, 10, 8) + ".ini" For Output As stMemoryDataMap.lngLowerOffsets(0)
        .lngHash = 0
        .strDataName = ".PreviousItemAddress"
        .strHash = "int32"
        End With
        With stMemorySearcherEntries(Log(BOTW_NEXTITEM_PROPERTY) / Log(2))
        .lngHash = &H4
        .strDataName = ".NextItemAddress"
        .strHash = "int32"
        End With
        With stMemorySearcherEntries(Log(BOTW_ITEMTYPE_PROPERTY) / Log(2))
        .lngHash = &H8
        .strDataName = ".Type"
        .strHash = "int32"
        End With
        With stMemorySearcherEntries(Log(BOTW_ITEMSUBTYPE_PROPERTY) / Log(2))
        .lngHash = &HC
        .strDataName = ".SubType"
        .strHash = "int32"
        End With
        With stMemorySearcherEntries(Log(BOTW_ITEMQTYDUR_PROPERTY) / Log(2))
        .lngHash = &H10
        .strDataName = ".QtyDur"
        .strHash = "int32"
        End With
        With stMemorySearcherEntries(Log(BOTW_ITEMEQUIPPEDFLAG_PROPERTY) / Log(2))
        .lngHash = &H14
        .strDataName = ".EquippedFlag"
        .strHash = "int32"
        End With
        With stMemorySearcherEntries(Log(BOTW_ITEMBONUSVALUE_PROPERTY) / Log(2))
        .lngHash = &H64
        .strDataName = ".BonusValue"
        .strHash = "int32"
        End With
        With stMemorySearcherEntries(Log(BOTW_ITEMBONUSDURATION_PROPERTY) / Log(2))
        .lngHash = &H68
        .strDataName = ".BonusDuration"
        .strHash = "int32"
        End With
        With stMemorySearcherEntries(Log(BOTW_ITEMBONUSTYPE_PROPERTY) / Log(2))
        .lngHash = &H6C
        .strDataName = ".lngBonusType"
        .strHash = "int32"
        End With
        With stMemorySearcherEntries(Log(BOTW_ITEMEFFECTTYPE_PROPERTY) / Log(2))
        .lngHash = &H70
        .strDataName = ".lngEffectType"
        .strHash = "int32"
        End With
        With stMemorySearcherEntries(Log(BOTW_ITEMEFFECTLEVEL_PROPERTY) / Log(2))
        .lngHash = &H74
        .strDataName = ".lngEffectLevel"
        .strHash = "float"
        End With
        For stMemoryDataMap.lngDataSize = 228044 To 108 Step -544
            If stMemoryDataMap.btdata(stMemoryDataMap.lngDataSize + 36) <> 0 Then
                Call CopyMemory(VarPtr(objInventoryItem), VarPtr(stMemoryDataMap.btdata(stMemoryDataMap.lngDataSize)), 544)
                If (ITEMTYPEFILTER And (2^ ^ Converter_SwapEndian32(objInventoryItem.lngType))) <> 0 Then
                    strCemuFolderPath = Converter_CNullTerminatedString(objInventoryItem.btActorName)
                    If strCemuFolderPath Like strItemIdFilter Then
                        lngItemDataAddress = Botw_MemorySearcherInventoryDataIniFile + stMemoryDataMap.lngDataSize
                        stMemorySearcherEntries(0).lngHash = BOTW_INVENTORYITEM_PROPERTIESCOUNT
                        Do
                            stMemorySearcherEntries(0).lngHash = stMemorySearcherEntries(0).lngHash - 1
                            If (BOTW_ITEM_PROPERTIES And (2^ ^ stMemorySearcherEntries(0).lngHash)) <> 0 Then
                                With stMemorySearcherEntries(stMemorySearcherEntries(0).lngHash)
                                    Call Cemu_WriteMemorySearcherEntry(stMemoryDataMap.lngLowerOffsets(0), strCemuFolderPath + .strDataName, lngItemDataAddress + .lngHash, .strHash)
                                End With
                            End If
                        Loop Until stMemorySearcherEntries(0).lngHash = 0
                    End If
                End If
            End If
        Next stMemoryDataMap.lngDataSize
        Close stMemoryDataMap.lngLowerOffsets(0)
        Erase stMemoryDataMap.lngLowerOffsets
        Erase stMemoryDataMap.btdata
    End If
End Function
Public Function Botw_InitHashesTable(ByRef strDataSource As String, ByRef stHashesTable() As stGameData, Optional ByRef strSeparator As String = "") As Long
Dim xlsWorksheet As Worksheet
    If strSeparator = "" Then
        Set xlsWorksheet = Worksheets(strDataSource)
        Botw_InitHashesTable = xlsWorksheet.Range("B1").Value
        If Botw_InitHashesTable > 0 Then
            ReDim stHashesTable(1 To Botw_InitHashesTable)
            With xlsWorksheet.Range("A1:A" + xlsWorksheet.Range("B1").Text).Cells
            Do
                stHashesTable(Botw_InitHashesTable).strDataName = .Item(Botw_InitHashesTable, 1).Text
                stHashesTable(Botw_InitHashesTable).lngHash = Crc_CRC32(stHashesTable(Botw_InitHashesTable).strDataName)
                'stHashesTable(Botw_InitHashesTable).strHash = Right("0000000" + Hex(stHashesTable(Botw_InitHashesTable).lngHash), 8)
                Botw_InitHashesTable = Botw_InitHashesTable - 1
            Loop Until Botw_InitHashesTable = 0
            Botw_InitHashesTable = .Rows.Count
            End With
        End If
        Set xlsWorksheet = Nothing
    Else
        'TODO
    End If
End Function
Public Function Botw_GetGameSavePath(Optional ByRef strCemuFolderPath As String = "", Optional ByRef lngLngMinFileTimestamp As LongLong = 0) As String
'Usage example with the immediate window: ?Botw_GetGameSavePath()
    Botw_GetGameSavePath = Cemu_GetTitleId(strCemuFolderPath)
    Botw_GetGameSavePath = File_GetMostRecentFileDir(Replace(Cemu_GetMlc01Path(strCemuFolderPath), "/", "\") + "\usr\save\" + Left(Botw_GetGameSavePath, 8) + "\" + Right(Botw_GetGameSavePath, 8) + "\user\80000001\", "?", "game_data.sav", lngLngMinFileTimestamp)
End Function
Public Function Botw_SaveDataCmp(Optional ByVal strCemuFolderPath As String = "") As Integer
'Usage example with the immediate window: ?Botw_SaveDataCmp()
'Input: D:\WiiU\Default\mlc01\usr\save\00050000\101C9500\user\80000001\game_data.sav
'Output: D:\WiiU\Default\mlc01\usr\save\00050000\101C9500\user\80000001\?\game_data.sav.diff
'?: the most recent save slot
Dim intFile As Integer
Dim intOutFile As Integer
Dim lngOldSaveData(1 To 2) As Long
Dim lngSaveData(1 To 2) As Long
Dim lngSaveDataIndex As Long
Dim lngLngHash As LongLong
Dim lngLngExpectedHash As LongLong
Dim stHashesTable() As stGameData
    strCemuFolderPath = Botw_GetGameSavePath(strCemuFolderPath)
    If strCemuFolderPath <> "" Then
        intFile = FreeFile
        Open strCemuFolderPath For Binary Access Read As intFile
        intOutFile = FreeFile
        Open strCemuFolderPath + ".diff" For Output As intOutFile
        Botw_SaveDataCmp = FreeFile
        Open Left(strCemuFolderPath, Len(strCemuFolderPath) - 15) + "game_data.sav" For Binary Access Read As Botw_SaveDataCmp
        Get Botw_SaveDataCmp, 9, lngSaveDataIndex
        Get intFile, 9, lngSaveDataIndex
        lngSaveDataIndex = Botw_InitHashesTable("Savedata", stHashesTable)
        Do Until EOF(Botw_SaveDataCmp)
            Get Botw_SaveDataCmp, , lngOldSaveData
            Get intFile, , lngSaveData
            If lngOldSaveData(2) <> lngSaveData(2) Then
                lngSaveData(1) = Converter_SwapEndian32(lngSaveData(1))
                If stHashesTable(lngSaveDataIndex).lngHash <> lngSaveData(1) Then
                    Print #intOutFile, Right("0000000" + Hex(lngOldSaveData(2)), 8);
                    Print #intOutFile, " ";
                    Print #intOutFile, Right("0000000" + Hex(lngSaveData(2)), 8);
                    Print #intOutFile, " ";
                    Print #intOutFile, Right("0000000" + Hex(lngSaveData(1)), 8);
                    Print #intOutFile, " ";
                    lngLngHash = Converter_CULng(lngSaveData(1))
                    Do While lngLngHash > lngLngExpectedHash And lngSaveDataIndex > 1
                        lngSaveDataIndex = lngSaveDataIndex - 1
                        lngLngExpectedHash = Converter_CULng(stHashesTable(lngSaveDataIndex).lngHash)
                    Loop
                    If lngLngHash = lngLngExpectedHash Then
                        Print #intOutFile, stHashesTable(lngSaveDataIndex).strDataName;
                        Print #intOutFile, " ";
                    Else
                        Print #intOutFile, "UNKNOWN ";
                    End If
                    Print #intOutFile, CStr(lngSaveData(1))
                End If
            End If
        Loop
        Close Botw_SaveDataCmp
        Close intOutFile
        Close intFile
        Erase stHashesTable
    End If
End Function
Private Function Botw_FGameDataCmp(ByVal intFile1 As Integer, ByVal intFile2 As Integer, ByVal lngOffset As Long, ByVal intDataSize As Integer, ByRef lngDataHash, ByRef strDataDump1 As String, ByRef strDataDump2 As String) As Long
Static btBinData1(0 To 259) As Byte
Static btBinData2(0 To 259) As Byte
    Get intFile1, lngOffset, btBinData1
    Get intFile2, lngOffset, btBinData2
    Call CopyMemory(VarPtr(lngDataHash), VarPtr(btBinData1(intDataSize - 4)), 4)
    lngDataHash = Converter_SwapEndian32(lngDataHash)
    strDataDump1 = Memory_HexDump(btBinData1, , "", intDataSize)
    strDataDump2 = Memory_HexDump(btBinData2, , "", intDataSize)
    Botw_FGameDataCmp = CompareMemory(VarPtr(btBinData1(0)), VarPtr(btBinData2(0)), intDataSize)
End Function
Private Function Botw_FgetGameROMPlayerDataAddress(ByVal intFile As Integer, ByVal lngDeltaOffset As Long) As Long
Static lngLowerOffsets(0 To 1) As Long
    If lngLowerOffsets(1) = 0 Then
        lngLowerOffsets(0) = &H30
        lngLowerOffsets(1) = &H10463F38
    End If
    Botw_FgetGameROMPlayerDataAddress = File_GetMappedData(intFile, lngDeltaOffset, lngLowerOffsets)
End Function
Public Function Botw_FgetGameDataAddress(ByVal intFile As Integer, ByVal lngDeltaOffset As Long) As Long
Static lngLowerOffsets(0 To 2) As Long
    If lngLowerOffsets(2) = 0 Then
        lngLowerOffsets(0) = 0
        lngLowerOffsets(1) = &H710
        lngLowerOffsets(2) = &H1046D5B0 '0x10470000 - 0x2a50
    End If
    Botw_FgetGameDataAddress = File_GetMappedData(intFile, lngDeltaOffset, lngLowerOffsets)
End Function
Public Function Botw_PgetGameROMPlayerDataAddress(ByRef lngProcess As Long, ByRef lngLngMemoryBase As LongLong) As Long
Static lngLowerOffsets(0 To 1) As Long
    If lngLowerOffsets(1) = 0 Then
        lngLowerOffsets(0) = &H30
        lngLowerOffsets(1) = &H10463F38
    End If
    Botw_PgetGameROMPlayerDataAddress = Memory_GetMappedData(lngProcess, lngLngMemoryBase, lngLowerOffsets)
End Function
Public Function Botw_PgetGameDataAddress(ByRef lngProcess As Long, ByRef lngLngMemoryBase As LongLong) As Long
Static lngLowerOffsets(0 To 2) As Long
    If lngLowerOffsets(2) = 0 Then
        lngLowerOffsets(0) = 0
        lngLowerOffsets(1) = &H710
        lngLowerOffsets(2) = &H1046D5B0 '0x10470000 - 0x2a50
    End If
    Botw_PgetGameDataAddress = Memory_GetMappedData(lngProcess, lngLngMemoryBase, lngLowerOffsets)
End Function
Public Function Botw_PgetBasicGameDataAddress(ByRef lngProcess As Long, ByRef lngLngMemoryBase As LongLong) As Long
'Greater then 0xA0000000 -> return a signed long
Static lngLowerOffsets(0 To 2) As Long
    If lngLowerOffsets(2) = 0 Then
        lngLowerOffsets(0) = 0
        lngLowerOffsets(1) = &H70C
        lngLowerOffsets(2) = &H1046D5B0 '0x10470000 - 0x2a50
    End If
    Botw_PgetBasicGameDataAddress = Memory_GetMappedData(lngProcess, lngLngMemoryBase, lngLowerOffsets)
End Function
Public Function Botw_PgetSaveMgrQueuedUpdateDataAddress(ByRef lngProcess As Long, ByRef lngLngMemoryBase As LongLong) As Long
Static lngLowerOffsets(0 To 1) As Long
    If lngLowerOffsets(1) = 0 Then
        lngLowerOffsets(0) = &H71C
        lngLowerOffsets(1) = &H1046D5B0 '0x10470000 - 0x2a50
    End If
    Botw_PgetSaveMgrQueuedUpdateDataAddress = Memory_GetMappedData(lngProcess, lngLngMemoryBase, lngLowerOffsets)
End Function
Public Function Botw_PgetSaveDataAddress(ByRef lngProcess As Long, ByRef lngLngMemoryBase As LongLong) As Long
Static lngLowerOffsets(0 To 1) As Long
    If lngLowerOffsets(1) = 0 Then
        lngLowerOffsets(0) = &H920
        lngLowerOffsets(1) = &H1046D618 '0x10470000 - 0x29E8
    End If
    Botw_PgetSaveDataAddress = Memory_GetMappedData(lngProcess, lngLngMemoryBase, lngLowerOffsets)
End Function
Private Function Botw_BasicGameDataSize(ByRef stCurrentGameDataMap As stGameDataMap) As Integer
    With stCurrentGameDataMap
    If .intDataTypeSize < 4 Then
        Botw_BasicGameDataSize = 4
    ElseIf Left(.strDataType, 3) = "str" Then
        Botw_BasicGameDataSize = .intDataTypeSize + 12
    Else
        Botw_BasicGameDataSize = .intDataTypeSize
    End If
    End With
End Function
Public Function Botw_GameDataCmp(ByVal strDumpFolderPath1 As String, ByVal strDumpFolderPath2 As String) As Integer
'Usage example with the immediate window: ?Botw_GameDataCmp("D:\WiiU\Default\ramDump1623276340\", "D:\WiiU\Default\dump\ramDump1624645914\")
'Output: D:\WiiU\Default\dump\ramDump1623276340-ramDump1624645914.txt
Dim btGameDataMapsLength As Byte
Dim intInputFile As Integer
Dim intOutputFile As Integer
Dim lngVectorDataAddresses() As Long
Static lngDataArrayInfos(1 To 4) As Long
    intInputFile = Cemu_OpenDumpFile(strDumpFolderPath1, CEMU_DUMP_10000000)
    lngDataArrayInfos(1) = Botw_FgetGameDataAddress(intInputFile, CEMU_DUMP_10000000)
    If lngDataArrayInfos(1) <> 0 Then
        Get intInputFile, lngDataArrayInfos(1) - CEMU_DUMP_10000000 + 5, stGameBinDataMaps
        Call Botw_InitGameDataMap(1)
        Botw_GameDataCmp = Cemu_OpenDumpFile(strDumpFolderPath2, CEMU_DUMP_10000000)
        btGameDataMapsLength = BOTW_GAMEDATASCOUNT
        strDumpFolderPath1 = Left(strDumpFolderPath1, Len(strDumpFolderPath1) - 1)
        lngDataArrayInfos(1) = InStrRev(strDumpFolderPath1, "\")
        strDumpFolderPath2 = Mid(strDumpFolderPath2, lngDataArrayInfos(1) + 1)
        intOutputFile = FreeFile
        Open Left(strDumpFolderPath1, lngDataArrayInfos(1)) + Mid(strDumpFolderPath1, lngDataArrayInfos(1) + 1) + "-" + Left(strDumpFolderPath2, Len(strDumpFolderPath2) - 1) + ".txt" For Output As intOutputFile
        Do
            If stGameBinDataMaps(btGameDataMapsLength).lngCount <> 0 Then
                stGameBinDataMaps(btGameDataMapsLength).lngCount = Converter_SwapEndian32(stGameBinDataMaps(btGameDataMapsLength).lngCount)
                Call File_ReadLongDataSegment(intInputFile, Converter_SwapEndian32(stGameBinDataMaps(btGameDataMapsLength).lngAddress) - CEMU_DUMP_10000000 + 1, stGameBinDataMaps(btGameDataMapsLength).lngCount, lngVectorDataAddresses)
                With stGameDataMaps(btGameDataMapsLength)
                Print #intOutputFile, vbCrLf;
                Print #intOutputFile, "[";
                Print #intOutputFile, .stGameDatas(1).strDataName;
                Print #intOutputFile, "]"
                Erase .stGameDatas
                .intDataTypeSize = .intDataTypeSize + 4
                If .intDataHashOffset < 0 Then
                    .intDataHashOffset = 8 - .intDataHashOffset
                    For stGameBinDataMaps(btGameDataMapsLength).lngSize = stGameBinDataMaps(btGameDataMapsLength).lngCount To 1 Step -1
                        Get intInputFile, Converter_SwapEndian32(lngVectorDataAddresses(stGameBinDataMaps(btGameDataMapsLength).lngSize)) - CEMU_DUMP_10000000 + 1, lngDataArrayInfos
                        lngDataArrayInfos(1) = Converter_SwapEndian32(lngDataArrayInfos(1))
                        lngDataArrayInfos(4) = Converter_SwapEndian32(lngDataArrayInfos(4)) + lngDataArrayInfos(1) * .intDataHashOffset - 3
                        Do
                            If Botw_FGameDataCmp(intInputFile, Botw_GameDataCmp, lngDataArrayInfos(4) - .intDataTypeSize, .intDataTypeSize, lngDataArrayInfos(2), strDumpFolderPath1, strDumpFolderPath2) <> .intDataTypeSize Then
                                GoSub Botw_GameDataCmpSub
                                Print #intOutputFile, " ";
                                Print #intOutputFile, CStr(lngDataArrayInfos(1))
                            End If
                            lngDataArrayInfos(4) = lngDataArrayInfos(4) - stGameDataMaps(btGameDataMapsLength).intDataHashOffset
                            lngDataArrayInfos(1) = lngDataArrayInfos(1) - 1
                        Loop Until lngDataArrayInfos(1) = 0
                    Next stGameBinDataMaps(btGameDataMapsLength).lngSize
                Else
                    For stGameBinDataMaps(btGameDataMapsLength).lngSize = stGameBinDataMaps(btGameDataMapsLength).lngCount To 1 Step -1
                        If Botw_FGameDataCmp(intInputFile, Botw_GameDataCmp, Converter_SwapEndian32(lngVectorDataAddresses(stGameBinDataMaps(btGameDataMapsLength).lngSize)) - CEMU_DUMP_10000000 + 5 + .intDataHashOffset - stGameDataMaps(btGameDataMapsLength).intDataTypeSize, stGameDataMaps(btGameDataMapsLength).intDataTypeSize, lngDataArrayInfos(2), strDumpFolderPath1, strDumpFolderPath2) <> stGameDataMaps(btGameDataMapsLength).intDataTypeSize Then
                            GoSub Botw_GameDataCmpSub
                            Print #intOutputFile, vbCrLf;
                        End If
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
    Exit Function
Botw_GameDataCmpSub:
    Print #intOutputFile, strDumpFolderPath1;
    Print #intOutputFile, " ";
    Print #intOutputFile, strDumpFolderPath2;
    Print #intOutputFile, " ";
    Print #intOutputFile, Right("0000000" + Hex(lngDataArrayInfos(2)), 8);
    Print #intOutputFile, " ";
    Print #intOutputFile, CStr(lngDataArrayInfos(2));
    Return
End Function
Public Function Botw_MemorySearcherGameROMPlayerDataIniFile(Optional ByVal strCemuFolderPath As String = "") As Long
'Usage example with the immediate window: ?Botw_MemorySearcherGameROMPlayerDataIniFile()
'Output: D:\WiiU\Default\memorySearcher\00050000101c9<3|4|5|X>00.ini
Dim stProcess As PROCESSENTRY32
Dim stCemuLogData() As stExtractedTextData
Dim lngLngMemoryBase As LongLong
    strCemuFolderPath = Cemu_GetRootFolderPath(strCemuFolderPath)
    stProcess.dwFlags = File_ExtractText("Cemu.A2:C32", stCemuLogData, strCemuFolderPath + "log.txt", CEMU_LOG_WIIUMEMORYBASE Or CEMU_LOG_TITLEID)
    If stProcess.dwFlags = 2 Then
        stProcess.dwSize = Cemu_OpenProcess(SYSTEM_PROC_VMREAD, stProcess)
        If stProcess.dwSize <> 0 Then
            If System_ToogleProcessById(stProcess.th32ProcessID, -1) > 0 Then
                lngLngMemoryBase = CLngLng("&H" + stCemuLogData(1).objData.Item(0).SubMatches(0))
                Botw_MemorySearcherGameROMPlayerDataIniFile = Botw_PgetGameROMPlayerDataAddress(stProcess.dwSize, lngLngMemoryBase)
                If Botw_MemorySearcherGameROMPlayerDataIniFile <> 0 Then
                    stProcess.cntUsage = FreeFile
                    Open strCemuFolderPath + "memorySearcher\" + Left(stCemuLogData(2).objData.Item(0).SubMatches(0), 8) + Mid(stCemuLogData(2).objData.Item(0).SubMatches(0), 10) + ".ini" For Output As stProcess.cntUsage
                    If Cemu_LoadMemorySearcherDataMap("GameROMPlayer") > 0 Then Call Cemu_WriteMemorySearcherIniFile(stProcess.cntUsage, stProcess.dwSize, Botw_MemorySearcherGameROMPlayerDataIniFile, lngLngMemoryBase)
                    Close stProcess.cntUsage
                End If
                System_ToogleProcessById stProcess.th32ProcessID, 1
            End If
            CloseHandle stProcess.dwSize
        Else
            strCemuFolderPath = Cemu_GetDumpFolderPath(strCemuFolderPath)
            If strCemuFolderPath <> "" Then
                stProcess.dwSize = Cemu_OpenDumpFile(strCemuFolderPath, CEMU_DUMP_10000000)
                Botw_MemorySearcherGameROMPlayerDataIniFile = Botw_FgetGameROMPlayerDataAddress(stProcess.dwSize, CEMU_DUMP_10000000)
                If Botw_MemorySearcherGameROMPlayerDataIniFile <> 0 Then
                    stProcess.cntUsage = FreeFile
                    Open strCemuFolderPath + "..\..\memorySearcher\" + Left(stCemuLogData(2).objData.Item(0).SubMatches(0), 8) + Mid(stCemuLogData(2).objData.Item(0).SubMatches(0), 10) + ".ini" For Output As stProcess.cntUsage
                    If Cemu_LoadMemorySearcherDataMap("GameROMPlayer") > 0 Then Call Cemu_WriteMemorySearcherIniFile(stProcess.cntUsage, stProcess.dwSize, Botw_MemorySearcherGameROMPlayerDataIniFile, CEMU_DUMP_10000000)
                    Close stProcess.cntUsage
                End If
                Close stProcess.dwSize
            End If
        End If
        Set stCemuLogData(1).objData = Nothing
        Set stCemuLogData(2).objData = Nothing
        Erase stCemuLogData
    End If
End Function
Public Function Botw_MemorySearcherGameDataIniFile(Optional ByVal strCemuFolderPath As String = "") As Long
'Usage example with the immediate window: ?Botw_MemorySearcherGameDataIniFile()
'Output: D:\WiiU\Default\memorySearcher\00050000101c9<3|4|5|X>00.ini
Dim stProcess As PROCESSENTRY32
Dim stCemuLogData() As stExtractedTextData
Dim lngLngMemoryBase As LongLong
Dim lngGameDataAddresses() As Long
Dim lngBasicGameDataAddresses() As Long
Static lngGameDataArrayInfos(1 To 4) As Long
Static lngBasicGameDataArrayInfos(1 To 4) As Long
Static stBasicGameBinDataMaps(1 To BOTW_GAMEDATASCOUNT) As stGameBinDataMap
    strCemuFolderPath = Cemu_GetRootFolderPath(strCemuFolderPath)
    stProcess.dwFlags = File_ExtractText("Cemu.A2:C32", stCemuLogData, strCemuFolderPath + "log.txt", CEMU_LOG_WIIUMEMORYBASE Or CEMU_LOG_TITLEID)
    If stProcess.dwFlags = 2 Then
        stProcess.dwSize = Cemu_OpenProcess(SYSTEM_PROC_VMREAD, stProcess)
        If stProcess.dwSize <> 0 Then
            If System_ToogleProcessById(stProcess.th32ProcessID, -1) > 0 Then
                lngLngMemoryBase = CLngLng("&H" + stCemuLogData(1).objData.Item(0).SubMatches(0))
                Botw_MemorySearcherGameDataIniFile = Botw_PgetBasicGameDataAddress(stProcess.dwSize, lngLngMemoryBase)
                If Botw_MemorySearcherGameDataIniFile <> 0 Then
                    If ReadProcessMemory(stProcess.dwSize, lngLngMemoryBase + Botw_MemorySearcherGameDataIniFile + 4294967300^, VarPtr(stBasicGameBinDataMaps(1)), 216, 0) <> 0 Then
                        Botw_MemorySearcherGameDataIniFile = Botw_PgetGameDataAddress(stProcess.dwSize, lngLngMemoryBase)
                        If Botw_MemorySearcherGameDataIniFile <> 0 Then
                            If ReadProcessMemory(stProcess.dwSize, lngLngMemoryBase + Botw_MemorySearcherGameDataIniFile + 4, VarPtr(stGameBinDataMaps(1)), 216, 0) <> 0 Then
                                Call Botw_InitGameDataMap(7)
                                stCemuLogData(1).intLine = BOTW_GAMEDATASCOUNT
                                stProcess.cntUsage = FreeFile
                                Open strCemuFolderPath + "memorySearcher\" + Left(stCemuLogData(2).objData.Item(0).SubMatches(0), 8) + Mid(stCemuLogData(2).objData.Item(0).SubMatches(0), 10) + ".ini" For Output As stProcess.cntUsage
                                Do
                                    If stGameDataMaps(stCemuLogData(1).intLine).lngDataCount <> 0 Then
                                        If stGameBinDataMaps(stCemuLogData(1).intLine).lngCount <> 0 Then
                                            stGameBinDataMaps(stCemuLogData(1).intLine).lngCount = Converter_SwapEndian32(stGameBinDataMaps(stCemuLogData(1).intLine).lngCount)
                                            If Memory_ReadProcessLongMemoryDataSegment(stProcess.dwSize, lngLngMemoryBase + Converter_SwapEndian32(stBasicGameBinDataMaps(stCemuLogData(1).intLine).lngAddress) + 4294967296^, stGameBinDataMaps(stCemuLogData(1).intLine).lngCount, lngBasicGameDataAddresses) <> 0 Then
                                                If Memory_ReadProcessLongMemoryDataSegment(stProcess.dwSize, lngLngMemoryBase + Converter_SwapEndian32(stGameBinDataMaps(stCemuLogData(1).intLine).lngAddress), stGameBinDataMaps(stCemuLogData(1).intLine).lngCount, lngGameDataAddresses) <> 0 Then
                                                    stBasicGameBinDataMaps(stCemuLogData(1).intLine).lngAddress = Botw_BasicGameDataSize(stGameDataMaps(stCemuLogData(1).intLine))
                                                    Botw_MemorySearcherGameDataIniFile = 8 + stBasicGameBinDataMaps(stCemuLogData(1).intLine).lngAddress
                                                    If stGameDataMaps(stCemuLogData(1).intLine).intDataHashOffset < 0 Then
                                                        stGameDataMaps(stCemuLogData(1).intLine).intDataHashOffset = 8 - stGameDataMaps(stCemuLogData(1).intLine).intDataHashOffset
                                                        For stGameBinDataMaps(stCemuLogData(1).intLine).lngSize = stGameBinDataMaps(stCemuLogData(1).intLine).lngCount To 1 Step -1
                                                            If ReadProcessMemory(stProcess.dwSize, lngLngMemoryBase + Converter_SwapEndian32(lngBasicGameDataAddresses(stGameBinDataMaps(stCemuLogData(1).intLine).lngSize)) + 4294967296^, VarPtr(lngBasicGameDataArrayInfos(1)), 16, 0) <> 0 Then
                                                                If ReadProcessMemory(stProcess.dwSize, lngLngMemoryBase + Converter_SwapEndian32(lngGameDataAddresses(stGameBinDataMaps(stCemuLogData(1).intLine).lngSize)), VarPtr(lngGameDataArrayInfos(1)), 16, 0) <> 0 Then
                                                                    lngGameDataArrayInfos(1) = Converter_SwapEndian32(lngGameDataArrayInfos(1))
                                                                    lngGameDataArrayInfos(4) = Converter_SwapEndian32(lngGameDataArrayInfos(4)) + lngGameDataArrayInfos(1) * stGameDataMaps(stCemuLogData(1).intLine).intDataHashOffset - 8
                                                                    lngBasicGameDataArrayInfos(4) = Converter_SwapEndian32(lngBasicGameDataArrayInfos(4)) + lngGameDataArrayInfos(1) * Botw_MemorySearcherGameDataIniFile
                                                                    If ReadProcessMemory(stProcess.dwSize, lngLngMemoryBase + lngGameDataArrayInfos(4), VarPtr(lngGameDataArrayInfos(2)), 4, 0) <> 0 Then
                                                                        lngGameDataArrayInfos(2) = Converter_SwapEndian32(lngGameDataArrayInfos(2))
                                                                        GoSub Botw_MemorySearcherGameDataIniFileSub0
                                                                        If stGameDataMaps(stCemuLogData(1).intLine).lngDataCount = 0 Then Exit For
                                                                    End If
                                                                End If
                                                            End If
                                                        Next stGameBinDataMaps(stCemuLogData(1).intLine).lngSize
                                                    Else
                                                        For stGameBinDataMaps(stCemuLogData(1).intLine).lngSize = stGameBinDataMaps(stCemuLogData(1).intLine).lngCount To 1 Step -1
                                                            lngGameDataAddresses(stGameBinDataMaps(stCemuLogData(1).intLine).lngSize) = Converter_SwapEndian32(lngGameDataAddresses(stGameBinDataMaps(stCemuLogData(1).intLine).lngSize)) + stGameDataMaps(stCemuLogData(1).intLine).intDataHashOffset
                                                            lngBasicGameDataAddresses(stGameBinDataMaps(stCemuLogData(1).intLine).lngSize) = Converter_SwapEndian32(lngBasicGameDataAddresses(stGameBinDataMaps(stCemuLogData(1).intLine).lngSize)) + Botw_MemorySearcherGameDataIniFile
                                                            If ReadProcessMemory(stProcess.dwSize, lngLngMemoryBase + lngGameDataAddresses(stGameBinDataMaps(stCemuLogData(1).intLine).lngSize), VarPtr(lngGameDataArrayInfos(2)), 4, 0) <> 0 Then
                                                                If Converter_SwapEndian32(lngGameDataArrayInfos(2)) = stGameDataMaps(stCemuLogData(1).intLine).stGameDatas(stGameDataMaps(stCemuLogData(1).intLine).lngDataCount).lngHash Then
                                                                    GoSub Botw_MemorySearcherGameDataIniFileSub1
                                                                    stGameDataMaps(stCemuLogData(1).intLine).lngDataCount = stGameDataMaps(stCemuLogData(1).intLine).lngDataCount - 1
                                                                    If stGameDataMaps(stCemuLogData(1).intLine).lngDataCount = 0 Then Exit For
                                                                End If
                                                            End If
                                                        Next stGameBinDataMaps(stCemuLogData(1).intLine).lngSize
                                                    End If
                                                End If
                                                Erase lngGameDataAddresses
                                            End If
                                            Erase lngBasicGameDataAddresses
                                        End If
                                        Erase stGameDataMaps(stCemuLogData(1).intLine).stGameDatas
                                    End If
                                    stCemuLogData(1).intLine = stCemuLogData(1).intLine - 1
                                Loop Until stCemuLogData(1).intLine = 0
                                Close stProcess.cntUsage
                            End If
                        End If
                    End If
                End If
                System_ToogleProcessById stProcess.th32ProcessID, 1
            End If
            CloseHandle stProcess.dwSize
        Else
            strCemuFolderPath = Cemu_GetDumpFolderPath(strCemuFolderPath)
            If strCemuFolderPath <> "" Then
                stProcess.dwSize = Cemu_OpenDumpFile(strCemuFolderPath, CEMU_DUMP_10000000)
                Botw_MemorySearcherGameDataIniFile = Botw_FgetGameDataAddress(stProcess.dwSize, CEMU_DUMP_10000000)
                If Botw_MemorySearcherGameDataIniFile <> 0 Then
                    Get stProcess.dwSize, Botw_MemorySearcherGameDataIniFile - CEMU_DUMP_10000000 + 5, stGameBinDataMaps
                    stProcess.cntThreads = Cemu_OpenDumpFile(strCemuFolderPath, CEMU_DUMP_A0000000)
                    Botw_MemorySearcherGameDataIniFile = Botw_PgetBasicGameDataAddress(stProcess.cntThreads, lngLngMemoryBase)
                    Get stProcess.dwSize, Botw_MemorySearcherGameDataIniFile - CEMU_DUMP_A0000000 + 5, stBasicGameBinDataMaps
                    Call Botw_InitGameDataMap(7)
                    stCemuLogData(1).intLine = BOTW_GAMEDATASCOUNT
                    stProcess.cntUsage = FreeFile
                    Open strCemuFolderPath + "..\..\memorySearcher\" + Left(stCemuLogData(2).objData.Item(0).SubMatches(0), 8) + Mid(stCemuLogData(2).objData.Item(0).SubMatches(0), 10) + ".ini" For Output As stProcess.cntUsage
                    Do
                        If stGameDataMaps(stCemuLogData(1).intLine).lngDataCount <> 0 Then
                            If stGameBinDataMaps(stCemuLogData(1).intLine).lngCount <> 0 Then
                                stGameBinDataMaps(stCemuLogData(1).intLine).lngCount = Converter_SwapEndian32(stGameBinDataMaps(stCemuLogData(1).intLine).lngCount)
                                Call File_ReadLongDataSegment(stProcess.dwSize, Converter_SwapEndian32(stGameBinDataMaps(stCemuLogData(1).intLine).lngAddress) - CEMU_DUMP_10000000 + 1, stGameBinDataMaps(stCemuLogData(1).intLine).lngCount, lngGameDataAddresses)
                                Call File_ReadLongDataSegment(stProcess.cntThreads, Converter_SwapEndian32(stBasicGameBinDataMaps(stCemuLogData(1).intLine).lngAddress) - CEMU_DUMP_A0000000 + 1, stGameBinDataMaps(stCemuLogData(1).intLine).lngCount, lngBasicGameDataAddresses)
                                stBasicGameBinDataMaps(stCemuLogData(1).intLine).lngAddress = Botw_BasicGameDataSize(stGameDataMaps(stCemuLogData(1).intLine))
                                Botw_MemorySearcherGameDataIniFile = 8 + stBasicGameBinDataMaps(stCemuLogData(1).intLine).lngAddress
                                If stGameDataMaps(stCemuLogData(1).intLine).intDataHashOffset < 0 Then
                                    stGameDataMaps(stCemuLogData(1).intLine).intDataHashOffset = 8 - stGameDataMaps(stCemuLogData(1).intLine).intDataHashOffset
                                    For stGameBinDataMaps(stCemuLogData(1).intLine).lngSize = stGameBinDataMaps(stCemuLogData(1).intLine).lngCount To 1 Step -1
                                        Get stProcess.dwSize, Converter_SwapEndian32(lngGameDataAddresses(stGameBinDataMaps(stCemuLogData(1).intLine).lngSize)) - CEMU_DUMP_10000000 + 1, lngGameDataArrayInfos
                                        Get stProcess.cntThreads, Converter_SwapEndian32(lngBasicGameDataAddresses(stGameBinDataMaps(stCemuLogData(1).intLine).lngSize)) - CEMU_DUMP_A0000000 + 1, lngBasicGameDataArrayInfos
                                        lngGameDataArrayInfos(1) = Converter_SwapEndian32(lngGameDataArrayInfos(1))
                                        lngGameDataArrayInfos(4) = Converter_SwapEndian32(lngGameDataArrayInfos(4)) + lngGameDataArrayInfos(1) * stGameDataMaps(stCemuLogData(1).intLine).intDataHashOffset - 8
                                        lngBasicGameDataArrayInfos(4) = Converter_SwapEndian32(lngBasicGameDataArrayInfos(4)) + lngGameDataArrayInfos(1) * Botw_MemorySearcherGameDataIniFile
                                        Get stProcess.dwSize, lngGameDataArrayInfos(4) - CEMU_DUMP_10000000 + 1, lngGameDataArrayInfos(2)
                                        lngGameDataArrayInfos(2) = Converter_SwapEndian32(lngGameDataArrayInfos(2))
                                        GoSub Botw_MemorySearcherGameDataIniFileSub0
                                        If stGameDataMaps(stCemuLogData(1).intLine).lngDataCount = 0 Then Exit For
                                    Next stGameBinDataMaps(stCemuLogData(1).intLine).lngSize
                                Else
                                    For stGameBinDataMaps(stCemuLogData(1).intLine).lngSize = stGameBinDataMaps(stCemuLogData(1).intLine).lngCount To 1 Step -1
                                        lngGameDataAddresses(stGameBinDataMaps(stCemuLogData(1).intLine).lngSize) = Converter_SwapEndian32(lngGameDataAddresses(stGameBinDataMaps(stCemuLogData(1).intLine).lngSize)) + stGameDataMaps(stCemuLogData(1).intLine).intDataHashOffset
                                        lngBasicGameDataAddresses(stGameBinDataMaps(stCemuLogData(1).intLine).lngSize) = Converter_SwapEndian32(lngBasicGameDataAddresses(stGameBinDataMaps(stCemuLogData(1).intLine).lngSize)) + Botw_MemorySearcherGameDataIniFile
                                        Get stProcess.dwSize, lngGameDataAddresses(stGameBinDataMaps(stCemuLogData(1).intLine).lngSize) - CEMU_DUMP_10000000 + 1, lngGameDataArrayInfos(2)
                                        If Converter_SwapEndian32(lngGameDataArrayInfos(2)) = stGameDataMaps(stCemuLogData(1).intLine).stGameDatas(stGameDataMaps(stCemuLogData(1).intLine).lngDataCount).lngHash Then
                                            GoSub Botw_MemorySearcherGameDataIniFileSub1
                                            stGameDataMaps(stCemuLogData(1).intLine).lngDataCount = stGameDataMaps(stCemuLogData(1).intLine).lngDataCount - 1
                                            If stGameDataMaps(stCemuLogData(1).intLine).lngDataCount = 0 Then Exit For
                                        End If
                                    Next stGameBinDataMaps(stCemuLogData(1).intLine).lngSize
                                End If
                                Erase lngBasicGameDataAddresses
                                Erase lngGameDataAddresses
                            End If
                            Erase stGameDataMaps(stCemuLogData(1).intLine).stGameDatas
                        End If
                        stCemuLogData(1).intLine = stCemuLogData(1).intLine - 1
                    Loop Until stCemuLogData(1).intLine = 0
                    Close stProcess.cntUsage
                    Close stProcess.cntThreads
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
    For lngGameDataArrayInfos(3) = .lngDataCount To 1 Step -1
        If .stGameDatas(lngGameDataArrayInfos(3)).lngHash = lngGameDataArrayInfos(2) Then
            .stGameDatas(lngGameDataArrayInfos(3)).strDataName = .stGameDatas(lngGameDataArrayInfos(3)).strDataName + ","
            .stGameDatas(lngGameDataArrayInfos(3)).strHash = "," + .stGameDatas(lngGameDataArrayInfos(3)).strHash + "," + CStr(lngGameDataArrayInfos(2)) + ","
            If Left(.strDataType, 3) = "str" Then
                Do
                    strCemuFolderPath = .stGameDatas(lngGameDataArrayInfos(3)).strDataName + CStr(lngGameDataArrayInfos(1)) + .stGameDatas(lngGameDataArrayInfos(3)).strHash
                    For stProcess.dwFlags = .intDataTypeSize To 8 Step -8
                        Call Cemu_WriteMemorySearcherEntry(stProcess.cntUsage, strCemuFolderPath + Hex(lngBasicGameDataArrayInfos(4) - stProcess.dwFlags), lngGameDataArrayInfos(4) - stProcess.dwFlags, "int64")
                    Next stProcess.dwFlags
                    lngGameDataArrayInfos(4) = lngGameDataArrayInfos(4) - .intDataHashOffset
                    lngBasicGameDataArrayInfos(4) = lngBasicGameDataArrayInfos(4) - Botw_MemorySearcherGameDataIniFile
                    lngGameDataArrayInfos(1) = lngGameDataArrayInfos(1) - 1
                Loop Until lngGameDataArrayInfos(1) = 0
            Else
                If .intDataTypeSize > 4 Then
                    Do
                        strCemuFolderPath = .stGameDatas(lngGameDataArrayInfos(3)).strDataName + CStr(lngGameDataArrayInfos(1)) + .stGameDatas(lngGameDataArrayInfos(3)).strHash
                        For stProcess.dwFlags = .intDataTypeSize To 4 Step -4
                            Call Cemu_WriteMemorySearcherEntry(stProcess.cntUsage, strCemuFolderPath + Hex(lngBasicGameDataArrayInfos(4) - stProcess.dwFlags), lngGameDataArrayInfos(4) - stProcess.dwFlags, .strDataType)
                        Next stProcess.dwFlags
                        lngGameDataArrayInfos(4) = lngGameDataArrayInfos(4) - .intDataHashOffset
                        lngBasicGameDataArrayInfos(4) = lngBasicGameDataArrayInfos(4) - Botw_MemorySearcherGameDataIniFile
                        lngGameDataArrayInfos(1) = lngGameDataArrayInfos(1) - 1
                    Loop Until lngGameDataArrayInfos(1) = 0
                Else
                    lngGameDataArrayInfos(4) = lngGameDataArrayInfos(4) - .intDataTypeSize
                    lngBasicGameDataArrayInfos(4) = lngBasicGameDataArrayInfos(4) - stBasicGameBinDataMaps(stCemuLogData(1).intLine).lngAddress
                    Do
                        Call Cemu_WriteMemorySearcherEntry(stProcess.cntUsage, .stGameDatas(lngGameDataArrayInfos(3)).strDataName + CStr(lngGameDataArrayInfos(1)) + .stGameDatas(lngGameDataArrayInfos(3)).strHash + Hex(lngBasicGameDataArrayInfos(4)), lngGameDataArrayInfos(4), .strDataType)
                        lngGameDataArrayInfos(4) = lngGameDataArrayInfos(4) - .intDataHashOffset
                        lngBasicGameDataArrayInfos(4) = lngBasicGameDataArrayInfos(4) - Botw_MemorySearcherGameDataIniFile
                        lngGameDataArrayInfos(1) = lngGameDataArrayInfos(1) - 1
                    Loop Until lngGameDataArrayInfos(1) = 0
                End If
            End If
            If lngGameDataArrayInfos(3) <> .lngDataCount Then .stGameDatas(lngGameDataArrayInfos(3)) = .stGameDatas(.lngDataCount)
            .lngDataCount = .lngDataCount - 1
            Exit For
        End If
    Next lngGameDataArrayInfos(3)
    End With
    Return
Botw_MemorySearcherGameDataIniFileSub1:
    With stGameDataMaps(stCemuLogData(1).intLine)
    .stGameDatas(.lngDataCount).strDataName = .stGameDatas(.lngDataCount).strDataName + "," + .stGameDatas(.lngDataCount).strHash + "," + CStr(.stGameDatas(.lngDataCount).lngHash) + ","
    If Left(.strDataType, 3) = "str" Then
        For stProcess.dwFlags = .intDataTypeSize To 8 Step -8
            Call Cemu_WriteMemorySearcherEntry(stProcess.cntUsage, .stGameDatas(.lngDataCount).strDataName + Hex(lngBasicGameDataAddresses(stGameBinDataMaps(stCemuLogData(1).intLine).lngSize) - stProcess.dwFlags), lngGameDataAddresses(stGameBinDataMaps(stCemuLogData(1).intLine).lngSize) - stProcess.dwFlags, "int64")
        Next stProcess.dwFlags
    Else
        If .intDataTypeSize > 4 Then
            For stProcess.dwFlags = .intDataTypeSize To 4 Step -4
                Call Cemu_WriteMemorySearcherEntry(stProcess.cntUsage, .stGameDatas(.lngDataCount).strDataName + Hex(lngBasicGameDataAddresses(stGameBinDataMaps(stCemuLogData(1).intLine).lngSize) - stProcess.dwFlags), lngGameDataAddresses(stGameBinDataMaps(stCemuLogData(1).intLine).lngSize) - stProcess.dwFlags, .strDataType)
            Next stProcess.dwFlags
        Else
            Call Cemu_WriteMemorySearcherEntry(stProcess.cntUsage, .stGameDatas(.lngDataCount).strDataName + Hex(lngBasicGameDataAddresses(stGameBinDataMaps(stCemuLogData(1).intLine).lngSize) - stBasicGameBinDataMaps(stCemuLogData(1).intLine).lngAddress), lngGameDataAddresses(stGameBinDataMaps(stCemuLogData(1).intLine).lngSize) - .intDataTypeSize, .strDataType)
        End If
    End If
    End With
    Return
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
                .lngHashId = Converter_SwapEndian32(CLng("&H" + .strHashId))
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
                        .lngCoordinates(1) = Converter_Sng2LngVar(CSng(strMapObjectPropertyValues(0)))
                        .lngCoordinates(2) = Converter_Sng2LngVar(CSng(strMapObjectPropertyValues(1)))
                        .lngCoordinates(3) = Converter_Sng2LngVar(CSng(strMapObjectPropertyValues(2)))
                        xlsRange.Item(i, 9).Value = Right("0000000" + Hex(.lngCoordinates(1)), 8) + Right(Hex(.lngCoordinates(2)), 8) + Right(Hex(.lngCoordinates(3)), 8)
                        .lngCoordinates(1) = Converter_SwapEndian32(.lngCoordinates(1))
                        .lngCoordinates(2) = Converter_SwapEndian32(.lngCoordinates(2))
                        .lngCoordinates(3) = Converter_SwapEndian32(.lngCoordinates(3))
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
                                .lngRotationFactors(1) = Converter_Sng2LngVar(CSng(strMapObjectPropertyValues(0)))
                                .lngRotationFactors(2) = Converter_Sng2LngVar(CSng(strMapObjectPropertyValues(1)))
                                .lngRotationFactors(3) = Converter_Sng2LngVar(CSng(strMapObjectPropertyValues(2)))
                                xlsRange.Item(i, 3).Value = Right("0000000" + Hex(.lngRotationFactors(1)), 8) + Right("0000000" + Hex(.lngRotationFactors(2)), 8) + Right("0000000" + Hex(.lngRotationFactors(3)), 8)
                                .lngRotationFactors(1) = Converter_SwapEndian32(.lngRotationFactors(1))
                                .lngRotationFactors(2) = Converter_SwapEndian32(.lngRotationFactors(2))
                                .lngRotationFactors(3) = Converter_SwapEndian32(.lngRotationFactors(3))
                                Erase strMapObjectPropertyValues
                            Else
                                .stMapUnitObjectDataMap.btDataSize(.stMapUnitObjectDataMap.btDataCount) = 4
                                .lngRotationFactors(1) = Converter_Sng2LngVar(CSng(strWkSheetName))
                                .lngRotationFactors(2) = -266111927
                                .lngRotationFactors(3) = -266111927
                                xlsRange.Item(i, 3).Value = Right("0000000" + Hex(.lngRotationFactors(1)), 8)
                                .lngRotationFactors(1) = Converter_SwapEndian32(.lngRotationFactors(1))
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
                                    .lngScaleFactors(1) = Converter_Sng2LngVar(CSng(strMapObjectPropertyValues(0)))
                                    .lngScaleFactors(2) = Converter_Sng2LngVar(CSng(strMapObjectPropertyValues(1)))
                                    .lngScaleFactors(3) = Converter_Sng2LngVar(CSng(strMapObjectPropertyValues(2)))
                                    xlsRange.Item(i, 7).Value = Right("0000000" + Hex(.lngScaleFactors(1)), 8) + Right("0000000" + Hex(.lngScaleFactors(2)), 8) + Right("0000000" + Hex(.lngScaleFactors(3)), 8)
                                    .lngScaleFactors(1) = Converter_SwapEndian32(.lngScaleFactors(1))
                                    .lngScaleFactors(2) = Converter_SwapEndian32(.lngScaleFactors(2))
                                    .lngScaleFactors(3) = Converter_SwapEndian32(.lngScaleFactors(3))
                                    Erase strMapObjectPropertyValues
                                Else
                                    .stMapUnitObjectDataMap.btDataSize(.stMapUnitObjectDataMap.btDataCount) = 4
                                    .lngScaleFactors(1) = Converter_Sng2LngVar(CSng(strWkSheetName))
                                    .lngScaleFactors(2) = -266111927
                                    .lngScaleFactors(3) = -266111927
                                    xlsRange.Item(i, 7).Value = Right("0000000" + Hex(.lngScaleFactors(1)), 8)
                                    .lngScaleFactors(1) = Converter_SwapEndian32(.lngScaleFactors(1))
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
                                    .lngSRTHash = Converter_SwapEndian32(CLng(strWkSheetName))
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
Dim btBuffer(1 To 1024) As Byte
Dim btSearchByte As Byte
Dim lngHashId As Long
Dim i As Integer
Dim intIndex As Integer
Dim lngMapUnitDataAddresses(0 To 3) As Long
Dim btMapUnitDataBytes() As Byte
Dim intInputFile As Integer
Dim intOutputFile As Integer
    Botw_MemorySearcherMapObjectsIniFile = Botw_LoadMapObjectsData(strWkSheetName, stMapObjects)
    intInputFile = Cemu_OpenDumpFile(strDumpFolderPath, CEMU_DUMP_10000000)
    intOutputFile = FreeFile
    Open strDumpFolderPath + "00050000101c9X00.mapobjects.ini" For Output As intOutputFile
    If Botw_MemorySearcherMapObjectsIniFile < 0 Then
        Botw_MemorySearcherMapObjectsIniFile = Abs(Botw_MemorySearcherMapObjectsIniFile)
        lngMapUnitDataAddresses(0) = 1
        Seek intInputFile, lngMapUnitDataOffset
        intIndex = Botw_NextMapUnitObject(stMapObjects, Botw_MemorySearcherMapObjectsIniFile, btSearchByte)
        Do Until EOF(intInputFile) Or intIndex = 0
            Get intInputFile, , btBuffer
            For i = 1 To 1024
                If btBuffer(i) = btSearchByte Then
                    lngMapUnitDataOffset = Seek(1) - 1025 + i
                    Get intInputFile, lngMapUnitDataOffset, lngHashId
                    If lngHashId = stMapObjects(intIndex).lngHashId Then
                        Get intInputFile, , btBuffer
                        lngHashId = 0
                        With stMapObjects(intIndex)
                        Do
                            lngHashId = lngHashId + 1
                            Call Converter_Var2Bytes(btMapUnitDataBytes, .stMapUnitObjectDataMap.ptrData(lngHashId), .stMapUnitObjectDataMap.btDataSize(lngHashId))
                            lngMapUnitDataAddresses(lngHashId) = Vector_InBytes(lngMapUnitDataAddresses(lngHashId - 1) + .stMapUnitObjectDataMap.btDataSize(lngHashId - 1), btBuffer, btMapUnitDataBytes)
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
                                        Print #intOutputFile, strDumpFolderPath + .stMapUnitObjectDataMap.strDataLabel(.stMapUnitObjectDataMap.btDataCount) + Chr(90 - .stMapUnitObjectDataMap.btDataSize(.stMapUnitObjectDataMap.btDataCount) \ 4) + vbCrLf + "address=0x" + Hex(CEMU_DUMP_10000000 + 2 + lngHashId + .stMapUnitObjectDataMap.btDataSize(.stMapUnitObjectDataMap.btDataCount) + lngMapUnitDataAddresses(.stMapUnitObjectDataMap.btDataCount)) + strWkSheetName
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
        Get intInputFile, , btBuffer
        For i = 1 To 1024
            If btBuffer(i) = btSearchByte Then
                lngTranslateDataOffset = Seek(1) - 1025 + i
                Get intInputFile, lngTranslateDataOffset, lngHashId
                If lngHashId = stMapObjects(Botw_MemorySearcherMapObjectsIniFile).lngHashId Then
                    If File_ReadCmp256(1, VarPtr(stMapObjects(Botw_MemorySearcherMapObjectsIniFile).lngCoordinates(1)), 12) = 12 Then
                        With stMapObjects(Botw_MemorySearcherMapObjectsIniFile)
                        strDumpFolderPath = "[Entry]" + vbCrLf + "description=" + .strUnitConfigName + "_" + .strHashId + "_"
                        strWkSheetName = vbCrLf + "type=float" + vbCrLf + "value=" + vbCrLf
                        Print #intOutputFile, strDumpFolderPath + "X" + vbCrLf + "address=0x" + Hex(CEMU_DUMP_10000000 + 3 + lngTranslateDataOffset) + strWkSheetName
                        Print #intOutputFile, strDumpFolderPath + "Y" + vbCrLf + "address=0x" + Hex(CEMU_DUMP_10000000 + 7 + lngTranslateDataOffset) + strWkSheetName
                        Print #intOutputFile, strDumpFolderPath + "Z" + vbCrLf + "address=0x" + Hex(CEMU_DUMP_10000000 + 11 + lngTranslateDataOffset) + strWkSheetName
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
                                    Print #intOutputFile, strDumpFolderPath + "X" + vbCrLf + "address=0x" + Hex(CEMU_DUMP_10000000 + 3 + lngTranslateDataOffset) + strWkSheetName
                                    Print #intOutputFile, strDumpFolderPath + "Y" + vbCrLf + "address=0x" + Hex(CEMU_DUMP_10000000 + 7 + lngTranslateDataOffset) + strWkSheetName
                                    Print #intOutputFile, strDumpFolderPath + "Z" + vbCrLf + "address=0x" + Hex(CEMU_DUMP_10000000 + 11 + lngTranslateDataOffset) + strWkSheetName
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
    lngHashId = Botw_FgetGameROMPlayerDataAddress(intInputFile, CEMU_DUMP_10000000)
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
Public Function Botw_readSaveMgrQueuedUpdateData(Optional ByVal strCemuFolderPath As String = "") As Long
'lis r3, 0x1047
'lwz r3, -0x2A50(r3)
'mr r29, r3
'r29=0x3F43B0E4 (minor infos: lwz r3, 0x720(r29) r3=a0000238,lwz r3, 0x724(r29) r3=3f5fec48)
'lwz r3, 0x71C(r29)
'r3=0x3F43BA20
'Dim stProcess As PROCESSENTRY32
'Dim stCemuLogData() As stExtractedTextData
'Dim lngLngMemoryBase As LongLong
'    strCemuFolderPath = Cemu_GetRootFolderPath(strCemuFolderPath)
'    Call Memory_InitDataMap("MemoryData.A4:C4", stMemoryDataMap)
'    stProcess.dwSize = Cemu_openProcess(SYSTEM_PROC_VMREAD, stProcess)
'    If stProcess.dwSize <> 0 Then
'        If System_ToogleProcessById(stProcess.th32ProcessID, -1) > 0 Then
'            stProcess.dwFlags = File_ExtractText("Cemu.A2:C32", stCemuLogData, strCemuFolderPath + "log.txt", CEMU_LOG_WIIUMEMORYBASE)
'            If stProcess.dwFlags = 1 Then
'                lngLngMemoryBase = CLngLng("&H" + stCemuLogData(1).objData.Item(0).SubMatches(0))
'                Botw_readInventoryBinData = Memory_GetMappedData(stProcess.dwSize, lngLngMemoryBase, stMemoryDataMap.lngLowerOffsets)
'                If ReadProcessMemory(stProcess.dwSize, lngLngMemoryBase + Botw_readInventoryBinData, VarPtr(stMemoryDataMap.btdata(0)), stMemoryDataMap.lngDataSize, 0) = 0 Then Botw_readInventoryBinData = 0
'                Set stCemuLogData(1).objData = Nothing
'                Erase stCemuLogData
'            End If
'            System_ToogleProcessById stProcess.th32ProcessID, 1
'        End If
'        CloseHandle stProcess.dwSize
'    Else
'        strCemuFolderPath = Cemu_GetDumpFolderPath(strCemuFolderPath)
'        If strCemuFolderPath <> "" Then
'            stProcess.dwSize = Cemu_openDumpFile(strCemuFolderPath, CEMU_DUMP_10000000)
'            Botw_readInventoryBinData = File_getMappedData(stProcess.dwSize, CEMU_DUMP_10000000, stMemoryDataMap.lngLowerOffsets)
'            Get stProcess.dwSize, Botw_readInventoryBinData - CEMU_DUMP_10000000 + 1, stMemoryDataMap.btdata
'            Close stProcess.dwSize
'        End If
'    End If
End Function
Public Function Botw_GetGameDataName(ByRef str10000000DumpFile As String, ByVal lngDataIndexMemoryLocation As Long, ByRef BOTW_GAMEDATA As BOTW_GAMEDATAS) As String
'Usage example with the immediate window: ?Botw_GetGameDataName("D:\WiiU\Default\dump\10000000.bin",&h1046608C,BOTW_BOOLGAMEDATA)
Dim intFile As Integer
Dim lnglngDataHash As LongLong
Dim stHashesTable() As stGameData
    intFile = FreeFile
    Open str10000000DumpFile For Binary Access Read As intFile
    With stGameBinDataMaps(BOTW_GAMEDATA)
    .lngAddress = Botw_FgetGameDataAddress(intFile, CEMU_DUMP_10000000)
    If .lngAddress <> 0 Then
        Get intFile, lngDataIndexMemoryLocation - CEMU_DUMP_10000000 + 1, lngDataIndexMemoryLocation
        If lngDataIndexMemoryLocation <> 0 Then
            lngDataIndexMemoryLocation = Converter_SwapEndian32(lngDataIndexMemoryLocation)
            Get intFile, .lngAddress - CEMU_DUMP_10000000 - 7 + BOTW_GAMEDATA * 12, stGameBinDataMaps(BOTW_GAMEDATA)
            If lngDataIndexMemoryLocation < Converter_SwapEndian32(.lngCount) Then
                Call Botw_InitGameDataMap(1, 2^ ^ (BOTW_GAMEDATA - 1))
                Get intFile, Converter_SwapEndian32(.lngAddress) + lngDataIndexMemoryLocation * 4 - CEMU_DUMP_10000000 + 1, .lngAddress
                Get intFile, Converter_SwapEndian32(.lngAddress) + stGameDataMaps(BOTW_GAMEDATA).intDataHashOffset - CEMU_DUMP_10000000 + 1, .lngAddress
                .lngAddress = Converter_SwapEndian32(.lngAddress)
                lnglngDataHash = Converter_CULng(.lngAddress)
                For lngDataIndexMemoryLocation = Botw_InitHashesTable("Savedata", stHashesTable) - 1 To 1 Step -1
                    If lnglngDataHash < Converter_CULng(stHashesTable(lngDataIndexMemoryLocation).lngHash) Then
                        Exit For
                    ElseIf .lngAddress = stHashesTable(lngDataIndexMemoryLocation).lngHash Then
                        Botw_GetGameDataName = stHashesTable(lngDataIndexMemoryLocation).strDataName
                        Exit For
                    End If
                Next lngDataIndexMemoryLocation
                Erase stHashesTable
                Erase stGameDataMaps(BOTW_GAMEDATA).stGameDatas
            End If
        End If
    End If
    Close intFile
    End With
End Function
Public Function Botw_GetSaveDataName(ByRef lngHash As Long) As String
Dim xlsWorksheet As Worksheet
Dim i As Long
    Set xlsWorksheet = Worksheets("SaveData")
    With xlsWorksheet.Range("A1:A" + xlsWorksheet.Range("B1").Text).Cells
    For i = .Rows.Count To 1 Step -1
        If lngHash = Crc_CRC32(.Item(i, 1).Text) Then
            Botw_GetSaveDataName = .Item(i, 1).Text
            Exit For
        End If
    Next i
    End With
    Set xlsWorksheet = Nothing
End Function
Public Function Botw_MemorySearcherMemoryDataIniFile(ByVal BOTW_MEMORYDATA As BOTW_MEMORYDATAS, Optional ByRef blnSuspendCemu As Boolean = True, Optional ByVal blnOverwriteIniFile As Boolean = False, Optional ByVal strCemuFolderPath As String = "") As Long
'Usage example with the immediate window: ?Botw_MemorySearcherMemoryDataIniFile(BOTW_MEMORY_MASTERCYCLEZERO)
'Output: D:\WiiU\Default\memorySearcher\00050000101c9<3|4|5|X>00.ini
Dim stProcess As PROCESSENTRY32
Dim stCemuLogData() As stExtractedTextData
Dim strRow As String
Dim lngLngMemoryBase As LongLong
Dim strDataMembers() As String
Dim strMapFields() As String
    strCemuFolderPath = Cemu_GetRootFolderPath(strCemuFolderPath)
    stProcess.dwFlags = File_ExtractText("Cemu.A2:C32", stCemuLogData, strCemuFolderPath + "log.txt", CEMU_LOG_WIIUMEMORYBASE Or CEMU_LOG_TITLEID)
    If stProcess.dwFlags = 2 Then
        stProcess.dwSize = Cemu_OpenProcess(SYSTEM_PROC_VMREAD, stProcess)
        If stProcess.dwSize <> 0 Then
            If System_ToogleProcessById(stProcess.th32ProcessID, CInt(blnSuspendCemu)) > 0 Then
                lngLngMemoryBase = CLngLng("&H" + stCemuLogData(1).objData.Item(0).SubMatches(0))
                strRow = CStr(BOTW_MEMORYDATA + 1)
                With Worksheets("MemoryData").Range("A" + strRow + ":D" + strRow).Cells
                strRow = .Item(1, 2).Text
                Botw_MemorySearcherMemoryDataIniFile = Memory_PortableGetMappedData(stProcess.dwSize, lngLngMemoryBase, strRow, vbLf)
                If Botw_MemorySearcherMemoryDataIniFile <> 0 Then
                    strDataMembers = Split(.Item(1, 4).Text, vbLf)
                    BOTW_MEMORYDATA = UBound(strDataMembers) + 1
                    Call Cemu_InitMemorySearcherDataMap(BOTW_MEMORYDATA)
                    Do
                        BOTW_MEMORYDATA = BOTW_MEMORYDATA - 1
                        strMapFields = Split(strDataMembers(BOTW_MEMORYDATA), " ", 5)
                        If UBound(strMapFields) = 3 Then
                            Call Cemu_AddMemorySearcherDataMap(strMapFields(0), Cemu_GetMemorySearcherDataIndex(strMapFields(1)), CLng(strMapFields(2)), CLng(strMapFields(3)) + Botw_MemorySearcherMemoryDataIniFile)
                        Else
                            Call Cemu_AddMemorySearcherDataMap(strMapFields(0), Cemu_GetMemorySearcherDataIndex(strMapFields(1)), CLng(strMapFields(2)), CLng(strMapFields(3)) + Memory_PortableGetMappedData(stProcess.dwSize, lngLngMemoryBase, strMapFields(4) + " " + strRow))
                        End If
                        Erase strMapFields
                    Loop Until BOTW_MEMORYDATA = 0
                    Erase strDataMembers
                    stProcess.cntUsage = File_Create(strCemuFolderPath + "memorySearcher\" + Left(stCemuLogData(2).objData.Item(0).SubMatches(0), 8) + Mid(stCemuLogData(2).objData.Item(0).SubMatches(0), 10) + ".ini", 0, blnOverwriteIniFile)
                    Call Cemu_WriteMemorySearcherIniFile(stProcess.cntUsage, stProcess.dwSize, 0, lngLngMemoryBase)
                    Close stProcess.cntUsage
                End If
                End With
                System_ToogleProcessById stProcess.th32ProcessID, -CInt(blnSuspendCemu)
            End If
            CloseHandle stProcess.dwSize
        End If
        Set stCemuLogData(1).objData = Nothing
        Set stCemuLogData(2).objData = Nothing
        Erase stCemuLogData
    End If
End Function
