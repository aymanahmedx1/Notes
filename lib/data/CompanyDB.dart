import 'dart:developer';

import 'package:notes/Models/CompanyModel.dart';
import 'package:notes/Models/MovementModel.dart';
import 'package:notes/data/Database.dart';

import '../Commons/Helpers.dart';

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
    List<Map> res = await db.readData('''  select * from  company''', []);
    List<CompanyModel> list = [];
    for (var record in res) {
      list.add(CompanyModel(
          id: record['id'],
          name: record['name'],
          notes: record['note'],
          date: record['date']));
    }
    return list;
  }

  addWorker(WorkerModel model) async {
    await db.insertData(
        ''' insert into worker (name,phone,company,total,out,note,drug,date,expDate,finish,price) values (?,?,?,?,?,?,?,?,?,?,?) ''',
        [
          model.name,
          model.phone,
          model.company,
          model.total,
          model.out,
          model.note,
          model.drug,
          model.date,
          model.expDate,
          0,
          model.price
        ]);
  }

  getAllWorkers(int company, int finish) async {
    try {
      List<Map> res = await db.readData(
          '''  select * from  worker where  company = ? and finish = ?''',
          [company, finish]);
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
          drug: record['drug'],
          date: record['date'],
          expDate: record['expDate'],
          finish: record['finish'],
          price: (record['price'] ?? 0.0).toDouble(),
        ));
      }
      return list;
    } catch (e) {
      log("$e");
    }
  }

  Future<Set<String>> getAllWorkerNames(int company) async {
    List<Map> res = await db
        .readData('''  select * from  worker where  company = ? ''', [company]);
    List<String> list = [];
    for (var record in res) {
      list.add(record['name']);
    }
    return list.toSet();
  }

  Future<String> getWorkerPhoneByName(String name) async {
    List<Map> res = await db
        .readData('''  select * from  worker where  name = ? ''', [name]);
    for (var record in res) {
      return (record['phone']);
    }
    return "";
  }

  updateWorker(WorkerModel model) async {
    var x = await getWorkerById(model.id);
    int? oldQty = x?.out;

    await db.updateData(
        ''' update worker set name= ? ,phone= ? ,company= ?,total= ?,out =out+ ?,note= ?,drug= ?,date=?,expDate=?,price=? where id = ? ''',
        [
          model.name,
          model.phone,
          model.company,
          model.total,
          model.out,
          model.note,
          model.drug,
          model.date,
          model.expDate,
          model.price,
          model.id
        ]);
    if (((oldQty ?? 0) + model.out) != oldQty) {
      log("message");
      await addMovement(MovementModel(
          id: 0, workerId: model.id, qty: model.out, date: formattedDate()));
    }
  }

  Future<WorkerModel?> getWorkerById(int id) async {
    List<Map> res =
        await db.readData('''  select * from  worker where  id = ?''', [id]);
    List<WorkerModel> list = [];
    for (var record in res) {
      return WorkerModel(
        id: record['id'],
        name: record['name'],
        phone: record['phone'],
        company: record['company'],
        total: record['total'],
        out: record['out'],
        note: record['note'],
        drug: record['drug'],
        date: record['date'],
        expDate: record['expDate'],
        finish: record['finish'],
        price: record['price'],
      );
    }
    return null;
  }

  markWorkerFinish(WorkerModel model) async {
    await db.updateData(
        ''' update worker set finish = true where id = ? ''', [model.id]);
  }

  deleteWorkers(CompanyModel companymodel) async {
    await db
        .deleteData("delete from worker where company = ?", [companymodel.id]);
  }

  deleteCompany(CompanyModel companymodel) async {
    await db.deleteData("delete from company where id = ?", [companymodel.id]);
  }

  deleteWorker(WorkerModel workerModel) async {
    await db.deleteData("delete from worker where id = ?", [workerModel.id]);
  }

  // --------------    MOVEMENTS ---------------
  addMovement(MovementModel model) async {
    await db.insertData(
        ''' insert into movements (workerId,qty,date) values (?,?,?) ''',
        [model.workerId, model.qty, model.date]);
  }

  getAllMovement(int worker) async {
    List<Map> res = await db
        .readData('''  select * from  movements where workerId =?''', [worker]);
    List<MovementModel> list = [];
    for (var record in res) {
      list.add(MovementModel(
          id: record['id'],
          workerId: record['workerId'],
          qty: record['qty'],
          date: record['date']));
    }
    return list;
  }
}
