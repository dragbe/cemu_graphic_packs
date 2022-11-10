Attribute VB_Name = "Memory"
Option Explicit
Public Declare PtrSafe Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" (ByVal Destination As LongPtr, ByVal Source As LongPtr, ByVal Length As Long)
Public Declare PtrSafe Function CompareMemory Lib "Ntdll.dll" Alias "RtlCompareMemory" (ByVal buffA As LongPtr, ByVal buffB As LongPtr, ByVal Length As Long) As Long
Public Declare PtrSafe Function ReadProcessMemory Lib "kernel32" (ByVal hProcess As Long, ByVal lngBaseAddress As LongPtr, ByVal lpBuffer As LongPtr, ByVal lngSize As Long, ByRef lpNumberOfBytesWritten As Long) As Long
Public Declare PtrSafe Function WriteProcessMemory Lib "kernel32" (ByVal hProcess As Long, ByVal lngBaseAddress As LongPtr, ByVal lpBuffer As LongPtr, ByVal lngSize As Long, ByRef lpNumberOfBytesWritten As Long) As Long
Public Type stDataMap
    lngLowerOffsets() As Long
    lngDataSize As Long
    btdata() As Byte
End Type
Public Type stPatchSetting
    lngPatchSize As Long
    lpDataLocation As LongPtr
    lngLngTargetOffset As LongLong
End Type
Public Type stPatches
    lngPatchesCount As Long
    stPatchSettings() As stPatchSetting
End Type
Public Sub Memory_InitDataMap(ByRef strMapDataSource As String, ByRef stMemoryDataMap As stDataMap, Optional ByRef strSeparator As String = " ")
Dim strLowOffsets() As String
Dim xlsRange As Range
    With stMemoryDataMap
    If InStr(strMapDataSource, ":") = 0 Then
        strLowOffsets = Split(strMapDataSource, strSeparator)
        .lngDataSize = UBound(strLowOffsets)
        ReDim .lngLowerOffsets(0 To .lngDataSize - 1)
        Do
            .lngLowerOffsets(.lngDataSize - 1) = CLng(strLowOffsets(.lngDataSize))
            .lngDataSize = .lngDataSize - 1
        Loop Until .lngDataSize = 0
        .lngDataSize = CLng(strLowOffsets(0))
        Erase strLowOffsets
    Else
        .lngDataSize = InStr(strMapDataSource, ".")
        Set xlsRange = Worksheets(Left(strMapDataSource, .lngDataSize - 1)).Range(Mid(strMapDataSource, .lngDataSize + 1)).Cells
        strLowOffsets = Split(xlsRange.Item(1, 2).Text, vbLf)
        .lngDataSize = UBound(strLowOffsets)
        ReDim .lngLowerOffsets(0 To .lngDataSize)
        Do
            .lngLowerOffsets(.lngDataSize) = CLng(strLowOffsets(.lngDataSize))
            .lngDataSize = .lngDataSize - 1
        Loop Until .lngDataSize < 0
        Erase strLowOffsets
        .lngDataSize = xlsRange.Item(1, 3).Value
        Set xlsRange = Nothing
    End If
    ReDim .btdata(0 To .lngDataSize - 1)
    End With
End Sub
Public Function Memory_GetMappedData(ByRef lngHProcess As Long, ByRef lngLngMemoryBase As LongLong, ByRef lngLowerOffsets() As Long) As Long
Dim i As Long
    For i = UBound(lngLowerOffsets) To 0 Step -1
        If ReadProcessMemory(lngHProcess, lngLngMemoryBase + lngLowerOffsets(i) + Memory_GetMappedData, VarPtr(Memory_GetMappedData), 4, 0) <> 0 Then
            Memory_GetMappedData = Converter_SwapEndian32(Memory_GetMappedData)
        Else
            Memory_GetMappedData = 0
            Exit Function
        End If
    Next i
End Function
Public Function Memory_PortableGetMappedData(ByRef lngHProcess As Long, ByRef lngLngMemoryBase As LongLong, ByRef strOffsets As String, Optional ByRef strSeparator As String = " ") As Long
Dim strLowerOffsets() As String
Dim lngLowerOffsets() As Long
    strLowerOffsets = Split(strOffsets, strSeparator)
    Memory_PortableGetMappedData = UBound(strLowerOffsets)
    ReDim lngLowerOffsets(0 To Memory_PortableGetMappedData)
    Do
        lngLowerOffsets(Memory_PortableGetMappedData) = CLng(strLowerOffsets(Memory_PortableGetMappedData))
        Memory_PortableGetMappedData = Memory_PortableGetMappedData - 1
    Loop Until Memory_PortableGetMappedData < 0
    Memory_PortableGetMappedData = Memory_GetMappedData(lngHProcess, lngLngMemoryBase, lngLowerOffsets)
    Erase lngLowerOffsets
    Erase strLowerOffsets
End Function
Public Function Memory_HexDump(ByRef btBytes() As Byte, Optional ByVal lngStartOffset As Long = 0, Optional ByRef strSeparator As String = " ", Optional ByVal lngBytesCount As Long = 32767) As String
Dim lngLbound As Long
Dim lngUbound As Long
    lngLbound = LBound(btBytes)
    lngStartOffset = lngStartOffset + lngLbound
    lngUbound = UBound(btBytes)
    lngLbound = lngUbound - lngLbound
    lngBytesCount = lngBytesCount - 1
    lngBytesCount = lngStartOffset + IIf(lngBytesCount > lngLbound, lngLbound, lngBytesCount)
    If lngUbound > lngBytesCount Then lngUbound = lngBytesCount
    For lngLbound = lngStartOffset To lngUbound
        Memory_HexDump = Memory_HexDump + strSeparator + Right("0" + Hex(btBytes(lngLbound)), 2)
    Next lngLbound
    Memory_HexDump = Mid(Memory_HexDump, Len(strSeparator) + 1)
