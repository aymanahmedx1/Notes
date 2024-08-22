import 'dart:developer';

import 'package:notes/Models/CompanyModel.dart';
import 'package:notes/data/Database.dart';

class CompanyDB {
  DatabaseHelper db = new DatabaseHelper();

  add(CompanyModel model) async {
    await db.insertData(
        ''' insert into company (name,note,date) values (?,?,?) ''',
        [model.name, model.notes, model.date]);
  }

  update(CompanyModel model) async {
    await db.updateData(''' update company set name=? ,note=? where id = ?''',
        [model.name, model.notes, model.id]);
  }

  getAll() async {
    List<Map> res = await db.readData('''  select * from  company''',[]);
    List<CompanyModel> list = [];
    for (var record in res) {
      list.add(CompanyModel(
          record['id'], record['name'], record['note'], record['date']));
    }
    return list;
  }

  addWorker(WorkerModel model) async {
    await db.insertData(
        ''' insert into worker (name,phone,company,total,out,note,drug) values (?,?,?,?,?,?,?) ''',
        [model.name, model.phone, model.company,model.total,model.out , model.note,model.drug]);
  }

  getAllWorkers(int company) async {
   try{
     List<Map> res = await db.readData('''  select * from  worker where  company = ?''' ,[company]);
     List<WorkerModel> list = [];
     for (var record in res) {
       list.add(WorkerModel(
         id: record['id'],
         name: record['name'],
         phone: record['phone'],
         company: record['company'],
         total: record['total'],
         out: record['out'],
         note: record['note'],
         drug:  record['drug'],
       ));
     }
     return list;
   }catch (e) {
     log("$e");
   }
  }

  updateWorker(WorkerModel model)async{
    await db.insertData(
        ''' update worker set name= ? ,phone= ? ,company= ?,total= ?,out= ?,note= ?,drug= ? where id = ? ''',
        [model.name, model.phone, model.company,model.total,model.out , model.note,model.drug ,model.id]);
  }
}
