import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:notes/Providers/CompanyProvider.dart';
import 'package:provider/provider.dart';

import '../../../CustomWidgets/CustomButton.dart';
import '../../../CustomWidgets/Spacers.dart';
import '../../../Models/CompanyModel.dart';

class TableData extends StatelessWidget {
  final double width;
  final CompanyModel companyModel;

  final List<WorkerModel> filter;
  final ScrollController controller;

  TableData(
      {required this.width,
      required this.filter,
      required this.companyModel,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    final double colSize = width / 12;
    return ListView.separated(
      controller: controller,
      shrinkWrap: true,
        itemBuilder: (context, index) {
          return makeRow(index, filter[index], context, companyModel, colSize);
        },
        separatorBuilder: (context, index) {
          return const Divider();
        },
        itemCount: filter.length);
  }

  makeRow(int index, WorkerModel worker, BuildContext context,
      CompanyModel companyModel, double colSize) {
    return InkWell(
      onLongPress: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("اختر اجراء للمتابعه"),
              actions: [
                CustomButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Provider.of<CompanyProvider>(context,listen: false)
                        .createWorker(context, companyModel, worker);
                  },
                  text: "تعديل",
                  icon: Icons.edit,
                ),
                heightSpace,
                CustomButton(
                    text: "حذف",
                    onPressed: () {
                      Provider.of<CompanyProvider>(context,listen: false)
                          .deleteWorker(worker);
                      Navigator.pop(context);
                    },
                    icon: Icons.delete),
                heightSpace,
                worker.out >= worker.total
                    ? CustomButton(
                        onPressed: () {
                          Provider.of<CompanyProvider>(context,listen: false)
                              .markWorkerAsFinish(worker);
                          Navigator.pop(context);
                        },
                        text: "انتهي",
                        icon: Icons.check,
                      )
                    : Container()
              ],
            );
          },
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          makeChild("${index + 1}", colSize * .5),
          makeChild(worker.name, colSize * 2),
          makeChild(worker.phone, colSize * 1.5),
          makeChild(worker.drug, colSize * 1.5),
          makeChild("${worker.total}", colSize * 1),
          makeChild("${worker.out}", colSize * 1),
          makeChild(worker.note, colSize * 2),
          makeChild(worker.date, colSize * 1.5),
        ],
      ),
    );
  }

  makeChild(String data, double width) {
    return SizedBox(
      width: width,
      child: Text(
        data,
        textAlign: TextAlign.center,
      ),
    );
  }
}
