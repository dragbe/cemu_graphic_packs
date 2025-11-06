Attribute VB_Name = "ASM"
Option Explicit
Private Enum ASM_BRANCH_JUMPS
    ASM_BRANCH_SHORTJUMP = &H7FFC&
    ASM_BRANCH_LONGJUMP = &H1FFFFFC
End Enum
Private Const ASM_GPRSCOUNT As Byte = 32
Private lngPPCAsmConditionalBranchs(1 To 6)
Private btTranslatedRegisters(0 To ASM_GPRSCOUNT - 1)
Private Type stAsmDataFiles
    intAsmFile As Integer
    intAsmMapFile As Integer
    intBinFile As Integer
    lngDeltaOffset As Long
End Type
Public stAsmResources As stAsmDataFiles
Private strSnippetVars(0 To 7) As String
Private Function Asm_IsSetRegisterPPCInstruction(ByRef strAssemblyInstruction As String) As Boolean
Static stSetRegisterInstructions(25, 7) As String
Dim i As Byte
Dim j As Byte
    If stSetRegisterInstructions(0, 0) = "" Then
        stSetRegisterInstructions(0, 0) = "add"
        stSetRegisterInstructions(0, 1) = "and"
        stSetRegisterInstructions(2, 0) = "clr"
        stSetRegisterInstructions(2, 1) = "cnt"
        stSetRegisterInstructions(3, 0) = "div"
        stSetRegisterInstructions(4, 0) = "eqv"
        stSetRegisterInstructions(4, 1) = "ext"
        stSetRegisterInstructions(8, 0) = "ins"
        stSetRegisterInstructions(11, 0) = "la"
        stSetRegisterInstructions(11, 1) = "lb"
        stSetRegisterInstructions(11, 2) = "lh"
        stSetRegisterInstructions(11, 3) = "li"
        stSetRegisterInstructions(11, 4) = "lm"
        stSetRegisterInstructions(11, 5) = "ls"
        stSetRegisterInstructions(11, 6) = "lw"
        stSetRegisterInstructions(12, 0) = "mf"
        stSetRegisterInstructions(12, 1) = "mr"
        stSetRegisterInstructions(12, 2) = "mul"
        stSetRegisterInstructions(13, 0) = "nand"
        stSetRegisterInstructions(13, 1) = "neg"
        stSetRegisterInstructions(13, 2) = "nor"
        stSetRegisterInstructions(13, 3) = "not"
        stSetRegisterInstructions(14, 0) = "or"
        stSetRegisterInstructions(17, 0) = "rl"
        stSetRegisterInstructions(17, 1) = "rot"
        stSetRegisterInstructions(18, 0) = "sl"
        stSetRegisterInstructions(18, 1) = "sr"
        stSetRegisterInstructions(18, 2) = "sub"
        stSetRegisterInstructions(23, 0) = "xor"
    End If
    i = Asc(Left(strAssemblyInstruction, 1)) - 97
    If stSetRegisterInstructions(i, 0) <> "" Then
        Do
            Asm_IsSetRegisterPPCInstruction = (stSetRegisterInstructions(i, j) = Left(strAssemblyInstruction, Len(stSetRegisterInstructions(i, j))))
            j = j + 1
        Loop Until Asm_IsSetRegisterPPCInstruction Or stSetRegisterInstructions(i, j) = ""
    End If
End Function
Public Function Asm_IsUsablePPCRa(ByRef strAssemblyInstruction As String, Optional ByVal btExcludedRegister As Byte = 2) As Byte
'Usage example with the immediate window: ?Asm_IsUsablePPCRa("lwz r3, 0x0(r31)")
Dim i As Long
Dim strRegister As String
    If Asm_IsSetRegisterPPCInstruction(strAssemblyInstruction) Then
        i = InStr(strAssemblyInstruction, " ")
        If i = 0 Then
            Asm_IsUsablePPCRa = 255
        Else
            Asm_IsUsablePPCRa = CByte(Mid(strAssemblyInstruction, i + 2, 2))
            If Asm_IsUsablePPCRa = btExcludedRegister Then
                Asm_IsUsablePPCRa = 255
            Else
                strRegister = "r" + CStr(Asm_IsUsablePPCRa)
                i = InStr(i + 4, strAssemblyInstruction, strRegister)
                If Len(strRegister) = 2 Then
                    Do Until i = 0
                        If IsNumeric(Mid(strAssemblyInstruction, i + 2, 1)) Then
                            i = InStr(i + 3, strAssemblyInstruction, strRegister)
                        Else
                            Asm_IsUsablePPCRa = 255
                            Exit Do
                        End If
                    Loop
                Else
                    If i <> 0 Then Asm_IsUsablePPCRa = 255
                End If
            End If
        End If
    Else
        Asm_IsUsablePPCRa = 255
    End If
End Function
Private Sub Asm_InitPPCConditionalBranchsVector()
    If lngPPCAsmConditionalBranchs(1) = 0 Then
        lngPPCAsmConditionalBranchs(1) = &H41820000 'beq [?Asm_PPCBInstruction(16, 12, 2, 0, false, false)]
        lngPPCAsmConditionalBranchs(2) = &H40820000 'bne [?Asm_PPCBInstruction(16, 4, 2, 0, false, false)]
        lngPPCAsmConditionalBranchs(3) = &H41810000 'bgt [?Asm_PPCBInstruction(16, 12, 1, 0, false, false)]
        lngPPCAsmConditionalBranchs(4) = &H40800000 'bge [?Asm_PPCBInstruction(16, 4, 0, 0, false, false)]
        lngPPCAsmConditionalBranchs(5) = &H41800000 'blt [?Asm_PPCBInstruction(16, 12, 0, 0, false, false)]
        lngPPCAsmConditionalBranchs(6) = &H40810000 'ble [?Asm_PPCBInstruction(16, 4, 1, 0, false, false)]
    End If
End Sub
Private Function Asm_SearchPPCBc(ByVal lngFile As Long, ByVal lngTargetBranch As Long, ByRef lngInstructionAddresses() As Long, Optional ByVal lngDeltaOffset As Long = 0) As Long
'b[eq|ne|gt|ge|lt|le] .[+|-]0x?
Dim lngDataSegment() As Long
Dim lngStartOffset As Long
    If lngTargetBranch >= lngDeltaOffset Then
        Call Asm_InitPPCConditionalBranchsVector
        lngStartOffset = lngTargetBranch - ASM_BRANCH_SHORTJUMP
        If lngStartOffset < lngDeltaOffset Then lngStartOffset = lngDeltaOffset
        Asm_SearchPPCBc = 1 + ((lngTargetBranch - lngStartOffset + ASM_BRANCH_SHORTJUMP) \ 4)
        Call File_ReadLongDataSegment(lngFile, lngStartOffset - lngDeltaOffset + 1, Asm_SearchPPCBc, lngDataSegment())
        lngFile = Asm_SearchPPCBc
        lngStartOffset = lngStartOffset + lngFile * 4
        Asm_SearchPPCBc = 0
        Do
            lngStartOffset = lngStartOffset - 4
            For lngDeltaOffset = 1 To 6
                'If Converter_SwapEndian32(lngDataSegment(lngFile)) = lngPPCAsmConditionalBranchs(lngDeltaOffset) + (((lngTargetBranch - lngStartOffset) \ 4) And &H3FFF&) * 4 Then
                If Converter_SwapEndian32(lngDataSegment(lngFile)) = lngPPCAsmConditionalBranchs(lngDeltaOffset) + ((lngTargetBranch - lngStartOffset) And &HFFFF&) Then
                    Asm_SearchPPCBc = Asm_SearchPPCBc + 1
                    ReDim Preserve lngInstructionAddresses(1 To Asm_SearchPPCBc)
                    lngInstructionAddresses(Asm_SearchPPCBc) = lngStartOffset
                End If
            Next lngDeltaOffset
            lngFile = lngFile - 1
        Loop Until lngFile = 0
        Erase lngDataSegment
    End If
