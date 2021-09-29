Attribute VB_Name = "Arithmetic"
Option Explicit

Public Function Arithmetic_StrNandCmp(ByRef str1 As String, ByRef str2 As String) As LongLong
'str<1|2> max length: 64
'Usage example with the immediate window: ?Arithmetic_StrNandCmp("00050000101c9500", "00050000101c9X00")
Dim btLen As Byte
Dim btPower As Byte
    Arithmetic_StrNandCmp = 0
    btPower = Len(str1)
    btLen = Len(str2)
    If btLen < btPower Then btLen = btPower
    btPower = 0
    Do Until btLen = 0
        If Mid(str1, btLen, 1) <> Mid(str2, btLen, 1) Then Arithmetic_StrNandCmp = Arithmetic_StrNandCmp + 2^ ^ btPower
        btLen = btLen - 1
        btPower = btPower + 1
    Loop
End Function
