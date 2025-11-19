Attribute VB_Name = "Memory"
Option Explicit
Public Declare PtrSafe Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" (ByVal Destination As LongPtr, ByVal Source As LongPtr, ByVal Length As LongLong)
Public Declare PtrSafe Sub FillMemory Lib "kernel32" Alias "RtlFillMemory" (ByVal Destination As LongPtr, ByVal Length As LongLong, ByVal Fill As Byte)
Public Declare PtrSafe Function CompareMemory Lib "Ntdll.dll" Alias "RtlCompareMemory" (ByVal buffA As LongPtr, ByVal buffB As LongPtr, ByVal Length As Long) As Long
Public Declare PtrSafe Function ReadProcessMemory Lib "kernel32" (ByVal hProcess As Long, ByVal lngBaseAddress As LongPtr, ByVal lpBuffer As LongPtr, ByVal lngSize As Long, ByRef lpNumberOfBytesWritten As Long) As Long
Public Declare PtrSafe Function WriteProcessMemory Lib "kernel32" (ByVal hProcess As Long, ByVal lngBaseAddress As LongPtr, ByVal lpBuffer As LongPtr, ByVal lngSize As Long, ByRef lpNumberOfBytesWritten As Long) As Long
Private Const VT_BYREF As Long = &H4000 'Flag used to simulate ByRef Variants
Public Type stDataMap
    lngLowerOffsets() As Long
    lngDataSize As Long
    btData() As Byte
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
Private Type stByte8
    l As Long
    r As Long
End Type
Private Type stByte16
    l As stByte8
    r As stByte8
End Type
Private Type stByte32
    l As stByte16
    r As stByte16
End Type
Private Type stByte64
    l As stByte32
    r As stByte32
End Type
Private Type stByte128
    l As stByte64
    r As stByte64
End Type
Private Type stByte256
    l As stByte128
    r As stByte128
End Type
Private Type stByte512
    l As stByte256
    r As stByte256
End Type
Private Type stByte1K
    l As stByte512
    r As stByte512
End Type
Private Type stByte2K
    l As stByte1K
    r As stByte1K
End Type
Private Type stByte4K
    l As stByte2K
    r As stByte2K
End Type
Private Type stByte8K
    l As stByte4K
    r As stByte4K
End Type
Private Type stByte16K
    l As stByte8K
    r As stByte8K
End Type
Private Type stByte32K
    l As stByte16K
    r As stByte16K
End Type
Private Type stArrayAccessor
    'For working directly with data types
    ptrData() As LongPtr
    btData() As Byte
    blnData() As Boolean
    intData() As Integer
    lngData() As Long
    sngData() As Single
    curData() As Currency
    dtData() As Date
    dbData() As Double
    varData() As Variant
    objData() As Object
    strData() As String
    lnglngData() As LongLong
    'For copying memory without overlap (faster than String)
    b16() As stByte16
    b32() As stByte32
    b64() As stByte64
    b128() As stByte128
    b256() As stByte256
    b512() As stByte512
    b1K() As stByte1K
    b2K() As stByte2K
    b4K() As stByte4K
    b8K() As stByte8K
    b16K() As stByte16K
    b32K() As stByte32K
    'For copying memory with overlap (slower than Byte)
    s16() As String * 8
    s32() As String * 16
    s64() As String * 32
    s128() As String * 64
    s256() As String * 128
    s512() As String * 256
    s1K() As String * 512
    s2K() As String * 1024
    s4K() As String * 2048
    s8K() As String * 4096
    s16K() As String * 8192
    s32K() As String * 16384
    'For referencing fake SAFE ARRAYs
    stFakeArrays() As stSafeArray1D
End Type
Private Type stByteInfo
    blnBits(0 To 7) As Boolean
End Type
Private Type stMemoryAccessor
    stArrAc As stArrayAccessor
    stArray As stSafeArray1D
