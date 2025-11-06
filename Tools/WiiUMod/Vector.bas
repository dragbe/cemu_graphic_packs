Attribute VB_Name = "Vector"
Option Explicit
Public Enum VECTOR_ITEM_STATUS
    UNSORTED_VECTOR_ITEM = -2
    OUTSIDELEFT_VECTOR_ITEM = -1
    INRANGE_VECTOR_ITEM = 0
    OUTSIDERIGHT_VECTOR_ITEM = 1
    EXISTING_VECTOR_ITEM = 2
End Enum
Public Enum VECTOR_STRINGITEMS_COMPAREMODES
    STRINGITEMS_NORMAL_COMPARE = 0
    STRINGITEMS_LENGTH_COMPARE = 1
    STRINGITEMS_HASH_COMPARE = 2
    STRINGITEMS_UHASH_COMPARE = 3
End Enum
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
Public Function Vector_SearchLongItemIndex(ByVal lngSearch As Long, ByRef lngArray() As Long, Optional ByVal lngStartIndex As Long = -2147483648#, Optional ByVal lngEndIndex As Long = 2147483647, Optional ByRef ITEMSTATUS As VECTOR_ITEM_STATUS = UNSORTED_VECTOR_ITEM, Optional ByRef blnUnsignedCompare As Boolean = False) As Long
Dim lnglngSearch As LongLong
Dim lnglngValue As LongLong
    Vector_SearchLongItemIndex = LBound(lngArray)
    If lngStartIndex < Vector_SearchLongItemIndex Then lngStartIndex = Vector_SearchLongItemIndex
    Vector_SearchLongItemIndex = UBound(lngArray)
    If lngEndIndex > Vector_SearchLongItemIndex Then lngEndIndex = Vector_SearchLongItemIndex
    If ITEMSTATUS = UNSORTED_VECTOR_ITEM Then
        'For unsorted long array
        For Vector_SearchLongItemIndex = lngStartIndex To lngEndIndex
            If lngArray(Vector_SearchLongItemIndex) = lngSearch Then Exit For
        Next Vector_SearchLongItemIndex
    Else
        'For sort ascending long array
        If blnUnsignedCompare Then
            lnglngSearch = Converter_CULng(lngSearch)
            If lnglngSearch > Converter_CULng(lngArray(lngStartIndex)) Then
                If lnglngSearch < Converter_CULng(lngArray(lngEndIndex)) Then
                    ITEMSTATUS = INRANGE_VECTOR_ITEM
                    Do
                        Vector_SearchLongItemIndex = (lngEndIndex + lngStartIndex) \ 2
                        If lngSearch = lngArray(Vector_SearchLongItemIndex) Then
                            ITEMSTATUS = EXISTING_VECTOR_ITEM
                            Exit Function
                        Else
                            lnglngValue = Converter_CULng(lngArray(Vector_SearchLongItemIndex))
                            If lnglngSearch > lnglngValue Then
                                lngStartIndex = Vector_SearchLongItemIndex
                            Else
                                lngEndIndex = Vector_SearchLongItemIndex
                            End If
                        End If
                    Loop Until lngEndIndex - lngStartIndex < 2
                    If lnglngSearch > lnglngValue Then
                        Vector_SearchLongItemIndex = Vector_SearchLongItemIndex + 1
                        If lngSearch = lngArray(Vector_SearchLongItemIndex) Then ITEMSTATUS = EXISTING_VECTOR_ITEM
                    End If
                Else
                    GoSub Vector_SearchLongItemIndexSub0
                End If
            Else
                GoSub Vector_SearchLongItemIndexSub1
            End If
        Else
            If lngSearch > lngArray(lngStartIndex) Then
                If lngSearch < lngArray(lngEndIndex) Then
                    ITEMSTATUS = INRANGE_VECTOR_ITEM
                    Do
                        Vector_SearchLongItemIndex = (lngEndIndex + lngStartIndex) \ 2
                        If lngSearch > lngArray(Vector_SearchLongItemIndex) Then
                            lngStartIndex = Vector_SearchLongItemIndex
                        ElseIf lngSearch < lngArray(Vector_SearchLongItemIndex) Then
                            lngEndIndex = Vector_SearchLongItemIndex
                        ElseIf lngSearch = lngArray(Vector_SearchLongItemIndex) Then
                            ITEMSTATUS = EXISTING_VECTOR_ITEM
                            Exit Function
                        End If
                    Loop Until lngEndIndex - lngStartIndex < 2
                    If lngSearch > lngArray(Vector_SearchLongItemIndex) Then
                        Vector_SearchLongItemIndex = Vector_SearchLongItemIndex + 1
                        If lngSearch = lngArray(Vector_SearchLongItemIndex) Then ITEMSTATUS = EXISTING_VECTOR_ITEM
                    End If
                Else
                    GoSub Vector_SearchLongItemIndexSub0
                End If
            Else
                GoSub Vector_SearchLongItemIndexSub1
            End If
        End If
    End If
    Exit Function
Vector_SearchLongItemIndexSub0:
    If lngSearch = lngArray(lngEndIndex) Then
        ITEMSTATUS = EXISTING_VECTOR_ITEM
        Vector_SearchLongItemIndex = lngEndIndex
    Else
        ITEMSTATUS = OUTSIDERIGHT_VECTOR_ITEM
        Vector_SearchLongItemIndex = lngEndIndex + 1
    End If
    Return
Vector_SearchLongItemIndexSub1:
    If lngSearch = lngArray(lngStartIndex) Then
        ITEMSTATUS = EXISTING_VECTOR_ITEM
        Vector_SearchLongItemIndex = lngStartIndex
    Else
        ITEMSTATUS = OUTSIDELEFT_VECTOR_ITEM
        Vector_SearchLongItemIndex = lngStartIndex - 1
    End If
    Return
End Function
Public Function Vector_GetLongItemToInsertIndex(ByVal lngValueToInsert As Long, ByRef lngArray() As Long, Optional ByRef blnUnsignedCompare As Boolean = False) As Long
Dim ITEMSTATUS As VECTOR_ITEM_STATUS
    Vector_GetLongItemToInsertIndex = Vector_SearchLongItemIndex(lngValueToInsert, lngArray, , , ITEMSTATUS, blnUnsignedCompare)
    If ITEMSTATUS = OUTSIDELEFT_VECTOR_ITEM Then Vector_GetLongItemToInsertIndex = Vector_GetLongItemToInsertIndex + 1
End Function
Public Function Vector_SortLongItems(ByRef lngArray() As Long, Optional ByVal blnUnsignedCompare As Boolean = False) As Long()
Dim i As Long
Dim j As Long
Dim lngUbound As Long
Dim varout() As Long
Dim lngTemp As Long
    lngUbound = UBound(lngArray)
    i = LBound(lngArray)
    varout = Arithmetic_GetLongLinearSequence(i, lngUbound - i + 1, 1, i)
    If blnUnsignedCompare Then
        Do
            blnUnsignedCompare = False
            For j = i + 1 To lngUbound
                If Converter_CULng(lngArray(i)) > Converter_CULng(lngArray(j)) Then
                    GoSub Vector_SortLongItemsSub0
                End If
            Next j
            i = i + 1
        Loop While i <= lngUbound And blnUnsignedCompare
    Else
        Do
            blnUnsignedCompare = False
            For j = i + 1 To lngUbound
                If lngArray(i) > lngArray(j) Then
                    GoSub Vector_SortLongItemsSub0
                End If
            Next j
            i = i + 1
        Loop While i <= lngUbound And blnUnsignedCompare
    End If
    Vector_SortLongItems = varout
    Exit Function
Vector_SortLongItemsSub0:
    lngTemp = varout(i)
    varout(i) = varout(j)
    varout(j) = lngTemp
    lngTemp = lngArray(i)
    lngArray(i) = lngArray(j)
    lngArray(j) = lngTemp
    blnUnsignedCompare = True
    Return
End Function
Public Function Vector_SortStringItems(ByRef strArray() As String, Optional ByVal STRINGITEMS_COMPAREMODE As VECTOR_STRINGITEMS_COMPAREMODES = STRINGITEMS_NORMAL_COMPARE, Optional ByRef blnReturnSortCompareData As Boolean = False) As Long()
Dim i As Long
Dim j As Long
Dim lngLbound As Long
Dim lngUbound As Long
Dim varout() As Long
Dim strTemp As String
Dim blnLoop As Boolean
Dim lngArray() As Long
Dim strCloneArray() As String
    lngUbound = UBound(strArray)
    lngLbound = LBound(strArray)
    ReDim lngArray(lngLbound To lngUbound)
    varout = Arithmetic_GetLongLinearSequence(lngLbound, lngUbound - lngLbound + 1, 1, lngLbound)
    Select Case STRINGITEMS_COMPAREMODE
    Case STRINGITEMS_LENGTH_COMPARE
        blnLoop = False
        ReDim strCloneArray(lngLbound To lngUbound)
        For j = lngLbound To lngUbound
            lngArray(j) = Len(strArray(j))
            strCloneArray(j) = strArray(j)
        Next j
        GoSub Vector_SortStringItemsSub1
    Case STRINGITEMS_HASH_COMPARE, STRINGITEMS_UHASH_COMPARE
        blnLoop = (STRINGITEMS_COMPAREMODE = STRINGITEMS_UHASH_COMPARE)
        ReDim strCloneArray(lngLbound To lngUbound)
        For j = lngLbound To lngUbound
            lngArray(j) = Hash_CRC32(strArray(j))
            strCloneArray(j) = strArray(j)
        Next j
        GoSub Vector_SortStringItemsSub1
    Case Else
        i = lngLbound
        Do
            blnLoop = False
            For j = i + 1 To lngUbound
                If strArray(i) > strArray(j) Then
                    strTemp = strArray(i)
                    strArray(i) = strArray(j)
                    strArray(j) = strTemp
                    STRINGITEMS_COMPAREMODE = varout(i)
                    varout(i) = varout(j)
                    varout(j) = STRINGITEMS_COMPAREMODE
                    blnLoop = True
                End If
            Next j
            i = i + 1
        Loop While i <= lngUbound And blnLoop
        For j = lngLbound + 1 To lngUbound
            lngArray(j) = Vbstring_GetCommonRootStringLength(strArray(j), strArray(j - 1))
        Next j
    End Select
    If blnReturnSortCompareData Then
        For j = lngLbound To lngUbound
            varout(j) = lngArray(j)
        Next j
    End If
    Vector_SortStringItems = varout
    Erase lngArray
    Exit Function
Vector_SortStringItemsSub1:
    varout = Vector_SortLongItems(lngArray, blnLoop)
    For j = lngLbound To lngUbound
        strArray(j) = strCloneArray(varout(j))
    Next j
    Erase strCloneArray
    Return
End Function
