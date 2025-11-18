Attribute VB_Name = "Botw"
Option Explicit
Private Const BOTW_ALZP01_TITLEID = 1407375153861888^
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
Private Type stDropTable
    strName As String
    btMinRepeat As Byte
    btMaxrepeat As Byte
    btApproach As Byte
    btOccurrenceSpeed As Byte
    lngItemsCount As Long
    stItems() As stHashTableItem
End Type
Public Type stDataBlockMetaData
    lnglngHash As LongLong
    lngOffset As Long
    lngStartLine As Long
    lngLinesCount As Long
    lngMaxLineLength As Long
End Type
Private Const BOTW_DATABLOCKMETADATASIZE As Long = 24
Public Enum BOTW_DATABLOCK_METADATA_OFFSETS
    BOTW_DATABLOCK_MAXLINELENGTH_OFFSET = BOTW_DATABLOCKMETADATASIZE - 4
    BOTW_DATABLOCK_LINESCOUNT_OFFSET = BOTW_DATABLOCK_MAXLINELENGTH_OFFSET - 4
    BOTW_DATABLOCK_STARTLINE_OFFSET = BOTW_DATABLOCK_LINESCOUNT_OFFSET - 4
    BOTW_DATABLOCK_OFFSET_OFFSET = BOTW_DATABLOCK_STARTLINE_OFFSET - 4
    BOTW_DATABLOCK_HASHID_OFFSET = BOTW_DATABLOCK_OFFSET_OFFSET - 8
End Enum
Public stGameDataMaps(1 To BOTW_GAMEDATASCOUNT) As stGameDataMap
Private stGameBinDataMaps(1 To BOTW_GAMEDATASCOUNT) As stGameBinDataMap
Private Sub Botw_FreeDroptablesArray(ByRef stDropTables() As stDropTable)
Dim lngUbound As Long
    For lngUbound = UBound(stDropTables) To 0 Step -1
        Erase stDropTables(lngUbound).stItems
    Next lngUbound
    Erase stDropTables
End Sub
Private Function Botw_GetDropTableSettings(ByRef strSrcSettings As String) As stDropTable()
Dim xmlDoc As Object
Dim xmlDropTableNodes As Object
Dim xmlNodeAttibutes As Object
Dim xmlDropTableItemNodes As Object
Dim varout() As stDropTable
Dim lngDropTablesCount As Long
Dim blnLoadingStatus As Boolean
    Set xmlDoc = CreateObject("MSXML2.DOMDocument")
    xmlDoc.async = False
    If Right(strSrcSettings, 4) = ".xml" Then
        blnLoadingStatus = xmlDoc.Load(strSrcSettings)
    Else
        blnLoadingStatus = xmlDoc.LoadXML(strSrcSettings)
    End If
    If blnLoadingStatus Then
        Set xmlDropTableNodes = xmlDoc.FirstChild.ChildNodes
        If xmlDropTableNodes.Length > 0 Then
            lngDropTablesCount = xmlDropTableNodes.Length - 1
            ReDim varout(0 To lngDropTablesCount)
            Do
                Set xmlNodeAttibutes = xmlDropTableNodes.Item(lngDropTablesCount).Attributes
                With varout(lngDropTablesCount)
                .strName = xmlDropTableNodes.Item(lngDropTablesCount).nodeName
                If xmlNodeAttibutes.Length > 0 Then
                    .lngItemsCount = xmlNodeAttibutes.Length
                    Do
                        .lngItemsCount = .lngItemsCount - 1
                        Select Case xmlNodeAttibutes(.lngItemsCount).nodeName
                        Case "RepeatNumMin"
                            .btMinRepeat = CByte(xmlNodeAttibutes(.lngItemsCount).Text)
                        Case "RepeatNumMax"
                            .btMaxrepeat = CByte(xmlNodeAttibutes(.lngItemsCount).Text)
                        Case "ApproachType"
                            .btApproach = CByte(xmlNodeAttibutes(.lngItemsCount).Text)
                        Case "OccurrenceSpeedType"
                            .btOccurrenceSpeed = CByte(xmlNodeAttibutes(.lngItemsCount).Text)
                        End Select
                    Loop Until .lngItemsCount = 0
                End If
                Set xmlDropTableItemNodes = xmlDropTableNodes.Item(lngDropTablesCount).SelectNodes("Item")
                If xmlDropTableItemNodes.Length > 0 Then
                    ReDim .stItems(0 To xmlDropTableItemNodes.Length - 1)
                    Do
                        .stItems(.lngItemsCount).strKey = xmlDropTableItemNodes.Item(.lngItemsCount).Attributes(0).Text
                        .stItems(.lngItemsCount).strValue = xmlDropTableItemNodes.Item(.lngItemsCount).Text
                        .lngItemsCount = .lngItemsCount + 1
                    Loop Until .lngItemsCount = xmlDropTableItemNodes.Length
                End If
                Set xmlDropTableItemNodes = Nothing
                End With
                Set xmlNodeAttibutes = Nothing
                lngDropTablesCount = lngDropTablesCount - 1
            Loop Until lngDropTablesCount < 0
        End If
        Set xmlDropTableNodes = Nothing
    End If
    Set xmlDoc = Nothing
    Botw_GetDropTableSettings = varout
End Function
Public Function Botw_WriteDropTableFile(ByVal strDropTableFilePath As String, ByVal strXmlDropTableFilePath As String) As Object
Dim intFreefile As Integer
Dim i As Long
Dim j As Long
Dim lngDropTablesCount As Long
Dim lngUbound As Long
Dim stDropTables() As stDropTable
Dim varout As Object
    Set varout = CreateObject("Scripting.Dictionary")
    stDropTables = Botw_GetDropTableSettings(strXmlDropTableFilePath)
    lngDropTablesCount = UBound(stDropTables)
    intFreefile = FreeFile
    Open strDropTableFilePath For Output As intFreefile
    Print #intFreefile, "!io" + vbCrLf + "version: 0" + vbCrLf + "type: xml" + vbCrLf + "param_root: !list" + vbCrLf + "  objects:" + vbCrLf + "    Header: !obj" + vbCrLf + "      TableNum: " + CStr(lngDropTablesCount + 1)
    For i = 0 To lngDropTablesCount
        Print #intFreefile, "      Table" + Right("0" + CStr(i + 1), 2) + ": !str64 " + stDropTables(i).strName
    Next i
    For i = 0 To lngDropTablesCount
        With stDropTables(i)
        Print #intFreefile, "    " + .strName + ": !obj" + vbCrLf + "      RepeatNumMin: " + CStr(.btMinRepeat) + vbCrLf + "      RepeatNumMax: " + CStr(.btMaxrepeat) + vbCrLf + "      ApproachType: " + CStr(.btApproach) + vbCrLf + "      OccurrenceSpeedType: " + CStr(.btOccurrenceSpeed) + vbCrLf + "      ColumnNum: " + CStr(.lngItemsCount)
        strXmlDropTableFilePath = ""
        lngUbound = .lngItemsCount - 1
        For j = 0 To lngUbound
            strDropTableFilePath = Right("0" + CStr(j + 1), 2)
            Print #intFreefile, "      ItemName" + strDropTableFilePath + ": !str64 " + .stItems(j).strKey + vbCrLf + "      ItemProbability" + strDropTableFilePath + ": " + .stItems(j).strValue
            strXmlDropTableFilePath = strXmlDropTableFilePath + ", " + .stItems(j).strKey
        Next j
        varout(.strName) = Mid(strXmlDropTableFilePath, 3)
        End With
    Next i
    Print #intFreefile, "  lists: {}"
    Close intFreefile
    Call Botw_FreeDroptablesArray(stDropTables)
    Set Botw_WriteDropTableFile = varout
