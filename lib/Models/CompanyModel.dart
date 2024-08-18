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
  WorkerModel(this.id, this.name,this.phone , this.company);
}