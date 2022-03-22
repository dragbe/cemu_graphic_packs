Attribute VB_Name = "ASM"
Option Explicit

Private Function Asm_SearchPPCB48(ByVal lngFile As Long, ByVal lngTargetBranch As Long, ByRef lngInstructionAddresses() As Long, Optional ByVal lngDeltaOffset As Long = 0, Optional ByVal lngLongJump As Long = 0, Optional ByVal btBranchLink As Byte = 0) As Long
'b[l] .+0x?
Dim lngDataSegment() As Long
Dim lngStartOffset As Long
    lngTargetBranch = lngTargetBranch - lngDeltaOffset + 1 - lngLongJump
    If lngTargetBranch > 0 Then
        lngStartOffset = lngTargetBranch - &HFFFFFC
        If lngStartOffset < 1 Then lngStartOffset = 1
        lngTargetBranch = (lngTargetBranch - lngStartOffset) / 4
        Call File_ReadLongDataSegment(lngFile, lngStartOffset, lngTargetBranch, lngDataSegment())
        For lngFile = lngTargetBranch To 1 Step -1
            If Converter_SwapEndian(lngDataSegment(lngFile)) = lngLongJump + &H48000000 + ((lngTargetBranch - lngFile + 1) * 4 + btBranchLink) Then
                Asm_SearchPPCB48 = Asm_SearchPPCB48 + 1
                ReDim Preserve lngInstructionAddresses(1 To Asm_SearchPPCB48)
                lngInstructionAddresses(Asm_SearchPPCB48) = lngStartOffset + (lngFile - 1) * 4 + lngDeltaOffset - 1
            End If
        Next lngFile
        Erase lngDataSegment
    End If
End Function

Private Function Asm_SearchPPCBl48(ByVal lngFile As Long, ByVal lngTargetBranch As Long, ByRef lngInstructionAddresses() As Long, Optional ByVal lngDeltaOffset As Long = 0, Optional ByVal lngLongJump As Long = 0) As Long
'bl .+0x?
    Asm_SearchPPCBl48 = Asm_SearchPPCB48(lngFile, lngTargetBranch, lngInstructionAddresses, lngDeltaOffset, lngLongJump, 1)
End Function

Private Function Asm_SearchPPCB4B(ByVal lngFile As Long, ByVal lngTargetBranch As Long, ByRef lngInstructionAddresses() As Long, Optional ByVal lngDeltaOffset As Long = 0, Optional ByVal lngLongJump As Long = 0, Optional ByVal btBranchLink As Byte = 0) As Long
'b[l] .-0x?
Dim lngDataSegment() As Long
    lngTargetBranch = lngTargetBranch - lngDeltaOffset + 1 + lngLongJump
    Call File_ReadLongDataSegment(lngFile, lngTargetBranch, &H3FFFFF, lngDataSegment)
    For lngFile = &H3FFFFF To 1 Step -1
        If Converter_SwapEndian(lngDataSegment(lngFile)) = &H4B000000 - lngLongJump + (((lngFile - 1) * -4 + btBranchLink) And &HFFFFFF) Then
            Asm_SearchPPCB4B = Asm_SearchPPCB4B + 1
            ReDim Preserve lngInstructionAddresses(1 To Asm_SearchPPCB4B)
            lngInstructionAddresses(Asm_SearchPPCB4B) = lngTargetBranch + (lngFile - 1) * 4 + lngDeltaOffset - 1
        End If
    Next lngFile
    Erase lngDataSegment
End Function

Private Function Asm_SearchPPCBl4B(ByVal lngFile As Long, ByVal lngTargetBranch As Long, ByRef lngInstructionAddresses() As Long, Optional ByVal lngDeltaOffset As Long = 0, Optional ByVal lngLongJump As Long = 0) As Long
'bl .-0x?
    Asm_SearchPPCBl4B = Asm_SearchPPCB4B(lngFile, lngTargetBranch, lngInstructionAddresses, lngDeltaOffset, lngLongJump, 1)
End Function

Private Function Asm_SearchPPCB49(ByVal lngFile As Long, ByVal lngTargetBranch As Long, ByRef lngInstructionAddresses() As Long, Optional ByVal lngDeltaOffset As Long = 0) As Long
'b .+0x? (long jump)
    Asm_SearchPPCB49 = Asm_SearchPPCB48(lngFile, lngTargetBranch, lngInstructionAddresses, lngDeltaOffset, &H1000000)
