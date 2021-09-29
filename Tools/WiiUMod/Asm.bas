Attribute VB_Name = "ASM"
Option Explicit

Private Function Asm_SearchPPCBl48(ByVal lngFile As Long, ByVal lngTargetBl As Long, ByRef lngInstructionAddresses() As Long, Optional ByVal lngDeltaOffset As Long = 0) As Long
'bl .+0x?
Dim lngDataSegment() As Long
Dim lngStartOffset As Long
    lngTargetBl = lngTargetBl - lngDeltaOffset + 1
    lngStartOffset = lngTargetBl - &HFFFFFC
    If lngStartOffset < 1 Then lngStartOffset = 1
    lngTargetBl = (lngTargetBl - lngStartOffset) / 4
    Call File_ReadLongDataSegment(lngFile, lngStartOffset, lngTargetBl, lngDataSegment())
    Asm_SearchPPCBl48 = 0
    For lngFile = lngTargetBl To 1 Step -1
        If Converter_SwapEndian(lngDataSegment(lngFile)) = &H48000000 + ((lngTargetBl - lngFile + 1) * 4 + 1) Then
            Asm_SearchPPCBl48 = Asm_SearchPPCBl48 + 1
            ReDim Preserve lngInstructionAddresses(1 To Asm_SearchPPCBl48)
            lngInstructionAddresses(Asm_SearchPPCBl48) = lngStartOffset + (lngFile - 1) * 4 + lngDeltaOffset - 1
        End If
    Next lngFile
    Erase lngDataSegment
End Function

Private Function Asm_SearchPPCBl4B(ByVal lngFile As Long, ByVal lngTargetBl As Long, ByRef lngInstructionAddresses() As Long, Optional ByVal lngDeltaOffset As Long = 0) As Long
'bl .-0x?
Dim lngDataSegment() As Long
    lngTargetBl = lngTargetBl - lngDeltaOffset + 1
    Call File_ReadLongDataSegment(lngFile, lngTargetBl, &H3FFFFF, lngDataSegment)
    Asm_SearchPPCBl4B = 0
    For lngFile = &H3FFFFF To 1 Step -1
        If Converter_SwapEndian(lngDataSegment(lngFile)) = &H4B000000 + (((lngFile - 1) * -4 + 1) And &HFFFFFF) Then
            Asm_SearchPPCBl4B = Asm_SearchPPCBl4B + 1
            ReDim Preserve lngInstructionAddresses(1 To Asm_SearchPPCBl4B)
            lngInstructionAddresses(Asm_SearchPPCBl4B) = lngTargetBl + (lngFile - 1) * 4 + lngDeltaOffset - 1
        End If
    Next lngFile
    Erase lngDataSegment
End Function

Public Function Asm_SearchPPCBl(ByRef strExecutableDumpFile As String, ByVal lngTargetBl As Long) As Long
'Usage example with the immediate window: ?Asm_SearchPPCBl("D:\WiiU\1.23.0\dump\02000000.bin",&H249e2e0)
Dim lngDeltaOffset As Long
Dim lngInstructionAddresses() As Long
Dim intFile As Integer
Dim i As Long
    lngDeltaOffset = File_getDumpOffset(Mid(strExecutableDumpFile, InStrRev(strExecutableDumpFile, "\") + 1))
    intFile = FreeFile
    Open strExecutableDumpFile For Binary As intFile
    Asm_SearchPPCBl = Asm_SearchPPCBl48(intFile, lngTargetBl, lngInstructionAddresses, lngDeltaOffset)
    For i = Asm_SearchPPCBl To 1 Step -1
        Debug.Print ("0x" + Hex(lngInstructionAddresses(Asm_SearchPPCBl)))
    Next i
    Erase lngInstructionAddresses
    i = Asm_SearchPPCBl + Asm_SearchPPCBl4B(intFile, lngTargetBl, lngInstructionAddresses, lngDeltaOffset)
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
