Attribute VB_Name = "Vbstring"
Option Explicit
Public Const VBSTRING_WIDENULLCHAR  As String * 2 = vbNullChar + vbNullChar
Public Function Vbstring_Replace(ByRef strString, ByRef objRegExp As Object, ByRef strReplaces() As String) As String
Dim objMatchCollection As Object
Dim i As Long
Dim lngUbound As Long
Dim lngOffset As Long
Dim lngChar41Offset As Long
Dim lngOldChar41Offset As Long
Dim objSubRegExp As Object
    lngOffset = 1
    Set objMatchCollection = objRegExp.Execute(strString)
    If objMatchCollection.Count = 1 Then
        i = objMatchCollection.Item(0).SubMatches.Count - 1
        Set objMatchCollection = Nothing
        Set objSubRegExp = CreateObject("VBScript.RegExp")
        lngUbound = UBound(strReplaces)
        If lngUbound > i Then lngUbound = i
        For i = 0 To lngUbound
            With objRegExp
            Do
                lngChar41Offset = InStr(lngChar41Offset + 1, .Pattern, ")")
            Loop Until Mid(.Pattern, lngChar41Offset - 1, 1) <> "\"
            objSubRegExp.Pattern = Mid(.Pattern, lngOldChar41Offset + 1, lngChar41Offset - lngOldChar41Offset)
            End With
            Set objMatchCollection = objSubRegExp.Execute(Mid(strString, lngOffset))
            With objMatchCollection.Item(0)
            Vbstring_Replace = Vbstring_Replace + Mid(strString, lngOffset, .Length - Len(.SubMatches(0))) + strReplaces(i)
            lngOffset = lngOffset + .Length
            End With
            Set objMatchCollection = Nothing
            lngOldChar41Offset = lngChar41Offset
        Next i
        Set objSubRegExp = Nothing
    Else
        Set objMatchCollection = Nothing
    End If
    Vbstring_Replace = Vbstring_Replace + Mid(strString, lngOffset)
End Function
Public Function Vbstring_CWholeNumberUstr(ByVal lnglngNumber As LongLong, ByVal lngMaxUnsignedValue As Long) As String
    If lnglngNumber > lngMaxUnsignedValue Then
        Vbstring_CWholeNumberUstr = "!u 0x" + Hex(lnglngNumber)
    Else
        Vbstring_CWholeNumberUstr = CStr(lnglngNumber)
    End If
End Function
Public Function Vbstring_GetCommonRootStringLength(ByRef strValue1 As String, ByRef strValue2 As String) As Long
    If strValue1 = strValue2 Then
        Vbstring_GetCommonRootStringLength = Len(strValue1)
    Else
        Do
            Vbstring_GetCommonRootStringLength = Vbstring_GetCommonRootStringLength + 1
        Loop Until Mid(strValue1, Vbstring_GetCommonRootStringLength, 1) <> Mid(strValue2, Vbstring_GetCommonRootStringLength, 1)
        Vbstring_GetCommonRootStringLength = Vbstring_GetCommonRootStringLength - 1
    End If
End Function
