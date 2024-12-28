class SectionModel {
  int id;
  String name;
  double totalIn;
  double totalOut;
  SectionModel(
      {required this.id,
      required this.name,
      required this.totalIn,
      required this.totalOut });

  @override
  String toString() {
    // TODO: implement toString
    return "id $id ,name $name ,totalIn $totalIn ,totalOut $totalOut ";
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
  SectionModel? sectionModel;

  ExpenseModel(
      {required this.id,
      required this.section,
      required this.reason,
      required this.amount,
      required this.note,
      required this.date,
      required this.expenseType,
      this.sectionModel});

  @override
  String toString() {
    // TODO: implement toString
    return "$id , $section , $reason , $amount , $note , $date , $expenseType";
  }
}

enum ExpenseType { all, moneyIn, moneyOut }
