Attribute VB_Name = "GfxPACK"
Option Explicit
Private Const GFXPACK_COMMON_MEMORYBASE As Long = &H1800000
'Private Const GFXPACK_COMMON_GROUPIDOFFSET As Long = &H5
'Private Const GFXPACK_COMMON_MODULEMATCHOFFSET As Long = &H22
Private Const GFXPACK_IPM_MAXINJECTIONCOUNT As Long = 15000
Private Const GFXPACK_IPM_CUSTOMSUBSIZE As Long = 68
Public Type stCodeCave
    lngStartOffset As Long
    lngEndOffset As Long
    btPatchIndex As Byte
    strComment As String
End Type
Public Type stPatchCodeCaves
    strGraphicPackName As String
    stCodeCaves() As stCodeCave
    intCodeCavesCount As Integer
End Type
Public Type stGfxPreset
    strPresetName As String
    stSettings() As stObjectItem
    intSettingsCount As Integer
End Type
Private Type stGfxPackMetaData
    strTitleIds As String
    lngCodeDataSize As Long
End Type
Private Type stAsmGfxPackStats
    lngModuleMatch As Long
    lngCodeCaveSize As Long
    lngInjectionPointCount As Long
End Type
Public Enum GFXPACK_MODULEMATCHES
    GFXPACK_BOTW_MODULEMATCH = &H6267BFD0
End Enum
Public stGfxPackInfos As stGfxPackMetaData
Public stGfxPackStats As stAsmGfxPackStats
Private stDefaultPreset As stGfxPreset
Public Function Gfxpack_Str2Asm(ByRef strValue As String, Optional ByVal btFieldSize As Byte = 32) As String
'Usage example with the immediate window: ?Gfxpack_Str2Asm("Zelda")
Dim strWord As String
Dim btLength As Byte
    btLength = Len(strValue)
    strWord = ".int 0" + vbCrLf
    btFieldSize = (btFieldSize - btLength) \ 4
    Do Until btFieldSize = 0
        btFieldSize = btFieldSize - 1
        Gfxpack_Str2Asm = Gfxpack_Str2Asm + strWord
    Loop
    btFieldSize = btLength Mod 4
    If btFieldSize = 0 Then
        btFieldSize = btLength + 1
    Else
        strWord = String(4 - btFieldSize, vbNullChar)
        btFieldSize = btLength - btFieldSize + 1
        strWord = Mid(strValue, btFieldSize) + strWord
        Gfxpack_Str2Asm = ".int 0x" + Hex(Converter_Asc2Int(strWord)) + " # " + strWord + vbCrLf + Gfxpack_Str2Asm
    End If
    Do Until btFieldSize = 1
        btFieldSize = btFieldSize - 4
        strWord = Mid(strValue, btFieldSize, 4)
        Gfxpack_Str2Asm = ".int 0x" + Hex(Converter_Asc2Int(strWord)) + " # " + strWord + vbCrLf + Gfxpack_Str2Asm
    Loop
    Gfxpack_Str2Asm = ".int " + CStr(btLength) + vbCrLf + Gfxpack_Str2Asm
End Function
Public Function Gfxpack_GetUserDefinedMapUnitData(ByVal strDataTypes As String, ByRef strDataLabel As String) As String
'Usage example with the immediate window: ?Gfxpack_GetUserDefinedMapUnitData("int|int|float|float", "Food service")
Dim i As Long
Dim j As Byte
Dim strDataTypesNames() As String
    strDataTypesNames = Split(strDataTypes, "|")
    strDataTypes = " " + strDataLabel + vbCrLf
    For i = UBound(strDataTypesNames) To 0 Step -1
        strDataTypes = strDataTypes + "." + strDataTypesNames(i) + " 0" + vbCrLf
    Next i
    For i = 65 To 74
        strDataTypesNames(0) = "#" + Chr(i) + "-"
        For j = 1 To 8
            Gfxpack_GetUserDefinedMapUnitData = Gfxpack_GetUserDefinedMapUnitData + strDataTypesNames(0) + CStr(j) + strDataTypes
        Next j
    Next i
    Erase strDataTypesNames
End Function
Public Function Gfxpack_GetCodeCave(ByRef strCemuLogFilePath As String, ByRef strGfxpackName As String, ByRef lngCodeCaveSize As Long) As Long
Dim stCemuLogData() As stExtractedTextData
    lngCodeCaveSize = File_ExtractText(vbLf + "1 \] Activate graphic pack: +.+/(" + Converter_Str2RegExp(strGfxpackName) + ").*$" + vbLf + "100 \] Applying patch group '.+' \(Codecave: ([0-9a-fA-F]{8}-[0-9a-fA-F]{8})\)$", stCemuLogData, strCemuLogFilePath)
    If lngCodeCaveSize <> 0 Then
        If lngCodeCaveSize > 1 Then
            With stCemuLogData(lngCodeCaveSize)
            If .objData.Item(0).SubMatches(0) = strGfxpackName Then
                Gfxpack_GetCodeCave = .lngLine
                lngCodeCaveSize = lngCodeCaveSize - 1
                If Gfxpack_GetCodeCave - .lngLine = 1 Then
                    Gfxpack_GetCodeCave = CLng("&H" + Left(.objData.Item(0).SubMatches(0), 8))
                    lngCodeCaveSize = CLng("&H" + Mid(.objData.Item(0).SubMatches(0), 10)) - Gfxpack_GetCodeCave
                Else
                    Gfxpack_GetCodeCave = 0
                End If
            End If
            End With
        End If
        Erase stCemuLogData
    End If