End Function
Private Function Asm_SearchPPCBx(ByVal lngFile As Long, ByVal lngTargetBranch As Long, ByRef lngInstructionAddresses() As Long, Optional ByVal lngDeltaOffset As Long = 0) As Long
'b[l] .[+|-]0x?
Dim lngDataSegment() As Long
Dim lngStartOffset As Long
    If lngTargetBranch >= lngDeltaOffset Then
        lngStartOffset = lngTargetBranch - ASM_BRANCH_LONGJUMP
        If lngStartOffset < lngDeltaOffset Then lngStartOffset = lngDeltaOffset
        Asm_SearchPPCBx = 1 + ((lngTargetBranch - lngStartOffset + ASM_BRANCH_LONGJUMP) \ 4)
        Call File_ReadLongDataSegment(lngFile, lngStartOffset - lngDeltaOffset + 1, Asm_SearchPPCBx, lngDataSegment())
        lngFile = Asm_SearchPPCBx
        lngStartOffset = lngStartOffset + lngFile * 4
        Asm_SearchPPCBx = 0
        Do
            lngStartOffset = lngStartOffset - 4
            'If ((Converter_SwapEndian32(lngDataSegment(lngFile)) Xor (&H48000000 + (((lngTargetBranch - lngStartOffset) \ 4) And &HFFFFFF) * 4)) Or 1) = 1 Then
            If ((Converter_SwapEndian32(lngDataSegment(lngFile)) Xor (&H48000000 + ((lngTargetBranch - lngStartOffset) And &H3FFFFFF))) Or 1) = 1 Then
                Asm_SearchPPCBx = Asm_SearchPPCBx + 1
                ReDim Preserve lngInstructionAddresses(1 To Asm_SearchPPCBx)
                lngInstructionAddresses(Asm_SearchPPCBx) = lngStartOffset
            End If
            lngFile = lngFile - 1
        Loop Until lngFile = 0
        Erase lngDataSegment
    End If
