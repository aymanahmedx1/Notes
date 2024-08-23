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
         id: record['id'],name: record['name'],notes:  record['note'],date: record['date']));
    }
    return list;
  }

  addWorker(WorkerModel model) async {
    await db.insertData(
        ''' insert into worker (name,phone,company,total,out,note,drug,date,finish) values (?,?,?,?,?,?,?,?,?) ''',
        [model.name, model.phone, model.company,model.total,model.out , model.note,model.drug,model.date,0]);
  }

  getAllWorkers(int company , int finish) async {
   try{
     List<Map> res = await db.readData('''  select * from  worker where  company = ? and finish = ?''' ,[company,finish]);
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
         date:  record['date'],
         finish: record['finish']
       ));
     }
     return list;
   }catch (e) {
     log("$e");
   }
  }

  updateWorker(WorkerModel model)async{
    await db.updateData(
        ''' update worker set name= ? ,phone= ? ,company= ?,total= ?,out= ?,note= ?,drug= ?,date=? where id = ? ''',
        [model.name, model.phone, model.company,model.total,model.out , model.note,model.drug,model.date ,model.id]);
  }

  markWorkerFinish(WorkerModel model)async {
    await db.updateData(
        ''' update worker set finish = true where id = ? ''',
        [model.id]);
  }
}
