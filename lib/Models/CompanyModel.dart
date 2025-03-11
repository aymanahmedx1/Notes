class CompanyModel {
  int id;

  String name;

  String notes;

  String date;

  CompanyModel(
      {required this.id,
      required this.name,
      required this.notes,
      required this.date});

  @override
  String toString() {
    return "$id ,$name , $notes , $date";
  }
}

class WorkerModel {
  int id;
  String name;
  String phone;
  int company;
  String drug;
  int total;
  int out;
  String note;
  String date;
  String expDate;
  int finish;
  double price;

  WorkerModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.company,
    required this.total,
    required this.out,
    required this.note,
    required this.drug,
    required this.date,
    required this.expDate,
    required this.finish,
    required this.price,
  });
}
