import 'package:flutter/material.dart';

import 'custom_colour_text.dart';

class CustomDataTable extends DataTable {
  CustomDataTable({Key key,
    @required List<DataColumn> columns,
    int sortColumnIndex,
    bool sortAscending = true,
    Function onSelectAll,
    double dataRowHeight = kMinInteractiveDimension,
    double headingRowHeight = 56.0,
    double horizontalMargin = 0.0,
    double columnSpacing = 0.0,
    @required List<DataRow> rows,})
      : super(
    columns: columns,
    sortColumnIndex: sortColumnIndex,
    sortAscending: sortAscending,
    onSelectAll: onSelectAll,
    dataRowHeight: kMinInteractiveDimension,
    headingRowHeight: headingRowHeight,
    rows: rows,
    columnSpacing: 0.0,
    horizontalMargin: 0.0,){}
  static List<DataRow> generateStatusRows(Color backgroundColor, List<List<String>> dataTableRows) {

//  static List<DataRow> generateStatusRows(Color backgroundColor,TextStyle textStyle, List<List<String>> dataTableRows) {

    Iterator dataTableRowsIterator = dataTableRows.iterator;
    Iterator stringArrayIterator;

    List<DataRow> dataRows = new List();
    List<DataCell> dataCells = new List();

    Color currentColor;

    for (int i = 0;dataTableRowsIterator.moveNext();i++) {
      currentColor = (i % 2 == 0) ? backgroundColor : Colors.white;
      stringArrayIterator = dataTableRows[i].iterator;
      for(int y = 0; stringArrayIterator.moveNext() ;y++)
      {
        dataCells.add(DataCell(CustomColourText(Text(dataTableRows[i][y]),currentColor)));
//        dataCells.add(DataCell(CustomColourText(Text(dataTableRows[i][y],style: textStyle),currentColor)));

      }
      dataRows.add(DataRow(cells: dataCells));
      dataCells = new List();
    }

    return dataRows;

  }

}