End Function

Private Function Asm_SearchPPCB4A(ByVal lngFile As Long, ByVal lngTargetBranch As Long, ByRef lngInstructionAddresses() As Long, Optional ByVal lngDeltaOffset As Long = 0) As Long
'b .-0x? (long jump)
    Asm_SearchPPCB4A = Asm_SearchPPCB4B(lngFile, lngTargetBranch, lngInstructionAddresses, lngDeltaOffset, &H1000000)
End Function

Public Function Asm_SearchPPCB(ByRef strExecutableDumpFile As String, ByVal lngTargetBranch As Long) As Long
'Usage example with the immediate window: ?Asm_SearchPPCB("D:\WiiU\1.25.6\dump\02000000.bin",&H249e2e0)
Dim lngDeltaOffset As Long
Dim lngInstructionAddresses() As Long
Dim intFile As Integer
Dim i As Long
    lngDeltaOffset = File_getDumpOffset(Mid(strExecutableDumpFile, InStrRev(strExecutableDumpFile, "\") + 1))
    intFile = FreeFile
    Open strExecutableDumpFile For Binary As intFile
    Asm_SearchPPCB = Asm_SearchPPCB48(intFile, lngTargetBranch, lngInstructionAddresses, lngDeltaOffset)
    For i = Asm_SearchPPCB To 1 Step -1
        Debug.Print ("0x" + Hex(lngInstructionAddresses(i)))
    Next i
    Erase lngInstructionAddresses
    i = Asm_SearchPPCB49(intFile, lngTargetBranch, lngInstructionAddresses, lngDeltaOffset)
    Asm_SearchPPCB = Asm_SearchPPCB + i
    Do Until i = 0
        Debug.Print ("0x" + Hex(lngInstructionAddresses(i)))
        i = i - 1
    Loop
    Erase lngInstructionAddresses
    i = Asm_SearchPPCB4A(intFile, lngTargetBranch, lngInstructionAddresses, lngDeltaOffset)
    Asm_SearchPPCB = Asm_SearchPPCB + i
    Do Until i = 0
        Debug.Print ("0x" + Hex(lngInstructionAddresses(i)))
        i = i - 1
    Loop
    Erase lngInstructionAddresses
    i = Asm_SearchPPCB4B(intFile, lngTargetBranch, lngInstructionAddresses, lngDeltaOffset)
    Asm_SearchPPCB = Asm_SearchPPCB + i
    Do Until i = 0
        Debug.Print ("0x" + Hex(lngInstructionAddresses(i)))
        i = i - 1
    Loop
    Erase lngInstructionAddresses
    Close intFile
End Function

Private Function Asm_SearchPPCBl49(ByVal lngFile As Long, ByVal lngTargetBranch As Long, ByRef lngInstructionAddresses() As Long, Optional ByVal lngDeltaOffset As Long = 0) As Long
'bl .+0x? (long jump)
    Asm_SearchPPCBl49 = Asm_SearchPPCBl48(lngFile, lngTargetBranch, lngInstructionAddresses, lngDeltaOffset, &H1000000)
End Function

Private Function Asm_SearchPPCBl4A(ByVal lngFile As Long, ByVal lngTargetBranch As Long, ByRef lngInstructionAddresses() As Long, Optional ByVal lngDeltaOffset As Long = 0) As Long
'bl .-0x? (long jump)
    Asm_SearchPPCBl4A = Asm_SearchPPCBl4B(lngFile, lngTargetBranch, lngInstructionAddresses, lngDeltaOffset, &H1000000)
End Function

Public Function Asm_SearchPPCBl(ByRef strExecutableDumpFile As String, ByVal lngTargetBranch As Long) As Long
'Usage example with the immediate window: ?Asm_SearchPPCBl("D:\WiiU\1.25.6\dump\02000000.bin",&H249e2e0)
Dim lngDeltaOffset As Long
Dim lngInstructionAddresses() As Long
Dim intFile As Integer
Dim i As Long
    lngDeltaOffset = File_getDumpOffset(Mid(strExecutableDumpFile, InStrRev(strExecutableDumpFile, "\") + 1))
    intFile = FreeFile
    Open strExecutableDumpFile For Binary As intFile
    Asm_SearchPPCBl = Asm_SearchPPCBl48(intFile, lngTargetBranch, lngInstructionAddresses, lngDeltaOffset)
    For i = Asm_SearchPPCBl To 1 Step -1
        Debug.Print ("0x" + Hex(lngInstructionAddresses(i)))
    Next i
    Erase lngInstructionAddresses
    i = Asm_SearchPPCBl49(intFile, lngTargetBranch, lngInstructionAddresses, lngDeltaOffset)
    Asm_SearchPPCBl = Asm_SearchPPCBl + i
    Do Until i = 0
        Debug.Print ("0x" + Hex(lngInstructionAddresses(i)))
        i = i - 1
    Loop
    Erase lngInstructionAddresses
    i = Asm_SearchPPCBl4A(intFile, lngTargetBranch, lngInstructionAddresses, lngDeltaOffset)
    Asm_SearchPPCBl = Asm_SearchPPCBl + i
    Do Until i = 0
        Debug.Print ("0x" + Hex(lngInstructionAddresses(i)))
        i = i - 1
    Loop
    Erase lngInstructionAddresses
    i = Asm_SearchPPCBl4B(intFile, lngTargetBranch, lngInstructionAddresses, lngDeltaOffset)
    Asm_SearchPPCBl = Asm_SearchPPCBl + i
    Do Until i = 0
        Debug.Print ("0x" + Hex(lngInstructionAddresses(i)))
        i = i - 1
    Loop
    Erase lngInstructionAddresses
    Close intFile
End Function

Public Function Asm_PPCAsmSubs(ByRef strExecutableDumpFile As String, ByVal intInstructionsCount As Integer, Optional ByVal lngCodeRegionStart As Long = &H0, Optional ByVal lngCodeRegionEnd As Long = &H2388EF2) As Integer
'blr = &H4E800020 -> 536903758 = Converter_SwapEndian(&H4E800020)
'Usage example with the immediate window: ?Asm_PPCAsmSubs("D:\WiiU\1.23.0\dump\02000000.bin",3)
'Output: D:\WiiU\1.23.0\dump\Asm_PPCAsmSubs.3
Dim intSkipBytes As Integer
Dim lngInstructions() As Long
Dim i As Integer
Dim intFile As Integer
Dim lngDeltaOffset As Long
    lngCodeRegionStart = lngCodeRegionStart + 1
    Asm_PPCAsmSubs = FreeFile
    i = InStrRev(strExecutableDumpFile, "\")
    Open Left(strExecutableDumpFile, i) + "Asm_PPCAsmSubs." + CStr(intInstructionsCount) For Output As Asm_PPCAsmSubs
    intFile = FreeFile
    Open strExecutableDumpFile For Binary As intFile
    intInstructionsCount = intInstructionsCount + 2
    intSkipBytes = intInstructionsCount * 4
    ReDim lngInstructions(1 To intInstructionsCount)
    lngDeltaOffset = File_getDumpOffset(Mid(strExecutableDumpFile, i + 1)) + 3
    Do Until EOF(intFile) Or lngCodeRegionStart > lngCodeRegionEnd
        Get intFile, lngCodeRegionStart, lngInstructions
        For i = intInstructionsCount To 1 Step -1
            If lngInstructions(i) = 536903758 Then Exit For
        Next i
        Select Case i
        Case 0
            lngCodeRegionStart = lngCodeRegionStart + intSkipBytes
        Case 1
            lngCodeRegionStart = lngCodeRegionStart + 4
        Case Else
            If i <> intInstructionsCount Then
                lngCodeRegionStart = lngCodeRegionStart + (i - 1) * 4
            Else
                If lngInstructions(1) = 536903758 Then
                    lngInstructions(1) = lngCodeRegionStart
                    lngCodeRegionStart = lngCodeRegionStart + (i - 1) * 4
                    For i = intInstructionsCount - 1 To 2 Step -1
                        If lngInstructions(i) = 536903758 Then Exit For
                    Next i
                    If i = 1 Then Print #Asm_PPCAsmSubs, Hex(lngInstructions(1) + lngDeltaOffset)
                Else
                    lngCodeRegionStart = lngCodeRegionStart + (i - 1) * 4
                End If
            End If
        End Select
    Loop
    Close intFile
    Close Asm_PPCAsmSubs
    Erase lngInstructions
End Function
