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
Private Deprecated_lngPPCAsmConditionalBranchs(1 To 6)
Public Function Deprecated_Botw_GetInventoryDataAddress(ByVal intFile As Integer, ByRef lngDeltaOffset As Long) As Long
    Get intFile, 273062265 - lngDeltaOffset, Deprecated_Botw_GetInventoryDataAddress ' 273062265 = 0x10470000 - 0x6688 + 1
    Deprecated_Botw_GetInventoryDataAddress = Converter_SwapEndian32(Deprecated_Botw_GetInventoryDataAddress)
End Function
Public Function Deprecated_Botw_MemorySearcherInventoryDataIniFile(ByVal strDumpFolderPath As String, Optional ByVal ITEMTYPEFILTER As BOTW_INVENTORYITEM_FILTERS = BOTW_ALLITEMS, Optional ByVal strItemIdFilter As String = "*") As Long
'strDumpFolderPath: Cemu dump folder path with \ as last character
Dim objInventoryItem As stInventoryItem
Dim strSearchString As String * 15
Dim i As Integer
Dim lngStartOffset As Long
Dim intInputFile As Integer
Dim intOutputFile As Integer
    intInputFile = Cemu_OpenDumpFile(strDumpFolderPath, CEMU_DUMP_10000000)
    Get intInputFile, Deprecated_Botw_GetInventoryDataAddress(intInputFile, CEMU_DUMP_10000000) - CEMU_DUMP_10000000 + 228613, lngStartOffset '&H37CEC + 25 = 228613
    Get intInputFile, Converter_SwapEndian32(lngStartOffset) - CEMU_DUMP_10000000 + 1, lngStartOffset
    Deprecated_Botw_MemorySearcherInventoryDataIniFile = Converter_SwapEndian32(lngStartOffset)
    lngStartOffset = Deprecated_Botw_MemorySearcherInventoryDataIniFile - CEMU_DUMP_10000000 + 1
    Get intInputFile, lngStartOffset + 36, strSearchString
    If strSearchString = "Obj_DRStone_Get" Then
        objInventoryItem.lngPreviousItemAddress = lngStartOffset
        intOutputFile = FreeFile
        Open strDumpFolderPath + "00050000101c9X00.inventorydata.ini" For Output As intOutputFile
        Do
            Get intInputFile, objInventoryItem.lngPreviousItemAddress, objInventoryItem
            If objInventoryItem.lngStr64TypeSize = 1073741824 Then
                If (ITEMTYPEFILTER And (2^ ^ Converter_SwapEndian32(objInventoryItem.lngType))) <> 0 Then
                    strDumpFolderPath = StrConv(objInventoryItem.btActorName, vbUnicode)
                    strDumpFolderPath = Left(strDumpFolderPath, InStr(strDumpFolderPath, vbNullChar) - 1)
                    If strDumpFolderPath Like strItemIdFilter Then Print #intOutputFile, "[Entry]" + vbCrLf + "description=" + strDumpFolderPath + " (Qty|Dur)" + vbCrLf + "address=0x" + Hex(Deprecated_Botw_MemorySearcherInventoryDataIniFile + &H10) + vbCrLf + "type=int32" + vbCrLf + "value=" + vbCrLf
                End If
            End If
            Deprecated_Botw_MemorySearcherInventoryDataIniFile = Converter_SwapEndian32(objInventoryItem.lngPreviousItemAddress)
            objInventoryItem.lngPreviousItemAddress = Deprecated_Botw_MemorySearcherInventoryDataIniFile - CEMU_DUMP_10000000 + 1
        Loop Until objInventoryItem.lngPreviousItemAddress = lngStartOffset
        Close intOutputFile
    End If
    Close intInputFile
End Function
Private Sub Deprecated_InitPPCConditionalBranchsVector()
    If Deprecated_lngPPCAsmConditionalBranchs(1) = 0 Then
        Deprecated_lngPPCAsmConditionalBranchs(1) = &H41820000 'beq [?Asm_PPCBInstruction(16, 12, 2, 0, false, false)]
        Deprecated_lngPPCAsmConditionalBranchs(2) = &H40820000 'bne [?Asm_PPCBInstruction(16, 4, 2, 0, false, false)]
        Deprecated_lngPPCAsmConditionalBranchs(3) = &H41810000 'bgt [?Asm_PPCBInstruction(16, 12, 1, 0, false, false)]
        Deprecated_lngPPCAsmConditionalBranchs(4) = &H40800000 'bge [?Asm_PPCBInstruction(16, 4, 0, 0, false, false)]
        Deprecated_lngPPCAsmConditionalBranchs(5) = &H41800000 'blt [?Asm_PPCBInstruction(16, 12, 0, 0, false, false)]
        Deprecated_lngPPCAsmConditionalBranchs(6) = &H40810000 'ble [?Asm_PPCBInstruction(16, 4, 1, 0, false, false)]
    End If
