import 'package:flutter/material.dart';

class TableHeader extends StatelessWidget {
  final double width;

  const TableHeader({required this.width});

  @override
  Widget build(BuildContext context) {
    // Calculate column sizes proportionally based on content importance
    final Map<String, double> columnWidths = _calculateColumnWidths(width);

    return SizedBox(
      width: width,
      child: Container(
        color: Colors.grey.shade300,
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            makeChild("م", columnWidths['index']!),
            makeChild("الاسم", columnWidths['name']!),
            makeChild("الهاتف", columnWidths['phone']!),
            makeChild("الادوية", columnWidths['drug']!),
            makeChild("المجموع", columnWidths['total']!),
            makeChild("المصروف", columnWidths['out']!),
            makeChild("لسعر", columnWidths['price']!),
            makeChild("الاكسباير", columnWidths['expDate']!),
            makeChild("ملاحظات", columnWidths['note']!),
            makeChild("التاريخ", columnWidths['date']!),
          ],
        ),
      ),
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

  Widget makeChild(String data, double width) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      alignment: Alignment.center,
      child: Text(
        data,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}