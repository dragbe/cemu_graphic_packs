Attribute VB_Name = "Deprecated"
Option Explicit
'stInventory type size exceeds 64K -> not usable
'Public Type stInventory
'    btPadding84(1 To 84) As Byte
'    lngUsedSlotsCount As Long
'    btPadding12(1 To 12) As Byte
'    lngfreeSlotsCount As Long
'    lngPadding As Long
'    stInventoryItems(1 To 420) As stInventoryItem
'    lngPagesFirstItemPointersArrayAddress(0 To 6) As Long
'    lngPagesFirstItemAddress(0 To 20) As Long
'End Type

Public Function Deprecated_Botw_GetInventoryDataAddress(ByVal intFile As Integer, ByRef lngDeltaOffset As Long) As Long
    Get intFile, 273062265 - lngDeltaOffset, Deprecated_Botw_GetInventoryDataAddress ' 273062265 = 0x10470000 - 0x6688 + 1
    Deprecated_Botw_GetInventoryDataAddress = Converter_SwapEndian(Deprecated_Botw_GetInventoryDataAddress)
End Function

Public Function Deprecated_Botw_MemorySearcherInventoryDataIniFile(ByVal strDumpFolderPath As String, Optional ByVal ITEMTYPEFILTER As BOTW_INVENTORYITEM_FILTERS = BOTW_ALLITEMS, Optional ByVal strItemIdFilter As String = "*") As Long
'strDumpFolderPath: Cemu dump folder path with \ as last character
Dim objInventoryItem As stInventoryItem
Dim strSearchString As String * 15
Dim i As Integer
Dim lngStartOffset As Long
Dim lngDeltaOffset As Long
Dim intInputFile As Integer
Dim intOutputFile As Integer
    Deprecated_Botw_MemorySearcherInventoryDataIniFile = 0
    intInputFile = Cemu_openDumpFile(strDumpFolderPath, lngDeltaOffset)
    Get intInputFile, Deprecated_Botw_GetInventoryDataAddress(intInputFile, lngDeltaOffset) - lngDeltaOffset + 228613, lngStartOffset '&H37CEC + 25 = 228613
    Get intInputFile, Converter_SwapEndian(lngStartOffset) - lngDeltaOffset + 1, lngStartOffset
    Deprecated_Botw_MemorySearcherInventoryDataIniFile = Converter_SwapEndian(lngStartOffset)
    lngStartOffset = Deprecated_Botw_MemorySearcherInventoryDataIniFile - lngDeltaOffset + 1
    Get intInputFile, lngStartOffset + 36, strSearchString
    If strSearchString = "Obj_DRStone_Get" Then
        objInventoryItem.lngPreviousItemAddress = lngStartOffset
        intOutputFile = FreeFile
        Open strDumpFolderPath + "00050000101c9X00.inventorydata.ini" For Output As intOutputFile
        Do
            Get intInputFile, objInventoryItem.lngPreviousItemAddress, objInventoryItem
            If objInventoryItem.lngStr64TypeSize = 1073741824 Then
                If (ITEMTYPEFILTER And (2^ ^ Converter_SwapEndian(objInventoryItem.lngType))) <> 0 Then
                    strDumpFolderPath = Left(objInventoryItem.strId, InStr(objInventoryItem.strId, Chr(0)) - 1)
                    If strDumpFolderPath Like strItemIdFilter Then Print #intOutputFile, "[Entry]" + vbCrLf + "description=" + strDumpFolderPath + " (Qty|Dur)" + vbCrLf + "address=0x" + Hex(Deprecated_Botw_MemorySearcherInventoryDataIniFile + &H10) + vbCrLf + "type=int32" + vbCrLf + "value=" + vbCrLf
                End If
            End If
            Deprecated_Botw_MemorySearcherInventoryDataIniFile = Converter_SwapEndian(objInventoryItem.lngPreviousItemAddress)
            objInventoryItem.lngPreviousItemAddress = Deprecated_Botw_MemorySearcherInventoryDataIniFile - lngDeltaOffset + 1
        Loop Until objInventoryItem.lngPreviousItemAddress = lngStartOffset
        Close intOutputFile
    End If
    Close intInputFile
End Function
