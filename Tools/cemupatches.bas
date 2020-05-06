Attribute VB_Name = "cemupatches"
Option Explicit
'memorysearcher.bas required

Public Function str2asm(ByVal strvalue As String, Optional ByVal btFieldSize As Byte = 32) As String
Dim strWord As String
Dim btLength As Byte
    str2asm = ""
    btLength = Len(strvalue)
    btFieldSize = (btFieldSize - btLength) \ 4
    Do Until btFieldSize = 0
        btFieldSize = btFieldSize - 1
        str2asm = str2asm + ".int 0" + vbCrLf
    Loop
    btFieldSize = btLength Mod 4
    If btFieldSize = 0 Then
        btFieldSize = btLength + 1
    Else
        btFieldSize = btLength - btFieldSize + 5
    End If
    Do Until btFieldSize = 1
        btFieldSize = btFieldSize - 4
        strWord = Mid(strvalue, btFieldSize, 4)
        str2asm = ".int " + CStr(asc2int(Left(strWord + Chr(0) + Chr(0) + Chr(0), 4))) + " # " + strWord + vbCrLf + str2asm
    Loop
    str2asm = ".int " + CStr(btLength) + vbCrLf + str2asm
End Function
