import '../screens/Accounting/Widgets/table_data.dart';

class PrintDetailsModel {
  String title;
  String dateFrom;
  String dateTo;
  String reasonFilter;
  int totalIn;
  int totalOut;
  AccountingTableData data;

  PrintDetailsModel(
      {required this.title,
      required this.dateFrom,
      required this.dateTo,
      required this.reasonFilter,
      required this.totalIn,
      required this.totalOut,
      required this.data});
}
