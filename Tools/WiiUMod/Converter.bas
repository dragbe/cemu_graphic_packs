Attribute VB_Name = "Converter"
Option Explicit
Private Type stSingle
    sngValue As Single
End Type
Private Type stLong
    lngValue As Long
End Type

Public Function Converter_SwapEndian(ByVal lngData As Long) As Long
'Usage example with the immediate window: ?hex(Converter_SwapEndian(6786))
    Converter_SwapEndian = (((lngData And &HFF000000) \ &H1000000) And &HFF&) Or ((lngData And &HFF0000) \ &H100&) Or ((lngData And &HFF00&) * &H100&) Or ((lngData And &H7F&) * &H1000000)
    If (lngData And &H80&) Then Converter_SwapEndian = Converter_SwapEndian Or &H80000000
End Function

Public Function Converter_Asc2Int(ByRef strValue As String) As LongLong
'strValue: max 8 characters
'Usage example with the immediate window: ?Converter_Asc2Int("Zelda")
Dim btLength As Byte
Dim btAsc As Byte
Dim lngLngHexPower As LongLong
    Converter_Asc2Int = 0
    lngLngHexPower = 1
    btLength = Len(strValue)
    If btLength > 8 Then btLength = 8
    Do
        btAsc = Asc(Mid(strValue, btLength, 1))
        Converter_Asc2Int = Converter_Asc2Int + CLngLng(lngLngHexPower * (btAsc And &HF))
        Converter_Asc2Int = Converter_Asc2Int + CLngLng(lngLngHexPower * (btAsc And &HF0))
        btLength = btLength - 1
        If btLength = 0 Then Exit Function
        lngLngHexPower = lngLngHexPower * 256
    Loop
End Function

Public Function Converter_Int2Hex(ByVal lngValue As LongLong) As String
'Usage example with the immediate window: ?Converter_Int2Hex(388248659041)
    Converter_Int2Hex = ""
    Do
        Converter_Int2Hex = Hex(lngValue And &HF) + Converter_Int2Hex
        lngValue = lngValue \ 16
    Loop Until lngValue = 0
End Function

Public Function Converter_Int2Asc(ByVal lngLngValue As LongLong) As String
'Usage example with the immediate window: ?Converter_Int2Asc(6513731614445563764^)
    Converter_Int2Asc = ""
    Do
        Converter_Int2Asc = Chr(CByte(lngLngValue And &HFF)) + Converter_Int2Asc
        lngLngValue = lngLngValue \ 256
    Loop Until lngLngValue = 0
End Function

Public Function Converter_Sng2Lng(ByRef sngValue As Single) As Long
'Usage example with the immediate window: ?Converter_Sng2Lng(1.78)
Dim stSin As stSingle
Dim stLng As stLong
    stSin.sngValue = sngValue
    LSet stLng = stSin
    Converter_Sng2Lng = stLng.lngValue
End Function

Public Function Converter_Asc2Utf16Hex(ByRef strValue As String) As String
'Usage example with the immediate window: ?Converter_Asc2Utf16Hex("Zelda")
Dim i As Integer
    Converter_Asc2Utf16Hex = ""
    For i = Len(strValue) To 1 Step -1
        Converter_Asc2Utf16Hex = "00" + Right("0" + Hex(Asc(Mid(strValue, i, 1))), 2) + Converter_Asc2Utf16Hex
    Next i
End Function

Public Function Converter_Var2Bytes(ByRef pVarData As LongPtr, ByVal intDataSize As Integer) As Byte()
Dim btBytes() As Byte
    ReDim btBytes(1 To intDataSize)
    Call CopyMemory(VarPtr(btBytes(1)), pVarData, intDataSize)
    Converter_Var2Bytes = btBytes
End Function

Public Function Converter_CULng(ByVal lngValue As Long) As LongLong
'Usage example with the immediate window: ?Converter_CULng("Zelda")
    Converter_CULng = IIf(lngValue < 0, 4294967296# + lngValue, lngValue)
End Function

Public Function Converter_Str2RegExp(ByRef str As String) As String
'Usage example with the immediate window: ?Converter_Str2RegExp("Zelda")
Dim i As Integer
    Converter_Str2RegExp = ""
    For i = Len(str) To 1 Step -1
        Converter_Str2RegExp = "\x" + Right("0" + Hex(Asc(Mid(str, i, 1))), 2) + Converter_Str2RegExp
    Next i
End Function
