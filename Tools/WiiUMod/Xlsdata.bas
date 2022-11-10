Attribute VB_Name = "Xlsdata"
Option Explicit
Public Function Xlsdata_SkipRowBlankCells(ByRef xlsUserDataRange As Range, ByRef lngStartRow As Long, ByRef lngColumn, ByRef strNextRowCellText As String, ByRef lngMoveNextRowCellTextToRow As Long) As Long
    Xlsdata_SkipRowBlankCells = lngStartRow
    With xlsUserDataRange
    strNextRowCellText = .Item(Xlsdata_SkipRowBlankCells, lngColumn).Text
    Do Until strNextRowCellText <> ""
        Xlsdata_SkipRowBlankCells = Xlsdata_SkipRowBlankCells + 1
        strNextRowCellText = .Item(Xlsdata_SkipRowBlankCells, lngColumn).Text
    Loop
    If lngStartRow <> lngMoveNextRowCellTextToRow Then
        .Item(Xlsdata_SkipRowBlankCells, lngColumn).ClearContents
        .Item(lngMoveNextRowCellTextToRow, lngColumn).Value = strNextRowCellText
    End If
    End With
End Function
