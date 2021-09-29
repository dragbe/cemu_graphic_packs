Attribute VB_Name = "Rpx"
Option Explicit
Public Enum RPX_GAME_CODE_OFFSETS
    RPX_BOTW_CODE_OFFSET = &H48B5E0
End Enum
Private objEncoder As Object

Private Sub Rpx_CreatePatchFile(ByVal intUnmodded02000000BinFile As Integer, ByRef intModdedBinFile As Integer, ByRef strOutputDirectory As String, ByRef lngInjectOffset As Long, ByRef lngCodeCaveOffset As Long, ByVal lngCodeCaveSize As Long, Optional ByVal RPX_GAME_CODE_OFFSET As RPX_GAME_CODE_OFFSETS = RPX_BOTW_CODE_OFFSET)
Dim btasm() As Byte
Dim btHash As Variant
Dim strTemp As String
    ReDim btasm(0 To lngCodeCaveSize - 1)
    Get intUnmodded02000000BinFile, lngInjectOffset - 33554431, btasm
    btHash = objEncoder.ComputeHash_2((btasm))
    strTemp = ""
    For lngCodeCaveSize = LenB(btHash) To 1 Step -1
        strTemp = Right("0" + Hex(AscB(MidB(btHash, lngCodeCaveSize, 1))), 2) + strTemp
    Next lngCodeCaveSize
    Erase btHash
    intUnmodded02000000BinFile = FreeFile
    Open strOutputDirectory + Right("0000000" + Hex(lngInjectOffset - &H2000000 + RPX_GAME_CODE_OFFSET), 8) + "-" + strTemp + ".bin" For Binary As intUnmodded02000000BinFile
        Get intModdedBinFile, lngCodeCaveOffset, btasm
        Put intUnmodded02000000BinFile, , btasm
    Close intUnmodded02000000BinFile
    Erase btasm
End Sub

Public Function Rpx_CreatePatch(ByVal strModName As String, Optional ByVal strModPrefix As String = "BreathOfTheWild", Optional ByVal strCemuPath As String = "", Optional ByVal lngInjectOffset As Long = &H249E2E0, Optional ByVal RPX_GAME_CODE_OFFSET As RPX_GAME_CODE_OFFSETS = RPX_BOTW_CODE_OFFSET) As Integer
'search pattern: 7C 08 02 A6 94 21 FF F0 93
'2000000.bin: 0x20
'drpx offset: 0x48B600
'Usage example with the immediate window: ?Rpx_CreatePatch("Cherry++")
Dim strGfxpackName As String
Dim strLine As String
Dim lngCodeCaveOffset As Long
Dim lngCodeCaveSize As Long
Dim intBinFile As Integer
Dim intAsmFile As Integer
    strCemuPath = Cemu_GetRootFolderPath(strCemuPath)
    strLine = strCemuPath + "log.txt"
    lngCodeCaveOffset = Gfxpack_getCodeCave(strLine, strModName, lngCodeCaveSize)
    strLine = Cemu_GetDumpFolderPath(strCemuPath, File_getTimestamp(strLine))
    If strLine = "" Then
        Rpx_CreatePatch = 0
    Else
        Rpx_CreatePatch = FreeFile
        Open strCemuPath + "dump\02000000.bin" For Binary As Rpx_CreatePatch
        strGfxpackName = Replace(strModName, " ", "")
        strModName = strModPrefix + "_" + strGfxpackName
        strModPrefix = strCemuPath + "dump\" + strModPrefix + "\" + strGfxpackName + "\"
        CreateDirectory strModPrefix, 0
        Set objEncoder = CreateObject("System.Security.Cryptography.MD5CryptoServiceProvider")
        If lngCodeCaveOffset <> 0 Then
            intBinFile = FreeFile
            Open strLine + "01800000.bin" For Binary As intBinFile
            Call Rpx_CreatePatchFile(Rpx_CreatePatch, intBinFile, strModPrefix, lngInjectOffset, lngCodeCaveOffset - 25165823, lngCodeCaveSize, RPX_GAME_CODE_OFFSET)
            Close intBinFile
        End If
        intBinFile = FreeFile
        Open strLine + "02000000.bin" For Binary As intBinFile
        intAsmFile = FreeFile
        Open strCemuPath + "graphicPacks\" + strModName + "\patch_patches.asm" For Input As intAsmFile
        Do
            Line Input #intAsmFile, strLine
        Loop Until Left(strLine, 1) = "0"
        lngCodeCaveOffset = CLng("&H" + RTrim(Mid(strLine, 3, InStr(strLine, "=") - 3)))
        lngCodeCaveSize = lngCodeCaveOffset + 4
        Do Until EOF(intAsmFile)
            Line Input #intAsmFile, strLine
            If Left(strLine, 1) = "0" Then
                lngInjectOffset = CLng("&H" + RTrim(Mid(strLine, 3, InStr(strLine, "=") - 3)))
                If lngInjectOffset = lngCodeCaveSize Then
                    lngCodeCaveSize = lngCodeCaveSize + 4
                Else
                    Call Rpx_CreatePatchFile(Rpx_CreatePatch, intBinFile, strModPrefix, lngCodeCaveOffset, lngCodeCaveOffset - 33554431, lngCodeCaveSize - lngCodeCaveOffset, RPX_GAME_CODE_OFFSET)
                    lngCodeCaveOffset = lngInjectOffset
                    lngCodeCaveSize = lngCodeCaveOffset + 4
                End If
            End If
        Loop
        Close intAsmFile
        Call Rpx_CreatePatchFile(Rpx_CreatePatch, intBinFile, strModPrefix, lngCodeCaveOffset, lngCodeCaveOffset - 33554431, lngCodeCaveSize - lngCodeCaveOffset, RPX_GAME_CODE_OFFSET)
        Set objEncoder = Nothing
        Close intBinFile
        Close Rpx_CreatePatch
    End If
End Function

Public Function Rpx_WriteMd5DataFiles(ByVal strModName As String, Optional ByVal strCemuPath = "") As Integer
Dim btasm() As Byte
Dim intFile As Integer
    strCemuPath = Cemu_GetRootFolderPath(strCemuPath)
    strModName = strCemuPath + "dump\" + strModName + "\"
    Rpx_WriteMd5DataFiles = FreeFile
    Open strCemuPath + "dump\02000000.bin" For Binary As Rpx_WriteMd5DataFiles
    strCemuPath = Dir(strModName + "*-*.bin", vbArchive)
    Do Until strCemuPath = ""
        ReDim btasm(1 To FileLen(strModName + strCemuPath))
        Get Rpx_WriteMd5DataFiles, CLng("&H" + Left(strCemuPath, 8)) + 1, btasm
        intFile = FreeFile
        Open strModName + Mid(strCemuPath, 10) For Binary As intFile
            Put intFile, , btasm
        Close intFile
        strCemuPath = Dir
    Loop
    Close Rpx_WriteMd5DataFiles
End Function
