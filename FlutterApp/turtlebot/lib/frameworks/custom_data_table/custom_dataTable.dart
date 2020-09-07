import 'package:flutter/material.dart';

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



}