End Function
Public Function Asm_SearchPPCBranches(ByRef strExecutableDumpFile As String, ByVal lngTargetBranch As Long, Optional ByRef blnVerbose As Boolean = True) As Long
'Usage example with the immediate window: ?Asm_SearchPPCBranches("D:\WiiU\Default\dump\02000000.bin",&H249e2e0)
Dim lngDeltaOffset As Long
Dim lngInstructionAddresses() As Long
Dim intFile As Integer
Dim i As Long
    lngDeltaOffset = File_GetDumpOffset(Mid(strExecutableDumpFile, InStrRev(strExecutableDumpFile, "\") + 1))
    intFile = FreeFile
    Open strExecutableDumpFile For Binary Access Read As intFile
    Asm_SearchPPCBranches = Asm_SearchPPCBx(intFile, lngTargetBranch, lngInstructionAddresses, lngDeltaOffset)
    Debug.Print "b[l] branches count: ";
    Debug.Print CStr(Asm_SearchPPCBranches)
    If blnVerbose Then
        For i = Asm_SearchPPCBranches To 1 Step -1
            Debug.Print ("0x" + Hex(lngInstructionAddresses(i)))
        Next i
    End If
    Erase lngInstructionAddresses
    i = Asm_SearchPPCBc(intFile, lngTargetBranch, lngInstructionAddresses, lngDeltaOffset)
    Debug.Print "bc branches count: ";
    Debug.Print CStr(i)
    Asm_SearchPPCBranches = Asm_SearchPPCBranches + i
    If blnVerbose Then
        Do Until i = 0
            Debug.Print ("0x" + Hex(lngInstructionAddresses(i)))
            i = i - 1
        Loop
    End If
    Erase lngInstructionAddresses
    Close intFile
End Function
Public Function Asm_ExistZeroByte(ByVal lngword As Long) As Boolean
    lngword = (lngword - &H1010101) And (Not lngword) And &H80808080
    Debug.Print Right("0000000" + Hex(lngword), 8)
    Asm_ExistZeroByte = (lngword <> 0)
End Function
Public Function Asm_FormatPpcAsmFile() As Long
Dim strTokens() As String
Dim strLine As String
Dim strComment As String
Dim i As Long
Dim lngCharOffset As Long
Dim intInFile As Integer
Dim intOutFile As Integer
'Dim lngLine As Long
    intInFile = FreeFile
    Open "D:\WiiU\default\dump\U-King.ppc" For Input As intInFile
    intOutFile = FreeFile
    Open "D:\WiiU\default\dump\U-King.asm" For Output As intOutFile
    Do Until EOF(intInFile)
        Line Input #intInFile, strLine
        'lngLine = lngLine + 1
        strTokens = Split(strLine, " ", 2)
        If Right(strTokens(0), 1) = ":" Then
            Print #intOutFile, strTokens(0);
            If UBound(strTokens) = 0 Then
                strComment = ""
            Else
                strComment = " " + strTokens(1)
            End If
            Erase strTokens
        Else
            Select Case Right(strTokens(0), 5)
            Case ".byte"
                Asm_FormatPpcAsmFile = Len(strTokens(0))
                Print #intOutFile, Left(strTokens(0), Asm_FormatPpcAsmFile - 4) + "long 0x" + Right("0" + Mid(strTokens(1), 1 + InStr(strTokens(1), "0x") * 2, 2), 2);
                If Asm_FormatPpcAsmFile <> 5 Then
                    Asm_FormatPpcAsmFile = InStr(strTokens(1), "#")
                    If Asm_FormatPpcAsmFile <> 0 Then strComment = " " + Mid(strTokens(1), Asm_FormatPpcAsmFile)
                End If
                Erase strTokens
                Asm_FormatPpcAsmFile = 3
                Do
                    Line Input #intInFile, strLine
                    'lngLine = lngLine + 1
                    strTokens = Split(strLine, " ", 2)
                    If strTokens(0) <> ".byte" Then
                        Asm_FormatPpcAsmFile = 1
                        'Debug.Print CStr(lngLine);
                        Debug.Print ">.byte string expected"
                    Else
                        Print #intOutFile, Right("0" + Mid(strTokens(1), 1 + InStr(strTokens(1), "0x") * 2, 2), 2);
                    End If
                    Erase strTokens
                    Asm_FormatPpcAsmFile = Asm_FormatPpcAsmFile - 1
                Loop Until Asm_FormatPpcAsmFile = 0
            Case ".long"
                If Asc(Left(strTokens(1), 1)) - 48 < 10 Then
                    Print #intOutFile, Left(strTokens(0), Len(strTokens(0)) - 4);
                    strLine = strTokens(1)
                    Erase strTokens
                    strTokens = Split(strLine, " ")
                    Asm_FormatPpcAsmFile = UBound(strTokens) - 1
                    For i = 0 To Asm_FormatPpcAsmFile
                        If strTokens(i + 1) = "#" Then Exit For
                        lngCharOffset = 1 + InStr(strTokens(i), "0x") * 2
                        Print #intOutFile, "long 0x" + Right("0000000" + Mid(strTokens(i), lngCharOffset, InStr(strTokens(i), ",") - lngCharOffset), 8) + vbCrLf + ".";
                    Next i
                    Print #intOutFile, "long 0x" + Right("0000000" + Mid(strTokens(i), 1 + InStr(strTokens(i), "0x") * 2), 8);
                    Do Until i > Asm_FormatPpcAsmFile
                        i = i + 1
                        Print #intOutFile, " " + strTokens(i);
                    Loop
                    Erase strTokens
                Else
                    Print #intOutFile, strLine;
                    Erase strTokens
                End If
            Case Else
                Print #intOutFile, strLine;
                Erase strTokens
            End Select
            Print #intOutFile, strComment
            strComment = ""
        End If
    Loop
    Close intOutFile
    Close intInFile
End Function
Public Function Asm_PPCBInstruction(ByRef btOpcode As Byte, ByVal btBo As Byte, ByVal btBi As Byte, ByVal intBd As Integer, ByRef blnAa As Boolean, ByRef blnLk As Boolean) As Long
'beq target
'...
    Asm_PPCBInstruction = Converter_CSLng(btOpcode * &H4000000^ + &H200000 * btBo + &H10000 * btBi + intBd * 4^ + IIf(blnAa, 2, 0) + IIf(blnLk, 1, 0))
End Function
Public Function Asm_PPCIInstruction(ByRef btOpcode As Byte, ByVal lngLI As Long, ByRef blnAa As Boolean, ByRef blnLk As Boolean) As Long
'b[l][a] target
'...
    Asm_PPCIInstruction = Converter_CSLng(btOpcode * &H4000000^ + lngLI * 4 + IIf(blnAa, 2, 0) + IIf(blnLk, 1, 0))
End Function
Public Function Asm_PPCBranch(ByRef lngTargetAddress As Long, Optional ByRef lngInstructionAddress As Long = 0, Optional ByRef blnLr As Boolean = False) As Long
'Asm_PPCBranch = Asm_PPCBranch + (((lngTargetAddress - lngInstructionAddress) \ 4) And &HFFFFFF) * 4
    If blnLr Then
        Asm_PPCBranch = &H48000001
    Else
        Asm_PPCBranch = &H48000000
    End If
    If lngInstructionAddress = 0 Then
        Asm_PPCBranch = Asm_PPCBranch + lngTargetAddress + 2
    Else
        Asm_PPCBranch = Asm_PPCBranch + ((lngTargetAddress - lngInstructionAddress) And &H3FFFFFF)
    End If
End Function
Public Function Asm_PPCXInstruction(ByRef btOpcode As Byte, ByVal btRa As Byte, ByVal btRs As Byte, ByVal btRb As Byte, ByRef intExtOpCode As Integer, Optional ByRef blnCr As Boolean = False) As Long
'or[.] Ra, Rs, Rb
'and[.] Ra, Rs, Rb
'stwx Rs, Ra, Rb
'lwzx Rs, Ra, Rb
'stbx Rs, Ra, Rb
'...
    Asm_PPCXInstruction = Converter_CSLng(btOpcode * &H4000000^ + &H200000 * btRs + &H10000 * btRa + &H800^ * btRb + 2 * intExtOpCode + IIf(blnCr, 1, 0))
End Function
Public Function Asm_PPCDInstruction(ByRef btOpcode As Byte, ByVal btRa As Byte, ByVal btRs As Byte, ByVal lngNum16 As Long) As Long
'stw Rs, Num16(Ra)
'addi Rs, Ra, Int16
'oris Ra, Rs, UInt16
'...
    Asm_PPCDInstruction = Converter_CSLng(btOpcode * &H4000000^ + &H200000 * btRs + &H10000 * btRa + (lngNum16 And &HFFFF&))
End Function
Public Function Asm_PPCMInstruction(ByRef btOpcode As Byte, ByVal btRa As Byte, ByVal btRs As Byte, ByRef btSh As Byte, ByRef btMb As Byte, ByRef btMe As Byte, Optional ByRef blnCr As Boolean = False) As Long
'rlwinm Ra, Rs, Sh, Mb, Me
'...
    Asm_PPCMInstruction = Converter_CSLng(btOpcode * &H4000000^ + &H200000 * btRs + &H10000 * btRa + &H800^ * btSh + &H40 * btMb + 2 * btMe + IIf(blnCr, 1, 0))
End Function
Public Function Asm_PPCXOInstruction(ByRef btOpcode As Byte, ByVal btRa As Byte, ByVal btRs As Byte, ByRef intExtOpCode As Integer, Optional ByRef blnOe As Boolean = False, Optional ByRef blnCr As Boolean = False) As Long
'neg Rs, Ra
'...
    Asm_PPCXOInstruction = Converter_CSLng(btOpcode * &H4000000^ + &H200000 * btRs + &H10000 * btRa + &H400 * IIf(blnOe, 1, 0) + 2 * intExtOpCode + IIf(blnCr, 1, 0))
End Function
Public Function Asm_ReadInstruction(ByVal lngInstructionOffset As Long, ByRef lngPPCCode As Long) As String
Dim strAsm As String * 64
    With stAsmResources
    lngInstructionOffset = lngInstructionOffset + 1 - .lngDeltaOffset
    If .intBinFile <> 0 Then Get .intBinFile, lngInstructionOffset, lngPPCCode
    Get .intAsmMapFile, lngInstructionOffset, lngInstructionOffset
    Get .intAsmFile, lngInstructionOffset + 1, strAsm
    End With
    lngInstructionOffset = InStr(strAsm, vbCr)
    If lngInstructionOffset = 0 Then
        Asm_ReadInstruction = RTrim(Left(strAsm, InStr(strAsm, "#") - 1))
    Else
        Asm_ReadInstruction = Left(strAsm, lngInstructionOffset - 1)
        lngInstructionOffset = InStr(Asm_ReadInstruction, "#")
        If lngInstructionOffset <> 0 Then Asm_ReadInstruction = RTrim(Left(Asm_ReadInstruction, lngInstructionOffset - 1))
    End If
    Asm_ReadInstruction = Mid(Asm_ReadInstruction, InStr(Asm_ReadInstruction, ":") + 1)
End Function
Private Function Asm_PrintCodeOffset(ByRef lngCodeOffset As Long) As String
    If lngCodeOffset >= 0 Then
        Asm_PrintCodeOffset = "[" + Asm_ReadInstruction(lngCodeOffset, lngCodeOffset) + "]"
        Debug.Print "0x0";
        Debug.Print Hex(lngCodeOffset);
        Debug.Print " = ";
        lngCodeOffset = lngCodeOffset + 4
    End If
End Function
Private Sub Asm_PrintCodeOffsets(ByRef lngCodeOffset As Long, ByVal btOffsetsCount As Byte, Optional ByRef strCommentChar As String = "#")
    Do Until btOffsetsCount = 0
        Debug.Print " " + strCommentChar + " " + Asm_PrintCodeOffset(lngCodeOffset)
        btOffsetsCount = btOffsetsCount - 1
    Loop
End Sub
Private Function Asm_PPCBranchTarget(ByRef ASM_BRANCH_JUMP As ASM_BRANCH_JUMPS, ByRef lngTo As Long, Optional ByRef lngFrom As Long = 0) As Long
    If lngTo < 0 Then
        If lngTo >= -ASM_BRANCH_JUMP And lngTo <= -8 Then Asm_PPCBranchTarget = lngTo
    Else
        If lngTo >= 8 And lngTo <= ASM_BRANCH_JUMP Then
            Asm_PPCBranchTarget = lngTo
        Else
            If lngTo = lngFrom Then
                Asm_PPCBranchTarget = 0
            Else
                Asm_PPCBranchTarget = lngTo - lngFrom
                Asm_PPCBranchTarget = Asm_PPCBranchTarget(ASM_BRANCH_JUMP, Asm_PPCBranchTarget, Asm_PPCBranchTarget)
            End If
        End If
    End If
End Function
Private Function Asm_PPCAsmBranchTarget(ByRef ASM_BRANCH_JUMP As ASM_BRANCH_JUMPS, ByVal lngTo As Long, Optional ByRef lngFrom As Long = 0) As String
    lngTo = Asm_PPCBranchTarget(ASM_BRANCH_JUMP, lngTo, lngFrom)
    If lngTo < 0 Then
        Asm_PPCAsmBranchTarget = "-0x" + Hex(Abs(lngTo))
    Else
        Asm_PPCAsmBranchTarget = "+0x" + Hex(lngTo)
    End If
End Function
Public Sub Asm_FreeResources()
    With stAsmResources
    If .intBinFile = 0 Then Close .intBinFile
    If .intAsmFile <> 0 Then
        Close .intAsmFile
        Close .intAsmMapFile
    End If
    End With
End Sub
Public Sub Asm_LoadResources(ByRef strAsmFilename As String, Optional ByRef str02000000BinFile As String = "")
    With stAsmResources
    .lngDeltaOffset = CEMU_DUMP_02000000
    If str02000000BinFile = "" Then
        .intBinFile = 0
    Else
        .intBinFile = FreeFile
        Open str02000000BinFile For Binary Access Read As .intBinFile
    End If
    If strAsmFilename = "" Then
        .intAsmFile = 0
    Else
        .intAsmFile = FreeFile
        Open strAsmFilename For Binary Access Read As .intAsmFile
        .intAsmMapFile = FreeFile
        Open strAsmFilename + ".map" For Binary Access Read As .intAsmMapFile
    End If
    End With
End Sub
Private Sub Asm_PPCSnippet(ByVal strAsm As String, ByRef lngInjectionPoint As Long, ByRef strAsmFilename As String, Optional ByRef btHeaderLinesCount As Byte = 0, Optional ByRef btFooterLinesCount As Byte = 0, Optional ByRef strCommentChar As String = "#")
Dim objRegExp As Object
Dim objRegMatch As Object
Dim objMatchCollection As Object
Dim lngOffset As Long
Dim i As Long
Dim lngCount As Long
Dim strAsmLines() As String
Dim strAsmVars() As String
    Set objRegExp = CreateObject("VBScript.RegExp")
    objRegExp.Pattern = "[ ,(]r[0-9][0-9]?"
    objRegExp.Global = True
    strAsmLines = Split(strAsm, vbLf)
    strAsm = ""
    lngCount = UBound(strAsmLines)
    Call Asm_LoadResources(strAsmFilename)
    With stAsmResources
    lngInjectionPoint = lngInjectionPoint - btHeaderLinesCount * 4
    Call Asm_PrintCodeOffsets(lngInjectionPoint, btHeaderLinesCount, strCommentChar)
    For i = 0 To lngCount
        If strAsmLines(i) = "" Then
            lngInjectionPoint = lngInjectionPoint + 4
        Else
            strAsmVars = Split(strAsmLines(i), "$")
            lngOffset = UBound(strAsmVars)
            If lngOffset = 2 And strAsmVars(0) = "" And strAsmVars(lngOffset) = "" Then
                strAsmLines(i) = strSnippetVars(CLng(strAsmVars(1)))
                If strAsmLines(i) <> "" Then
                    If InStr(strAsmLines(i), strCommentChar) = 0 Then
                        Debug.Print strAsmLines(i) + " " + strCommentChar + " " + Asm_PrintCodeOffset(lngInjectionPoint)
                    Else
                        Debug.Print strAsmLines(i) + " " + Asm_PrintCodeOffset(lngInjectionPoint)
                    End If
                End If
            Else
                strAsmLines(i) = ""
                Do
                    If (lngOffset And 1) Then
                        strAsmLines(i) = strSnippetVars(CLng(strAsmVars(lngOffset))) + strAsmLines(i)
                    Else
                        strAsmLines(i) = strAsmVars(lngOffset) + strAsmLines(i)
                    End If
                    lngOffset = lngOffset - 1
                Loop Until lngOffset < 0
                Set objMatchCollection = objRegExp.Execute(strAsmLines(i))
                strAsm = Asm_PrintCodeOffset(lngInjectionPoint)
                lngOffset = 1
                For Each objRegMatch In objMatchCollection
                    Debug.Print Mid(strAsmLines(i), lngOffset, objRegMatch.FirstIndex - lngOffset + 1);
                    Debug.Print Left(objRegMatch.Value, 2);
                    Debug.Print CStr(btTranslatedRegisters(CByte(Mid(objRegMatch.Value, 3))));
                    lngOffset = objRegMatch.FirstIndex + objRegMatch.Length + 1
                Next
                Debug.Print Mid(strAsmLines(i), lngOffset);
                Debug.Print " ";
                If InStr(strAsmLines(i), strCommentChar) = 0 Then
                    Debug.Print strCommentChar;
                    Debug.Print " ";
                End If
                Debug.Print strAsm
                Set objMatchCollection = Nothing
            End If
            Erase strAsmVars
        End If
    Next i
    Call Asm_PrintCodeOffsets(lngInjectionPoint, btFooterLinesCount, strCommentChar)
    End With
    Call Asm_FreeResources
    Erase strAsmLines
    Set objRegExp = Nothing
End Sub
Public Function Asm_PPCFastStrlen(ByRef btString As Byte, ByRef btStrlen As Byte, ByRef btZero As Byte, ByRef btSubstr As Byte, ByRef int01010101Register As Integer, ByRef bt80808080 As Byte, Optional ByVal lngInjectionPoint As Long = -1, Optional ByRef strAsmFilename As String = "") As String
'Usage example with the immediate window: ?Asm_PPCFastStrlen(9,3,4,8,5,6,&h2A376DC,"D:\WiiU\default\dump\U-King.asm")
    btTranslatedRegisters(3) = btStrlen
    btTranslatedRegisters(4) = btZero
    If int01010101Register < 0 Then
        btTranslatedRegisters(5) = -int01010101Register
        strSnippetVars(0) = ""
        strSnippetVars(1) = ""
        strSnippetVars(2) = ""
    Else
        Asm_PPCFastStrlen = " r" + CStr(int01010101Register) + ","
        strSnippetVars(0) = "lis" + Asm_PPCFastStrlen + " 0x101"
        strSnippetVars(1) = "addic" + Asm_PPCFastStrlen + Asm_PPCFastStrlen + " 0x101"
        strSnippetVars(2) = "rlwinm r" + CStr(bt80808080) + "," + Asm_PPCFastStrlen + " 31, 0, 31"
        btTranslatedRegisters(5) = int01010101Register
    End If
    btTranslatedRegisters(6) = bt80808080
    btTranslatedRegisters(8) = btSubstr
    btTranslatedRegisters(9) = btString
    Call Asm_PPCSnippet(Worksheets("AsmSnippets").Range("B2").Text, lngInjectionPoint, strAsmFilename, 0, 1)
End Function
Public Function Asm_PPCFastStartswith(ByRef btString1 As Byte, ByRef btString2 As Byte, ByRef btZero As Byte, ByRef btSubstr As Byte, ByRef int01010101Register As Integer, ByRef bt80808080 As Byte, ByRef btUsableRegister As Byte, Optional ByVal lngInjectionPoint As Long = -1, Optional ByRef strAsmFilename As String = "") As String
'Usage example with the immediate window: ?Asm_PPCFastStartswith(9,10,4,8,5,6,3,&h2A376DC,"D:\WiiU\default\dump\U-King.asm")
    btTranslatedRegisters(11) = btUsableRegister
    btTranslatedRegisters(10) = btString2
    btTranslatedRegisters(4) = btZero
    If int01010101Register < 0 Then
        btTranslatedRegisters(5) = -int01010101Register
        strSnippetVars(0) = ""
        strSnippetVars(1) = ""
        strSnippetVars(2) = ""
    Else
        Asm_PPCFastStartswith = " r" + CStr(int01010101Register) + ","
        strSnippetVars(0) = "lis" + Asm_PPCFastStartswith + " 0x101"
        strSnippetVars(1) = "addic" + Asm_PPCFastStartswith + Asm_PPCFastStartswith + " 0x101"
        strSnippetVars(2) = "rlwinm r" + CStr(bt80808080) + "," + Asm_PPCFastStartswith + " 31, 0, 31"
        btTranslatedRegisters(5) = int01010101Register
    End If
    btTranslatedRegisters(6) = bt80808080
    btTranslatedRegisters(8) = btSubstr
    btTranslatedRegisters(9) = btString1
    Call Asm_PPCSnippet(Worksheets("AsmSnippets").Range("B9").Text, lngInjectionPoint, strAsmFilename, 0, 2)
End Function
Public Function Asm_PPCFastStrcmp(ByRef intStringRegister1 As Integer, ByRef btString2 As Byte, ByRef btZero As Byte, ByRef btSubstr1 As Byte, ByRef btSubstr2 As Byte, ByRef int01010101Register As Integer, ByRef bt80808080 As Byte, ByRef btUsableRegister2 As Byte, Optional ByRef btCharsCount As Byte = ASM_GPRSCOUNT, Optional ByVal lngInjectionPoint As Long = -1, Optional ByRef strAsmFilename As String = "") As String
'Usage example with the immediate window for Strcmp: ?Asm_PPCFastStrcmp(9,10,4,7,8,5,6,11,,&h2A376DC,"D:\WiiU\default\dump\U-King.asm")
'Usage example with the immediate window for Strncmp: ?Asm_PPCFastStrcmp(9,10,4,7,8,-5,6,11,12,&h2A376DC,"D:\WiiU\default\dump\U-King.asm")
    btTranslatedRegisters(4) = btZero
    If int01010101Register < 0 Then
        btTranslatedRegisters(5) = -int01010101Register
        strSnippetVars(0) = ""
        strSnippetVars(1) = ""
        strSnippetVars(2) = ""
    Else
        Asm_PPCFastStrcmp = " r" + CStr(int01010101Register) + ","
        strSnippetVars(0) = "lis" + Asm_PPCFastStrcmp + " 0x101"
        strSnippetVars(1) = "addic" + Asm_PPCFastStrcmp + Asm_PPCFastStrcmp + " 0x101"
        strSnippetVars(2) = "rlwinm r" + CStr(bt80808080) + "," + Asm_PPCFastStrcmp + " 31, 0, 31"
        btTranslatedRegisters(5) = int01010101Register
    End If
    btTranslatedRegisters(6) = bt80808080
    btTranslatedRegisters(7) = btSubstr1
    btTranslatedRegisters(8) = btSubstr2
    If intStringRegister1 < ASM_GPRSCOUNT Then
        Asm_PPCFastStrcmp = " r" + CStr(intStringRegister1) + ","
        strSnippetVars(3) = "addi" + Asm_PPCFastStrcmp + Asm_PPCFastStrcmp + " -4"
        btTranslatedRegisters(9) = intStringRegister1
    Else
        btTranslatedRegisters(9) = intStringRegister1 \ &H100
        strSnippetVars(3) = "addi r" + CStr(btTranslatedRegisters(9)) + ", r" + CStr(intStringRegister1 Mod &H100) + ", -4"
    End If
    btTranslatedRegisters(10) = btString2
    btTranslatedRegisters(11) = btUsableRegister2
    If btCharsCount < ASM_GPRSCOUNT Then
        btTranslatedRegisters(12) = btCharsCount
        Call Asm_PPCSnippet(Worksheets("AsmSnippets").Range("B7").Text, lngInjectionPoint, strAsmFilename, 4, 1)
    Else
        Call Asm_PPCSnippet(Worksheets("AsmSnippets").Range("B3").Text, lngInjectionPoint, strAsmFilename, 4, 1)
    End If
    Exit Function
End Function
Public Function Asm_PPCFastStrcomp(ByRef btReturnLen As Byte, ByRef btString1 As Byte, ByRef btString2 As Byte, ByRef btZero As Byte, ByRef btSubstr1 As Byte, ByRef btSubstr2 As Byte, ByRef btMaxlen As Byte, ByRef btUsableRegister1 As Byte, ByRef btUsableRegister2 As Byte, Optional ByVal lngInjectionPoint As Long = -1, Optional ByRef strAsmFilename As String = "") As Byte
'Usage example with the immediate window: ?Asm_PPCFastStrcomp(3,9,10,4,7,8,5,6,11,&h2A376DC,"D:\WiiU\default\dump\U-King.asm")
    btTranslatedRegisters(3) = btReturnLen
    btTranslatedRegisters(4) = btZero
    btTranslatedRegisters(5) = btMaxlen
    btTranslatedRegisters(6) = btUsableRegister1
    btTranslatedRegisters(7) = btSubstr1
    btTranslatedRegisters(8) = btSubstr2
    btTranslatedRegisters(11) = btUsableRegister2
    btTranslatedRegisters(9) = btString1
    btTranslatedRegisters(10) = btString2
    Call Asm_PPCSnippet(Worksheets("AsmSnippets").Range("B6").Text, lngInjectionPoint, strAsmFilename)
End Function
Public Function Asm_PPCFastStrcmpx(ByRef btR01010101 As Byte, Optional ByRef blnStrncmp As Boolean = False, Optional ByVal lngInjectionPoint As Long = -1, Optional ByRef strAsmFilename As String = "") As String
'Usage example with the immediate window for Strcmp28: ?Asm_PPCFastStrcmpx(28,,&h2A376DC,"D:\WiiU\default\dump\U-King.asm")
'Usage example with the immediate window for Strncmp28: ?Asm_PPCFastStrcmpx(28,true,&h2A376DC,"D:\WiiU\default\dump\U-King.asm")
    btTranslatedRegisters(3) = 3
    btTranslatedRegisters(5) = btR01010101
    Debug.Print "_BOTW_UKingTweaks_Str";
    If blnStrncmp Then
        strSnippetVars(0) = "n"
    Else
        strSnippetVars(0) = ""
    End If
    Debug.Print strSnippetVars(0);
    Debug.Print "cmp";
    Debug.Print CStr(btR01010101);
    Debug.Print ":"
    Call Asm_PPCSnippet(Worksheets("AsmSnippets").Range("B4").Text, lngInjectionPoint, strAsmFilename)
End Function
Private Sub Asm_PrintCodecaveComment(ByRef lngStart As Long, ByRef lngEnd As Long)
    Debug.Print "#0x0";
    Debug.Print Hex(lngStart);
    Debug.Print "-0x0";
    Debug.Print Hex(lngEnd);
    Debug.Print "(";
    Debug.Print CStr((lngEnd - lngStart) \ 4);
    Debug.Print ")"
End Sub
Private Function Asm_PPCFastStringSnippetCall01010101Sub(ByRef btR01010101 As Byte, ByRef lngCurrentAddress As Long, ByRef strVarSubName As String, ByRef strVarAsmMrR3R01010101 As String) As Byte
    If btR01010101 < ASM_GPRSCOUNT Then
        If btR01010101 = 0 Then
            strVarSubName = strVarSubName + "xx"
            Asm_PPCFastStringSnippetCall01010101Sub = 12
            strVarAsmMrR3R01010101 = ""
        Else
            strVarSubName = strVarSubName + "x"
            Asm_PPCFastStringSnippetCall01010101Sub = 8
            If btR01010101 = 3 Then
                strVarAsmMrR3R01010101 = ""
            Else
                strVarAsmMrR3R01010101 = "mr r3, r" + CStr(btR01010101)
                lngCurrentAddress = lngCurrentAddress + 4
            End If
        End If
    Else
        strVarAsmMrR3R01010101 = ""
    End If
End Function
Private Function Asm_PPCFastStringSnippetCallStrptrcmpSub(ByRef lngInjectionPoint As Long, ByRef lngIfEqGoto As Long, ByRef strAsmStrptrcmp As String, ByRef strAsmBeq As String) As Byte
    If lngIfEqGoto < 0 Then
        strAsmStrptrcmp = "cmplw r9, r10"
        strAsmBeq = "beq ." + Asm_PPCAsmBranchTarget(ASM_BRANCH_SHORTJUMP, Abs(lngIfEqGoto), lngInjectionPoint + 12)
        Asm_PPCFastStringSnippetCallStrptrcmpSub = 8
    Else
        strAsmStrptrcmp = ""
        strAsmBeq = ""
    End If
End Function
Private Function Asm_PPCFastStrcmpCallSub(ByRef lngInjectionPoint As Long, ByRef strAsm As String, ByRef lngStartAddress As Long, ByRef lngIfEqGoto As Long, ByRef lngIfNeqGoto As Long, ByRef strAsmFilename As String) As Byte
Dim intFile As Integer
Dim intJump As Integer
Dim strAsmBranches(0 To 1) As String
Dim lngPPCCode As Long
    intFile = FreeFile
    Open Mid(strAsmFilename, 1, InStrRev(strAsmFilename, "\")) + "2000000.bin" For Binary Access Read As intFile
    intJump = Asm_PPCBranchTarget(ASM_BRANCH_SHORTJUMP, lngIfEqGoto, lngStartAddress)
    strAsmBranches(0) = "beq ." + Hex(lngIfEqGoto)
    GoSub Asm_PPCFastStrcmpCallFooterSub
    If Asm_PPCFastStrcmpCallSub = 2 Then
        strAsm = strAsm + vbLf + "b ." + Asm_PPCAsmBranchTarget(ASM_BRANCH_LONGJUMP, lngIfNeqGoto, lngStartAddress) + " # GOTO 0x" + Hex(lngIfNeqGoto)
        Asm_PPCFastStrcmpCallSub = 0
    Else
        intJump = Asm_PPCBranchTarget(ASM_BRANCH_SHORTJUMP, lngIfNeqGoto, lngStartAddress)
        strAsmBranches(1) = "bne ." + Hex(lngIfNeqGoto)
        GoSub Asm_PPCFastStrcmpCallFooterSub
    End If
    Close intFile
    Call Asm_PPCSnippet(strAsm, lngInjectionPoint, strAsmFilename, 0, Asm_PPCFastStrcmpCallSub)
    If Asm_PPCFastStrcmpCallSub = 0 Then
        If lngIfEqGoto > lngIfNeqGoto Then
            If lngInjectionPoint < lngIfNeqGoto Then
                Call Asm_PrintCodecaveComment(lngInjectionPoint, lngIfNeqGoto)
            Else
                If lngInjectionPoint < lngIfEqGoto Then Call Asm_PrintCodecaveComment(lngInjectionPoint, lngIfEqGoto)
            End If
        Else
            If lngInjectionPoint < lngIfEqGoto Then
                Call Asm_PrintCodecaveComment(lngInjectionPoint, lngIfEqGoto)
            Else
                If lngInjectionPoint < lngIfNeqGoto Then Call Asm_PrintCodecaveComment(lngInjectionPoint, lngIfNeqGoto)
            End If
        End If
    End If
    Exit Function
Asm_PPCFastStrcmpCallFooterSub:
    If intJump = 0 Then
        Asm_PPCFastStrcmpCallSub = Asm_PPCFastStrcmpCallSub + 1
    Else
        strAsm = strAsm + vbLf
        Get intFile, lngStartAddress - &H1FFFFFF, lngPPCCode
        If Converter_SwapEndian32(lngPPCCode) <> Asm_PPCBInstruction(16, 12 - Asm_PPCFastStrcmpCallSub * 8, 2, (intJump \ 4) And &H3FFF, False, False) Then strAsm = strAsm + Left(strAsmBranches(Asm_PPCFastStrcmpCallSub), 5) + IIf(intJump < 0, "-0x" + Hex(Abs(intJump)), "+0x" + Hex(intJump)) + " # IFGOTO 0x" + Mid(strAsmBranches(Asm_PPCFastStrcmpCallSub), 6)
        Asm_PPCFastStrcmpCallSub = 2
        lngStartAddress = lngStartAddress + 4
    End If
    Return
End Function
Public Function Asm_PPCFastStrcmpBcall(ByRef lngInjectionPoint As Long, ByVal intStrptrOffsetL1 As Integer, ByRef btStrptrH1 As Byte, ByVal intStrptrOffsetL2 As Integer, ByRef btStrptrH2 As Byte, Optional ByVal btCharsCount As Byte = ASM_GPRSCOUNT, Optional ByRef lngIfEqGoto As Long = 0, Optional ByRef lngIfNeqGoto As Long = 0, Optional ByRef strAsmFilename As String = "", Optional ByRef btR01010101 As Byte = ASM_GPRSCOUNT, Optional ByRef lngStrcmpEntryPoint As Long = 0) As Long
'Usage example with the immediate window for Strcmp bcall: ?Asm_PPCFastStrcmpBcall(&h2A376DC,&h8,6,-&h164,12,,,,"D:\WiiU\default\dump\U-King.asm",28)
'Usage example with the immediate window for Strncmp bcall: ?Asm_PPCFastStrcmpBcall(&h2A376DC,&h8,6,-&h164,12,13,,,"D:\WiiU\default\dump\U-King.asm",28)
Dim strAsm As String
    If intStrptrOffsetL1 < 0 Then
        strSnippetVars(0) = "-0x" + Hex(Abs(intStrptrOffsetL1))
    Else
        strSnippetVars(0) = "0x" + Hex(intStrptrOffsetL1)
    End If
    If intStrptrOffsetL2 < 0 Then
        strSnippetVars(1) = "-0x" + Hex(Abs(intStrptrOffsetL2))
    Else
        strSnippetVars(1) = "0x" + Hex(intStrptrOffsetL2)
    End If
    If btCharsCount < ASM_GPRSCOUNT Then
        strSnippetVars(4) = "ncmp"
        btTranslatedRegisters(13) = btCharsCount
        btTranslatedRegisters(12) = 12
        strAsm = Worksheets("AsmSnippets").Range("B8").Text
        Asm_PPCFastStrcmpBcall = lngInjectionPoint + 24
    Else
        strSnippetVars(4) = "cmp"
        Asm_PPCFastStrcmpBcall = lngInjectionPoint + 20
        strAsm = Worksheets("AsmSnippets").Range("B5").Text
    End If
    btCharsCount = Asm_PPCFastStringSnippetCall01010101Sub(btR01010101, Asm_PPCFastStrcmpBcall, strSnippetVars(4), strSnippetVars(7))
    Asm_PPCFastStrcmpBcall = Asm_PPCFastStrcmpBcall + Asm_PPCFastStringSnippetCallStrptrcmpSub(lngInjectionPoint, lngIfEqGoto, strSnippetVars(5), strSnippetVars(6))
    strSnippetVars(2) = "0x" + Hex(Asm_PPCFastStrcmpBcall \ &H10000)
    strSnippetVars(3) = "0x" + Hex(Asm_PPCFastStrcmpBcall Mod &H10000)
    btTranslatedRegisters(0) = 0
    btTranslatedRegisters(6) = btStrptrH1
    btTranslatedRegisters(1) = btStrptrH2
    btTranslatedRegisters(9) = 9
    btTranslatedRegisters(10) = 10
    If lngStrcmpEntryPoint = 0 Then
        strSnippetVars(4) = "a _BOTW_UKingTweaks_Str" + strSnippetVars(4)
    Else
        strSnippetVars(4) = " ." + Asm_PPCAsmBranchTarget(ASM_BRANCH_LONGJUMP, lngStrcmpEntryPoint, Asm_PPCFastStrcmpBcall - 4 - btCharsCount)
    End If
    Asm_PPCFastStrcmpCallSub lngInjectionPoint, strAsm, Asm_PPCFastStrcmpBcall, Abs(lngIfEqGoto), lngIfNeqGoto, strAsmFilename
End Function
Public Function Asm_PPCFastStrcmpCall(ByRef lngInjectionPoint As Long, ByVal intStrptrOffsetL1 As Integer, ByRef btStrptrH1 As Byte, ByVal intStrptrOffsetL2 As Integer, ByRef btStrptrH2 As Byte, Optional ByVal btCharsCount As Byte = ASM_GPRSCOUNT, Optional ByRef lngIfEqGoto As Long = 0, Optional ByRef lngIfNeqGoto As Long = 0, Optional ByRef strAsmFilename As String = "", Optional ByRef btR01010101 As Byte = ASM_GPRSCOUNT, Optional ByRef lngStrcmpEntryPoint As Long = 0) As Long
'Usage example with the immediate window for Strcmp call: ?Asm_PPCFastStrcmpCall(&h2A376DC,&h8,6,-&h164,12,,,,"D:\WiiU\default\dump\U-King.asm",28)
'Usage example with the immediate window for Strncmp call: ?Asm_PPCFastStrcmpCall(&h2A376DC,&h8,6,-&h164,12,13,,,"D:\WiiU\default\dump\U-King.asm",28)
Dim strAsm As String
    If intStrptrOffsetL1 < 0 Then
        strSnippetVars(0) = "-0x" + Hex(Abs(intStrptrOffsetL1))
    Else
        strSnippetVars(0) = "0x" + Hex(intStrptrOffsetL1)
    End If
    If intStrptrOffsetL2 < 0 Then
        strSnippetVars(1) = "-0x" + Hex(Abs(intStrptrOffsetL2))
    Else
        strSnippetVars(1) = "0x" + Hex(intStrptrOffsetL2)
    End If
    If btCharsCount < ASM_GPRSCOUNT Then
        strSnippetVars(2) = "ncmp"
        btTranslatedRegisters(13) = btCharsCount
        btTranslatedRegisters(12) = 12
        strAsm = Worksheets("AsmSnippets").Range("B11").Text
        Asm_PPCFastStrcmpCall = lngInjectionPoint + 12
    Else
        strSnippetVars(2) = "cmp"
        Asm_PPCFastStrcmpCall = lngInjectionPoint + 8
        strAsm = Worksheets("AsmSnippets").Range("B10").Text
    End If
    btCharsCount = Asm_PPCFastStringSnippetCall01010101Sub(btR01010101, Asm_PPCFastStrcmpCall, strSnippetVars(2), strSnippetVars(5))
    Asm_PPCFastStrcmpCall = Asm_PPCFastStrcmpCall + Asm_PPCFastStringSnippetCallStrptrcmpSub(lngInjectionPoint, lngIfEqGoto, strSnippetVars(3), strSnippetVars(4))
    btTranslatedRegisters(6) = btStrptrH1
    btTranslatedRegisters(1) = btStrptrH2
    btTranslatedRegisters(9) = 9
    btTranslatedRegisters(10) = 10
    If lngStrcmpEntryPoint = 0 Then
        strSnippetVars(2) = "a _BOTW_UKingTweaks_Str" + strSnippetVars(2)
    Else
        strSnippetVars(2) = " ." + Asm_PPCAsmBranchTarget(ASM_BRANCH_LONGJUMP, lngStrcmpEntryPoint, Asm_PPCFastStrcmpCall - btCharsCount)
    End If
    Asm_PPCFastStrcmpCall = Asm_PPCFastStrcmpCall + 4
    Asm_PPCFastStrcmpCallSub lngInjectionPoint, strAsm, Asm_PPCFastStrcmpCall, Abs(lngIfEqGoto), lngIfNeqGoto, strAsmFilename
End Function
Public Function Asm_PPCFastStrlenCall(ByRef lngInjectionPoint As Long, ByRef intStrptrOffsetL As Integer, ByRef btStrptrH As Byte, ByRef btLen As Byte, Optional ByRef strAsmFilename As String = "", Optional ByVal btR01010101 As Byte = ASM_GPRSCOUNT, Optional ByRef btStrptr As Byte = 5, Optional ByRef lngStrlenEntryPoint As Long = 0) As Long
'Usage example with the immediate window for Strcmp call: ?Asm_PPCFastStrlenCall(&h2A376DC,&h8,6,30,"D:\WiiU\default\dump\U-King.asm")
    If intStrptrOffsetL < 0 Then
        strSnippetVars(0) = "-0x" + Hex(Abs(intStrptrOffsetL))
    Else
        strSnippetVars(0) = "0x" + Hex(intStrptrOffsetL)
    End If
    strSnippetVars(1) = ""
    btTranslatedRegisters(6) = btStrptrH
    Asm_PPCFastStrlenCall = lngInjectionPoint + 4
    btR01010101 = Asm_PPCFastStringSnippetCall01010101Sub(btR01010101, Asm_PPCFastStrlenCall, strSnippetVars(1), strSnippetVars(2))
    If btR01010101 = 0 Then
        btTranslatedRegisters(5) = 5
    Else
        btTranslatedRegisters(5) = btStrptr
        If btStrptr <> 5 Then
            strSnippetVars(4) = "addi r7, r" + CStr(btStrptr) + ", -4"
            If btR01010101 = 8 Then
                strSnippetVars(3) = "rlwinm r0, r3, 31, 0, 31"
                strSnippetVars(1) = strSnippetVars(1) + "xx"
            Else
                strSnippetVars(1) = strSnippetVars(1) + "x"
            End If
        End If
    End If
    btTranslatedRegisters(7) = 7
    btTranslatedRegisters(9) = btLen
    btTranslatedRegisters(4) = 4
    If lngStrlenEntryPoint = 0 Then
        strSnippetVars(1) = "a _BOTW_UKingTweaks_Strlen" + strSnippetVars(1)
    Else
        strSnippetVars(1) = " ." + Asm_PPCAsmBranchTarget(ASM_BRANCH_LONGJUMP, lngStrlenEntryPoint, Asm_PPCFastStrlenCall - btR01010101)
    End If
    Call Asm_PPCSnippet(Worksheets("AsmSnippets").Range("B12").Text, lngInjectionPoint, strAsmFilename, , 1)
End Function
Public Function Asm_PPCStrpbrk(ByRef btString As Byte, ByRef btSearchedChars As Byte, ByRef btStrpbrk As Byte, ByRef btChar As Byte, ByRef btSearchedChar As Byte, ByRef btUsableRegister As Byte, Optional ByVal lngInjectionPoint As Long = -1, Optional ByRef strAsmFilename As String = "") As String
'Usage example with the immediate window: ?Asm_PPCStrpbrk(4,3,22,0,5,6,&h2A376DC,"D:\WiiU\default\dump\U-King.asm")
    btTranslatedRegisters(0) = btChar
    btTranslatedRegisters(3) = btSearchedChars
    btTranslatedRegisters(4) = btString
    btTranslatedRegisters(5) = btSearchedChar
    btTranslatedRegisters(6) = btUsableRegister
    btTranslatedRegisters(22) = btStrpbrk
    Call Asm_PPCSnippet(Worksheets("AsmSnippets").Range("B13").Text, lngInjectionPoint, strAsmFilename, 0, 1)
End Function
Public Function Asm_PPCStrpbrkCall(ByRef intStrptrOffsetL As Integer, ByRef btStrptrH As Byte, ByRef intSearchedCharsOffsetL As Integer, ByRef btSearchedCharsH As Byte, ByRef btStrpbrk As Byte, Optional ByVal lngInjectionPoint As Long = -1, Optional ByRef strAsmFilename As String = "", Optional ByRef lngStrpbrkEntryPoint As Long = 0) As String
'Usage example with the immediate window: ?Asm_PPCStrpbrkCall(0,4,&h10,1,22,&h2B75B54,"D:\WiiU\default\dump\U-King.asm")
    If intStrptrOffsetL < 0 Then
        strSnippetVars(1) = "-0x" + Hex(Abs(intStrptrOffsetL))
    Else
        strSnippetVars(1) = "0x" + Hex(intStrptrOffsetL)
    End If
    If intSearchedCharsOffsetL < 0 Then
        strSnippetVars(0) = "-0x" + Hex(Abs(intSearchedCharsOffsetL))
    Else
        strSnippetVars(0) = "0x" + Hex(intSearchedCharsOffsetL)
    End If
    btTranslatedRegisters(1) = btSearchedCharsH
    btTranslatedRegisters(3) = 3
    btTranslatedRegisters(4) = 4
    btTranslatedRegisters(5) = btStrptrH
    btTranslatedRegisters(7) = 7
    btTranslatedRegisters(22) = btStrpbrk
    If lngStrpbrkEntryPoint = 0 Then
        strSnippetVars(2) = "a _BOTW_UKingTweaks_Strpbrk"
    Else
        strSnippetVars(2) = " ." + Asm_PPCAsmBranchTarget(ASM_BRANCH_LONGJUMP, lngStrpbrkEntryPoint, lngInjectionPoint + 16)
    End If
    Call Asm_PPCSnippet(Worksheets("AsmSnippets").Range("B14").Text, lngInjectionPoint, strAsmFilename, 0, 1)
End Function
