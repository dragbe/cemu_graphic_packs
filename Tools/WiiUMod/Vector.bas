Attribute VB_Name = "Vector"
Option Explicit
Public Function Vector_ItemIndexes(ByRef lpVector As LongPtr, ByRef lpItem As LongPtr, ByVal lngItemSize As Long, ByVal lngItemsCount As Long, ByRef lngItemOffsets() As Long, Optional ByVal lngLbound As Long = 0, Optional ByVal lngJumpStep As Long = 0) As Long
    If lngItemsCount <> 0 Then
        If lngJumpStep = 0 Then lngJumpStep = lngItemSize
        lngItemsCount = lngItemsCount * lngJumpStep
        Do
            lngItemsCount = lngItemsCount - lngJumpStep
            If CompareMemory(lpVector + lngItemsCount, lpItem, lngItemSize) = lngItemSize Then
                Vector_ItemIndexes = Vector_ItemIndexes + 1
                ReDim Preserve lngItemOffsets(1 To Vector_ItemIndexes)
                lngItemOffsets(Vector_ItemIndexes) = lngItemsCount \ lngJumpStep + lngLbound
            End If
        Loop Until lngItemsCount = 0
    End If
End Function
Public Function Vector_InBytes(ByVal lngStart As Long, ByRef btBytes() As Byte, ByRef btSearchBytes() As Byte, Optional ByVal lngNotFound As Long = 0) As Long
Dim pBtSearchBytes As LongPtr
Dim lngUbound As Long
Dim lngLbound As Long
Dim lngBytesCount As Long
    lngLbound = LBound(btSearchBytes)
    lngBytesCount = UBound(btSearchBytes) - lngLbound + 1
    lngStart = lngStart + LBound(btBytes) - 1
    lngUbound = UBound(btBytes) - lngBytesCount + 1
    pBtSearchBytes = VarPtr(btSearchBytes(lngLbound))
    Do Until lngStart > lngUbound
        If btBytes(lngStart) = btSearchBytes(lngLbound) Then
            If CompareMemory(VarPtr(btBytes(lngStart)), pBtSearchBytes, lngBytesCount) = lngBytesCount Then
                Vector_InBytes = lngStart
                Exit Function
            End If
        End If
        lngStart = lngStart + 1
    Loop
    Vector_InBytes = lngNotFound
End Function
Public Function Vector_InBytes2(ByVal lngStart As Long, ByRef btBytes() As Byte, ByRef btSearchBytes() As Byte, Optional ByRef btJokerByte As Byte = 46, Optional ByVal lngNotFound As Long = 0) As Long
Dim lngJokerBytesCount As Long
Dim lngJokerByteIndexes() As Long
Dim pBtSearchBytes As LongPtr
Dim lngUbound As Long
Dim lngLbound As Long
Dim lngBytesCount As Long
    lngLbound = LBound(btSearchBytes)
    lngBytesCount = UBound(btSearchBytes) - lngLbound + 1
    lngStart = lngStart + LBound(btBytes) - 1
    lngUbound = UBound(btBytes) - lngBytesCount + 1
    pBtSearchBytes = VarPtr(btSearchBytes(lngLbound))
    lngJokerBytesCount = Vector_ItemIndexes(VarPtr(btSearchBytes(lngLbound)), VarPtr(btJokerByte), 1, lngBytesCount, lngJokerByteIndexes)
    If lngJokerBytesCount <> 0 Then
        Do Until lngStart > lngUbound
            For Vector_InBytes2 = lngJokerBytesCount To 1 Step -1
                btSearchBytes(lngJokerByteIndexes(Vector_InBytes2) + lngLbound) = btBytes(lngStart + lngJokerByteIndexes(Vector_InBytes2))
            Next Vector_InBytes2
            If btBytes(lngStart) = btSearchBytes(lngLbound) Then
                If CompareMemory(VarPtr(btBytes(lngStart)), pBtSearchBytes, lngBytesCount) = lngBytesCount Then
                    Erase lngJokerByteIndexes
                    Vector_InBytes2 = lngStart
                    Exit Function
                End If
            End If
            lngStart = lngStart + 1
        Loop
        Erase lngJokerByteIndexes
    End If
    Vector_InBytes2 = lngNotFound
End Function
Public Function Vector_Cbytes(ByRef strBytes As String, ByRef btBytes() As Byte, Optional ByVal lngBaseIndex As Long = 1) As Long
Dim lngOffset As Long
Dim lngUbound As Long
    Select Case Left(strBytes, 1)
    Case "$"
        Vector_Cbytes = Len(strBytes) - 1
        lngOffset = Vector_Cbytes And 1
        Vector_Cbytes = (Vector_Cbytes + lngOffset) \ 2
        lngUbound = Vector_Cbytes + lngBaseIndex - 1
        ReDim btBytes(lngBaseIndex To lngUbound)
        lngOffset = 2 - lngOffset
        btBytes(lngBaseIndex) = CByte("&H" + Mid(strBytes, 2, lngOffset))
        Do Until lngBaseIndex = lngUbound
            lngOffset = lngOffset + 2
            lngBaseIndex = lngBaseIndex + 1
            btBytes(lngBaseIndex) = CByte("&H" + Mid(strBytes, lngOffset, 2))
        Loop
    Case Else
        Vector_Cbytes = Len(strBytes)
        ReDim btBytes(lngBaseIndex To Vector_Cbytes + lngBaseIndex - 1)
        lngBaseIndex = lngBaseIndex - 1
        For lngOffset = 1 To Vector_Cbytes
            btBytes(lngBaseIndex + lngOffset) = Asc(Mid(strBytes, lngOffset, 1))
        Next lngOffset
    End Select
End Function
