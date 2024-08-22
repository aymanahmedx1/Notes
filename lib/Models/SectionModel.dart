class SectionModel {
  int id;

  String name;

  double total;

  SectionModel({required this.id, required this.name, required this.total});
}

class ExpenseModel {
  int id;

  int section;
  String reason;

  double amount;

  String note;
  String date;

  ExpenseModel(
      {required this.id,
      required this.section,
      required this.reason,
      required this.amount,
      required this.note,
      required this.date});
}
