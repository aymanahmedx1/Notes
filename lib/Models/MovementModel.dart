class MovementModel {
  int id ;
  int workerId ;
  int qty ;
  String date ;
  MovementModel({required this.id,required  this.workerId,required this.qty ,required this.date});
  @override
  String toString() {
    return "$id ,$workerId , $qty , $date";
  }
}