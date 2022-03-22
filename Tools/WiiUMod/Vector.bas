Attribute VB_Name = "Vector"
Option Explicit

Public Function Vector_ItemIndexes(ByRef lpVector As LongPtr, ByRef lpItem As LongPtr, ByVal intItemSize As Integer, ByVal intItemsCount As Integer, ByRef intItemOffsets() As Integer, Optional ByVal intLbound As Integer = 0) As Integer
    If intItemsCount <> 0 Then
        intItemsCount = intItemsCount * intItemSize
        Do
            intItemsCount = intItemsCount - intItemSize
            If CompareMemory(lpVector + intItemsCount, lpItem, intItemSize) = intItemSize Then
                Vector_ItemIndexes = Vector_ItemIndexes + 1
                ReDim Preserve intItemOffsets(1 To Vector_ItemIndexes)
                intItemOffsets(Vector_ItemIndexes) = intItemsCount / intItemSize + intLbound
            End If
        Loop Until intItemsCount = 0
    End If
End Function

Public Function Vector_InBytes(ByVal intStart As Integer, ByRef btBytes() As Byte, ByRef btSearchBytes() As Byte) As Integer
Dim pBtSearchBytes As LongPtr
Dim intUbound As Integer
Dim intLbound As Integer
Dim intBytesCount As Integer
    intLbound = LBound(btSearchBytes)
    intBytesCount = UBound(btSearchBytes) - intLbound + 1
    intStart = intStart + LBound(btBytes) - 1
    intUbound = UBound(btBytes) - intBytesCount + 1
    pBtSearchBytes = VarPtr(btSearchBytes(intLbound))
    Do Until intStart > intUbound
        If btBytes(intStart) = btSearchBytes(intLbound) Then
            Vector_InBytes = CompareMemory(VarPtr(btBytes(intStart)), pBtSearchBytes, intBytesCount)
            If Vector_InBytes = intBytesCount Then
                Vector_InBytes = intStart
                Exit Function
            End If
        End If
        intStart = intStart + 1
    Loop
    Vector_InBytes = 0
End Function

Public Function Vector_InBytes2(ByVal intStart As Integer, ByRef btBytes() As Byte, ByRef btSearchBytes() As Byte, Optional ByRef btJokerByte As Byte = 46) As Integer
Dim intJokerBytesCount As Integer
Dim intJokerByteIndexes() As Integer
Dim pBtSearchBytes As LongPtr
Dim intUbound As Integer
Dim intLbound As Integer
Dim intBytesCount As Integer
    intLbound = LBound(btSearchBytes)
    intBytesCount = UBound(btSearchBytes) - intLbound + 1
    intStart = intStart + LBound(btBytes) - 1
    intUbound = UBound(btBytes) - intBytesCount + 1
    pBtSearchBytes = VarPtr(btSearchBytes(intLbound))
    intJokerBytesCount = Vector_ItemIndexes(VarPtr(btSearchBytes(intLbound)), VarPtr(btJokerByte), 1, intBytesCount, intJokerByteIndexes)
    If intJokerBytesCount <> 0 Then
        Do Until intStart > intUbound
            For Vector_InBytes2 = intJokerBytesCount To 1 Step -1
                btSearchBytes(intJokerByteIndexes(Vector_InBytes2) + intLbound) = btBytes(intStart + intJokerByteIndexes(Vector_InBytes2))
            Next Vector_InBytes2
            If btBytes(intStart) = btSearchBytes(intLbound) Then
                Vector_InBytes2 = CompareMemory(VarPtr(btBytes(intStart)), pBtSearchBytes, intBytesCount)
                If Vector_InBytes2 = intBytesCount Then
                    Erase intJokerByteIndexes
                    Vector_InBytes2 = intStart
                    Exit Function
                End If
            End If
            intStart = intStart + 1
        Loop
        Erase intJokerByteIndexes
    End If
    Vector_InBytes2 = 0
End Function