End Type
Private Sub Memory_InitMemoryAccessor(ByRef stMemAcToInit As stMemoryAccessor)
'Links all arrays under 'ac' accessor to the 'sa' SAFEARRAY
Static stMemAc As stMemoryAccessor
    If stMemAcToInit.stArray.intDimensionsCount = 0 Then
        If stMemAc.stArray.intDimensionsCount = 0 Then
            With stMemAc.stArray
                .intDimensionsCount = 1
                .lngItemSize = 8
                .lngLocksCount = 1
                .intFeaturesFlag = FADF_AUTO Or FADF_FIXEDSIZE
            End With
            Call CopyMemory(VarPtr(stMemAc.stArrAc), VarPtr(VarPtr(stMemAc.stArray)), 8)
        End If
        With stMemAcToInit.stArray
            .intDimensionsCount = 1
            .intFeaturesFlag = FADF_AUTO Or FADF_FIXEDSIZE
        End With
        With stMemAc.stArray
        .ptrData = VarPtr(stMemAcToInit.stArrAc)
        .stArrayBound.lngItemsCount = LenB(stMemAcToInit.stArrAc) / 8
        stMemAc.stArrAc.ptrData(0) = VarPtr(stMemAcToInit.stArray)
        stMemAcToInit.stArray.lngLocksCount = .stArrayBound.lngItemsCount
        Do
            stMemAcToInit.stArray.lngLocksCount = stMemAcToInit.stArray.lngLocksCount - 1
            stMemAc.stArrAc.ptrData(stMemAcToInit.stArray.lngLocksCount) = stMemAc.stArrAc.ptrData(0)
        Loop Until stMemAcToInit.stArray.lngLocksCount = 1
        .stArrayBound.lngItemsCount = 0
        .ptrData = 0^
        End With
    End If
