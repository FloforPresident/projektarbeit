import 'package:flutter/material.dart';


class CustomDataTable extends SizedBox {
  CustomDataTable({
    Key key,
    @required List<DataColumn> columns,
    int sortColumnIndex,
    bool sortAscending = true,
    Function onSelectAll,
    double dataRowHeight = kMinInteractiveDimension,
    double headingRowHeight = 56.0,
    double horizontalMargin = 0.0,
    double columnSpacing = 0.0,
    @required List<DataRow> rows,
  }) : super(
          width: double.infinity,
          child: DataTable(
              columns: columns,
              sortColumnIndex: sortColumnIndex,
              sortAscending: sortAscending,
              onSelectAll: onSelectAll,
              dataRowHeight: kMinInteractiveDimension,
              headingRowHeight: headingRowHeight,
              rows: rows,
              columnSpacing: 0.0,
              horizontalMargin: 0.0),
        ) {}


        //todo add possibility to add textstyles
  static List<DataRow> generateStatusRows(
      Color backgroundColor, List<List<String>> dataTableRows) {
//  static List<DataRow> generateStatusRows(Color backgroundColor,TextStyle textStyle, List<List<String>> dataTableRows) todo {

    Iterator dataTableRowsIterator = dataTableRows.iterator;
    Iterator stringArrayIterator;

    List<DataRow> dataRows = new List();
    List<DataCell> dataCells = new List();

    Color currentColor;

    for (int i = 0; dataTableRowsIterator.moveNext(); i++) {
      currentColor = (i % 2 == 0) ? backgroundColor : Colors.white;
      stringArrayIterator = dataTableRows[i].iterator;
      for (int y = 0; stringArrayIterator.moveNext(); y++) {
        dataCells.add(DataCell(
            CustomColourText(Text(dataTableRows[i][y]), currentColor)));
//        dataCells.add(DataCell(CustomColourText(Text(dataTableRows[i][y],style: textStyle),currentColor)));

      }
      dataRows.add(DataRow(cells: dataCells));
      dataCells = new List();
    }

    return dataRows;
  }

}


///Use this for better positioning of Column TextWidget
class CustomColumnText extends StatelessWidget
{

  Text _textWidget;
  EdgeInsets _padding;
  CustomColumnText(this._textWidget, [this._padding = const EdgeInsets.all(15.0)]);

  @override
  Widget build(BuildContext context) {

    return Container(
      child: _textWidget,
      padding: _padding,
    );
  }

}

///Use this as instead of DataCells
///Will produce a Container Widget taken up full space
class CustomColourText extends StatelessWidget {

  Color _backgroundColor;
  final Text _text;
  EdgeInsetsGeometry padding;

  CustomColourText(this._text,[ this._backgroundColor = Colors.white,this.padding = const EdgeInsets.all(15.0)]);

  Widget build(BuildContext context) {
    return Container(child: _text,
      color: _backgroundColor,
      height: double.infinity,
      width: double.infinity,
      padding: EdgeInsets.all(15.0),);
  }


}


