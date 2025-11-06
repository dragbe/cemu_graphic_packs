Attribute VB_Name = "Arithmetic"
Option Explicit
Public Function Arithmetic_StrNandCmp(ByRef str1 As String, ByRef str2 As String) As LongLong
'String max length support: 64
'Usage example with the immediate window: ?Arithmetic_StrNandCmp("00050000101c9500", "00050000101c9X00")
Dim lngLen As Long
Dim lngPower As Long
    lngPower = Len(str1)
    lngLen = Len(str2)
    If lngLen < lngPower Then lngLen = lngPower
    lngPower = 0
    Do Until lngLen = 0 Or lngPower = 64
        If Mid(str1, lngLen, 1) <> Mid(str2, lngLen, 1) Then Arithmetic_StrNandCmp = Arithmetic_StrNandCmp + 2^ ^ lngPower
        lngLen = lngLen - 1
        lngPower = lngPower + 1
    Loop
End Function
Public Function Arithmetic_GetLongLinearSequence(ByVal lngStart As Long, ByVal lngItemsCount As Long, ByVal lngIncrement As Long, Optional ByVal lngLbound As Long = 1) As Long()
Dim varout() As Long
    lngItemsCount = lngLbound + lngItemsCount - 1
    ReDim varout(lngLbound To lngItemsCount)
    varout(lngLbound) = lngStart
    For lngStart = lngLbound + 1 To lngItemsCount
        varout(lngStart) = varout(lngStart - 1) + lngIncrement
    Next lngStart
    Arithmetic_GetLongLinearSequence = varout
End Function
