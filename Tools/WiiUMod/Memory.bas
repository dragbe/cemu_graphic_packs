Attribute VB_Name = "Memory"
Option Explicit
Public Declare PtrSafe Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" (ByVal Destination As LongPtr, ByVal Source As LongPtr, ByVal Length As Long)
Public Declare PtrSafe Function CompareMemory Lib "Ntdll.dll" Alias "RtlCompareMemory" (ByVal buffA As LongPtr, ByVal buffB As LongPtr, ByVal Length As Long) As Long
Public Type stDataMap
    lngLowerOffsets() As Long
    lngDataSize As Long
    btdata() As Byte
End Type

Public Sub Memory_InitDataMap(ByVal strMapDataSource As String, ByRef stMemoryDataMap As stDataMap)
Dim strLowOffsets() As String
    If InStr(strMapDataSource, ":") = 0 Then
        strLowOffsets = Split(strMapDataSource, " ")
        stMemoryDataMap.lngDataSize = UBound(strLowOffsets)
        ReDim stMemoryDataMap.lngLowerOffsets(0 To stMemoryDataMap.lngDataSize - 1)
        Do
            stMemoryDataMap.lngLowerOffsets(stMemoryDataMap.lngDataSize - 1) = CLng(strLowOffsets(stMemoryDataMap.lngDataSize))
            stMemoryDataMap.lngDataSize = stMemoryDataMap.lngDataSize - 1
        Loop Until stMemoryDataMap.lngDataSize = 0
        stMemoryDataMap.lngDataSize = CLng(strLowOffsets(0))
        Erase strLowOffsets
    Else
        stMemoryDataMap.lngDataSize = InStr(strMapDataSource, ".")
        With Worksheets(Left(strMapDataSource, stMemoryDataMap.lngDataSize - 1)).Range(Mid(strMapDataSource, stMemoryDataMap.lngDataSize + 1)).Cells
        strLowOffsets = Split(.Item(1, 2).Text, Chr(10))
        stMemoryDataMap.lngDataSize = UBound(strLowOffsets)
        ReDim stMemoryDataMap.lngLowerOffsets(0 To stMemoryDataMap.lngDataSize)
        Do
            stMemoryDataMap.lngLowerOffsets(stMemoryDataMap.lngDataSize) = CLng(strLowOffsets(stMemoryDataMap.lngDataSize))
            stMemoryDataMap.lngDataSize = stMemoryDataMap.lngDataSize - 1
        Loop Until stMemoryDataMap.lngDataSize < 0
        Erase strLowOffsets
        stMemoryDataMap.lngDataSize = .Item(1, 3).Value
        End With
    End If
    ReDim stMemoryDataMap.btdata(0 To stMemoryDataMap.lngDataSize - 1)
End Sub

Public Function Memory_getMappedDataAddress(ByRef lngHProcess As Long, ByRef lngLngMemoryBase As LongLong, ByRef lngLowerOffsets() As Long) As Long
Dim i As Integer
    For i = UBound(lngLowerOffsets) To 0 Step -1
        If ReadProcessMemory(lngHProcess, lngLngMemoryBase + lngLowerOffsets(i) + Memory_getMappedDataAddress, VarPtr(Memory_getMappedDataAddress), 4, 0) <> 0 Then
            Memory_getMappedDataAddress = Converter_SwapEndian(Memory_getMappedDataAddress)
        Else
            Memory_getMappedDataAddress = 0
            Exit Function
        End If
    Next i
End Function
