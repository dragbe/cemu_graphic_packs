Attribute VB_Name = "Tools"
Option Explicit
Public Function Tools_MatchXmlNodes(ByRef xmlCurrentNode As Object, ByRef strNodes() As String, ByVal lngXmlNodeLevel As Long, Optional ByRef strMatchPattern As String = ".*") As Object()
Dim xmlNodes As Object
Dim lngMatchesCount As Long
Dim varout() As Object
Dim lngIndex As Long
Dim lngUbound As Long
Dim xmlMatchXmlNodes() As Object
Dim objRegExp As Object
    ReDim varout(0 To 0)
    Set xmlNodes = xmlCurrentNode.ChildNodes
    If xmlNodes.Length <> 0 Then
        Set objRegExp = CreateObject("VBScript.RegExp")
        For lngIndex = xmlNodes.Length - 1 To 0 Step -1
            If xmlNodes.Item(lngIndex).nodeName = strNodes(lngXmlNodeLevel) Then
                If lngXmlNodeLevel = 0 Then
                    objRegExp.Pattern = strMatchPattern
                    If objRegExp.test(xmlNodes.Item(lngIndex).Text) Then
                        lngMatchesCount = UBound(varout) + 1
                        ReDim Preserve varout(0 To lngMatchesCount)
                        Set varout(lngMatchesCount) = xmlNodes.Item(lngIndex)
                    End If
                Else
                    xmlMatchXmlNodes = Tools_MatchXmlNodes(xmlNodes.Item(lngIndex), strNodes, lngXmlNodeLevel - 1, strMatchPattern)
                    lngUbound = UBound(varout)
                    lngMatchesCount = UBound(xmlMatchXmlNodes)
                    ReDim Preserve varout(0 To lngUbound + lngMatchesCount)
                    Do Until lngMatchesCount < 1
                        Set varout(lngUbound + lngMatchesCount) = xmlMatchXmlNodes(lngMatchesCount)
                        Set xmlMatchXmlNodes(lngMatchesCount) = Nothing
                        lngMatchesCount = lngMatchesCount - 1
                    Loop
                    'Set xmlMatchXmlNodes(0) = Nothing
                    Erase xmlMatchXmlNodes
                End If
            End If
        Next lngIndex
        Set objRegExp = Nothing
    End If
    Set xmlNodes = Nothing
    Tools_MatchXmlNodes = varout
End Function