End Sub
Private Function Deprecated_SearchPPCSJCB(ByVal lngFile As Long, ByVal lngTargetBranch As Long, ByRef lngInstructionAddresses() As Long, Optional ByVal lngDeltaOffset As Long = 0) As Long
'b[eq|ne|gt|ge|lt|le] .+0x?
Dim lngDataSegment() As Long
Dim lngStartOffset As Long
    lngTargetBranch = lngTargetBranch - lngDeltaOffset + 1
    If lngTargetBranch > 0 Then
        Call Deprecated_InitPPCConditionalBranchsVector
        lngStartOffset = lngTargetBranch - &HFFFC&
        If lngStartOffset < 1 Then lngStartOffset = 1
        lngTargetBranch = (lngTargetBranch - lngStartOffset) \ 4
        Call File_ReadLongDataSegment(lngFile, lngStartOffset, lngTargetBranch, lngDataSegment())
        lngStartOffset = lngStartOffset + lngDeltaOffset - 1
        lngTargetBranch = lngTargetBranch + 1
        For lngFile = lngTargetBranch - 1 To 1 Step -1
            For lngDeltaOffset = 1 To 6
                If Converter_SwapEndian32(lngDataSegment(lngFile)) = Deprecated_lngPPCAsmConditionalBranchs(lngDeltaOffset) + (lngTargetBranch - lngFile) * 4 Then
                    Deprecated_SearchPPCSJCB = Deprecated_SearchPPCSJCB + 1
                    ReDim Preserve lngInstructionAddresses(1 To Deprecated_SearchPPCSJCB)
                    lngInstructionAddresses(Deprecated_SearchPPCSJCB) = lngStartOffset + (lngFile - 1) * 4
                End If
            Next lngDeltaOffset
        Next lngFile
        Erase lngDataSegment
    End If
End Function
Private Function Deprecated_SearchPPCBJCB(ByVal lngFile As Long, ByVal lngTargetBranch As Long, ByRef lngInstructionAddresses() As Long, Optional ByVal lngDeltaOffset As Long = 0) As Long
'b[eq|ne|gt|ge|lt|le] .-0x?
Dim lngDataSegment() As Long
    lngTargetBranch = lngTargetBranch - lngDeltaOffset + 1
    Call Deprecated_InitPPCConditionalBranchsVector
    Call File_ReadLongDataSegment(lngFile, lngTargetBranch, &H1FFF&, lngDataSegment)
    lngTargetBranch = lngTargetBranch + lngDeltaOffset - 1
    For lngFile = &H1FFF& To 1 Step -1
        For lngDeltaOffset = 1 To 6
            If Converter_SwapEndian32(lngDataSegment(lngFile)) = Deprecated_lngPPCAsmConditionalBranchs(lngDeltaOffset) + (((lngFile - 1) * -4) And &HFFFF&) Then
                Deprecated_SearchPPCBJCB = Deprecated_SearchPPCBJCB + 1
                ReDim Preserve lngInstructionAddresses(1 To Deprecated_SearchPPCBJCB)
                lngInstructionAddresses(Deprecated_SearchPPCBJCB) = lngTargetBranch + (lngFile - 1) * 4
            End If
        Next lngDeltaOffset
    Next lngFile
    Erase lngDataSegment