End Function
Public Function Gfxpack_UseableInjectionPoint() As Byte
Dim wsPatches As Worksheet
Dim stSwapCodeCave As stCodeCave
Dim intFile As Integer
Dim strLine As String
Dim strCodeCaveOffsets() As String
Dim intPos As Integer
Dim i As Integer
Dim xlsRange As Range
Dim stPatchesCodeCaves() As stPatchCodeCaves
    Set wsPatches = Worksheets("Patches")
    wsPatches.Range("A2:D1048576").ClearContents
    Gfxpack_UseableInjectionPoint = CLng(wsPatches.Range("G1").Text)
    ReDim stPatchesCodeCaves(0 To Gfxpack_UseableInjectionPoint)
    With wsPatches.Range("F2:F" + CStr(Gfxpack_UseableInjectionPoint + 1)).Cells
    Do Until Gfxpack_UseableInjectionPoint = 0
        ReDim stPatchesCodeCaves(Gfxpack_UseableInjectionPoint).stCodeCaves(0 To 0)
        intFile = FreeFile
        Open Left(.Item(Gfxpack_UseableInjectionPoint, 1).Text, InStrRev(.Item(Gfxpack_UseableInjectionPoint, 1).Text, "\")) + "rules.txt" For Input As intFile
        Do Until EOF(intFile) Or LCase(Left(strLine, 4)) = "name"
            Line Input #intFile, strLine
        Loop
        Close intFile
        stPatchesCodeCaves(Gfxpack_UseableInjectionPoint).strGraphicPackName = "[" + LTrim(Mid(strLine, InStr(strLine, "=") + 1)) + "]"
        intFile = FreeFile
        Open .Item(Gfxpack_UseableInjectionPoint, 1).Text For Input As intFile
        Do Until EOF(intFile)
            Line Input #intFile, strLine
            If LCase(Mid(strLine, 1, 2)) = "0x" Then
                stSwapCodeCave.lngStartOffset = CLng("&H" + Mid(strLine, 3, InStr(strLine, "=") - 3))
                stSwapCodeCave.lngEndOffset = stSwapCodeCave.lngStartOffset
                intPos = InStrRev(strLine, "#")
                If intPos > 1 Then stSwapCodeCave.strComment = LTrim(Mid(strLine, intPos + 1))
                i = 0
                GoSub Gfxpack_UseableInjectionPointSub
            Else
                If LCase(Mid(strLine, 1, 3)) = "#0x" And Right(strLine, 1) = ")" Then
                    strCodeCaveOffsets = Split(strLine, "-")
                    If UBound(strCodeCaveOffsets) = 1 Then
                        strCodeCaveOffsets(1) = RTrim(strCodeCaveOffsets(1))
                        intPos = InStr(strCodeCaveOffsets(1), "(")
                        If intPos <> 0 Then
                            stSwapCodeCave.lngStartOffset = CLng("&H" + Mid(strCodeCaveOffsets(0), 4))
                            stSwapCodeCave.lngEndOffset = CLng("&H" + Mid(strCodeCaveOffsets(1), 3, intPos - 3)) - 4
                            intPos = intPos + 1
                            stSwapCodeCave.strComment = Mid(strCodeCaveOffsets(1), intPos, Len(strCodeCaveOffsets(1)) - intPos)
                            i = 1
                            GoSub Gfxpack_UseableInjectionPointSub
                        End If
                    End If
                    Erase strCodeCaveOffsets
                End If
            End If
        Loop
        Close intFile
        stPatchesCodeCaves(0).intCodeCavesCount = stPatchesCodeCaves(0).intCodeCavesCount + stPatchesCodeCaves(Gfxpack_UseableInjectionPoint).intCodeCavesCount
        Gfxpack_UseableInjectionPoint = Gfxpack_UseableInjectionPoint - 1
    Loop
    End With
    Gfxpack_UseableInjectionPoint = UBound(stPatchesCodeCaves)
    With stPatchesCodeCaves(0)
    intFile = .intCodeCavesCount + 1
    ReDim .stCodeCaves(0 To intFile)
    .stCodeCaves(intFile).lngStartOffset = 2147483647
    .intCodeCavesCount = 0
    Do Until Gfxpack_UseableInjectionPoint = 0
        Do Until stPatchesCodeCaves(Gfxpack_UseableInjectionPoint).intCodeCavesCount = 0
            intPos = .intCodeCavesCount
            stSwapCodeCave = stPatchesCodeCaves(Gfxpack_UseableInjectionPoint).stCodeCaves(stPatchesCodeCaves(Gfxpack_UseableInjectionPoint).intCodeCavesCount)
            Do Until .stCodeCaves(intPos).lngStartOffset < stSwapCodeCave.lngStartOffset
                intPos = intPos - 1
            Loop
            .intCodeCavesCount = .intCodeCavesCount + 1
            intPos = intPos + 1
            For i = .intCodeCavesCount - 1 To intPos Step -1
                .stCodeCaves(i + 1) = .stCodeCaves(i)
            Next i
            .stCodeCaves(intPos) = stSwapCodeCave
            stPatchesCodeCaves(Gfxpack_UseableInjectionPoint).intCodeCavesCount = stPatchesCodeCaves(Gfxpack_UseableInjectionPoint).intCodeCavesCount - 1
        Loop
        Erase stPatchesCodeCaves(Gfxpack_UseableInjectionPoint).stCodeCaves
        Gfxpack_UseableInjectionPoint = Gfxpack_UseableInjectionPoint - 1
    Loop
    Set xlsRange = wsPatches.Range("A2:D" + CStr(.intCodeCavesCount + 1)).Cells
    intFile = 0
    stSwapCodeCave.lngStartOffset = FreeFile
    .strGraphicPackName = """"
    Open ThisWorkbook.Path + "\BreathOfTheWild_PatchCodecaves.js" For Output As stSwapCodeCave.lngStartOffset
    Print #stSwapCodeCave.lngStartOffset, "var arrPatchCodecaves=[";
    For intPos = 1 To .intCodeCavesCount
        intFile = intFile + 1
        Print #stSwapCodeCave.lngStartOffset, "[" + CStr(.stCodeCaves(intPos).lngStartOffset) + "," + CStr(.stCodeCaves(intPos).lngEndOffset) + ",";
        xlsRange.Item(intFile, 1).Value = Hex(.stCodeCaves(intPos).lngStartOffset)
        xlsRange.Item(intFile, 2).Value = Hex(.stCodeCaves(intPos).lngEndOffset)
        xlsRange.Item(intFile, 4).Value = .stCodeCaves(intPos).strComment
        strLine = stPatchesCodeCaves(.stCodeCaves(intPos).btPatchIndex).strGraphicPackName
        i = intPos + 1
        Do Until .stCodeCaves(intPos).lngEndOffset < .stCodeCaves(i).lngStartOffset
            If .stCodeCaves(intPos).lngStartOffset = .stCodeCaves(i).lngStartOffset And .stCodeCaves(intPos).lngEndOffset = .stCodeCaves(i).lngEndOffset Then intPos = intPos + 1
            If InStr(strLine, stPatchesCodeCaves(.stCodeCaves(i).btPatchIndex).strGraphicPackName) = 0 Then
                strLine = strLine + stPatchesCodeCaves(.stCodeCaves(i).btPatchIndex).strGraphicPackName
            End If
            i = i + 1
        Loop
        xlsRange.Item(intFile, 3).Value = strLine
        Print #stSwapCodeCave.lngStartOffset, .strGraphicPackName + Replace(Mid(strLine, 2, Len(strLine) - 2), "][", "<br>") + .strGraphicPackName + "," + .strGraphicPackName + xlsRange.Item(intFile, 4).Text + .strGraphicPackName + "],";
    Next intPos
    Print #stSwapCodeCave.lngStartOffset, "[0,0," + .strGraphicPackName + .strGraphicPackName + "," + .strGraphicPackName + .strGraphicPackName + "]];";
    Close stSwapCodeCave.lngStartOffset
    Erase .stCodeCaves
    End With
    Erase stPatchesCodeCaves
    Set xlsRange = Nothing
    Set wsPatches = Nothing
    Exit Function
Gfxpack_UseableInjectionPointSub:
    stSwapCodeCave.btPatchIndex = Gfxpack_UseableInjectionPoint
    With stPatchesCodeCaves(Gfxpack_UseableInjectionPoint)
    intPos = .intCodeCavesCount
    Do Until .stCodeCaves(intPos).lngStartOffset < stSwapCodeCave.lngStartOffset
        intPos = intPos - 1
    Loop
    If i = 0 And stSwapCodeCave.lngStartOffset - .stCodeCaves(intPos).lngEndOffset = 4 Then
        .stCodeCaves(intPos).lngEndOffset = stSwapCodeCave.lngStartOffset
    Else
        .intCodeCavesCount = .intCodeCavesCount + 1
        ReDim Preserve .stCodeCaves(0 To .intCodeCavesCount)
        intPos = intPos + 1
        For i = .intCodeCavesCount - 1 To intPos Step -1
            .stCodeCaves(i + 1) = .stCodeCaves(i)
        Next i
        .stCodeCaves(intPos) = stSwapCodeCave
    End If
    End With
    Return
End Function
Private Sub Gfxpack_SetMetaData(ByRef GAME_MODULEMATCH As GFXPACK_MODULEMATCHES)
    With stGfxPackInfos
    Select Case GAME_MODULEMATCH
        Case GFXPACK_BOTW_MODULEMATCH
            .lngCodeDataSize = &H2347C0C
            .strTitleIds = "00050000101C9300,00050000101C9400,00050000101C9500"
    End Select
    End With
End Sub
Private Function Gfxpack_ParseAsmFile(ByVal strAsmFilename As String) As Long
Dim intFile As Integer
Dim strFirstChar As String * 1
    intFile = FreeFile
    Gfxpack_ParseAsmFile = -FileLen(strAsmFilename)
    Open strAsmFilename For Input As intFile
    With stGfxPackStats
    .lngInjectionPointCount = 0
    .lngCodeCaveSize = 0
    .lngModuleMatch = 0
    Do Until EOF(intFile) Or .lngModuleMatch <> 0
        Line Input #intFile, strAsmFilename
        If LCase(Left(strAsmFilename, 13)) = "modulematches" Then .lngModuleMatch = CLng("&h" + Mid(strAsmFilename, InStr(15, strAsmFilename, "0") + 2))
    Loop
    Do Until EOF(intFile) Or Gfxpack_ParseAsmFile > 0
        Line Input #intFile, strAsmFilename
        If strAsmFilename <> "" Then
            strFirstChar = Left(strAsmFilename, 1)
            If (strFirstChar <> "#" And strFirstChar <> "_") Then
                If Left(strAsmFilename, 7) <> ".origin" Then
                    If strFirstChar = "0" Then
                        .lngInjectionPointCount = .lngInjectionPointCount + 1
                    Else
                        .lngCodeCaveSize = .lngCodeCaveSize + 4
                    End If
                End If
                Gfxpack_ParseAsmFile = -Gfxpack_ParseAsmFile
            End If
        End If
    Loop
    Do Until EOF(intFile)
        Line Input #intFile, strAsmFilename
        If strAsmFilename <> "" Then
            strFirstChar = Left(strAsmFilename, 1)
            If strFirstChar <> "#" And strFirstChar <> "_" Then
                If strFirstChar = "0" Then
                    .lngInjectionPointCount = .lngInjectionPointCount + 1
                Else
                    .lngCodeCaveSize = .lngCodeCaveSize + 4
                End If
            End If
        End If
    Loop
    End With
    Close intFile
End Function
Private Sub Gfxpack_WriteRulesFile(ByVal strRulesFilename As String, ByRef strTitleIds, ByRef strName As String, ByRef strPath As String, Optional ByRef btVersion As Byte = 5)
Dim intOutputFile As Integer
    intOutputFile = FreeFile
    Open strRulesFilename For Output As intOutputFile
    Print #intOutputFile, "[Definition]"
    Print #intOutputFile, "titleIds = ";
    Print #intOutputFile, strTitleIds
    Print #intOutputFile, "name = ";
    Print #intOutputFile, strName
    Print #intOutputFile, "path = ";
    strRulesFilename = """"
    Print #intOutputFile, strRulesFilename;
    Print #intOutputFile, strPath;
    Print #intOutputFile, strRulesFilename
    Print #intOutputFile, "description = ";
    Print #intOutputFile, strName
    Print #intOutputFile, "version = ";
    Print #intOutputFile, CStr(btVersion)
    With stDefaultPreset
        If .intSettingsCount <> 0 Then
            Print #intOutputFile, vbCrLf;
            Print #intOutputFile, "[";
            Print #intOutputFile, .strPresetName;
            Print #intOutputFile, "]"
            Do
                Print #intOutputFile, "$";
                Print #intOutputFile, .stSettings(.intSettingsCount).strParamName;
                Print #intOutputFile, ":";
                Select Case TypeName(.stSettings(.intSettingsCount).varParamValue)
                    Case "Byte"
                        Print #intOutputFile, "byte";
                    Case "Integer"
                        Print #intOutputFile, "short";
                    Case "Long"
                        Print #intOutputFile, "int";
                    Case "Single"
                        Print #intOutputFile, "float";
                    Case "Double"
                        Print #intOutputFile, "double";
                End Select
                Print #intOutputFile, "=";
                Print #intOutputFile, CStr(.stSettings(.intSettingsCount).varParamValue)
                .intSettingsCount = .intSettingsCount - 1
            Loop Until .intSettingsCount = 0
        End If
    End With
    Close intOutputFile
End Sub
Public Function Gfxpack_WriteInjectionPointMonitoringPatch(Optional ByRef GAME_MODULEMATCH As GFXPACK_MODULEMATCHES = GFXPACK_BOTW_MODULEMATCH, Optional ByVal strCemuFolderPath As String = "") As Long
'Usage example with the immediate window: ?Gfxpack_WriteInjectionPointMonitoringPatch()
Dim wks As Worksheet
Dim intBinaryCodeFile As Integer
Dim intAppendedBinaryCodeFile As Integer
Dim lngPPCCode As Long
Dim intCemuPatchFile As Integer
Dim strXlsFields(1 To 3) As String
Dim lngBranchAddress As Long
Dim lngInjectionPoint As Long
Dim lngIpmCorePpcCodes(1 To GFXPACK_IPM_CUSTOMSUBSIZE \ 4) As Long
Dim lngStorageAddress As Long
    Set wks = Worksheets("InjectionPointMonitoring")
    wks.Range("B2:D1048576").ClearContents
    Gfxpack_WriteInjectionPointMonitoringPatch = wks.Range("E1").Value - 1
    If Gfxpack_WriteInjectionPointMonitoringPatch > 0 Then
        lngStorageAddress = GFXPACK_COMMON_MEMORYBASE \ &H10000 + 32
        lngIpmCorePpcCodes(8) = &HFFFF4238 'addi r2, r2, -1 [0x3842FFFF]
        lngIpmCorePpcCodes(10) = &H3400427C 'cntlzw r2, r2 [0x7C420034]
        lngIpmCorePpcCodes(11) = &H7AEF4254 'rlwinm r2, r2, 29, 29, 29 [0x5442EF7A]
        lngIpmCorePpcCodes(12) = &H7004268  'xori r2, r2, 7 [0x68420007]
        lngIpmCorePpcCodes(15) = &HFCFF4280 'lwz r2, -0x4(r2) [0x8042FFFC]
        If Gfxpack_WriteInjectionPointMonitoringPatch > GFXPACK_IPM_MAXINJECTIONCOUNT Then Gfxpack_WriteInjectionPointMonitoringPatch = GFXPACK_IPM_MAXINJECTIONCOUNT
        strCemuFolderPath = Cemu_GetRootFolderPath(strCemuFolderPath)
        Call Gfxpack_SetMetaData(GAME_MODULEMATCH)
        lngBranchAddress = GFXPACK_COMMON_MEMORYBASE - 8
        stAsmResources.lngDeltaOffset = CEMU_DUMP_02000000
        With stGfxPackInfos
        .lngCodeDataSize = .lngCodeDataSize + &H2000020
        .strTitleIds = strCemuFolderPath + "dump\"
        stAsmResources.intBinFile = FreeFile
        Open .strTitleIds + "02000000.bin" For Binary Access Read As stAsmResources.intBinFile
        stAsmResources.intAsmFile = FreeFile
        Open .strTitleIds + "U-King.asm" For Binary Access Read As stAsmResources.intAsmFile
        stAsmResources.intAsmMapFile = FreeFile
        Open .strTitleIds + "U-King.asm.map" For Binary Access Read As stAsmResources.intAsmMapFile
        strCemuFolderPath = strCemuFolderPath + "graphicPacks\Tools_InjectionPointMonitoring\"
        intCemuPatchFile = File_Create(strCemuFolderPath + "patch_patches.asm")
        .strTitleIds = Right("0000000" + Hex(GAME_MODULEMATCH), 8)
        Print #intCemuPatchFile, "[IPM";
        Print #intCemuPatchFile, .strTitleIds;
        Print #intCemuPatchFile, "]"
        Print #intCemuPatchFile, "moduleMatches = 0x";
        Print #intCemuPatchFile, .strTitleIds
        Print #intCemuPatchFile, vbCrLf;
        '.strTitleIds = strCemuFolderPath + "????????.ppc"
        'If Dir(.strTitleIds) <> "" Then Kill .strTitleIds
        intAppendedBinaryCodeFile = File_Create(strCemuFolderPath + Right("0000000" + Hex(.lngCodeDataSize), 8) + ".ppc", 1)
        End With
        intBinaryCodeFile = File_Create(strCemuFolderPath + Right("0000000" + Hex(GFXPACK_COMMON_MEMORYBASE), 8) + ".ppc", 1)
        With wks.Range("A2:D" + wks.Range("E1").Text).Cells
        Do
            strXlsFields(1) = .Item(Gfxpack_WriteInjectionPointMonitoringPatch, 1).Text
            lngPPCCode = CLng("&h" + strXlsFields(1))
            strXlsFields(3) = Asm_ReadInstruction(lngPPCCode, lngInjectionPoint)
            strXlsFields(2) = Memory_VarHexDump(VarPtr(lngInjectionPoint), 4, "")
            .Item(Gfxpack_WriteInjectionPointMonitoringPatch, 2).Value = strXlsFields(2)
            .Item(Gfxpack_WriteInjectionPointMonitoringPatch, 3).Value = strXlsFields(3)
            lngInjectionPoint = Asm_IsUsablePPCRa(strXlsFields(3))
            If lngInjectionPoint = 255 Then
                Debug.Print "Skip ";
                Debug.Print strXlsFields(1);
                Debug.Print " ";
                Debug.Print strXlsFields(3)
            Else
                lngIpmCorePpcCodes(1) = Converter_SwapEndian32(Asm_PPCDInstruction(14, 0, lngInjectionPoint, Gfxpack_WriteInjectionPointMonitoringPatch - 1)) 'li r<lngInjectionPoint>, <Injection Point Index>
                lngIpmCorePpcCodes(2) = Converter_SwapEndian32(Asm_PPCMInstruction(21, lngInjectionPoint, lngInjectionPoint, 3, 0, 28)) 'slwi r<lngInjectionPoint>, r<lngInjectionPoint>, 3
                lngIpmCorePpcCodes(3) = Converter_SwapEndian32(Asm_PPCDInstruction(25, lngInjectionPoint, lngInjectionPoint, lngStorageAddress)) 'oris r<lngInjectionPoint>, r<lngInjectionPoint>, 0x190
                lngIpmCorePpcCodes(4) = Converter_SwapEndian32(Asm_PPCXInstruction(31, 0, 2, lngInjectionPoint, 151)) 'stwx r2, r0, r<lngInjectionPoint>
                lngIpmCorePpcCodes(5) = Converter_SwapEndian32(Asm_PPCXInstruction(31, 2, lngInjectionPoint, lngInjectionPoint, 444)) 'mr r2, r<lngInjectionPoint>
                lngIpmCorePpcCodes(6) = Converter_SwapEndian32(Asm_PPCDInstruction(14, 2, lngInjectionPoint, 4)) 'addi r<lngInjectionPoint>, r2, 4
                lngIpmCorePpcCodes(7) = Converter_SwapEndian32(Asm_PPCXInstruction(31, 0, 2, lngInjectionPoint, 23)) 'lwzx r2, r0, r<lngInjectionPoint>
                lngIpmCorePpcCodes(9) = Converter_SwapEndian32(Asm_PPCXInstruction(31, 0, 2, lngInjectionPoint, 151)) 'stwx r2, r0, r<lngInjectionPoint>
                lngIpmCorePpcCodes(13) = Converter_SwapEndian32(Asm_PPCXInstruction(31, 2, 2, lngInjectionPoint, 215)) 'stbx r2, r2, r<lngInjectionPoint>
                lngIpmCorePpcCodes(14) = lngIpmCorePpcCodes(5) 'mr r2, r<lngInjectionPoint>
                lngIpmCorePpcCodes(16) = Converter_SwapEndian32(Asm_PPCDInstruction(15, 0, lngInjectionPoint, 8)) 'lis r<lngInjectionPoint>, 8
                lngInjectionPoint = lngPPCCode - lngBranchAddress - GFXPACK_IPM_CUSTOMSUBSIZE
                Print #intCemuPatchFile, "0x";
                Print #intCemuPatchFile, strXlsFields(1);
                If lngInjectionPoint < &H2000000 Then
                    lngIpmCorePpcCodes(17) = Converter_SwapEndian32(&H48000000 + lngInjectionPoint) 'b .<target address-instruction address>
                    Put intBinaryCodeFile, , lngIpmCorePpcCodes
                    Print #intCemuPatchFile, "=ba 0x";
                    Print #intCemuPatchFile, Hex(lngBranchAddress + 8)
                    lngBranchAddress = lngBranchAddress + GFXPACK_IPM_CUSTOMSUBSIZE
                Else
                    Print #intCemuPatchFile, "=b .+0x";
                    Print #intCemuPatchFile, Hex(stGfxPackInfos.lngCodeDataSize - lngPPCCode)
                    stGfxPackInfos.lngCodeDataSize = stGfxPackInfos.lngCodeDataSize + GFXPACK_IPM_CUSTOMSUBSIZE
                    'lngIpmCorePpcCodes(17) = Converter_SwapEndian32(&H48000000 + (((lngPPCCode - stGfxPackInfos.lngCodeDataSize + 8) \ 4) And &HFFFFFF) * 4) 'b .<target address-instruction address>
                    lngIpmCorePpcCodes(17) = Converter_SwapEndian32(&H48000000 + ((lngPPCCode - stGfxPackInfos.lngCodeDataSize + 8) And &H3FFFFFF)) 'b .<target address-instruction address>
                    Put intAppendedBinaryCodeFile, , lngIpmCorePpcCodes
                End If
            End If
            Gfxpack_WriteInjectionPointMonitoringPatch = Gfxpack_WriteInjectionPointMonitoringPatch - 1
        Loop Until Gfxpack_WriteInjectionPointMonitoringPatch = 0
        End With
        Close stAsmResources.intAsmMapFile
        Close stAsmResources.intAsmFile
        Close stAsmResources.intBinFile
        Close intBinaryCodeFile
        Close intAppendedBinaryCodeFile
        Close intCemuPatchFile
    End If
    Set wks = Nothing
End Function
Private Sub Gfxpack_ReadPresetSettings(ByVal strRulesFilename As String, ByRef stPreset As stGfxPreset)
Dim intFile As Integer
Dim lngLength As Long
    intFile = FreeFile
    With stPreset
    lngLength = Len(.strPresetName) + 2
    .strPresetName = "[" + .strPresetName + "]"
    .intSettingsCount = 0
    Open strRulesFilename For Input As intFile
        Do Until EOF(intFile)
            Line Input #intFile, strRulesFilename
            If Left(strRulesFilename, lngLength) = .strPresetName Then
                Do Until EOF(intFile)
                    Line Input #intFile, strRulesFilename
                    If Left(strRulesFilename, 1) = "[" Then Exit Do
                    lngLength = InStr(strRulesFilename, "=")
                    If lngLength > 1 Then
                        .strPresetName = LTrim(Left(strRulesFilename, lngLength - 1))
                        If .strPresetName <> "" Then
                            strRulesFilename = LTrim(Mid(strRulesFilename, lngLength + 1))
                            lngLength = InStr(.strPresetName, ":")
                            If lngLength <> 0 Then
                                .intSettingsCount = .intSettingsCount + 1
                                ReDim Preserve .stSettings(1 To .intSettingsCount)
                                .stSettings(.intSettingsCount).strParamName = Left(.strPresetName, lngLength - 1)
                                .strPresetName = RTrim(Mid(.strPresetName, lngLength + 1))
                                lngLength = InStr(strRulesFilename, "#")
                                If lngLength <> 0 Then strRulesFilename = Left(strRulesFilename, lngLength - 1)
                                Select Case .strPresetName
                                    Case "byte"
                                        If LCase(Left(strRulesFilename, 2)) = "0x" Then
                                            .stSettings(.intSettingsCount).varParamValue = CByte("&h" + Mid(strRulesFilename, 3))
                                        Else
                                            .stSettings(.intSettingsCount).varParamValue = CByte(strRulesFilename)
                                        End If
                                    Case "short"
                                        If LCase(Left(strRulesFilename, 2)) = "0x" Then
                                            .stSettings(.intSettingsCount).varParamValue = CInt("&h" + Mid(strRulesFilename, 3))
                                        Else
                                            .stSettings(.intSettingsCount).varParamValue = CInt(strRulesFilename)
                                        End If
                                    Case "int"
                                        If LCase(Left(strRulesFilename, 2)) = "0x" Then
                                            .stSettings(.intSettingsCount).varParamValue = CLng("&h" + Mid(strRulesFilename, 3))
                                        Else
                                            .stSettings(.intSettingsCount).varParamValue = CLng(strRulesFilename)
                                        End If
                                    Case "float"
                                        .stSettings(.intSettingsCount).varParamValue = CSng(strRulesFilename)
                                    Case "double"
                                        .stSettings(.intSettingsCount).varParamValue = CDbl(strRulesFilename)
                                End Select
                            End If
                        End If
                    End If
                Loop
                Exit Do
            End If
        Loop
    Close intFile
    End With
End Sub
Public Function Gfxpack_CollectInjectionPointMonitoringData(Optional ByRef blnSuspendCemu As Boolean = True, Optional ByVal lngIntenseExecutionThreshold As Long = 0, Optional ByVal strCemuFolderPath As String = "") As Long
'Usage example with the immediate window: ?Gfxpack_CollectInjectionPointMonitoringData(true,20,"D:\WiiU\vanilla\")
Dim stProcess As PROCESSENTRY32
Dim stCemuLogData() As stExtractedTextData
Dim wks As Worksheet
Dim lngStatFields() As Long
Dim lngLngMemoryBase As LongLong
    Set wks = Worksheets("InjectionPointMonitoring")
    wks.Range("D2:D1048576").ClearContents
    Gfxpack_CollectInjectionPointMonitoringData = wks.Range("E1").Value - 1
    If Gfxpack_CollectInjectionPointMonitoringData > 0 Then
        If Gfxpack_CollectInjectionPointMonitoringData > GFXPACK_IPM_MAXINJECTIONCOUNT Then Gfxpack_CollectInjectionPointMonitoringData = GFXPACK_IPM_MAXINJECTIONCOUNT
        strCemuFolderPath = Cemu_GetRootFolderPath(strCemuFolderPath)
        stProcess.dwFlags = File_ExtractText("Cemu.A2:C32", stCemuLogData, strCemuFolderPath + "log.txt", CEMU_LOG_WIIUMEMORYBASE)
        If stProcess.dwFlags = 1 Then
            stProcess.dwSize = Cemu_OpenProcess(SYSTEM_PROC_VMREAD, stProcess)
            If stProcess.dwSize <> 0 Then
                If System_ToogleProcessById(stProcess.th32ProcessID, CInt(blnSuspendCemu)) > 0 Then
                    Gfxpack_CollectInjectionPointMonitoringData = Gfxpack_CollectInjectionPointMonitoringData * 2
                    ReDim lngStatFields(0 To Gfxpack_CollectInjectionPointMonitoringData - 1)
                    lngLngMemoryBase = CLngLng("&H" + stCemuLogData(1).objData.Item(0).SubMatches(0)) + GFXPACK_COMMON_MEMORYBASE + &H200004
                    If ReadProcessMemory(stProcess.dwSize, lngLngMemoryBase, VarPtr(lngStatFields(0)), Gfxpack_CollectInjectionPointMonitoringData * 4, 0) <> 0 Then
                        With wks.Range("A2:D" + wks.Range("E1").Text).Cells
                            Do
                                stProcess.cntUsage = Gfxpack_CollectInjectionPointMonitoringData \ 2
                                Gfxpack_CollectInjectionPointMonitoringData = Gfxpack_CollectInjectionPointMonitoringData - 2
                                If lngStatFields(Gfxpack_CollectInjectionPointMonitoringData) = 0 Then
                                    lngLngMemoryBase = 0
                                Else
                                    lngLngMemoryBase = 4294967296^ - Converter_CULng(Converter_SwapEndian32(lngStatFields(Gfxpack_CollectInjectionPointMonitoringData)))
                                End If
                                If lngLngMemoryBase >= lngIntenseExecutionThreshold Then .Item(stProcess.cntUsage, 4).Value = lngLngMemoryBase
                            Loop Until Gfxpack_CollectInjectionPointMonitoringData = 0
                        End With
                    End If
                    Erase lngStatFields
                    System_ToogleProcessById stProcess.th32ProcessID, -CInt(blnSuspendCemu)
                End If
                CloseHandle stProcess.dwSize
            End If
            Set stCemuLogData(1).objData = Nothing
            Erase stCemuLogData
        End If
    End If
    Set wks = Nothing
End Function
Public Function Gfxpack_ImportInjectionPointMonitoringOffsets(ByVal strDataFilename As String) As Long
'Usage example with the immediate window: ?Gfxpack_WriteInjectionPointMonitoringPatch("D:\WiiU\default\dump\02000000.ipm")
'Command line to generate the 'lis r[0-31], 8' instructions 02000000.ipm file: FINDSTR /N /R /C:"lis r[0-9][0-9]*, 8" U-King.asm > 02000000.ipm
Dim intFile As Integer
Dim lngDeltaOffset As Long
    intFile = FreeFile
    Open strDataFilename For Input As intFile
    With Worksheets("InjectionPointMonitoring").Range("A2:D1048576").Cells
    .ClearContents
    lngDeltaOffset = CLng("&h" + Mid(strDataFilename, InStrRev(strDataFilename, "\") + 1, 8)) - 4
    Do Until EOF(intFile)
        Gfxpack_ImportInjectionPointMonitoringOffsets = Gfxpack_ImportInjectionPointMonitoringOffsets + 1
        Line Input #intFile, strDataFilename
        .Item(Gfxpack_ImportInjectionPointMonitoringOffsets, 1).Value = Right("0000000" + Hex((CLng(Left(strDataFilename, InStr(strDataFilename, ":") - 1))) * 4 + lngDeltaOffset), 8)
    Loop
    End With
    Close intFile
End Function
Public Function Gfxpack_InstallPatches(ByVal strGfxpackName As String, Optional ByRef blnSuspendCemu As Boolean = True, Optional ByVal strCemuFolderPath As String = "") As Long
'Usage example with the immediate window: ?Gfxpack_InstallPatches("Tools_InjectionPointMonitoring",false,"D:\WiiU\vanilla\")
Dim stProcess As PROCESSENTRY32
Dim stCemuLogData() As stExtractedTextData
Dim lngLngMemoryBase As LongLong
Dim btFileContent() As Byte
    strCemuFolderPath = Cemu_GetRootFolderPath(strCemuFolderPath)
    With stProcess
    .dwFlags = File_ExtractText("Cemu.A2:C32", stCemuLogData, strCemuFolderPath + "log.txt", CEMU_LOG_WIIUMEMORYBASE)
    If .dwFlags = 1 Then
        .dwSize = Cemu_OpenProcess(SYSTEM_PROC_VMREAD Or SYSTEM_PROC_VMWRITE Or SYSTEM_PROC_VMOPERATION, stProcess)
        If .dwSize <> 0 Then
            If System_ToogleProcessById(.th32ProcessID, CInt(blnSuspendCemu)) > 0 Then
                lngLngMemoryBase = CLngLng("&H" + stCemuLogData(1).objData.Item(0).SubMatches(0))
                strCemuFolderPath = strCemuFolderPath + "graphicPacks\" + strGfxpackName + "\"
                strGfxpackName = Dir(strCemuFolderPath + "*.ppc", vbNormal)
                Do Until strGfxpackName = ""
                    If Len(strGfxpackName) = 12 Then
                        Gfxpack_InstallPatches = File_GetContent(strCemuFolderPath + strGfxpackName, btFileContent)
                        Gfxpack_InstallPatches = WriteProcessMemory(.dwSize, lngLngMemoryBase + CLng("&h" + Left(strGfxpackName, 8)), VarPtr(btFileContent(0)), Gfxpack_InstallPatches, 0)
                        Erase btFileContent
                    End If
                    strGfxpackName = Dir
                Loop
                System_ToogleProcessById .th32ProcessID, -CInt(blnSuspendCemu)
            End If
            CloseHandle .dwSize
        End If
        Set stCemuLogData(1).objData = Nothing
        Erase stCemuLogData
    End If
    End With
End Function
Public Function Gfxpack_InjectAsmSnippet(ByVal strAsmFile As String, ByVal strSnippetEntryPoints As String, ByRef strOutputDirectory As String) As Long
'Usage example with the immediate window: ?Gfxpack_InjectAsmSnippet("D:\WiiU\vanilla\graphicPacks\!BreathOfTheWild_CEMUKingTweaks\patch_strcmp.asm","AsmSnippets.A3:C3","D:\WiiU\vanilla\graphicPacks\!BreathOfTheWild_UKingTweaks\")
Dim stAsmSub As stDataMap
Dim strEntryPoints() As String
Dim intOutFile As Integer
Dim intInFile As Integer
Dim i As Long
    Gfxpack_InjectAsmSnippet = InStr(strSnippetEntryPoints, ".")
    With Worksheets(Left(strSnippetEntryPoints, Gfxpack_InjectAsmSnippet - 1)).Range(Mid(strSnippetEntryPoints, Gfxpack_InjectAsmSnippet + 1)).Cells
        strEntryPoints = Split(.Item(1, 3).Text, vbLf)
        strSnippetEntryPoints = File_GetFolder(strAsmFile)
        Gfxpack_InjectAsmSnippet = InStr(strSnippetEntryPoints, "_")
        strSnippetEntryPoints = "_" + Converter_Str2Acronym(Left(strSnippetEntryPoints, Gfxpack_InjectAsmSnippet - 1)) + Mid(strSnippetEntryPoints, Gfxpack_InjectAsmSnippet) + "_" + .Item(1, 1).Text
    End With
    With stAsmSub
    .lngDataSize = UBound(strEntryPoints)
    ReDim .lngLowerOffsets(0 To .lngDataSize)
    i = CLng("&h" + strEntryPoints(0))
    .lngLowerOffsets(0) = i
    For Gfxpack_InjectAsmSnippet = .lngDataSize To 1 Step -1
        .lngLowerOffsets(Gfxpack_InjectAsmSnippet) = .lngLowerOffsets(0) + CLng(strEntryPoints(Gfxpack_InjectAsmSnippet))
    Next Gfxpack_InjectAsmSnippet
    Gfxpack_InjectAsmSnippet = Len(strSnippetEntryPoints)
    .lngDataSize = Gfxpack_InjectAsmSnippet + 18
    intOutFile = FreeFile
    Open strOutputDirectory + Mid(strAsmFile, InStrRev(strAsmFile, "\") + 1) For Output As intOutFile
    intInFile = FreeFile
    Open strAsmFile For Input As intInFile
    Line Input #intInFile, strAsmFile
    Do Until EOF(intInFile) Or Left(strAsmFile, 7) = ".origin"
        Print #intOutFile, strAsmFile
        Line Input #intInFile, strAsmFile
    Loop
    Print #intOutFile, "#";
    Print #intOutFile, strAsmFile
    Do Until EOF(intInFile)
        Line Input #intInFile, strAsmFile
        Select Case Left(strAsmFile, 1)
        Case "_"
            Print #intOutFile, "#";
            Print #intOutFile, strAsmFile
        Case "0"
            If Mid(strAsmFile, 18, Gfxpack_InjectAsmSnippet) = strSnippetEntryPoints Then
                Print #intOutFile, Left(strAsmFile, 15);
                i = 0
                strEntryPoints(0) = Mid(strAsmFile, .lngDataSize)
                Do Until Left(strEntryPoints(0), 1) <> "x"
                    i = i + 1
                    strEntryPoints(0) = Mid(strAsmFile, .lngDataSize + i)
                Loop
                i = .lngLowerOffsets(i) - CLng("&h" + Mid(strAsmFile, 3, 8))
                If i < 0 Then
                    Print #intOutFile, " .-0x" + Hex(Abs(i));
                Else
                    Print #intOutFile, " .+0x" + Hex(i);
                End If
                Print #intOutFile, strEntryPoints(0)
            Else
                Print #intOutFile, strAsmFile
            End If
        Case "#", ""
            Print #intOutFile, strAsmFile
        Case Else
            Print #intOutFile, "0x0";
            Print #intOutFile, Hex(i);
            Print #intOutFile, " = ";
            Print #intOutFile, strAsmFile
            i = i + 4
        End Select
    Loop
    Erase .lngLowerOffsets
    End With
    Erase strEntryPoints
    Close intInFile
    Close intOutFile
End Function
