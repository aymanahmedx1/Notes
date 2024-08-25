import 'dart:developer';

import 'package:flutter/cupertino.dart';

import '../Models/CompanyModel.dart';
import '../data/CompanyDB.dart';
import '../screens/Company/Widgets/CompanyDialogs.dart';

class CompanyProvider with ChangeNotifier {
  List<CompanyModel> _companyModels = [];
  List<CompanyModel> filterdCompanyModels = [];
  List<WorkerModel> workersModel = [];
  List<WorkerModel> filter = [];

  CompanyProvider() {
    fillCompanyList();
  }

  fillCompanyList() async {
    _companyModels = await CompanyDB().getAll();
    filterdCompanyModels = List<CompanyModel>.from(_companyModels);
    notifyListeners();
  }

  void createOrUpdate(BuildContext context, CompanyModel? data) async {
    await CompanyDialogs().createOrUpdate(context, data);
    fillCompanyList();
  }

  fillWorkerList(int companyID, int finish) async {
    workersModel = await CompanyDB().getAllWorkers(companyID, finish);
    filter = List<WorkerModel>.from(workersModel);
    filter.sort((a, b) => (a.total - a.out).compareTo(b.total - b.out));
    notifyListeners();
  }

  workerFilter(String value) {
    if (value != "") {
      filter.clear();
      filter = workersModel
          .where((i) => i.drug.contains(value) || i.name.contains(value))
          .toList();
      filter.sort((a, b) => (a.total - a.out).compareTo(b.total - b.out));
    } else {
      filter = new List<WorkerModel>.from(workersModel);
    }
    notifyListeners();
  }

  createWorker(
      BuildContext context, CompanyModel company, WorkerModel? model) async {
    await CompanyDialogs().createWorkerDialog(context, company, model);
    fillWorkerList(company.id, 0);
  }

  updateWorker(WorkerModel workerModel) async {
    await CompanyDB().updateWorker(workerModel);
    fillWorkerList(workerModel.company, 0);
  }

  saveWorker(WorkerModel workerModel) async {
    await CompanyDB().addWorker(workerModel);
    fillWorkerList(workerModel.company, 0);
  }

  addCompany(CompanyModel company) async {
    await CompanyDB().add(company);
    fillCompanyList();
    notifyListeners();
  }

  updateCompany(CompanyModel company) async {
    await CompanyDB().update(company);
    fillCompanyList();
    notifyListeners();
  }

  void markWorkerAsFinish(WorkerModel workerModel) async {
    await CompanyDB().markWorkerFinish(workerModel);
    fillWorkerList(workerModel.company, 0);
  }

  companyFilter(String value) {
    if (value != "") {
      filterdCompanyModels.clear();
      filterdCompanyModels =
          _companyModels.where((i) => i.name.contains(value)).toList();
    } else {
      filterdCompanyModels = List<CompanyModel>.from(_companyModels);
    }
    notifyListeners();
  }

  void deleteCompany(CompanyModel companymodel) async{
    await  CompanyDB().deleteWorkers(companymodel);
    await  CompanyDB().deleteCompany(companymodel);
    fillCompanyList();
  }
}