End Function
Public Function Deprecated_SearchPPCBXX(ByRef strExecutableDumpFile As String, ByVal lngTargetBranch As Long, Optional ByRef blnVerbose As Boolean = True) As Long
'Usage example with the immediate window: ?Deprecated_SearchPPCBXX("D:\WiiU\Default\dump\02000000.bin",&H37FD600)
Dim lngDeltaOffset As Long
Dim lngInstructionAddresses() As Long
Dim intFile As Integer
Dim i As Long
    lngDeltaOffset = File_GetDumpOffset(Mid(strExecutableDumpFile, InStrRev(strExecutableDumpFile, "\") + 1))
    intFile = FreeFile
    Open strExecutableDumpFile For Binary Access Read As intFile
    Deprecated_SearchPPCBXX = Deprecated_SearchPPCSJCB(intFile, lngTargetBranch, lngInstructionAddresses, lngDeltaOffset)
    If blnVerbose Then
        For i = Deprecated_SearchPPCBXX To 1 Step -1
            Debug.Print ("0x" + Hex(lngInstructionAddresses(i)))
        Next i
    End If
    Erase lngInstructionAddresses
    i = Deprecated_SearchPPCBJCB(intFile, lngTargetBranch, lngInstructionAddresses, lngDeltaOffset)
    Deprecated_SearchPPCBXX = Deprecated_SearchPPCBXX + i
    If blnVerbose Then
        Do Until i = 0
            Debug.Print ("0x" + Hex(lngInstructionAddresses(i)))
            i = i - 1
        Loop
    End If
    Erase lngInstructionAddresses
    Close intFile
End Function
Private Function Deprecated_SearchPPCB48(ByVal lngFile As Long, ByVal lngTargetBranch As Long, ByRef lngInstructionAddresses() As Long, Optional ByVal lngDeltaOffset As Long = 0, Optional ByVal lngLongJump As Long = 0, Optional ByVal btBranchLink As Byte = 0) As Long
'b[l] .+0x?
Dim lngDataSegment() As Long
Dim lngStartOffset As Long
    lngTargetBranch = lngTargetBranch - lngDeltaOffset + 1 - lngLongJump
    If lngTargetBranch > 0 Then
        lngStartOffset = lngTargetBranch - &HFFFFFC
        If lngStartOffset < 1 Then lngStartOffset = 1
        lngTargetBranch = (lngTargetBranch - lngStartOffset) \ 4
        Call File_ReadLongDataSegment(lngFile, lngStartOffset, lngTargetBranch, lngDataSegment())
        lngLongJump = lngLongJump + &H48000000 + btBranchLink
        lngStartOffset = lngStartOffset + lngDeltaOffset - 1
        lngTargetBranch = lngTargetBranch + 1
        For lngFile = lngTargetBranch - 1 To 1 Step -1
            If Converter_SwapEndian32(lngDataSegment(lngFile)) = lngLongJump + (lngTargetBranch - lngFile) * 4 Then
                Deprecated_SearchPPCB48 = Deprecated_SearchPPCB48 + 1
                ReDim Preserve lngInstructionAddresses(1 To Deprecated_SearchPPCB48)
                lngInstructionAddresses(Deprecated_SearchPPCB48) = lngStartOffset + (lngFile - 1) * 4
            End If
        Next lngFile
        Erase lngDataSegment
    End If
End Function
Private Function Deprecated_SearchPPCBl48(ByVal lngFile As Long, ByVal lngTargetBranch As Long, ByRef lngInstructionAddresses() As Long, Optional ByVal lngDeltaOffset As Long = 0, Optional ByVal lngLongJump As Long = 0) As Long
'bl .+0x?
    Deprecated_SearchPPCBl48 = Deprecated_SearchPPCB48(lngFile, lngTargetBranch, lngInstructionAddresses, lngDeltaOffset, lngLongJump, 1)
End Function
Private Function Deprecated_SearchPPCB4B(ByVal lngFile As Long, ByVal lngTargetBranch As Long, ByRef lngInstructionAddresses() As Long, Optional ByVal lngDeltaOffset As Long = 0, Optional ByVal lngLongJump As Long = 0, Optional ByVal btBranchLink As Byte = 0) As Long
'b[l] .-0x?
Dim lngDataSegment() As Long
    lngTargetBranch = lngTargetBranch - lngDeltaOffset + 1 + lngLongJump
    Call File_ReadLongDataSegment(lngFile, lngTargetBranch, &H3FFFFF, lngDataSegment)
    lngLongJump = &H4B000000 - lngLongJump
    lngTargetBranch = lngTargetBranch + lngDeltaOffset - 1
    For lngFile = &H3FFFFF To 1 Step -1
        If Converter_SwapEndian32(lngDataSegment(lngFile)) = lngLongJump + (((lngFile - 1) * -4 + btBranchLink) And &HFFFFFF) Then
            Deprecated_SearchPPCB4B = Deprecated_SearchPPCB4B + 1
            ReDim Preserve lngInstructionAddresses(1 To Deprecated_SearchPPCB4B)
            lngInstructionAddresses(Deprecated_SearchPPCB4B) = lngTargetBranch + (lngFile - 1) * 4
        End If
    Next lngFile
    Erase lngDataSegment
End Function
Private Function Deprecated_SearchPPCBl4B(ByVal lngFile As Long, ByVal lngTargetBranch As Long, ByRef lngInstructionAddresses() As Long, Optional ByVal lngDeltaOffset As Long = 0, Optional ByVal lngLongJump As Long = 0) As Long
'bl .-0x?
    Deprecated_SearchPPCBl4B = Deprecated_SearchPPCB4B(lngFile, lngTargetBranch, lngInstructionAddresses, lngDeltaOffset, lngLongJump, 1)
End Function
Private Function Deprecated_SearchPPCB49(ByVal lngFile As Long, ByVal lngTargetBranch As Long, ByRef lngInstructionAddresses() As Long, Optional ByVal lngDeltaOffset As Long = 0) As Long
'b .+0x? (long jump)
    Deprecated_SearchPPCB49 = Deprecated_SearchPPCB48(lngFile, lngTargetBranch, lngInstructionAddresses, lngDeltaOffset, &H1000000)
End Function
Private Function Deprecated_SearchPPCB4A(ByVal lngFile As Long, ByVal lngTargetBranch As Long, ByRef lngInstructionAddresses() As Long, Optional ByVal lngDeltaOffset As Long = 0) As Long
'b .-0x? (long jump)
    Deprecated_SearchPPCB4A = Deprecated_SearchPPCB4B(lngFile, lngTargetBranch, lngInstructionAddresses, lngDeltaOffset, &H1000000)
End Function
Public Function Deprecated_SearchPPCB(ByRef strExecutableDumpFile As String, ByVal lngTargetBranch As Long, Optional ByRef blnVerbose As Boolean = True) As Long
'Usage example with the immediate window: ?Deprecated_SearchPPCB("D:\WiiU\Default\dump\02000000.bin",&H249e2e0)
Dim lngDeltaOffset As Long
Dim lngInstructionAddresses() As Long
Dim intFile As Integer
Dim i As Long
    lngDeltaOffset = File_GetDumpOffset(Mid(strExecutableDumpFile, InStrRev(strExecutableDumpFile, "\") + 1))
    intFile = FreeFile
    Open strExecutableDumpFile For Binary Access Read As intFile
    Deprecated_SearchPPCB = Deprecated_SearchPPCB48(intFile, lngTargetBranch, lngInstructionAddresses, lngDeltaOffset)
    If blnVerbose Then
        For i = Deprecated_SearchPPCB To 1 Step -1
            Debug.Print ("0x" + Hex(lngInstructionAddresses(i)))
        Next i
    End If
    Erase lngInstructionAddresses
    i = Deprecated_SearchPPCB49(intFile, lngTargetBranch, lngInstructionAddresses, lngDeltaOffset)
    Deprecated_SearchPPCB = Deprecated_SearchPPCB + i
    If blnVerbose Then
        Do Until i = 0
            Debug.Print ("0x" + Hex(lngInstructionAddresses(i)))
            i = i - 1
        Loop
    End If
    Erase lngInstructionAddresses
    i = Deprecated_SearchPPCB4A(intFile, lngTargetBranch, lngInstructionAddresses, lngDeltaOffset)
    Deprecated_SearchPPCB = Deprecated_SearchPPCB + i
    If blnVerbose Then
        Do Until i = 0
            Debug.Print ("0x" + Hex(lngInstructionAddresses(i)))
            i = i - 1
        Loop
    End If
    Erase lngInstructionAddresses
    i = Deprecated_SearchPPCB4B(intFile, lngTargetBranch, lngInstructionAddresses, lngDeltaOffset)
    Deprecated_SearchPPCB = Deprecated_SearchPPCB + i
    If blnVerbose Then
        Do Until i = 0
            Debug.Print ("0x" + Hex(lngInstructionAddresses(i)))
            i = i - 1
        Loop
    End If
    Erase lngInstructionAddresses
    Close intFile
End Function
Private Function Deprecated_SearchPPCBl49(ByVal lngFile As Long, ByVal lngTargetBranch As Long, ByRef lngInstructionAddresses() As Long, Optional ByVal lngDeltaOffset As Long = 0) As Long
'bl .+0x? (long jump)
    Deprecated_SearchPPCBl49 = Deprecated_SearchPPCBl48(lngFile, lngTargetBranch, lngInstructionAddresses, lngDeltaOffset, &H1000000)
End Function
Private Function Deprecated_SearchPPCBl4A(ByVal lngFile As Long, ByVal lngTargetBranch As Long, ByRef lngInstructionAddresses() As Long, Optional ByVal lngDeltaOffset As Long = 0) As Long
'bl .-0x? (long jump)
    Deprecated_SearchPPCBl4A = Deprecated_SearchPPCBl4B(lngFile, lngTargetBranch, lngInstructionAddresses, lngDeltaOffset, &H1000000)
End Function
Public Function Deprecated_SearchPPCBl(ByRef strExecutableDumpFile As String, ByVal lngTargetBranch As Long, Optional ByRef blnVerbose As Boolean = True) As Long
'Usage example with the immediate window: ?Deprecated_SearchPPCBl("D:\WiiU\Default\dump\02000000.bin",&H249e2e0)
Dim lngDeltaOffset As Long
Dim lngInstructionAddresses() As Long
Dim intFile As Integer
Dim i As Long
    lngDeltaOffset = File_GetDumpOffset(Mid(strExecutableDumpFile, InStrRev(strExecutableDumpFile, "\") + 1))
    intFile = FreeFile
    Open strExecutableDumpFile For Binary Access Read As intFile
    Deprecated_SearchPPCBl = Deprecated_SearchPPCBl48(intFile, lngTargetBranch, lngInstructionAddresses, lngDeltaOffset)
    If blnVerbose Then
        For i = Deprecated_SearchPPCBl To 1 Step -1
            Debug.Print ("0x" + Hex(lngInstructionAddresses(i)))
        Next i
    End If
    Erase lngInstructionAddresses
    i = Deprecated_SearchPPCBl49(intFile, lngTargetBranch, lngInstructionAddresses, lngDeltaOffset)
    Deprecated_SearchPPCBl = Deprecated_SearchPPCBl + i
    If blnVerbose Then
        Do Until i = 0
            Debug.Print ("0x" + Hex(lngInstructionAddresses(i)))
            i = i - 1
        Loop
    End If
    Erase lngInstructionAddresses
    i = Deprecated_SearchPPCBl4A(intFile, lngTargetBranch, lngInstructionAddresses, lngDeltaOffset)
    Deprecated_SearchPPCBl = Deprecated_SearchPPCBl + i
    If blnVerbose Then
        Do Until i = 0
            Debug.Print ("0x" + Hex(lngInstructionAddresses(i)))
            i = i - 1
        Loop
    End If
    Erase lngInstructionAddresses
    i = Deprecated_SearchPPCBl4B(intFile, lngTargetBranch, lngInstructionAddresses, lngDeltaOffset)
    Deprecated_SearchPPCBl = Deprecated_SearchPPCBl + i
    If blnVerbose Then
        Do Until i = 0
            Debug.Print ("0x" + Hex(lngInstructionAddresses(i)))
            i = i - 1
        Loop
    End If
    Erase lngInstructionAddresses
    Close intFile
End Function
Public Function Deprecated_SearchPPCBranch(ByRef strExecutableDumpFile As String, ByVal lngTargetBranch As Long, Optional ByRef blnVerbose As Boolean = True) As Long
'Usage example with the immediate window: ?Deprecated_SearchPPCBranch("D:\WiiU\Default\dump\02000000.bin",&H29E9464)
    Debug.Print "b branches count: " + CStr(Deprecated_SearchPPCB(strExecutableDumpFile, lngTargetBranch, blnVerbose))
    Debug.Print "bc branches count: " + CStr(Deprecated_SearchPPCBXX(strExecutableDumpFile, lngTargetBranch, blnVerbose))
    Debug.Print "bl branches count: " + CStr(Deprecated_SearchPPCBl(strExecutableDumpFile, lngTargetBranch, blnVerbose))
End Function
