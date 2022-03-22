Attribute VB_Name = "GfxPACK"
Option Explicit

Public Function Gfxpack_Str2Asm(ByVal strValue As String, Optional ByVal btFieldSize As Byte = 32) As String
'Usage example with the immediate window: ?Gfxpack_Str2Asm("Zelda")
Dim strWord As String
Dim btLength As Byte
    btLength = Len(strValue)
    btFieldSize = (btFieldSize - btLength) \ 4
    Do Until btFieldSize = 0
        btFieldSize = btFieldSize - 1
        Gfxpack_Str2Asm = Gfxpack_Str2Asm + ".int 0" + vbCrLf
    Loop
    btFieldSize = btLength Mod 4
    If btFieldSize = 0 Then
        btFieldSize = btLength + 1
    Else
        btFieldSize = btLength - btFieldSize + 5
    End If
    Do Until btFieldSize = 1
        btFieldSize = btFieldSize - 4
        strWord = Mid(strValue, btFieldSize, 4)
        Gfxpack_Str2Asm = ".int " + CStr(Converter_Asc2Int(Left(strWord + Chr(0) + Chr(0) + Chr(0), 4))) + " # " + strWord + vbCrLf + Gfxpack_Str2Asm
    Loop
    Gfxpack_Str2Asm = ".int " + CStr(btLength) + vbCrLf + Gfxpack_Str2Asm
End Function

Public Function Gfxpack_GetUserDefinedMapUnitData(ByVal strDataTypes As String, ByRef strDataLabel As String) As String
'Usage example with the immediate window: ?Gfxpack_GetUserDefinedMapUnitData("int|int|float|float", "Food service")
Dim i As Integer
Dim j As Integer
Dim strDataTypesNames() As String
    strDataTypesNames = Split(strDataTypes, "|")
    strDataTypes = " " + strDataLabel + vbCrLf
    For i = UBound(strDataTypesNames) To 0 Step -1
        strDataTypes = strDataTypes + "." + strDataTypesNames(i) + " 0" + vbCrLf
    Next i
    For i = 65 To 74
        strDataTypesNames(0) = Chr(i)
        For j = 1 To 8
            Gfxpack_GetUserDefinedMapUnitData = Gfxpack_GetUserDefinedMapUnitData + "# " + strDataTypesNames(0) + "-" + CStr(j) + strDataTypes
        Next j
    Next i
    Erase strDataTypesNames
End Function

Public Function Gfxpack_getCodeCave(ByRef strCemuLogFilePath As String, ByRef strGfxpackName As String, ByRef lngCodeCaveSize As Long) As Long
Dim stCemuLogData() As stExtractedTextData
Dim strTempFilePath As String
    strTempFilePath = File_getTempFilePath
    If strTempFilePath <> "" Then
        lngCodeCaveSize = FreeFile
        Open strTempFilePath For Output As lngCodeCaveSize
            Print #lngCodeCaveSize, "1 \] Activate graphic pack: +.+/(" + Converter_Str2RegExp(strGfxpackName) + ").*$" + vbCrLf + "100 \] Applying patch group '.+' \(Codecave: ([0-9a-fA-F]{8}-[0-9a-fA-F]{8})\)$"
        Close lngCodeCaveSize
        lngCodeCaveSize = File_ExtractText(strTempFilePath, stCemuLogData, strCemuLogFilePath)
        If lngCodeCaveSize <> 0 Then
            If lngCodeCaveSize > 1 Then
                If stCemuLogData(lngCodeCaveSize).objData.Item(0).SubMatches(0) = strGfxpackName Then
                    Gfxpack_getCodeCave = stCemuLogData(lngCodeCaveSize).intLine
                    lngCodeCaveSize = lngCodeCaveSize - 1
                    If Gfxpack_getCodeCave - stCemuLogData(lngCodeCaveSize).intLine = 1 Then
                        Gfxpack_getCodeCave = CLng("&H" + Left(stCemuLogData(lngCodeCaveSize).objData.Item(0).SubMatches(0), 8))
                        lngCodeCaveSize = CLng("&H" + Mid(stCemuLogData(lngCodeCaveSize).objData.Item(0).SubMatches(0), 10)) - Gfxpack_getCodeCave
                    Else
                        Gfxpack_getCodeCave = 0
                    End If
                End If
            End If
            Erase stCemuLogData
        End If
        Kill strTempFilePath
    End If
End Function
