class CompanyModel {
  int id ;
  String name ;
  String notes ;
  String date ;
  CompanyModel(this.id, this.name,this.notes , this.date);
  @override
  String toString() {
    return "$id ,$name , $notes , $date";
  }
}

class WorkerModel{
  int id ;
  String name ;
  String phone ;
  int company ;
  String drug ;
  String total ;
  String out ;
  String note ;
  WorkerModel({ required this.id, required this.name,required this.phone ,required this.company ,required this.total ,required this.out ,required this.note , required this.drug});
}