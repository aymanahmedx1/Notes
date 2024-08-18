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
    List<Map> res = await db.readData('''  select * from  company''');
    List<CompanyModel> list = [];
    for (var record in res) {
      list.add(CompanyModel(
          record['id'], record['name'], record['note'], record['date']));
    }
    return list;
  }

  addWorker(WorkerModel model) async {
    await db.insertData(
        ''' insert into worker (name,phone,company) values (?,?,?) ''',
        [model.name, model.phone, model.company]);
  }

  getAllWorkers() async {
    List<Map> res = await db.readData('''  select * from  worker''');
    List<WorkerModel> list = [];
    for (var record in res) {
      list.add(WorkerModel(
          record['id'], record['name'], record['phone'], record['company']));
    }
    return list;
  }
}
