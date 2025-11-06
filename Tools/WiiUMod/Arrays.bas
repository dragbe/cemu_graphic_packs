Attribute VB_Name = "Arrays"
Option Explicit
'https://learn.microsoft.com/en-us/windows/win32/api/oaidl/ns-oaidl-safearray
Private Type stSafeArrayBound
    lngItemsCount As Long
    lngLbound As Long
End Type
Public Type stSafeArray1D
    intDimensionsCount As Integer
    intFeaturesFlag As Integer
    lngItemSize As Long
    lngLocksCount As Long
    'lngDummy As Long
    ptrData As LongPtr
    stArrayBound As stSafeArrayBound
End Type
Public Enum ARRAYS_SAFEARRAY_FEATURES
    FADF_AUTO = &H1
    FADF_STATIC = &H2
    FADF_EMBEDDED = &H4
    FADF_FIXEDSIZE = &H10
    FADF_RECORD = &H20
    FADF_HAVEIID = &H40
    FADF_HAVEVARTYPE = &H80
    FADF_BSTR = &H100
    FADF_UNKNOWN = &H200
    FADF_DISPATCH = &H400
    FADF_VARIANT = &H800
    FADF_RESERVED = &HF008
End Enum
Public Type stObjectItem
    strParamName As String
    varParamValue As Variant
End Type
Public Type stHashTableItem
    strKey As String
    strValue As String
    lngHash As Long
End Type
Public Type stHashTable
    stItems() As stHashTableItem
    lngItemsCount As Long
    lngHashesMap(1 To 50) As Long
End Type
Public Function Arrays_GetDimsCount(ByRef varArray As Variant) As Integer
'MAX DIMENSIONS COUNT: 60
Dim lngLbound As Long
    On Error GoTo Arrays_GetDimsCount_err
    For Arrays_GetDimsCount = 1 To 60
        lngLbound = LBound(varArray, Arrays_GetDimsCount)
    Next Arrays_GetDimsCount
Arrays_GetDimsCount_err:
    Arrays_GetDimsCount = Arrays_GetDimsCount - 1
End Function
