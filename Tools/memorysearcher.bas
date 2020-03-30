Attribute VB_Name = "memorysearcher"
Option Explicit
Public Enum INVENTORYITEMTYPEFILTERS
    ONLYSWORDS = 1
    ONLYBOWS = 2
    ONLYARROWS = 4
    ONLYSHIELDS = 8
    ONLYHEADARMORS = 16
    ONLYUPPERARMORS = 32
    ONLYLOWERARMORS = 64
    ONLYMATERIALS = 128
    ONLYFOODS = 256
    ONLYKEYITEMS = 512
    ALLITEMS = ONLYSWORDS Or ONLYBOWS Or ONLYARROWS Or ONLYSHIELDS Or ONLYHEADARMORS Or ONLYUPPERARMORS Or ONLYLOWERARMORS Or ONLYMATERIALS Or ONLYFOODS Or ONLYKEYITEMS
End Enum
Public Type stRecipeIngredient
    lngRecipeIngredientIdAddress As Long
    lngLessUsefulField As Long
    lngRecipeIngredientIdSize As Long
    strRecipeIngredientId As String * 64
End Type
Public Type stRecipe
    objIngredients(1 To 5) As stRecipeIngredient
    lngRecipeIngredientsAddresses(1 To 5) As Long
End Type
Public Type stInventoryItem
    lngPreviousItemAddress As Long
    lngNextItemAddress As Long
    lngType As Long
    lngFlag As Long 'lngBurnableFlag ???
    lngQtyDur As Long
    lngEquippedFlag As Long
    lngIdAddress As Long
    lngLessUsefulField As Long
    lngIdFieldSize As Long
    strId As String * 64
    lngBonusValue As Long
    lngLessUsefulBonusField As Long
    lngBonusType As Long
    'btLessUsefulData(1 To 16) As Byte
    'lngRecipeIngredientsAddressesArrayPointer As Long
    'lngZeroField As Long
    'lngRecipeAddress As Long
    'objRecipe As stRecipe
End Type

Public Function swapEndian(ByVal lngData As Long) As Long
    swapEndian = (((lngData And &HFF000000) \ &H1000000) And &HFF&) Or ((lngData And &HFF0000) \ &H100&) Or ((lngData And &HFF00&) * &H100&) Or ((lngData And &H7F&) * &H1000000)
    If (lngData And &H80&) Then swapEndian = swapEndian Or &H80000000
End Function

Public Function getInventoryMemorySearcherData(ByVal strRamDumpFile As String, Optional ByVal ITEMTYPEFILTER As INVENTORYITEMTYPEFILTERS = ALLITEMS, Optional ByVal strItemIdFilter As String = "*", Optional ByVal lngStartOffset As Long = &H40000000) As Long
'strRamDumpFile: Cemu RAM dump (02000000.bin) path
Dim objInventoryItem As stInventoryItem
Dim btBuffer(1 To 1024) As Byte
Dim strSearchString As String * 15
Dim i As Integer
    getInventoryMemorySearcherData = 0
    Open strRamDumpFile For Binary As #1
        Seek #1, lngStartOffset
        Do Until EOF(1)
            Get #1, , btBuffer
            For i = 1 To 1024
                If btBuffer(i) = 64 Then
                    lngStartOffset = Seek(1) - 1024 + i
                    Get #1, lngStartOffset, strSearchString
                    If strSearchString = "Obj_DRStone_Get" Then
                        lngStartOffset = lngStartOffset - 36
                        Get #1, lngStartOffset, objInventoryItem
                        If objInventoryItem.lngType = 150994944 Then
                            objInventoryItem.lngNextItemAddress = swapEndian(objInventoryItem.lngNextItemAddress) - 33554431
                            i = InStrRev(strRamDumpFile, "\")
                            strRamDumpFile = IIf(i > 0, Left$(strRamDumpFile, i), "")
                            Open strRamDumpFile + "00050000101c9X00.ini" For Output As #2
                            Do Until objInventoryItem.lngNextItemAddress = lngStartOffset
                                getInventoryMemorySearcherData = objInventoryItem.lngNextItemAddress
                                Get #1, objInventoryItem.lngNextItemAddress, objInventoryItem
                                objInventoryItem.lngNextItemAddress = swapEndian(objInventoryItem.lngNextItemAddress) - 33554431
                                If objInventoryItem.lngIdFieldSize = 1073741824 Then
                                    If (ITEMTYPEFILTER And (2^ ^ swapEndian(objInventoryItem.lngType))) <> 0 Then
                                        strRamDumpFile = Left(objInventoryItem.strId, InStr(objInventoryItem.strId, Chr(0)) - 1)
                                        If strRamDumpFile Like strItemIdFilter Then Print #2, "[Entry]" + vbCrLf + "description=" + strRamDumpFile + " (Qty|Dur)" + vbCrLf + "address=0x" + Hex(getInventoryMemorySearcherData + 33554447) + vbCrLf + "type=int32" + vbCrLf + "value=" + vbCrLf + vbCrLf + "[Entry]" + vbCrLf + "description=" + strRamDumpFile + " (Equipped flag)" + vbCrLf + "address=0x" + Hex(getInventoryMemorySearcherData + 33554451) + vbCrLf + "type=int32" + vbCrLf + "value=" + vbCrLf
                                    End If
                                End If
                            Loop
                            Close #2
                            Close #1
                            getInventoryMemorySearcherData = objInventoryItem.lngNextItemAddress - 1
                            Exit Function
                        End If
                    End If
                    Exit For
                End If
            Next i
        Loop
    Close #1
End Function

Public Function asc2int(ByVal strValue As String) As LongLong
Dim i As Byte
Dim j As Byte
Dim btLength As Byte
Dim strBytes As String * 2
    asc2int = 0
    strValue = Left(strValue, 8)
    btLength = Len(strValue)
    For i = 1 To btLength
        strBytes = Right("0" + Hex(Asc(Mid(strValue, i, 1))), 2)
        For j = 1 To 2
            asc2int = asc2int + CLngLng((16^ ^ ((btLength - i) * 2 + 2 - j)) * CByte("&H" + Mid(strBytes, j, 1)))
        Next j
    Next i
End Function

Public Function int2hex(ByVal lngValue As LongLong) As String
    int2hex = ""
    Do
        int2hex = Hex(lngValue Mod 16) + int2hex
        lngValue = lngValue \ 16
    Loop Until lngValue = 0
End Function

Public Function int2asc(ByVal strValue As String) As String
Dim lngValue As LongLong
    lngValue = CLngLng(strValue)
    strValue = int2hex(lngValue)
    lngValue = Len(strValue)
    If lngValue Mod 2 = 1 Then
        strValue = "0" + strValue
        lngValue = lngValue + 1
    End If
    int2asc = ""
    For lngValue = lngValue - 1 To 1 Step -2
        int2asc = Chr(CLng("&H" & Mid(strValue, CLng(lngValue), 2))) + int2asc
    Next lngValue
End Function