End Sub
Public Sub Memory_CopyMemory(ByRef ptrDestination As LongPtr, ByRef ptrSource As LongPtr, ByVal lngBytesCount As Long, Optional ByVal lngMaxSizeSpeedGain As Long = &H2000000)
'- https://github.com/cristianbuse/VBA-MemoryTools
Static stSrcMemAc As stMemoryAccessor
Static stDestMemAc As stMemoryAccessor
Static stByteMap(0 To 255) As stByteInfo
Dim blnOverLap As Boolean
Dim i As Long
    If ptrDestination <> ptrSource Then
        If lngBytesCount < 0 Or lngBytesCount > lngMaxSizeSpeedGain Then
            Call CopyMemory(ptrDestination, ptrSource, lngBytesCount)
        Else
            If stSrcMemAc.stArray.intDimensionsCount = 0 Then
                Call Memory_InitMemoryAccessor(stSrcMemAc)
                Call Memory_InitMemoryAccessor(stDestMemAc)
                For i = &H1 To &HFF&
                    With stByteMap(i)
                        For lngMaxSizeSpeedGain = 0 To 7
                            .blnBits(lngMaxSizeSpeedGain) = i And 2 ^ lngMaxSizeSpeedGain
                        Next lngMaxSizeSpeedGain
                    End With
                Next i
            End If
            stSrcMemAc.stArray.ptrData = ptrSource
            stDestMemAc.stArray.ptrData = ptrDestination
            If lngBytesCount <= 8 Then
                stSrcMemAc.stArray.stArrayBound.lngItemsCount = 1
                stDestMemAc.stArray.stArrayBound.lngItemsCount = 1
                Select Case lngBytesCount
                    Case 0:
                        GoTo Clean
                    Case 1:
                        stDestMemAc.stArrAc.btData(0) = stSrcMemAc.stArrAc.btData(0)
                        GoTo Clean
                    Case 2:
                        stDestMemAc.stArrAc.intData(0) = stSrcMemAc.stArrAc.intData(0)
                        GoTo Clean
                    Case 4:
                        stDestMemAc.stArrAc.lngData(0) = stSrcMemAc.stArrAc.lngData(0)
                        GoTo Clean
                    Case 8:
                        stDestMemAc.stArrAc.curData(0) = stSrcMemAc.stArrAc.curData(0)
                        GoTo Clean
                End Select
            End If
            blnOverLap = (ptrDestination > ptrSource) And (ptrSource + lngBytesCount > ptrDestination) 'overlap status
            With stSrcMemAc.stArray
            If lngBytesCount And &H7FFF8000 Then
                .lngItemSize = &H8000&
                stDestMemAc.stArray.lngItemSize = &H8000&
                .stArrayBound.lngItemsCount = lngBytesCount \ .lngItemSize
                stDestMemAc.stArray.stArrayBound.lngItemsCount = .stArrayBound.lngItemsCount
                lngMaxSizeSpeedGain = .stArrayBound.lngItemsCount * .lngItemSize
                lngBytesCount = lngBytesCount - lngMaxSizeSpeedGain
                If blnOverLap Then
                    .ptrData = .ptrData + lngBytesCount
                    stDestMemAc.stArray.ptrData = stDestMemAc.stArray.ptrData + lngBytesCount
                    For i = .stArrayBound.lngItemsCount - 1 To 0 Step -1
                        stDestMemAc.stArrAc.s32K(i) = stSrcMemAc.stArrAc.s32K(i)
                    Next i
                Else
                    i = 0
                    Do While i < .stArrayBound.lngItemsCount
                         stDestMemAc.stArrAc.b32K(i) = stSrcMemAc.stArrAc.b32K(i)
                        i = i + 1
                    Loop
                    .ptrData = .ptrData + lngMaxSizeSpeedGain
                    stDestMemAc.stArray.ptrData = stDestMemAc.stArray.ptrData + lngMaxSizeSpeedGain
                End If
                lngMaxSizeSpeedGain = &H8000&
            ElseIf blnOverLap Then
                .ptrData = .ptrData + lngBytesCount
                stDestMemAc.stArray.ptrData = stDestMemAc.stArray.ptrData + lngBytesCount
            End If
            .stArrayBound.lngItemsCount = 1
            End With
            stDestMemAc.stArray.stArrayBound.lngItemsCount = 1
            i = lngBytesCount And &HFF&
            If i Then
                With stByteMap(i)
                    If blnOverLap Then
                        If .blnBits(0) Then stSrcMemAc.stArray.ptrData = stSrcMemAc.stArray.ptrData - 1: stDestMemAc.stArray.ptrData = stDestMemAc.stArray.ptrData - 1: stDestMemAc.stArrAc.btData(0) = stSrcMemAc.stArrAc.btData(0)
                        If .blnBits(1) Then stSrcMemAc.stArray.ptrData = stSrcMemAc.stArray.ptrData - 2: stDestMemAc.stArray.ptrData = stDestMemAc.stArray.ptrData - 2: stDestMemAc.stArrAc.intData(0) = stSrcMemAc.stArrAc.intData(0)
                        If .blnBits(2) Then stSrcMemAc.stArray.ptrData = stSrcMemAc.stArray.ptrData - 4: stDestMemAc.stArray.ptrData = stDestMemAc.stArray.ptrData - 4: stDestMemAc.stArrAc.lngData(0) = stSrcMemAc.stArrAc.lngData(0)
                        If .blnBits(3) Then stSrcMemAc.stArray.ptrData = stSrcMemAc.stArray.ptrData - 8: stDestMemAc.stArray.ptrData = stDestMemAc.stArray.ptrData - 8: stDestMemAc.stArrAc.curData(0) = stSrcMemAc.stArrAc.curData(0)
                        If .blnBits(4) Then stSrcMemAc.stArray.ptrData = stSrcMemAc.stArray.ptrData - 16: stDestMemAc.stArray.ptrData = stDestMemAc.stArray.ptrData - 16: stDestMemAc.stArrAc.s16(0) = stSrcMemAc.stArrAc.s16(0)
                        If .blnBits(5) Then stSrcMemAc.stArray.ptrData = stSrcMemAc.stArray.ptrData - 32: stDestMemAc.stArray.ptrData = stDestMemAc.stArray.ptrData - 32: stDestMemAc.stArrAc.s32(0) = stSrcMemAc.stArrAc.s32(0)
                        If .blnBits(6) Then stSrcMemAc.stArray.ptrData = stSrcMemAc.stArray.ptrData - 64: stDestMemAc.stArray.ptrData = stDestMemAc.stArray.ptrData - 64: stDestMemAc.stArrAc.s64(0) = stSrcMemAc.stArrAc.s64(0)
                        If .blnBits(7) Then stSrcMemAc.stArray.ptrData = stSrcMemAc.stArray.ptrData - 128: stDestMemAc.stArray.ptrData = stDestMemAc.stArray.ptrData - 128: stDestMemAc.stArrAc.s128(0) = stSrcMemAc.stArrAc.s128(0)
                    Else
                        If .blnBits(0) Then stDestMemAc.stArrAc.btData(0) = stSrcMemAc.stArrAc.btData(0): stSrcMemAc.stArray.ptrData = stSrcMemAc.stArray.ptrData + 1: stDestMemAc.stArray.ptrData = stDestMemAc.stArray.ptrData + 1
                        If .blnBits(1) Then stDestMemAc.stArrAc.intData(0) = stSrcMemAc.stArrAc.intData(0): stSrcMemAc.stArray.ptrData = stSrcMemAc.stArray.ptrData + 2: stDestMemAc.stArray.ptrData = stDestMemAc.stArray.ptrData + 2
                        If .blnBits(2) Then stDestMemAc.stArrAc.lngData(0) = stSrcMemAc.stArrAc.lngData(0): stSrcMemAc.stArray.ptrData = stSrcMemAc.stArray.ptrData + 4: stDestMemAc.stArray.ptrData = stDestMemAc.stArray.ptrData + 4
                        If .blnBits(3) Then stDestMemAc.stArrAc.curData(0) = stSrcMemAc.stArrAc.curData(0): stSrcMemAc.stArray.ptrData = stSrcMemAc.stArray.ptrData + 8: stDestMemAc.stArray.ptrData = stDestMemAc.stArray.ptrData + 8
                        If .blnBits(4) Then stDestMemAc.stArrAc.b16(0) = stSrcMemAc.stArrAc.b16(0): stSrcMemAc.stArray.ptrData = stSrcMemAc.stArray.ptrData + 16: stDestMemAc.stArray.ptrData = stDestMemAc.stArray.ptrData + 16
                        If .blnBits(5) Then stDestMemAc.stArrAc.b32(0) = stSrcMemAc.stArrAc.b32(0): stSrcMemAc.stArray.ptrData = stSrcMemAc.stArray.ptrData + 32: stDestMemAc.stArray.ptrData = stDestMemAc.stArray.ptrData + 32
                        If .blnBits(6) Then stDestMemAc.stArrAc.b64(0) = stSrcMemAc.stArrAc.b64(0): stSrcMemAc.stArray.ptrData = stSrcMemAc.stArray.ptrData + 64: stDestMemAc.stArray.ptrData = stDestMemAc.stArray.ptrData + 64
                        If .blnBits(7) Then stDestMemAc.stArrAc.b128(0) = stSrcMemAc.stArrAc.b128(0): stSrcMemAc.stArray.ptrData = stSrcMemAc.stArray.ptrData + 128: stDestMemAc.stArray.ptrData = stDestMemAc.stArray.ptrData + 128
                    End If
                End With
            End If
            i = (lngBytesCount And &H7F00&) / &H100&
            If i Then
                With stByteMap(i)
                    If blnOverLap Then
                        If .blnBits(0) Then stSrcMemAc.stArray.ptrData = stSrcMemAc.stArray.ptrData - 256: stDestMemAc.stArray.ptrData = stDestMemAc.stArray.ptrData - 256: stDestMemAc.stArrAc.s256(0) = stSrcMemAc.stArrAc.s256(0)
                        If .blnBits(1) Then stSrcMemAc.stArray.ptrData = stSrcMemAc.stArray.ptrData - 512: stDestMemAc.stArray.ptrData = stDestMemAc.stArray.ptrData - 512: stDestMemAc.stArrAc.s512(0) = stSrcMemAc.stArrAc.s512(0)
                        If .blnBits(2) Then stSrcMemAc.stArray.ptrData = stSrcMemAc.stArray.ptrData - 1024: stDestMemAc.stArray.ptrData = stDestMemAc.stArray.ptrData - 1024: stDestMemAc.stArrAc.s1K(0) = stSrcMemAc.stArrAc.s1K(0)
                        If .blnBits(3) Then stSrcMemAc.stArray.ptrData = stSrcMemAc.stArray.ptrData - 2048: stDestMemAc.stArray.ptrData = stDestMemAc.stArray.ptrData - 2048: stDestMemAc.stArrAc.s2K(0) = stSrcMemAc.stArrAc.s2K(0)
                        If .blnBits(4) Then stSrcMemAc.stArray.ptrData = stSrcMemAc.stArray.ptrData - 4096: stDestMemAc.stArray.ptrData = stDestMemAc.stArray.ptrData - 4096: stDestMemAc.stArrAc.s4K(0) = stSrcMemAc.stArrAc.s4K(0)
                        If .blnBits(5) Then stSrcMemAc.stArray.ptrData = stSrcMemAc.stArray.ptrData - 8192: stDestMemAc.stArray.ptrData = stDestMemAc.stArray.ptrData - 8192: stDestMemAc.stArrAc.s8K(0) = stSrcMemAc.stArrAc.s8K(0)
                        If .blnBits(6) Then stSrcMemAc.stArray.ptrData = stSrcMemAc.stArray.ptrData - 16384: stDestMemAc.stArray.ptrData = stDestMemAc.stArray.ptrData - 16384: stDestMemAc.stArrAc.s16K(0) = stSrcMemAc.stArrAc.s16K(0)
                    Else
                        If .blnBits(0) Then stDestMemAc.stArrAc.b256(0) = stSrcMemAc.stArrAc.b256(0): stSrcMemAc.stArray.ptrData = stSrcMemAc.stArray.ptrData + 256: stDestMemAc.stArray.ptrData = stDestMemAc.stArray.ptrData + 256
                        If .blnBits(1) Then stDestMemAc.stArrAc.b512(0) = stSrcMemAc.stArrAc.b512(0): stSrcMemAc.stArray.ptrData = stSrcMemAc.stArray.ptrData + 512: stDestMemAc.stArray.ptrData = stDestMemAc.stArray.ptrData + 512
                        If .blnBits(2) Then stDestMemAc.stArrAc.b1K(0) = stSrcMemAc.stArrAc.b1K(0): stSrcMemAc.stArray.ptrData = stSrcMemAc.stArray.ptrData + 1024: stDestMemAc.stArray.ptrData = stDestMemAc.stArray.ptrData + 1024
                        If .blnBits(3) Then stDestMemAc.stArrAc.b2K(0) = stSrcMemAc.stArrAc.b2K(0): stSrcMemAc.stArray.ptrData = stSrcMemAc.stArray.ptrData + 2048: stDestMemAc.stArray.ptrData = stDestMemAc.stArray.ptrData + 2048
                        If .blnBits(4) Then stDestMemAc.stArrAc.b4K(0) = stSrcMemAc.stArrAc.b4K(0): stSrcMemAc.stArray.ptrData = stSrcMemAc.stArray.ptrData + 4096: stDestMemAc.stArray.ptrData = stDestMemAc.stArray.ptrData + 4096
                        If .blnBits(5) Then stDestMemAc.stArrAc.b8K(0) = stSrcMemAc.stArrAc.b8K(0): stSrcMemAc.stArray.ptrData = stSrcMemAc.stArray.ptrData + 8192: stDestMemAc.stArray.ptrData = stDestMemAc.stArray.ptrData + 8192
                        If .blnBits(6) Then stDestMemAc.stArrAc.b16K(0) = stSrcMemAc.stArrAc.b16K(0): stSrcMemAc.stArray.ptrData = stSrcMemAc.stArray.ptrData + 16384: stDestMemAc.stArray.ptrData = stDestMemAc.stArray.ptrData + 16384
                    End If
                End With
            End If
Clean:
            stSrcMemAc.stArray.stArrayBound.lngItemsCount = 0
            stDestMemAc.stArray.stArrayBound.lngItemsCount = 0
            stSrcMemAc.stArray.ptrData = 0^
            stDestMemAc.stArray.ptrData = 0^
            Exit Sub
        End If
    End If
End Sub
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
    ReDim .btData(0 To .lngDataSize - 1)
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
    If lngBytesCount > lngLbound Then
        lngBytesCount = lngStartOffset + lngLbound
    Else
        lngBytesCount = lngStartOffset + lngBytesCount
    End If
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
Public Function Memory_ItemCmp(ByRef lngptrMemItem1 As LongPtr, ByRef lngptrMemItem2 As LongPtr, ByVal lngItemSize As Long) As Integer
Dim strMemData1 As String
Dim strMemData2 As String
    strMemData1 = Space(lngItemSize)
    strMemData2 = strMemData1
    Call CopyMemory(StrPtr(strMemData1), lngptrMemItem1, lngItemSize)
    Call CopyMemory(StrPtr(strMemData2), lngptrMemItem2, lngItemSize)
    Memory_ItemCmp = StrComp(strMemData1, strMemData2, vbBinaryCompare)
End Function
