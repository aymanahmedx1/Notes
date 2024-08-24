class SectionModel {
  int id;

  String name;

  double total;

  SectionModel({required this.id, required this.name, required this.total});
  @override
  String toString() {
    // TODO: implement toString
    return " $id , $name , $total ";
  }
}

class ExpenseModel {
  int id;

  int section;
  ExpenseType expenseType;
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
      required this.date,
      required this.expenseType
      });
  @override
  String toString() {
    // TODO: implement toString
    return "$id , $section , $reason , $amount , $note , $date";
  }
}
enum ExpenseType{
  moneyIn,
  moneyOut
}