End Function
Public Function Memory_VarHexDump(ByRef pVarData As LongPtr, ByVal intDataSize As Integer, Optional ByRef strSeparator As String = " ") As String
Dim btBytes() As Byte
    Call Converter_Var2Bytes(btBytes, pVarData, intDataSize)
    Memory_VarHexDump = Memory_HexDump(btBytes(), 0, strSeparator)
    Erase btBytes
End Function
Public Function Memory_ReadProcessLongMemoryDataSegment(ByRef lngHProcess As Long, ByRef lngLngMemoryBase As LongLong, ByVal lngDataCount As Long, ByRef lngDataSegment() As Long) As Long
    ReDim lngDataSegment(1 To lngDataCount)
    Memory_ReadProcessLongMemoryDataSegment = ReadProcessMemory(lngHProcess, lngLngMemoryBase, VarPtr(lngDataSegment(1)), lngDataCount * 4, 0)
End Function
Public Function Memory_CopyProcessMemory(ByRef lngHProcess As Long, ByRef lngLngDestMemoryBase As LongLong, ByRef lnglngSourceMemoryBase As LongLong, ByVal lngDataSize As Long) As Long
Dim btBuffer() As Byte
    ReDim btBuffer(1 To lngDataSize)
    If ReadProcessMemory(lngHProcess, lnglngSourceMemoryBase, VarPtr(btBuffer(1)), lngDataSize, 0) <> 0 Then Memory_CopyProcessMemory = WriteProcessMemory(lngHProcess, lngLngDestMemoryBase, VarPtr(btBuffer(1)), lngDataSize, 0)
    Erase btBuffer
End Function
Public Function Memory_PatchProcessMemory(ByRef lngHProcess As Long, ByRef stMemoryPatches As stPatches) As Long
'return stMemoryPatches.lngPatchesCount+1 on success
    If WriteProcessMemory(lngHProcess, stMemoryPatches.stPatchSettings(1).lngLngTargetOffset, stMemoryPatches.stPatchSettings(1).lpDataLocation, Abs(stMemoryPatches.stPatchSettings(1).lngPatchSize), 0) <> 0 Then
        If stMemoryPatches.stPatchSettings(1).lngPatchSize < 0 Then
            For Memory_PatchProcessMemory = 2 To stMemoryPatches.lngPatchesCount
                With stMemoryPatches.stPatchSettings(Memory_PatchProcessMemory)
                .lngLngTargetOffset = stMemoryPatches.stPatchSettings(Memory_PatchProcessMemory - 1).lngLngTargetOffset + .lngLngTargetOffset
                If WriteProcessMemory(lngHProcess, .lngLngTargetOffset, .lpDataLocation, .lngPatchSize, 0) = 0 Then Exit Function
                End With
            Next Memory_PatchProcessMemory
        Else
            For Memory_PatchProcessMemory = 2 To stMemoryPatches.lngPatchesCount
                With stMemoryPatches.stPatchSettings(Memory_PatchProcessMemory)
                If WriteProcessMemory(lngHProcess, .lngLngTargetOffset, .lpDataLocation, .lngPatchSize, 0) = 0 Then Exit Function
                End With
            Next Memory_PatchProcessMemory
        End If
    End If
End Function
Public Function Memory_PatchMemory(ByRef lpMemoryBase As LongPtr, ByRef stMemoryPatches As stPatches) As Long
'return stMemoryPatches.lngPatchesCount+1 on success
    With stMemoryPatches.stPatchSettings(1)
    .lngLngTargetOffset = .lngLngTargetOffset + lpMemoryBase
    Call CopyMemory(.lngLngTargetOffset, .lpDataLocation, Abs(.lngPatchSize))
    End With
    If stMemoryPatches.stPatchSettings(1).lngPatchSize < 0 Then
        For Memory_PatchMemory = 2 To stMemoryPatches.lngPatchesCount
            With stMemoryPatches.stPatchSettings(Memory_PatchMemory)
            .lngLngTargetOffset = stMemoryPatches.stPatchSettings(Memory_PatchMemory - 1).lngLngTargetOffset + .lngLngTargetOffset
            Call CopyMemory(.lngLngTargetOffset, .lpDataLocation, .lngPatchSize)
            End With
        Next Memory_PatchMemory
    Else
        For Memory_PatchMemory = 2 To stMemoryPatches.lngPatchesCount
            With stMemoryPatches.stPatchSettings(Memory_PatchMemory)
            .lngLngTargetOffset = .lngLngTargetOffset + lpMemoryBase
            Call CopyMemory(.lngLngTargetOffset, .lpDataLocation, .lngPatchSize)
            End With
        Next Memory_PatchMemory
    End If
End Function
Public Function Memory_GetInteger(ByRef lngProcess As Long, ByRef lngLngDataAddress As LongLong, ByVal btDataSize As Byte) As LongLong
    If ReadProcessMemory(lngProcess, lngLngDataAddress, VarPtr(Memory_GetInteger), 8, 0) <> 0 Then
        If btDataSize < 8 Then Memory_GetInteger = Memory_GetInteger And (256^ ^ btDataSize - 1)
    End If
End Function
