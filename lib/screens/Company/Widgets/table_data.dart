import 'package:flutter/material.dart';
import 'package:notes/Providers/CompanyProvider.dart';
import 'package:notes/screens/Company/MovementsScreen.dart';
import 'package:provider/provider.dart';

import '../../../CustomWidgets/CustomButton.dart';
import '../../../CustomWidgets/Spacers.dart';
import '../../../Models/CompanyModel.dart';

class TableData extends StatelessWidget {
  final double width;
  final CompanyModel companyModel;
  final List<WorkerModel> filter;
  final ScrollController controller;

  TableData({
    required this.width,
    required this.filter,
    required this.companyModel,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate column sizes proportionally based on content importance
    final Map<String, double> columnWidths = _calculateColumnWidths(width);

    return ListView.separated(
      controller: controller,
      physics: const AlwaysScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return makeRow(index, filter[index], context, companyModel, columnWidths);
      },
      separatorBuilder: (context, index) {
        return const Divider(height: 1);
      },
      itemCount: filter.length,
    );
  }

  Map<String, double> _calculateColumnWidths(double totalWidth) {
    // Distributing column widths proportionally
    return {
      'index': totalWidth * 0.04,     // 4%
      'name': totalWidth * 0.17,      // 17%
      'phone': totalWidth * 0.10,     // 10%
      'drug': totalWidth * 0.13,      // 13%
      'total': totalWidth * 0.08,     // 8%
      'out': totalWidth * 0.08,       // 8%
      'price': totalWidth * 0.08,     // 8%
      'expDate': totalWidth * 0.10,   // 10%
      'note': totalWidth * 0.12,      // 12%
      'date': totalWidth * 0.10,      // 10%
    };
  }

  Widget makeRow(int index, WorkerModel worker, BuildContext context,
      CompanyModel companyModel, Map<String, double> columnWidths) {
    return InkWell(
      onTap: () {
        // Add tap for mobile users who can't use long press easily
        _showActionDialog(context, worker, companyModel);
      },
      onLongPress: () {
        _showActionDialog(context, worker, companyModel);
      },
      child: Container(
        color: getColor(worker.expDate),
        height: 50, // Fixed height for predictable rows
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            makeChild("${index + 1}", columnWidths['index']!),
            makeChild(worker.name, columnWidths['name']!),
            makeChild(worker.phone, columnWidths['phone']!),
            makeChild(worker.drug, columnWidths['drug']!),
            makeChild("${worker.total}", columnWidths['total']!),
            makeChild("${worker.out}", columnWidths['out']!),
            makeChild("${worker.price}", columnWidths['price']!),
            makeChild(worker.expDate, columnWidths['expDate']!),
            makeChild(worker.note, columnWidths['note']!),
            makeChild(worker.date, columnWidths['date']!),
          ],
        ),
      ),
    );
  }

  void _showActionDialog(BuildContext context, WorkerModel worker, CompanyModel companyModel) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("اختر إجراء للمتابعة"),
          actions: [
            CustomButton(
              onPressed: () {
                Navigator.pop(context);
                Provider.of<CompanyProvider>(context, listen: false)
                    .workerId = worker.id;
                Provider.of<CompanyProvider>(context, listen: false)
                    .fillMovements();
                Navigator.of(context).pushNamed(Movementsscreen.rout);
              },
              text: "تفاصيل",
              icon: Icons.list,
            ),
            heightSpace,
            CustomButton(
              onPressed: () {
                Navigator.pop(context);
                Provider.of<CompanyProvider>(context, listen: false)
                    .createWorker(context, companyModel, worker);
              },
              text: "تعديل",
              icon: Icons.edit,
            ),
            heightSpace,
            CustomButton(
                text: "حذف",
                onPressed: () {
                  Provider.of<CompanyProvider>(context, listen: false)
                      .deleteWorker(worker);
                  Navigator.pop(context);
                },
                icon: Icons.delete),
            heightSpace,
            worker.out >= worker.total
                ? CustomButton(
              onPressed: () {
                Provider.of<CompanyProvider>(context, listen: false)
                    .markWorkerAsFinish(worker);
                Navigator.pop(context);
              },
              text: "أكتمل",
              icon: Icons.check,
            )
                : Container()
          ],
        );
      },
    );
  }

  Widget makeChild(String data, double width) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      alignment: Alignment.center,
      child: Text(
        data,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
        style: const TextStyle(fontSize: 13),
      ),
    );
  }

  Color getColor(String? worker) {
    if (worker != null && worker.isNotEmpty) {
      try {
        return DateTime.parse(worker)
            .isBefore(DateTime.now().add(const Duration(days: 30 * 4)))
            ? Colors.deepOrange.withOpacity(0.3)
            : Colors.white;
      } catch (e) {
        return Colors.white;
      }
    }
    return Colors.white;
  }
}