End Function
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
                        stCurrentGameData.lngHash = Hash_CRC32(stCurrentGameData.strDataName)
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
                ReDim stMemoryDataMap.btData(0 To stMemoryDataMap.lngDataSize - 1)
                Get stProcess.dwSize, Botw_ReadGameBinData - CEMU_DUMP_10000000 + 1, stMemoryDataMap.btData
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
            If stMemoryDataMap.btData(stMemoryDataMap.lngDataSize + 36) <> 0 Then
                Call CopyMemory(VarPtr(objInventoryItem), VarPtr(stMemoryDataMap.btData(stMemoryDataMap.lngDataSize)), 544)
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
        Erase stMemoryDataMap.btData
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
                stHashesTable(Botw_InitHashesTable).lngHash = Hash_CRC32(stHashesTable(Botw_InitHashesTable).strDataName)
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
    Botw_GetGameSavePath = File_GetMostRecentFileDir(Cemu_GetMlc01Path(strCemuFolderPath) + "\usr\save\" + Left(Botw_GetGameSavePath, 8) + "\" + Right(Botw_GetGameSavePath, 8) + "\user\80000001\", "?", "game_data.sav", lngLngMinFileTimestamp)
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
Dim lnglngHash As LongLong
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
                    lnglngHash = Converter_CULng(lngSaveData(1))
                    Do While lnglngHash > lngLngExpectedHash And lngSaveDataIndex > 1
                        lngSaveDataIndex = lngSaveDataIndex - 1
                        lngLngExpectedHash = Converter_CULng(stHashesTable(lngSaveDataIndex).lngHash)
                    Loop
                    If lnglngHash = lngLngExpectedHash Then
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
                                stCemuLogData(1).lngLine = BOTW_GAMEDATASCOUNT
                                stProcess.cntUsage = FreeFile
                                Open strCemuFolderPath + "memorySearcher\" + Left(stCemuLogData(2).objData.Item(0).SubMatches(0), 8) + Mid(stCemuLogData(2).objData.Item(0).SubMatches(0), 10) + ".ini" For Output As stProcess.cntUsage
                                Do
                                    If stGameDataMaps(stCemuLogData(1).lngLine).lngDataCount <> 0 Then
                                        If stGameBinDataMaps(stCemuLogData(1).lngLine).lngCount <> 0 Then
                                            stGameBinDataMaps(stCemuLogData(1).lngLine).lngCount = Converter_SwapEndian32(stGameBinDataMaps(stCemuLogData(1).lngLine).lngCount)
                                            If Memory_ReadProcessLongMemoryDataSegment(stProcess.dwSize, lngLngMemoryBase + Converter_SwapEndian32(stBasicGameBinDataMaps(stCemuLogData(1).lngLine).lngAddress) + 4294967296^, stGameBinDataMaps(stCemuLogData(1).lngLine).lngCount, lngBasicGameDataAddresses) <> 0 Then
                                                If Memory_ReadProcessLongMemoryDataSegment(stProcess.dwSize, lngLngMemoryBase + Converter_SwapEndian32(stGameBinDataMaps(stCemuLogData(1).lngLine).lngAddress), stGameBinDataMaps(stCemuLogData(1).lngLine).lngCount, lngGameDataAddresses) <> 0 Then
                                                    stBasicGameBinDataMaps(stCemuLogData(1).lngLine).lngAddress = Botw_BasicGameDataSize(stGameDataMaps(stCemuLogData(1).lngLine))
                                                    Botw_MemorySearcherGameDataIniFile = 8 + stBasicGameBinDataMaps(stCemuLogData(1).lngLine).lngAddress
                                                    If stGameDataMaps(stCemuLogData(1).lngLine).intDataHashOffset < 0 Then
                                                        stGameDataMaps(stCemuLogData(1).lngLine).intDataHashOffset = 8 - stGameDataMaps(stCemuLogData(1).lngLine).intDataHashOffset
                                                        For stGameBinDataMaps(stCemuLogData(1).lngLine).lngSize = stGameBinDataMaps(stCemuLogData(1).lngLine).lngCount To 1 Step -1
                                                            If ReadProcessMemory(stProcess.dwSize, lngLngMemoryBase + Converter_SwapEndian32(lngBasicGameDataAddresses(stGameBinDataMaps(stCemuLogData(1).lngLine).lngSize)) + 4294967296^, VarPtr(lngBasicGameDataArrayInfos(1)), 16, 0) <> 0 Then
                                                                If ReadProcessMemory(stProcess.dwSize, lngLngMemoryBase + Converter_SwapEndian32(lngGameDataAddresses(stGameBinDataMaps(stCemuLogData(1).lngLine).lngSize)), VarPtr(lngGameDataArrayInfos(1)), 16, 0) <> 0 Then
                                                                    lngGameDataArrayInfos(1) = Converter_SwapEndian32(lngGameDataArrayInfos(1))
                                                                    lngGameDataArrayInfos(4) = Converter_SwapEndian32(lngGameDataArrayInfos(4)) + lngGameDataArrayInfos(1) * stGameDataMaps(stCemuLogData(1).lngLine).intDataHashOffset - 8
                                                                    lngBasicGameDataArrayInfos(4) = Converter_SwapEndian32(lngBasicGameDataArrayInfos(4)) + lngGameDataArrayInfos(1) * Botw_MemorySearcherGameDataIniFile
                                                                    If ReadProcessMemory(stProcess.dwSize, lngLngMemoryBase + lngGameDataArrayInfos(4), VarPtr(lngGameDataArrayInfos(2)), 4, 0) <> 0 Then
                                                                        lngGameDataArrayInfos(2) = Converter_SwapEndian32(lngGameDataArrayInfos(2))
                                                                        GoSub Botw_MemorySearcherGameDataIniFileSub0
                                                                        If stGameDataMaps(stCemuLogData(1).lngLine).lngDataCount = 0 Then Exit For
                                                                    End If
                                                                End If
                                                            End If
                                                        Next stGameBinDataMaps(stCemuLogData(1).lngLine).lngSize
                                                    Else
                                                        For stGameBinDataMaps(stCemuLogData(1).lngLine).lngSize = stGameBinDataMaps(stCemuLogData(1).lngLine).lngCount To 1 Step -1
                                                            lngGameDataAddresses(stGameBinDataMaps(stCemuLogData(1).lngLine).lngSize) = Converter_SwapEndian32(lngGameDataAddresses(stGameBinDataMaps(stCemuLogData(1).lngLine).lngSize)) + stGameDataMaps(stCemuLogData(1).lngLine).intDataHashOffset
                                                            lngBasicGameDataAddresses(stGameBinDataMaps(stCemuLogData(1).lngLine).lngSize) = Converter_SwapEndian32(lngBasicGameDataAddresses(stGameBinDataMaps(stCemuLogData(1).lngLine).lngSize)) + Botw_MemorySearcherGameDataIniFile
                                                            If ReadProcessMemory(stProcess.dwSize, lngLngMemoryBase + lngGameDataAddresses(stGameBinDataMaps(stCemuLogData(1).lngLine).lngSize), VarPtr(lngGameDataArrayInfos(2)), 4, 0) <> 0 Then
                                                                If Converter_SwapEndian32(lngGameDataArrayInfos(2)) = stGameDataMaps(stCemuLogData(1).lngLine).stGameDatas(stGameDataMaps(stCemuLogData(1).lngLine).lngDataCount).lngHash Then
                                                                    GoSub Botw_MemorySearcherGameDataIniFileSub1
                                                                    stGameDataMaps(stCemuLogData(1).lngLine).lngDataCount = stGameDataMaps(stCemuLogData(1).lngLine).lngDataCount - 1
                                                                    If stGameDataMaps(stCemuLogData(1).lngLine).lngDataCount = 0 Then Exit For
                                                                End If
                                                            End If
                                                        Next stGameBinDataMaps(stCemuLogData(1).lngLine).lngSize
                                                    End If
                                                End If
                                                Erase lngGameDataAddresses
                                            End If
                                            Erase lngBasicGameDataAddresses
                                        End If
                                        Erase stGameDataMaps(stCemuLogData(1).lngLine).stGameDatas
                                    End If
                                    stCemuLogData(1).lngLine = stCemuLogData(1).lngLine - 1
                                Loop Until stCemuLogData(1).lngLine = 0
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
                    stCemuLogData(1).lngLine = BOTW_GAMEDATASCOUNT
                    stProcess.cntUsage = FreeFile
                    Open strCemuFolderPath + "..\..\memorySearcher\" + Left(stCemuLogData(2).objData.Item(0).SubMatches(0), 8) + Mid(stCemuLogData(2).objData.Item(0).SubMatches(0), 10) + ".ini" For Output As stProcess.cntUsage
                    Do
                        If stGameDataMaps(stCemuLogData(1).lngLine).lngDataCount <> 0 Then
                            If stGameBinDataMaps(stCemuLogData(1).lngLine).lngCount <> 0 Then
                                stGameBinDataMaps(stCemuLogData(1).lngLine).lngCount = Converter_SwapEndian32(stGameBinDataMaps(stCemuLogData(1).lngLine).lngCount)
                                Call File_ReadLongDataSegment(stProcess.dwSize, Converter_SwapEndian32(stGameBinDataMaps(stCemuLogData(1).lngLine).lngAddress) - CEMU_DUMP_10000000 + 1, stGameBinDataMaps(stCemuLogData(1).lngLine).lngCount, lngGameDataAddresses)
                                Call File_ReadLongDataSegment(stProcess.cntThreads, Converter_SwapEndian32(stBasicGameBinDataMaps(stCemuLogData(1).lngLine).lngAddress) - CEMU_DUMP_A0000000 + 1, stGameBinDataMaps(stCemuLogData(1).lngLine).lngCount, lngBasicGameDataAddresses)
                                stBasicGameBinDataMaps(stCemuLogData(1).lngLine).lngAddress = Botw_BasicGameDataSize(stGameDataMaps(stCemuLogData(1).lngLine))
                                Botw_MemorySearcherGameDataIniFile = 8 + stBasicGameBinDataMaps(stCemuLogData(1).lngLine).lngAddress
                                If stGameDataMaps(stCemuLogData(1).lngLine).intDataHashOffset < 0 Then
                                    stGameDataMaps(stCemuLogData(1).lngLine).intDataHashOffset = 8 - stGameDataMaps(stCemuLogData(1).lngLine).intDataHashOffset
                                    For stGameBinDataMaps(stCemuLogData(1).lngLine).lngSize = stGameBinDataMaps(stCemuLogData(1).lngLine).lngCount To 1 Step -1
                                        Get stProcess.dwSize, Converter_SwapEndian32(lngGameDataAddresses(stGameBinDataMaps(stCemuLogData(1).lngLine).lngSize)) - CEMU_DUMP_10000000 + 1, lngGameDataArrayInfos
                                        Get stProcess.cntThreads, Converter_SwapEndian32(lngBasicGameDataAddresses(stGameBinDataMaps(stCemuLogData(1).lngLine).lngSize)) - CEMU_DUMP_A0000000 + 1, lngBasicGameDataArrayInfos
                                        lngGameDataArrayInfos(1) = Converter_SwapEndian32(lngGameDataArrayInfos(1))
                                        lngGameDataArrayInfos(4) = Converter_SwapEndian32(lngGameDataArrayInfos(4)) + lngGameDataArrayInfos(1) * stGameDataMaps(stCemuLogData(1).lngLine).intDataHashOffset - 8
                                        lngBasicGameDataArrayInfos(4) = Converter_SwapEndian32(lngBasicGameDataArrayInfos(4)) + lngGameDataArrayInfos(1) * Botw_MemorySearcherGameDataIniFile
                                        Get stProcess.dwSize, lngGameDataArrayInfos(4) - CEMU_DUMP_10000000 + 1, lngGameDataArrayInfos(2)
                                        lngGameDataArrayInfos(2) = Converter_SwapEndian32(lngGameDataArrayInfos(2))
                                        GoSub Botw_MemorySearcherGameDataIniFileSub0
                                        If stGameDataMaps(stCemuLogData(1).lngLine).lngDataCount = 0 Then Exit For
                                    Next stGameBinDataMaps(stCemuLogData(1).lngLine).lngSize
                                Else
                                    For stGameBinDataMaps(stCemuLogData(1).lngLine).lngSize = stGameBinDataMaps(stCemuLogData(1).lngLine).lngCount To 1 Step -1
                                        lngGameDataAddresses(stGameBinDataMaps(stCemuLogData(1).lngLine).lngSize) = Converter_SwapEndian32(lngGameDataAddresses(stGameBinDataMaps(stCemuLogData(1).lngLine).lngSize)) + stGameDataMaps(stCemuLogData(1).lngLine).intDataHashOffset
                                        lngBasicGameDataAddresses(stGameBinDataMaps(stCemuLogData(1).lngLine).lngSize) = Converter_SwapEndian32(lngBasicGameDataAddresses(stGameBinDataMaps(stCemuLogData(1).lngLine).lngSize)) + Botw_MemorySearcherGameDataIniFile
                                        Get stProcess.dwSize, lngGameDataAddresses(stGameBinDataMaps(stCemuLogData(1).lngLine).lngSize) - CEMU_DUMP_10000000 + 1, lngGameDataArrayInfos(2)
                                        If Converter_SwapEndian32(lngGameDataArrayInfos(2)) = stGameDataMaps(stCemuLogData(1).lngLine).stGameDatas(stGameDataMaps(stCemuLogData(1).lngLine).lngDataCount).lngHash Then
                                            GoSub Botw_MemorySearcherGameDataIniFileSub1
                                            stGameDataMaps(stCemuLogData(1).lngLine).lngDataCount = stGameDataMaps(stCemuLogData(1).lngLine).lngDataCount - 1
                                            If stGameDataMaps(stCemuLogData(1).lngLine).lngDataCount = 0 Then Exit For
                                        End If
                                    Next stGameBinDataMaps(stCemuLogData(1).lngLine).lngSize
                                End If
                                Erase lngBasicGameDataAddresses
                                Erase lngGameDataAddresses
                            End If
                            Erase stGameDataMaps(stCemuLogData(1).lngLine).stGameDatas
                        End If
                        stCemuLogData(1).lngLine = stCemuLogData(1).lngLine - 1
                    Loop Until stCemuLogData(1).lngLine = 0
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
    With stGameDataMaps(stCemuLogData(1).lngLine)
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
                    lngBasicGameDataArrayInfos(4) = lngBasicGameDataArrayInfos(4) - stBasicGameBinDataMaps(stCemuLogData(1).lngLine).lngAddress
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
    With stGameDataMaps(stCemuLogData(1).lngLine)
    .stGameDatas(.lngDataCount).strDataName = .stGameDatas(.lngDataCount).strDataName + "," + .stGameDatas(.lngDataCount).strHash + "," + CStr(.stGameDatas(.lngDataCount).lngHash) + ","
    If Left(.strDataType, 3) = "str" Then
        For stProcess.dwFlags = .intDataTypeSize To 8 Step -8
            Call Cemu_WriteMemorySearcherEntry(stProcess.cntUsage, .stGameDatas(.lngDataCount).strDataName + Hex(lngBasicGameDataAddresses(stGameBinDataMaps(stCemuLogData(1).lngLine).lngSize) - stProcess.dwFlags), lngGameDataAddresses(stGameBinDataMaps(stCemuLogData(1).lngLine).lngSize) - stProcess.dwFlags, "int64")
        Next stProcess.dwFlags
    Else
        If .intDataTypeSize > 4 Then
            For stProcess.dwFlags = .intDataTypeSize To 4 Step -4
                Call Cemu_WriteMemorySearcherEntry(stProcess.cntUsage, .stGameDatas(.lngDataCount).strDataName + Hex(lngBasicGameDataAddresses(stGameBinDataMaps(stCemuLogData(1).lngLine).lngSize) - stProcess.dwFlags), lngGameDataAddresses(stGameBinDataMaps(stCemuLogData(1).lngLine).lngSize) - stProcess.dwFlags, .strDataType)
            Next stProcess.dwFlags
        Else
            Call Cemu_WriteMemorySearcherEntry(stProcess.cntUsage, .stGameDatas(.lngDataCount).strDataName + Hex(lngBasicGameDataAddresses(stGameBinDataMaps(stCemuLogData(1).lngLine).lngSize) - stBasicGameBinDataMaps(stCemuLogData(1).lngLine).lngAddress), lngGameDataAddresses(stGameBinDataMaps(stCemuLogData(1).lngLine).lngSize) - .intDataTypeSize, .strDataType)
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
        If lngHash = Hash_CRC32(.Item(i, 1).Text) Then
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
Public Function Botw_GetGamePath(Optional ByRef strCemuFolderPath As String = "") As String
Dim xmlNodes() As Object
Dim lngMatchesCount As Long
    xmlNodes = Cemu_ReadSettingsFromXml("title_id Entry GameCache content", CStr(BOTW_ALZP01_TITLEID), strCemuFolderPath)
    lngMatchesCount = UBound(xmlNodes)
    If lngMatchesCount = 1 Then Botw_GetGamePath = xmlNodes(1).ParentNode.SelectSingleNode("path").Text
    Do Until lngMatchesCount < 1
        Set xmlNodes(lngMatchesCount) = Nothing
        lngMatchesCount = lngMatchesCount - 1
    Loop
    Erase xmlNodes
End Function
Public Function Botw_BuildDropTablesMetadata(ByVal strDropTablesFilePath As String) As Integer
Dim stDropTablesMeta As stDataBlockMetaData
Dim strFilePath As String
Dim intDropTablesFile As Integer
Dim lngCurrentLine As Long
Dim lnglngFileLength As LongLong
    lnglngFileLength = FileLen(strDropTablesFilePath)
    If lnglngFileLength <> 0 Then
        lngCurrentLine = InStrRev(strDropTablesFilePath, "\")
        strFilePath = Mid(strDropTablesFilePath, lngCurrentLine + 1)
        strFilePath = Left(strDropTablesFilePath, lngCurrentLine) + Left(strFilePath, InStr(strFilePath, ".")) + "dropmeta"
        Botw_BuildDropTablesMetadata = FreeFile
        If Dir(strFilePath, vbNormal) = "" Then
            stDropTablesMeta.lngStartLine = 1
            stDropTablesMeta.lngOffset = 1
            Open strFilePath For Binary Access Read Write As Botw_BuildDropTablesMetadata
            intDropTablesFile = FreeFile
            Open strDropTablesFilePath For Input As intDropTablesFile
            Do Until EOF(intDropTablesFile)
                lngCurrentLine = lngCurrentLine + 1
                Line Input #intDropTablesFile, strDropTablesFilePath
                stDropTablesMeta.lngMaxLineLength = InStr(strDropTablesFilePath, ": !obj")
                If stDropTablesMeta.lngMaxLineLength <> 0 Then
                    Put Botw_BuildDropTablesMetadata, , stDropTablesMeta
                    GoSub Botw_BuildDropTablesMetadataSub0
                    stDropTablesMeta.lnglngHash = Converter_CULng(Hash_CRC32(LTrim(Left(strDropTablesFilePath, stDropTablesMeta.lngMaxLineLength - 1))))
                Else
                    stDropTablesMeta.lngLinesCount = stDropTablesMeta.lngLinesCount + 1
                End If
            Loop
            stDropTablesMeta.lngLinesCount = stDropTablesMeta.lngLinesCount - 1
            Put Botw_BuildDropTablesMetadata, , stDropTablesMeta
            GoSub Botw_BuildDropTablesMetadataSub0
            stDropTablesMeta.lnglngHash = lnglngFileLength
            Put Botw_BuildDropTablesMetadata, , stDropTablesMeta
            lngCurrentLine = (Seek(Botw_BuildDropTablesMetadata) - 1) / BOTW_DATABLOCKMETADATASIZE - 2
            Put Botw_BuildDropTablesMetadata, 1, -lngCurrentLine
            lngCurrentLine = Seek(intDropTablesFile) - stDropTablesMeta.lngOffset
            Put Botw_BuildDropTablesMetadata, , lngCurrentLine
            Close intDropTablesFile
        Else
            Open strFilePath For Binary Access Read As Botw_BuildDropTablesMetadata
            Get Botw_BuildDropTablesMetadata, 1, lngCurrentLine
            Get Botw_BuildDropTablesMetadata, (lngCurrentLine + 1) * BOTW_DATABLOCKMETADATASIZE + BOTW_DATABLOCK_HASHID_OFFSET + 1, stDropTablesMeta.lnglngHash
            If stDropTablesMeta.lnglngHash <> lnglngFileLength Then
                Close Botw_BuildDropTablesMetadata
                Kill strFilePath
                Botw_BuildDropTablesMetadata = Botw_BuildDropTablesMetadata(strDropTablesFilePath)
            End If
        End If
    End If
    Exit Function
Botw_BuildDropTablesMetadataSub0:
    stDropTablesMeta.lngOffset = Seek(intDropTablesFile) - Len(strDropTablesFilePath) - 2
    stDropTablesMeta.lngLinesCount = 1
    stDropTablesMeta.lngStartLine = lngCurrentLine
    Return
End Function
Public Function Botw_BuildMapUnitMetadata(ByVal strMapUnitFilePath As String) As Integer
Dim stMapUnitMeta As stDataBlockMetaData
Dim strFilePath As String
Dim intMapUnitFile As Integer
Dim lngCurrentLine As Long
Dim lnglngFileLength As LongLong
    lnglngFileLength = FileLen(strMapUnitFilePath)
    If lnglngFileLength <> 0 Then
        lngCurrentLine = InStrRev(strMapUnitFilePath, "\")
        strFilePath = Mid(strMapUnitFilePath, lngCurrentLine + 1)
        strFilePath = Left(strMapUnitFilePath, lngCurrentLine) + Left(strFilePath, InStr(strFilePath, ".")) + "meta"
        Botw_BuildMapUnitMetadata = FreeFile
        If Dir(strFilePath, vbNormal) = "" Then
            FILE_DoShellOperation SHELL_DELETE_OPERATION, Left(strFilePath, Len(strFilePath) - 5)
            stMapUnitMeta.lngStartLine = 1
            stMapUnitMeta.lngOffset = 1
            Open strFilePath For Binary Access Read Write As Botw_BuildMapUnitMetadata
            intMapUnitFile = FreeFile
            Open strMapUnitFilePath For Input As intMapUnitFile
            Do Until EOF(intMapUnitFile)
                lngCurrentLine = lngCurrentLine + 1
                Line Input #intMapUnitFile, strMapUnitFilePath
                Select Case Left(strMapUnitFilePath, 1)
                Case "-"
                    Put Botw_BuildMapUnitMetadata, , stMapUnitMeta
                    GoSub Botw_BuildMapUnitMetadataSub0
                    If Mid(strMapUnitFilePath, 3, 7) = "HashId:" Then
                        stMapUnitMeta.lnglngHash = Converter_CULng(CLng("&H" + Right(strMapUnitFilePath, 8)))
                    Else
                        stMapUnitMeta.lnglngHash = 0
                    End If
                Case " "
                    stMapUnitMeta.lngLinesCount = stMapUnitMeta.lngLinesCount + 1
                    If stMapUnitMeta.lnglngHash = 0 Then
                        If Mid(strMapUnitFilePath, 3, 7) = "HashId:" Then stMapUnitMeta.lnglngHash = Converter_CULng(CLng("&H" + Right(strMapUnitFilePath, 8)))
                    End If
                Case "R"
                    Put Botw_BuildMapUnitMetadata, , stMapUnitMeta
                    GoSub Botw_BuildMapUnitMetadataSub0
                    Do Until EOF(intMapUnitFile)
                        Line Input #intMapUnitFile, strMapUnitFilePath
                        stMapUnitMeta.lngLinesCount = stMapUnitMeta.lngLinesCount + 1
                    Loop
                    stMapUnitMeta.lnglngHash = lnglngFileLength
                    Put Botw_BuildMapUnitMetadata, , stMapUnitMeta
                Case Else
                    stMapUnitMeta.lngLinesCount = stMapUnitMeta.lngLinesCount + 1
                End Select
            Loop
            lngCurrentLine = (Seek(Botw_BuildMapUnitMetadata) - 1) / BOTW_DATABLOCKMETADATASIZE - 2
            Put Botw_BuildMapUnitMetadata, 1, lngCurrentLine
            lngCurrentLine = Seek(intMapUnitFile) - stMapUnitMeta.lngOffset
            Put Botw_BuildMapUnitMetadata, , lngCurrentLine
            Close intMapUnitFile
        Else
            Open strFilePath For Binary Access Read As Botw_BuildMapUnitMetadata
            Get Botw_BuildMapUnitMetadata, 1, lngCurrentLine
            Get Botw_BuildMapUnitMetadata, (lngCurrentLine + 1) * BOTW_DATABLOCKMETADATASIZE + BOTW_DATABLOCK_HASHID_OFFSET + 1, stMapUnitMeta.lnglngHash
            If stMapUnitMeta.lnglngHash <> lnglngFileLength Then
                Close Botw_BuildMapUnitMetadata
                Kill strFilePath
                Botw_BuildMapUnitMetadata = Botw_BuildMapUnitMetadata(strMapUnitFilePath)
            End If
        End If
    End If
    Exit Function
Botw_BuildMapUnitMetadataSub0:
    stMapUnitMeta.lngOffset = Seek(intMapUnitFile) - Len(strMapUnitFilePath) - 2
    stMapUnitMeta.lngLinesCount = 1
    stMapUnitMeta.lngStartLine = lngCurrentLine
    Return
End Function
Public Function Botw_BuildActorInfoMetaData(ByVal strActorInfoFilePath As String) As Integer
Dim stActorInfoMeta As stDataBlockMetaData
Dim strFilePath As String
Dim intActorInfoFile As Integer
Dim objRegExp As Object
Dim objMatchCollection As Object
Dim lngCurrentLine As Long
Dim lnglngFileLength As LongLong
    lnglngFileLength = FileLen(strActorInfoFilePath)
    If lnglngFileLength <> 0 Then
        strFilePath = Left(strActorInfoFilePath, InStrRev(strActorInfoFilePath, "\")) + "ActorInfo.meta"
        Botw_BuildActorInfoMetaData = FreeFile
        If Dir(strFilePath, vbNormal) = "" Then
            FILE_DoShellOperation SHELL_DELETE_OPERATION, Left(strFilePath, Len(strFilePath) - 5)
            stActorInfoMeta.lngStartLine = 1
            stActorInfoMeta.lngOffset = 1
            Open strFilePath For Binary Access Read Write As Botw_BuildActorInfoMetaData
            intActorInfoFile = FreeFile
            Open strActorInfoFilePath For Input As intActorInfoFile
            Set objRegExp = CreateObject("VBScript.RegExp")
            objRegExp.Pattern = " name:[ ]*([^ ,]*)"
            Do Until EOF(intActorInfoFile)
                lngCurrentLine = lngCurrentLine + 1
                Line Input #intActorInfoFile, strActorInfoFilePath
                Select Case Left(strActorInfoFilePath, 1)
                Case "-"
                    Put Botw_BuildActorInfoMetaData, , stActorInfoMeta
                    GoSub Botw_BuildActorInfoMetaDataSub0
                    Set objMatchCollection = objRegExp.Execute(strActorInfoFilePath)
                    If objMatchCollection.Count = 1 Then
                        stActorInfoMeta.lnglngHash = Converter_CULng(Hash_CRC32(objMatchCollection.Item(0).SubMatches(0)))
                    Else
                        stActorInfoMeta.lnglngHash = 0
                    End If
                    Set objMatchCollection = Nothing
                Case " "
                    stActorInfoMeta.lngLinesCount = stActorInfoMeta.lngLinesCount + 1
                    If stActorInfoMeta.lnglngHash = 0 Then
                        Set objMatchCollection = objRegExp.Execute(strActorInfoFilePath)
                        If objMatchCollection.Count = 1 Then stActorInfoMeta.lnglngHash = Converter_CULng(Hash_CRC32(objMatchCollection.Item(0).SubMatches(0)))
                        Set objMatchCollection = Nothing
                    End If
                Case "H"
                    Put Botw_BuildActorInfoMetaData, , stActorInfoMeta
                    GoSub Botw_BuildActorInfoMetaDataSub0
                    Do Until EOF(intActorInfoFile)
                        Line Input #intActorInfoFile, strActorInfoFilePath
                        stActorInfoMeta.lngLinesCount = stActorInfoMeta.lngLinesCount + 1
                    Loop
                    stActorInfoMeta.lnglngHash = lnglngFileLength
                    Put Botw_BuildActorInfoMetaData, , stActorInfoMeta
                Case Else
                    stActorInfoMeta.lngLinesCount = stActorInfoMeta.lngLinesCount + 1
                End Select
            Loop
            Set objRegExp = Nothing
            lngCurrentLine = (Seek(Botw_BuildActorInfoMetaData) - 1) / BOTW_DATABLOCKMETADATASIZE - 2
            Put Botw_BuildActorInfoMetaData, 1, lngCurrentLine
            lngCurrentLine = Seek(intActorInfoFile) - stActorInfoMeta.lngOffset
            Put Botw_BuildActorInfoMetaData, , lngCurrentLine
            Close intActorInfoFile
        Else
            Open strFilePath For Binary Access Read As Botw_BuildActorInfoMetaData
            Get Botw_BuildActorInfoMetaData, 1, lngCurrentLine
            Get Botw_BuildActorInfoMetaData, (lngCurrentLine + 1) * BOTW_DATABLOCKMETADATASIZE + BOTW_DATABLOCK_HASHID_OFFSET + 1, stActorInfoMeta.lnglngHash
            If stActorInfoMeta.lnglngHash <> lnglngFileLength Then
                Close Botw_BuildActorInfoMetaData
                Kill strFilePath
                Botw_BuildActorInfoMetaData = Botw_BuildActorInfoMetaData(strActorInfoFilePath)
            End If
        End If
    End If
    Exit Function
Botw_BuildActorInfoMetaDataSub0:
    stActorInfoMeta.lngOffset = Seek(intActorInfoFile) - Len(strActorInfoFilePath) - 2
    stActorInfoMeta.lngLinesCount = 1
    stActorInfoMeta.lngStartLine = lngCurrentLine
    Return
End Function
Private Function Botw_SearchDataBlockMetaDataIndex(ByRef lnglngHash As LongLong, ByVal intMetaDataFile As Integer) As Long
Dim lngMetadataOffset As Long
Dim lnglngExistingHash As LongLong
Dim lngLbound As Long
Dim lngUbound As Long
    lngMetadataOffset = BOTW_DATABLOCK_HASHID_OFFSET + 1
    Get intMetaDataFile, 1, lngUbound
    If lngUbound < 0 Then
        Botw_SearchDataBlockMetaDataIndex = -lngUbound
        lngMetadataOffset = Botw_SearchDataBlockMetaDataIndex * BOTW_DATABLOCKMETADATASIZE + lngMetadataOffset
        Do
            Get intMetaDataFile, lngMetadataOffset, lnglngExistingHash
            If lnglngExistingHash = lnglngHash Then Exit Do
            lngMetadataOffset = lngMetadataOffset - BOTW_DATABLOCKMETADATASIZE
            Botw_SearchDataBlockMetaDataIndex = Botw_SearchDataBlockMetaDataIndex - 1
        Loop Until Botw_SearchDataBlockMetaDataIndex = 0
    Else
        Get intMetaDataFile, BOTW_DATABLOCKMETADATASIZE + lngMetadataOffset, lnglngExistingHash
        If lnglngHash > lnglngExistingHash Then
            Get intMetaDataFile, lngUbound * BOTW_DATABLOCKMETADATASIZE + lngMetadataOffset, lnglngExistingHash
            If lnglngHash < lnglngExistingHash Then
                lngLbound = 1
                Do
                    Botw_SearchDataBlockMetaDataIndex = (lngUbound + lngLbound) \ 2
                    Get intMetaDataFile, Botw_SearchDataBlockMetaDataIndex * BOTW_DATABLOCKMETADATASIZE + lngMetadataOffset, lnglngExistingHash
                    If lnglngHash > lnglngExistingHash Then
                        lngLbound = Botw_SearchDataBlockMetaDataIndex
                    ElseIf lnglngHash < lnglngExistingHash Then
                        lngUbound = Botw_SearchDataBlockMetaDataIndex
                    ElseIf lnglngHash = lnglngExistingHash Then
                        Exit Function
                    End If
                Loop Until lngUbound - lngLbound < 2
                If lnglngHash > lnglngExistingHash Then Botw_SearchDataBlockMetaDataIndex = Botw_SearchDataBlockMetaDataIndex + 1
            Else
                If lnglngHash = lnglngExistingHash Then
                    Botw_SearchDataBlockMetaDataIndex = lngUbound
                Else
                    Botw_SearchDataBlockMetaDataIndex = lngUbound + 1
                End If
            End If
        Else
            If lnglngHash = lnglngExistingHash Then
                Botw_SearchDataBlockMetaDataIndex = 1
            Else
                Botw_SearchDataBlockMetaDataIndex = 0
            End If
        End If
    End If
End Function
Public Function Botw_GetActorInfoMetaDataIndex(ByRef strActorName As String, ByRef strActorInfoFilePath As String) As Long
'Usage example with the immediate window: ?Botw_GetActorInfoMetaDataIndex("PutRupee", "E:\Users\dragbe\Desktop\Temp\ActorInfo.product.yml")
Dim intActorInfoMetaDataFile As Integer
    intActorInfoMetaDataFile = Botw_BuildActorInfoMetaData(strActorInfoFilePath)
    Botw_GetActorInfoMetaDataIndex = Botw_SearchDataBlockMetaDataIndex(Converter_CULng(Hash_CRC32(strActorName)), intActorInfoMetaDataFile)
    Close intActorInfoMetaDataFile
End Function
Private Function Botw_ReadDataBlockTextContent(ByVal intDataFile As Integer, ByVal intMetaDataFile As Integer, ByVal lngDataBlockIndex As Long) As String
Dim lngMetadataEndOffset As Long
    Get intMetaDataFile, 1, lngMetadataEndOffset
    lngMetadataEndOffset = Abs(lngMetadataEndOffset)
    If lngDataBlockIndex > lngMetadataEndOffset Then
        Get intMetaDataFile, 5, lngDataBlockIndex
        If lngDataBlockIndex > 0 Then
            Botw_ReadDataBlockTextContent = Space(lngDataBlockIndex)
            Get intMetaDataFile, (lngMetadataEndOffset + 1) * BOTW_DATABLOCKMETADATASIZE + BOTW_DATABLOCK_OFFSET_OFFSET + 1, lngDataBlockIndex
        End If
    Else
        lngMetadataEndOffset = lngDataBlockIndex * BOTW_DATABLOCKMETADATASIZE + BOTW_DATABLOCK_OFFSET_OFFSET + 1
        Get intMetaDataFile, lngMetadataEndOffset, lngDataBlockIndex
        Get intMetaDataFile, lngMetadataEndOffset + BOTW_DATABLOCKMETADATASIZE, lngMetadataEndOffset
        Botw_ReadDataBlockTextContent = Space(lngMetadataEndOffset - lngDataBlockIndex - 2)
    End If
    Get intDataFile, lngDataBlockIndex, Botw_ReadDataBlockTextContent
End Function
Private Function Botw_ExtractDataBlockTextContent(ByRef lnglngHash As LongLong, ByVal intMetaDataFile As Integer, ByVal intDataFile As Integer, Optional ByVal intOutputMode As Integer = 0, Optional ByRef lngDataBlockIndex As Long = -1, Optional ByVal strCacheFolder As String = "") As String
Dim lngMetadataEndOffset As Long
Dim lngMetadataStartOffset As Long
Dim strDataBlockIndex As String
    If strCacheFolder = "" Then
        If lngDataBlockIndex = -1 Then
            lngMetadataEndOffset = Botw_SearchDataBlockMetaDataIndex(lnglngHash, intMetaDataFile) * BOTW_DATABLOCKMETADATASIZE + BOTW_DATABLOCK_OFFSET_OFFSET + 1
        Else
            lngDataBlockIndex = Botw_SearchDataBlockMetaDataIndex(lnglngHash, intMetaDataFile)
            lngMetadataEndOffset = lngDataBlockIndex * BOTW_DATABLOCKMETADATASIZE + BOTW_DATABLOCK_OFFSET_OFFSET + 1
        End If
        Get intMetaDataFile, lngMetadataEndOffset, lngMetadataStartOffset
        Get intMetaDataFile, lngMetadataEndOffset + BOTW_DATABLOCKMETADATASIZE, lngMetadataEndOffset
        Select Case intOutputMode
        Case 1
            Botw_ExtractDataBlockTextContent = File_GetTempFilePath
            intOutputMode = FreeFile
            Open Botw_ExtractDataBlockTextContent For Binary Access Write As intOutputMode
            Call File_CopyBytes(intOutputMode, intDataFile, lngMetadataStartOffset, lngMetadataEndOffset - lngMetadataStartOffset - 2)
            Close intOutputMode
        Case Else
            Botw_ExtractDataBlockTextContent = Space(lngMetadataEndOffset - lngMetadataStartOffset - 2)
            Get intDataFile, lngMetadataStartOffset, Botw_ExtractDataBlockTextContent
        End Select
    Else
        Botw_ExtractDataBlockTextContent = strCacheFolder + Hex(lnglngHash)
        If Dir(Botw_ExtractDataBlockTextContent) = "" Then
            MakeSureDirectoryPathExists strCacheFolder
            lngMetadataStartOffset = FreeFile
            Open Botw_ExtractDataBlockTextContent For Output As lngMetadataStartOffset
            Botw_ExtractDataBlockTextContent = Botw_ExtractDataBlockTextContent(lnglngHash, intMetaDataFile, intDataFile, intOutputMode, lngMetadataEndOffset)
            strDataBlockIndex = CStr(lngMetadataEndOffset)
            Print #lngMetadataStartOffset, strDataBlockIndex
            Close lngMetadataStartOffset
            Select Case intOutputMode
            Case 1
                FILE_DoShellOperation SHELL_COPY_OPERATION, Botw_ExtractDataBlockTextContent, strCacheFolder + strDataBlockIndex
            Case Else
                Call File_WriteTextContent(strCacheFolder + strDataBlockIndex, Botw_ExtractDataBlockTextContent)
            End Select
        Else
            intDataFile = FreeFile
            Open Botw_ExtractDataBlockTextContent For Input As intDataFile
            Line Input #intDataFile, Botw_ExtractDataBlockTextContent
            lngMetadataEndOffset = CLng(Botw_ExtractDataBlockTextContent)
            Close intDataFile
            Select Case intOutputMode
            Case 1
                strCacheFolder = strCacheFolder + Botw_ExtractDataBlockTextContent
                Botw_ExtractDataBlockTextContent = File_GetTempFilePath
                FILE_DoShellOperation SHELL_COPY_OPERATION, strCacheFolder, Botw_ExtractDataBlockTextContent
            Case Else
                Botw_ExtractDataBlockTextContent = File_GetTextContent(strCacheFolder + Botw_ExtractDataBlockTextContent)
            End Select
        End If
        If lngDataBlockIndex <> -1 Then lngDataBlockIndex = lngMetadataEndOffset
    End If
End Function
Private Function Botw_GetDataBlockTextContents(ByRef strDataFilePath As String, ByRef intMetaDataFile As Integer, ByVal intOutputMode As Integer, ParamArray varActorNames() As Variant) As String()
'Auto close the metaData file on exit function
Dim varout() As String
Dim lngUbound As Long
Dim intDataFile As Integer
    lngUbound = UBound(varActorNames)
    ReDim varout(0 To lngUbound)
    intDataFile = InStrRev(strDataFilePath, "\")
    varout(0) = Mid(strDataFilePath, intDataFile + 1)
    varout(0) = Left(strDataFilePath, intDataFile) + Left(varout(0), InStr(varout(0), ".") - 1) + "\"
    intDataFile = FreeFile
    Open strDataFilePath For Binary Access Read As intDataFile
    Do
        varout(lngUbound) = Botw_ExtractDataBlockTextContent(Converter_CULng(Hash_CRC32(CStr(varActorNames(lngUbound)))), intMetaDataFile, intDataFile, intOutputMode, , varout(0))
        lngUbound = lngUbound - 1
    Loop Until lngUbound < 0
    Close intDataFile
    Close intMetaDataFile
    Botw_GetDataBlockTextContents = varout
End Function
Public Function Botw_GetDataBlockTextContent(ByRef lnglngHash As LongLong, ByVal intMetaDataFile As Integer, ByRef strDataFilePath As String, Optional ByVal intOutputMode As Integer = 0) As String
Dim intDataFile As Integer
    intDataFile = FreeFile
    Open strDataFilePath For Binary Access Read As intDataFile
    Botw_GetDataBlockTextContent = Botw_ExtractDataBlockTextContent(lnglngHash, intMetaDataFile, intDataFile, intOutputMode)
    Close intDataFile
End Function
Public Function Botw_GetActorInfoData(ByRef strActorName As String, ByRef strActorInfoFilePath As String, Optional ByVal intOutputMode As Integer = 0) As String
'Usage example with the immediate window: ?Botw_GetActorInfoData("PutRupee", "E:\Users\dragbe\Desktop\Temp\ActorInfo.product.yml")
Dim intMetaDataFile As Integer
    intMetaDataFile = Botw_BuildActorInfoMetaData(strActorInfoFilePath)
    Botw_GetActorInfoData = Botw_GetDataBlockTextContent(Converter_CULng(Hash_CRC32(strActorName)), intMetaDataFile, strActorInfoFilePath, intOutputMode)
    Close intMetaDataFile
End Function
Public Function Botw_GetDropTableData(ByRef strDropTableName As String, ByRef strDropTablesFilePath As String, Optional ByVal intOutputMode As Integer = 0) As String
'Usage example with the immediate window: ?Botw_GetDropTableData("Normal", "E:\Users\dragbe\Desktop\Temp\lockedchests10hyre\content\Actor\Pack\Enemy_Bokoblin_Bone_Junior_Head\Actor\DropTable\Bokoblin_Bone_Junior.bdrop.xml")
Dim intMetaDataFile As Integer
    intMetaDataFile = Botw_BuildDropTablesMetadata(strDropTablesFilePath)
    Botw_GetDropTableData = Botw_GetDataBlockTextContent(Converter_CULng(Hash_CRC32(strDropTableName)), intMetaDataFile, strDropTablesFilePath, intOutputMode)
    Close intMetaDataFile
End Function
Private Function Botw_WriteModdedMapTBoxObjectContent(ByVal intMapFile As Integer, ByVal intMapMetaDataFile As Integer, ByVal strHashId As String, ByRef strDropActorName As String, ByVal strCacheFolder As String, Optional ByRef lngDataBlockIndex As Long = -1) As String
Dim lngOffset As Long
Dim lnglngHashId As LongLong
    lnglngHashId = Converter_CULng(CLng("&H" + strHashId))
    strHashId = strCacheFolder + Hex(lnglngHashId)
    If Dir(strHashId) = "" Then
        MakeSureDirectoryPathExists strCacheFolder
        strCacheFolder = Botw_ExtractDataBlockTextContent(lnglngHashId, intMapMetaDataFile, intMapFile, 1, lngOffset, strCacheFolder)
        If lngDataBlockIndex <> -1 Then lngDataBlockIndex = lngOffset
        intMapFile = FreeFile
        Open strHashId For Output As intMapFile
        Print #intMapFile, CStr(lngOffset)
        Close intMapFile
    Else
        intMapFile = FreeFile
        Open strHashId For Input As intMapFile
        Line Input #intMapFile, strHashId
        Close intMapFile
        strCacheFolder = strCacheFolder + strHashId
        If lngDataBlockIndex <> -1 Then lngDataBlockIndex = CLng(strHashId)
    End If
    intMapFile = FreeFile
    Open strCacheFolder For Input As intMapFile
    intMapMetaDataFile = FreeFile
    Botw_WriteModdedMapTBoxObjectContent = File_GetTempFilePath
    Open Botw_WriteModdedMapTBoxObjectContent For Output As intMapMetaDataFile
    Do Until EOF(intMapFile)
        Line Input #intMapFile, strHashId
        lngOffset = InStr(strHashId, "DropActor:")
        If lngOffset = 0 Then
            Print #intMapMetaDataFile, strHashId
        Else
            Print #intMapMetaDataFile, Left(strHashId, lngOffset + 9) + " " + strDropActorName;
            strHashId = Mid(strHashId, lngOffset + 10)
            lngOffset = InStr(strHashId, ",")
            If lngOffset = 0 Then
                Print #intMapMetaDataFile, vbCrLf;
            Else
                Print #intMapMetaDataFile, Mid(strHashId, lngOffset)
            End If
            Do Until EOF(intMapFile)
                Line Input #intMapFile, strHashId
                Print #intMapMetaDataFile, strHashId
            Loop
        End If
    Loop
    Close intMapMetaDataFile
    Close intMapFile
End Function
Public Function Botw_Material2Rupee(ByRef xlsFakeRupeeSettings As Range, ByRef xlsFakeRupeeActorDataBuildSettings As Range, Optional ByVal strCemuFolderPath As String = "") As String
'Usage example with the immediate window: ?Botw_Material2Rupee(worksheets("FakeRupee").range("D2:J2").cells,worksheets("FakeRupee").range("A2:B5").cells)
Dim strFilePath As String
Dim strTemp As String
Dim strTmp As String
Dim strTempPath As String
Dim strActorPackPath As String
Dim intFreefile As Integer
Dim intOutFile As Integer
Dim strDropTables() As String
Dim strSrcPath As String
Dim strTokens() As String
Dim strMaterialActorLinkFilePath As String
Dim strCachePath As String
Dim i As Long
Dim j As Long
Dim k As Long
Dim m As Long
Dim lngStartOffset As Long
Dim lngDataBlockIndex As Long
Dim objDict As Object
Dim varDictKey As Variant
Dim objRegExp As Object
Dim objMatchCollection As Object
Dim strGamePath As String
Dim strSrcRootPath As String
Dim strDestRootPath As String
Dim strBoolDataPath As String
Dim strDlcFolderPath As String
Dim lnglngHash As LongLong
Dim lnglngUHash As LongLong
Dim lngCompareData() As Long
Dim lngPreviousStartOffset As Long
Dim objDropTableDict As Object
    strCachePath = Left(ThisWorkbook.FullName, InStrRev(ThisWorkbook.FullName, ".") - 1) + "\"
    With xlsFakeRupeeSettings
    'strCemuFolderPath: BOTW mlc and dlc folders path, Botw_Material2Rupee: Fake Rupee mod folder path
    strDlcFolderPath = Cemu_GetDlcPath(strCemuFolderPath)
    strFilePath = Mid(.Item(1, 1).Text, 4)
    Botw_Material2Rupee = ThisWorkbook.Path + "\graphicPacks\" + strFilePath + "\BreathOfTheWild_" + strFilePath + "\"
    FILE_DoShellOperation SHELL_DELETE_OPERATION, Botw_Material2Rupee
    MakeSureDirectoryPathExists Botw_Material2Rupee + "logs\"
    strGamePath = Botw_GetGamePath(strCemuFolderPath)
    strGamePath = Left(strGamePath, Len(strGamePath) - 15)
    strTmp = Cemu_GetTitleId(strCemuFolderPath)
    strCemuFolderPath = Cemu_GetMlc01Path(strCemuFolderPath) + "\usr\title\" + Left(strTmp, 8) + "\" + Mid(strTmp, 10) + "\"
    'Build the Fake Rupee directory structure from the PutRupee sbactorpack
    strActorPackPath = Botw_Material2Rupee + "content\Actor\Pack\"
    strTmp = strCemuFolderPath + "content\Actor\Pack\"
    strMaterialActorLinkFilePath = strActorPackPath + .Item(1, 1).Text
    strTempPath = strCachePath + "content\Actor\Pack\"
    strBoolDataPath = strTempPath + .Worksheet.name
    If FILE_DoShellOperation(SHELL_COPY_OPERATION, strBoolDataPath, strMaterialActorLinkFilePath) <> 0 Then
        System_ShellAndWait 0, 1, "SARC extract """ + strTmp + "PutRupee.sbactorpack"" -C """ + strMaterialActorLinkFilePath + """"
        Call File_DeleteFileSystemObjects(strMaterialActorLinkFilePath + "\Actor\AS", strMaterialActorLinkFilePath + "\Actor\ASList", strMaterialActorLinkFilePath + "\Actor\ModelList\Item_Put_Rupee_Green.bmodellist", strMaterialActorLinkFilePath + "\Actor\Physics\Rupee.bphysics")
        FILE_DoShellOperation SHELL_COPY_OPERATION, strMaterialActorLinkFilePath, strBoolDataPath
    End If
    'Extract some required data files from the Fake Rupee material sbactorpack
    strBoolDataPath = strTempPath + .Item(1, 4).Text
    strTemp = strActorPackPath + .Item(1, 4).Text
    strSrcPath = strTemp + "\Actor\ActorLink\" + .Item(1, 4).Text + ".bxml"
    strMaterialActorLinkFilePath = strSrcPath + ".xml"
    If FILE_DoShellOperation(SHELL_COPY_OPERATION, strBoolDataPath, strTemp) <> 0 Then
        System_ShellAndWait 0, 1, "AAMP_TO_YML """ + strSrcPath + """ """ + strMaterialActorLinkFilePath + """", "SARC extract """ + strTmp + .Item(1, 4).Text + ".sbactorpack"" -C """ + strTemp + """"
        Kill strSrcPath
        strSrcPath = strTemp + "\Actor\"
        Call File_DeleteFileSystemObjects(strSrcPath + "AIProgram", strSrcPath + "AS", strSrcPath + "ASList", strSrcPath + "AttClient", strSrcPath + "AttClientList", strSrcPath + "Chemical")
        FILE_DoShellOperation SHELL_COPY_OPERATION, strTemp, strBoolDataPath
    End If
    'Prepare the drop tables data
    strDropTables = Split(.Item(1, 5).Text, vbLf)
    For i = UBound(strDropTables) To 0 Step -1
        strBoolDataPath = strTempPath + strDropTables(i) + "\Actor\DropTable\"
        strFilePath = strActorPackPath + strDropTables(i)
        strTemp = strFilePath + "\Actor\DropTable\"
        If FILE_DoShellOperation(SHELL_COPY_OPERATION, strBoolDataPath, strTemp) <> 0 Then
            System_ShellAndWait 0, 1, "SARC extract """ + strTmp + strDropTables(i) + ".sbactorpack"" -C """ + strFilePath + """"
            strDropTables(i) = Dir(strTemp + "*.bdrop")
            strSrcPath = strTemp + strDropTables(i)
            strFilePath = strSrcPath + ".xml"
            System_ShellAndWait 0, 1, "AAMP_TO_YML """ + strSrcPath + """ """ + strFilePath + """"
            Kill strSrcPath
            FILE_DoShellOperation SHELL_COPY_OPERATION, strFilePath, strBoolDataPath + strDropTables(i) + ".xml"
        End If
    Next i
    Erase strDropTables
    'Extract bool_data_X.bgdata revival_bool_data_X.bgdata from Bootup.pack and gamedata.ssarc files
    strTmp = Botw_Material2Rupee + "content\Pack\"
    strDestRootPath = strTmp + "Bootup\GameData\gamedata\"
    strBoolDataPath = strDestRootPath + "bool_data_0.bgdata"
    strSrcPath = strBoolDataPath + ".yml"
    strSrcRootPath = strCachePath + "content\Pack\Bootup\GameData\gamedata\"
    strTempPath = strSrcRootPath + "bool_data_0.bgdata.yml"
    If FILE_DoShellOperation(SHELL_COPY_OPERATION, strTempPath, strSrcPath) = 0 Then
        For i = 1 To 2
            strTemp = CStr(i)
            System_ShellAndWait 0, 1, "YML_TO_BYML """ + strSrcRootPath + "bool_data_" + strTemp + ".bgdata.yml"" """ + strDestRootPath + "bool_data_" + strTemp + ".bgdata"" -b"
        Next i
        For i = 0 To 7
            strTemp = CStr(i)
            System_ShellAndWait 0, 1, "YML_TO_BYML """ + strSrcRootPath + "revival_bool_data_" + strTemp + ".bgdata.yml"" """ + strDestRootPath + "revival_bool_data_" + strTemp + ".bgdata"" -b"
        Next i
    Else
        strFilePath = strTmp + "Bootup"
        strTemp = strFilePath + "\GameData\gamedata.ssarc"
        System_ShellAndWait 0, 1, "BYML_TO_YML """ + strBoolDataPath + """ """ + strSrcPath + """", "SARC extract """ + strTemp + """", "SARC extract """ + strCemuFolderPath + "content\Pack\Bootup.pack"" -C """ + strFilePath + """"
        Call File_DeleteFileSystemObjects(strTemp, strBoolDataPath)
        FILE_DoShellOperation SHELL_COPY_OPERATION, strSrcPath, strTempPath
        For i = 1 To 2
            strTemp = CStr(i)
            System_ShellAndWait 0, 1, "BYML_TO_YML """ + strDestRootPath + "bool_data_" + strTemp + ".bgdata"" """ + strSrcRootPath + "bool_data_" + strTemp + ".bgdata.yml"""
        Next i
        For i = 0 To 7
            strTemp = CStr(i)
            System_ShellAndWait 0, 1, "BYML_TO_YML """ + strDestRootPath + "revival_bool_data_" + strTemp + ".bgdata"" """ + strSrcRootPath + "revival_bool_data_" + strTemp + ".bgdata.yml"""
        Next i
    End If
    'Prepare the Fake Rupee icon from its material sbitemico file
    FILE_DoShellOperation SHELL_COPY_OPERATION, strCemuFolderPath + "content\UI\StockItem\" + .Item(1, 4).Text + ".sbitemico", Botw_Material2Rupee + "content\UI\StockItem\" + .Item(1, 1).Text + ".sbitemico"
    'Convert ActorInfo.product.sbyml
    strFilePath = strCachePath + "content\Actor\ActorInfo.product.sbyml"
    strSrcPath = strFilePath + ".yml"
    If Dir(strSrcPath) = "" Then System_ShellAndWait 0, 1, "BYML_TO_YML """ + strCemuFolderPath + "content\Actor\ActorInfo.product.sbyml"" """ + strSrcPath + """"
    strFilePath = Botw_Material2Rupee + "content\Actor\ActorInfo.product.sbyml"
    strTokens = Split(.Item(1, 7).Text, vbLf)
    If strTokens(2) = "bfres @1@" Then
        'Prepare the Fake Rupee model from their material model files
        strTempPath = "content\Model\" + .Item(1, 4).Text
        strDestRootPath = strGamePath + strTempPath
        strTempPath = strCemuFolderPath + strTempPath
        strTmp = Botw_Material2Rupee + "content\Model\"
        strTemp = strTmp + .Item(1, 1).Text
        MakeSureDirectoryPathExists strTmp
        If CopyFile(strTempPath + ".sbfres", strTemp + ".sbfres", 0) = 0 Then CopyFile strDestRootPath + ".sbfres", strTemp + ".sbfres", 0
        If CopyFile(strTempPath + ".Tex1.sbfres", strTemp + ".Tex1.sbfres", 0) = 0 Then CopyFile strDestRootPath + ".Tex1.sbfres", strTemp + ".Tex1.sbfres", 0
        If CopyFile(strTempPath + ".Tex2.sbfres", strTemp + ".Tex2.sbfres", 0) = 0 Then CopyFile strDestRootPath + ".Tex2.sbfres", strTemp + ".Tex2.sbfres", 0
    End If
    strSrcRootPath = strCachePath + .Item(1, 1).Text + "\"
    FILE_DoShellOperation SHELL_COPY_OPERATION, strSrcRootPath + "content", Botw_Material2Rupee
    FILE_DoShellOperation SHELL_COPY_OPERATION, strSrcRootPath + "rules.txt", Botw_Material2Rupee + "rules.txt"
    'Rebuild ActorInfo.product.sbyml
    strDropTables = Botw_GetDataBlockTextContents(strSrcPath, Botw_BuildActorInfoMetaData(strSrcPath), 1, "PutRupee", .Item(1, 4).Text)
    Set objDict = CreateObject("Scripting.Dictionary")
    intFreefile = FreeFile
    Open strDropTables(1) For Input As intFreefile
    j = UBound(strTokens)
    For i = 0 To j
        strTmp = Left(strTokens(i), InStr(strTokens(i), " ") - 1)
        strDestRootPath = Right(strTokens(i), 3)
        If strDestRootPath = "@0@" Then
            Do Until EOF(intFreefile)
                Line Input #intFreefile, strDestRootPath
                strDestRootPath = Mid(strDestRootPath, 3)
                k = InStr(strDestRootPath, ":")
                If Left(strDestRootPath, k - 1) = strTmp Then
                    objDict(strTmp) = Mid(strDestRootPath, k)
                    Exit Do
                End If
            Loop
        Else
            objDict(strTmp) = ": " + .Item(1, CLng(Mid(strDestRootPath, 2, 1))).Text
        End If
    Next i
    Close intFreefile
    intOutFile = FreeFile
    Open strDropTables(1) For Output As intOutFile
    intFreefile = FreeFile
    Open strDropTables(0) For Input As intFreefile
    Do Until EOF(intFreefile)
        Line Input #intFreefile, strDestRootPath
        strTemp = Mid(Left(strDestRootPath, InStr(strDestRootPath, ":") - 1), 3)
        If objDict.Exists(strTemp) Then
            Print #intOutFile, Left(strDestRootPath, 2) + strTemp + objDict(strTemp)
        Else
            Print #intOutFile, strDestRootPath
        End If
    Loop
    Close intFreefile
    Close intOutFile
    Erase strTokens
    Kill strDropTables(0)
    'Drop tables management
    lngStartOffset = Hash_CRC32(.Item(1, 1).Text)
    k = Botw_BuildActorInfoMetaData(strSrcPath)
    strTokens = Split(.Item(1, 5).Text, vbLf)
    m = UBound(strTokens)
    If m < 0 Then
        m = 0
        ReDim strTokens(0 To 0)
        strTokens(0) = strDropTables(1)
        ReDim lngCompareData(0 To 0)
        lngCompareData(0) = lngStartOffset
    Else
        lngCompareData = Vector_SortStringItems(strTokens, STRINGITEMS_UHASH_COMPARE, True)
        For i = m To 0 Step -1
            strTempPath = strActorPackPath + strTokens(i)
            strTmp = strTempPath + "\Actor\DropTable\"
            strTokens(i) = Dir(strTmp + "*.bdrop.xml")
            strTemp = strTmp + Left(strTokens(i), Len(strTokens(i)) - 4)
            strTmp = strTmp + strTokens(i)
            Set objDropTableDict = Botw_WriteDropTableFile(strTmp, strSrcRootPath + strTokens(i))
            System_ShellAndWait 0, 0, "YML_TO_AAMP """ + strTmp + """ """ + strTemp + """"
            Kill strTmp
            System_ShellAndWait 0, 1, "SARC create """ + strTempPath + """ """ + strTempPath + ".sbactorpack"" -b"
            FILE_DoShellOperation SHELL_DELETE_OPERATION, strTempPath
            strTokens(i) = Botw_GetDataBlockTextContent(Converter_CULng(lngCompareData(i)), k, strSrcPath, 1)
            intFreefile = FreeFile
            Open strDropTables(0) For Output As intFreefile
            j = FreeFile
            Open strTokens(i) For Input As j
            Do Until EOF(j)
                Line Input #j, strTemp
                If Right(strTemp, 6) = "drops:" Then
                    Print #intFreefile, strTemp
                    For Each varDictKey In objDropTableDict.Keys
                        Print #intFreefile, "    " + varDictKey + ": [" + objDropTableDict(varDictKey) + "]"
                    Next varDictKey
                    Do Until EOF(j)
                        Line Input #j, strTemp
                        If Mid(strTemp, 3, 1) <> " " Then
                            Print #intFreefile, strTemp
                            Call File_CpyLines(intFreefile, j)
                        End If
                    Loop
                Else
                    Print #intFreefile, strTemp
                End If
            Loop
            Close j
            Close intFreefile
            Kill strTokens(i)
            Name strDropTables(0) As strTokens(i)
            Set objDropTableDict = Nothing
        Next i
        j = Vector_GetLongItemToInsertIndex(lngStartOffset, lngCompareData, True) + 1
        m = m + 1
        ReDim Preserve strTokens(0 To m)
        ReDim Preserve lngCompareData(0 To m)
        For i = m To j Step -1
            strTokens(i) = strTokens(i - 1)
            lngCompareData(i) = lngCompareData(i - 1)
        Next i
        strTokens(i) = strDropTables(1)
        lngCompareData(i) = lngStartOffset
    End If
    lnglngHash = Converter_CULng(lngStartOffset)
    j = FreeFile
    Open strDropTables(0) For Binary Access Write As j
    intFreefile = FreeFile
    Open strSrcPath For Binary Access Read As intFreefile
    lngPreviousStartOffset = 1
    For i = 0 To m
        lnglngUHash = Converter_CULng(lngCompareData(i))
        lngDataBlockIndex = Botw_SearchDataBlockMetaDataIndex(lnglngUHash, k)
        If lngDataBlockIndex = 0 Then lngDataBlockIndex = lngDataBlockIndex + 1
        lngCompareData(i) = lngDataBlockIndex * BOTW_DATABLOCKMETADATASIZE + BOTW_DATABLOCK_OFFSET_OFFSET + 1
        Get k, lngCompareData(i), lngStartOffset
        Call File_CpyBytes(j, intFreefile, lngStartOffset - lngPreviousStartOffset, lngPreviousStartOffset)
        Call File_CopyContent(j, strTokens(i))
        Kill strTokens(i)
        If lnglngHash = lnglngUHash Then
            lngCompareData(0) = lngDataBlockIndex
            lngPreviousStartOffset = lngStartOffset
        Else
            Get k, lngCompareData(i) + BOTW_DATABLOCKMETADATASIZE, lngPreviousStartOffset
        End If
    Next i
    Get k, 1, m
    Get k, (m + 1) * BOTW_DATABLOCKMETADATASIZE + BOTW_DATABLOCK_OFFSET_OFFSET + 1, i
    Call File_CpyBytes(j, intFreefile, i - lngPreviousStartOffset, lngPreviousStartOffset)
    Close j
    Close intFreefile
    Erase strTokens
    j = FreeFile
    Open strDropTables(0) For Append As j
    Print #j, "Hashes:"
    strTmp = "- " + Vbstring_CWholeNumberUstr(lnglngHash, 2147483647)
    i = BOTW_DATABLOCK_HASHID_OFFSET + 1
    For lngStartOffset = lngCompareData(0) - 1 To 1 Step -1
        GoSub Botw_Material2RupeeSub1
    Next lngStartOffset
    Print #j, strTmp
    For lngStartOffset = lngCompareData(0) To m
        GoSub Botw_Material2RupeeSub1
    Next lngStartOffset
    Close j
    Close k
    Erase lngCompareData
    System_ShellAndWait 0, 1, "YML_TO_BYML """ + strDropTables(0) + """ """ + strFilePath + """ -b"
    Kill strDropTables(0)
    Erase strDropTables
    strTempPath = strActorPackPath + .Item(1, 1).Text
    End With
    'Patch Fake Rupee actor files
    With xlsFakeRupeeActorDataBuildSettings
    i = .Rows.Count
    ReDim strDropTables(1 To i, 1 To 2)
    objDict.RemoveAll
    Set objRegExp = CreateObject("VBScript.RegExp")
    strTmp = File_GetTextContent(strMaterialActorLinkFilePath, True)
    Do
        For k = 1 To 2
            strTokens = Split(.Item(i, k).Text, "@")
            For j = UBound(strTokens) To 0 Step -1
                If j Mod 2 = 0 Then
                    strDropTables(i, k) = strTokens(j) + strDropTables(i, k)
                ElseIf Len(strTokens(j)) = 1 Then
                    strDropTables(i, k) = xlsFakeRupeeSettings.Item(1, CLng(strTokens(j))).Text + strDropTables(i, k)
                Else
                    If objDict.Exists(strTokens(j)) Then
                        strDropTables(i, k) = objDict(strTokens(j)) + strDropTables(i, k)
                    Else
                        objRegExp.Pattern = strTokens(j)
                        Set objMatchCollection = objRegExp.Execute(strTmp)
                        If objMatchCollection.Count <> 0 Then
                            objDict(strTokens(j)) = objMatchCollection.Item(0).SubMatches(0)
                            strDropTables(i, k) = objMatchCollection.Item(0).SubMatches(0) + strDropTables(i, k)
                        End If
                        Set objMatchCollection = Nothing
                    End If
                End If
            Next j
            Erase strTokens
        Next k
        strTokens = Split(strDropTables(i, 2), vbLf)
        strTemp = strTempPath + "\" + strDropTables(i, 1)
        strFilePath = strTemp + ".xml"
        strTmp = strActorPackPath + strTokens(0)
        System_ShellAndWait 0, 0, "AAMP_TO_YML """ + strTmp + """ """ + strFilePath + """"
        Kill strTmp
        objRegExp.Global = True
        strTmp = File_GetTextContent(strFilePath, True)
        For k = UBound(strTokens) To 1 Step -1
            j = InStr(strTokens(k), "")
            objRegExp.Pattern = Left(strTokens(k), j - 1)
            strTmp = objRegExp.Replace(strTmp, Mid(strTokens(k), j + 1))
        Next k
        Erase strTokens
        Call File_WriteTextContent(strFilePath, strTmp)
        System_ShellAndWait 0, 0, "YML_TO_AAMP """ + strFilePath + """ """ + strTemp + """"
        Kill strFilePath
        i = i - 1
    Loop Until i = 0
    Set objDict = Nothing
    Set objRegExp = Nothing
    Erase strDropTables
    End With
    System_ShellAndWait 0, 1, "SARC create """ + strTempPath + """ """ + strTempPath + ".sbactorpack"" -b"
    With xlsFakeRupeeSettings
    Call File_DeleteFileSystemObjects(strTempPath, strActorPackPath + .Item(1, 4).Text)
    'Add IsGet_<FAKE RUPEE ACTOR NAME> game data into bool_data_0.bgdata and rebuild Bootup.pack
    strTmp = File_GetTempFilePath()
    strSrcPath = "IsGet_" + .Item(1, 1).Text
    i = FreeFile
    Open strTmp For Output As i
    Print #i, "^- {DataName: IsGet_PutRupee_Blue," + vbCrLf + "-1" + vbCrLf + "- {DataName: " + strSrcPath + ", DeleteRev: -1, HashValue: " + CStr(Hash_CRC32(strSrcPath)) + ", InitValue: 1," + vbCrLf + "  IsEventAssociated: false, IsOneTrigger: true, IsProgramReadable: true, IsProgramWritable: true," + vbCrLf + "  IsSave: false, MaxValue: true, MinValue: false, ResetType: 0}"
    Close i
    strMaterialActorLinkFilePath = Botw_Material2Rupee + "content\Pack\Bootup"
    strSrcPath = strMaterialActorLinkFilePath + "\GameData\gamedata"
    strFilePath = strBoolDataPath + ".yml"
    Name strFilePath As strBoolDataPath
    File_PatchText strBoolDataPath, strFilePath, strTmp
    System_ShellAndWait 0, 1, "YML_TO_BYML """ + strFilePath + """ """ + strBoolDataPath + """ -b"
    Call File_DeleteFileSystemObjects(strTmp, strFilePath)
    System_ShellAndWait 0, 1, "SARC create """ + strSrcPath + """ """ + strSrcPath + "\..\gamedata.ssarc"" -b"
    FILE_DoShellOperation SHELL_DELETE_OPERATION, strSrcPath
    System_ShellAndWait 0, 1, "SARC create """ + strMaterialActorLinkFilePath + """ """ + strMaterialActorLinkFilePath + "\..\Bootup.pack"" -b"
    FILE_DoShellOperation SHELL_DELETE_OPERATION, strMaterialActorLinkFilePath
    'build texts.json
    strTmp = """: {" + vbCrLf + "    ""ActorType/Item.msyt"": {"
    strTemp = "      """ + .Item(1, 1).Text + "_"
    strDestRootPath = """: {" + vbCrLf + "        ""contents"": [" + vbCrLf + "          {" + vbCrLf + "            ""text"": """
    strFilePath = """" + vbCrLf + "          }" + vbCrLf + "        ]" + vbCrLf + "      }"
    strSrcPath = "    }" + vbCrLf + "  }"
    strTokens = Split(.Item(1, 2).Text, vbLf)
    intFreefile = FreeFile
    Open Botw_Material2Rupee + "logs\texts.json" For Output As intFreefile
    Print #intFreefile, "{"
    j = UBound(strTokens) - 1
    For i = 0 To j
        GoSub Botw_Material2RupeeSub0
        Print #intFreefile, ","
    Next i
    GoSub Botw_Material2RupeeSub0
    Print #intFreefile, vbCrLf + "}"
    Close #intFreefile
    Erase strTokens
    'drop actor patch for map tbox objects
    strCemuFolderPath = Botw_Material2Rupee + "content\Pack\"
    strGamePath = strGamePath + "content\Pack\"
    strDestRootPath = Botw_Material2Rupee + "content\Map\"
    strTempPath = strCachePath + "content\Map\"
    strSrcRootPath = strCachePath + "content\Pack\"
    strTokens = Split(.Item(1, 6).Text, vbLf)
    lngPreviousStartOffset = FreeFile
    Open Botw_Material2Rupee + "logs\packs.json" For Output As lngPreviousStartOffset
    Print #lngPreviousStartOffset, "{" + vbCrLf + "  ""Actor/Pack/" + .Item(1, 1).Text + ".bactorpack"": ""content\\Actor\\Pack\\" + .Item(1, 1).Text + ".sbactorpack"""
    For i = UBound(strTokens) To 0 Step -1
        If Left(strTokens(i), 1) <> "#" Then
            strBoolDataPath = ""
            strDropTables = Split(strTokens(i), " ")
            strTemp = strDropTables(0) + ".smubin"
            strTmp = Left(strTemp, InStr(strTemp, "\") - 1)
            Select Case strTmp
            Case "MainField"
                strFilePath = strDestRootPath + strTemp
                strSrcPath = strFilePath + ".yml"
                strMaterialActorLinkFilePath = strTempPath + strTemp + ".yml"
                If Dir(strMaterialActorLinkFilePath) = "" Then
                    MakeSureDirectoryPathExists Left(strMaterialActorLinkFilePath, InStrRev(strMaterialActorLinkFilePath, "\"))
                    System_ShellAndWait 0, 1, "BYML_TO_YML """ + strDlcFolderPath + "\content\0010\Map\" + strTemp + """ """ + strMaterialActorLinkFilePath + """"
                End If
            Case Else
                Print #lngPreviousStartOffset, "  ""Pack/" + strTmp + ".pack"": ""content\\Pack\\" + strTmp + ".pack"""
                strFilePath = strCemuFolderPath + strTemp
                strSrcPath = strFilePath + ".yml"
                strMaterialActorLinkFilePath = strSrcRootPath + strTemp + ".yml"
                strBoolDataPath = strCemuFolderPath + strTmp
                If Dir(strMaterialActorLinkFilePath) = "" Then
                    MakeSureDirectoryPathExists Left(strMaterialActorLinkFilePath, InStrRev(strMaterialActorLinkFilePath, "\"))
                    System_ShellAndWait 0, 1, "BYML_TO_YML """ + strFilePath + """ """ + strMaterialActorLinkFilePath + """", "SARC extract """ + strGamePath + strTmp + ".pack"" -C """ + strBoolDataPath + """"
                End If
            End Select
            MakeSureDirectoryPathExists Left(strFilePath, InStrRev(strFilePath, "\"))
            strTmp = Left(strMaterialActorLinkFilePath, Len(strMaterialActorLinkFilePath) - 4) + "\"
            k = Botw_BuildMapUnitMetadata(strMaterialActorLinkFilePath)
            intFreefile = FreeFile
            Open strMaterialActorLinkFilePath For Binary Access Read As intFreefile
            intOutFile = FreeFile
            Open strSrcPath For Binary Access Write As intOutFile
            m = 0
            If Left(strDropTables(1), 1) = "@" Then strDropTables(1) = .Item(1, CLng(Mid(strDropTables(1), 2, 1))).Text
            For j = UBound(strDropTables) To 2 Step -1
                strMaterialActorLinkFilePath = Botw_WriteModdedMapTBoxObjectContent(intFreefile, k, Right(strDropTables(j), 8), strDropTables(1), strTmp, lngDataBlockIndex)
                If lngDataBlockIndex > m Then
                    Get k, m * BOTW_DATABLOCKMETADATASIZE + BOTW_DATABLOCK_OFFSET_OFFSET + 1, lngStartOffset
                    Get k, lngDataBlockIndex * BOTW_DATABLOCKMETADATASIZE + BOTW_DATABLOCK_OFFSET_OFFSET + 1, m
                    Call File_CopyBytes(intOutFile, intFreefile, lngStartOffset, m - lngStartOffset)
                End If
                Call File_CopyContent(intOutFile, strMaterialActorLinkFilePath)
                m = lngDataBlockIndex + 1
                Kill strMaterialActorLinkFilePath
            Next j
            Get k, m * BOTW_DATABLOCKMETADATASIZE + BOTW_DATABLOCK_OFFSET_OFFSET + 1, lngStartOffset
            Call File_CpyBytes(intOutFile, intFreefile, LOF(intFreefile) - lngStartOffset + 1, lngStartOffset)
            Erase strDropTables
            Close intOutFile
            Close k
            Close intFreefile
            System_ShellAndWait 0, 0, "YML_TO_BYML """ + strSrcPath + """ """ + strFilePath + """ -b"
            Kill strSrcPath
            If strBoolDataPath <> "" Then
                System_ShellAndWait 0, 1, "SARC create """ + strBoolDataPath + """ """ + strBoolDataPath + ".pack"" -b"
                FILE_DoShellOperation SHELL_DELETE_OPERATION, strBoolDataPath
            End If
        End If
    Next i
    Print #lngPreviousStartOffset, "}"
    Close lngPreviousStartOffset
    Erase strTokens
    strTmp = Left(Botw_Material2Rupee, Len(Botw_Material2Rupee) - 1)
    strTemp = " """ + strTmp + ".bnp"" "
    Set objDict = File_IniReadSectionSettings(Botw_Material2Rupee + "rules.txt", "Definition")
    System_ShellAndWait 0, 1, "7Z a" + strTemp + """logs\packs.json""", "CD /D """ + Botw_Material2Rupee + """", "BNPTOOL create --output" + strTemp + "--name """ + objDict("name") + """ --version ""1.0.0"" --description """ + objDict("description") + """ """ + strTmp + """"
    Set objDict = Nothing
    End With
    Exit Function
Botw_Material2RupeeSub0:
    strDropTables = Split(strTokens(i), "")
    Print #intFreefile, "  """;
    Print #intFreefile, strDropTables(0);
    Print #intFreefile, strTmp
    Print #intFreefile, strTemp;
    Print #intFreefile, "Desc";
    Print #intFreefile, strDestRootPath;
    Print #intFreefile, strDropTables(1);
    Print #intFreefile, strFilePath;
    Print #intFreefile, ","
    Print #intFreefile, strTemp;
    Print #intFreefile, "Name";
    Print #intFreefile, strDestRootPath;
    Print #intFreefile, strDropTables(2);
    Print #intFreefile, strFilePath
    Print #intFreefile, strSrcPath;
    Erase strDropTables
    Return
Botw_Material2RupeeSub1:
    i = BOTW_DATABLOCKMETADATASIZE + i
    Get k, i, lnglngHash
    Print #j, "- " + Vbstring_CWholeNumberUstr(lnglngHash, 2147483647)
    Return
End Function
