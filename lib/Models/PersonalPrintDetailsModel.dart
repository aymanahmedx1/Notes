import '../screens/PersonalAccounting/Widgets/table_data.dart';

class PersonalPrintDetailsModel {
  String title;
  String dateFrom;
  String dateTo;
  String reasonFilter;
  int totalIn;
  int totalOut;
  PersonalAccountingTableData data;

  PersonalPrintDetailsModel(
      {required this.title,
      required this.dateFrom,
      required this.dateTo,
      required this.reasonFilter,
      required this.totalIn,
      required this.totalOut,
      required this.data});
}
