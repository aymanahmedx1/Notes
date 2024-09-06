import 'package:flutter/material.dart';

class TableHeader extends StatelessWidget {
  final double width;

  const TableHeader({required this.width});

  @override
  Widget build(BuildContext context) {
    final double colSize = width / 12;
    return makeRow(context, colSize);
  }

  makeRow(BuildContext context, double colSize) {
    return Container(
      color: Colors.grey,
      padding: const EdgeInsets.symmetric(vertical: 10),
      margin: const EdgeInsets.only(bottom: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          makeChild("م", colSize * .5),
          makeChild("الاسم", colSize * 2),
          makeChild("الهاتف", colSize * 1.5),
          makeChild("الادوية", colSize * 1.5),
          makeChild("الاجمالي", colSize * 1),
          makeChild("المنصرف", colSize * 1),
          makeChild("ملاحظات", colSize * 2),
          makeChild("التاريخ", colSize * 1.5),
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
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
