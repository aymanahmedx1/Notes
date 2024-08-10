import 'package:flutter/material.dart';
import 'package:notes/screens/AddWorker.dart';

class Workers extends StatefulWidget {
  @override
  State<Workers> createState() => _WorkersState();
}

class _WorkersState extends State<Workers> {
  final ScrollController controller = ScrollController();
  int? _selectedRowIndex;

  void _onRowSelected(int index) {
    setState(() {
      _selectedRowIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
          child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(
                height: 5,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "المندوبين",
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.bold),
                  )
                ],
              ),
              Row(
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Row(
                        children: [Text("الرئيسيه"), Icon(Icons.home)],
                      )),
                  const SizedBox(
                    width: 30,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddWorker()));
                      },
                      child: const Row(
                        children: [Text("جديد"), Icon(Icons.add)],
                      )),
                ],
              ),
              Expanded(
                child: Scrollbar(
                  /// Scroll Bar
                  trackVisibility: true,
                  // SHow
                  interactive: true,
                  // Interact
                  thickness: 10,
                  // Width Of Scroll bar
                  controller: controller,
                  // Controll scroll bar location
                  thumbVisibility: true,
                  // show all time
                  child: SingleChildScrollView(
                    // scroll list
                    controller: controller,
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: double.infinity,
                          child: DataTable(
                              columns: const <DataColumn>[
                                DataColumn(
                                  label: Expanded(
                                    child: Text(
                                      'الشركه',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Expanded(
                                    child: Text(
                                      'ملاحظه',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Expanded(
                                    child: Text(
                                      'تاريخ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                              rows: List.generate(
                                300,
                                (index) {
                                  return DataRow(
                                    onLongPress: () {},
                                    color:
                                        WidgetStateProperty.resolveWith<Color>(
                                            (Set<MaterialState> states) {
                                      // Color for the row
                                      if (_selectedRowIndex == index) {
                                        return Colors.lightGreen;
                                      }
                                      return index % 2 == 0
                                          ? Colors.grey.shade200
                                          : Colors.white;
                                    }),
                                    cells: <DataCell>[
                                      DataCell(Text('الشركه')),
                                      DataCell(Text("$index")),
                                      DataCell(Text('2024-10-1')),
                                    ],
                                  );
                                },
                              )),
                        )),
                  ),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
// Table(
//
// border: TableBorder.all(),
// columnWidths: const <int, TableColumnWidth>{
// 0: FlexColumnWidth(),
// 1: FlexColumnWidth(),
// 2: FlexColumnWidth(),
// },
// defaultVerticalAlignment: TableCellVerticalAlignment.middle,
// children: [
// const TableRow(
// children: [
// TableCell(
// verticalAlignment: TableCellVerticalAlignment.middle,
// child: Padding(
// padding: EdgeInsets.all(8.0),
// child: Text("الشركه" , textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold),),
// ),
// ),
// TableCell(
// verticalAlignment: TableCellVerticalAlignment.middle,
// child: Padding(
// padding: EdgeInsets.all(8.0),
// child: Text("ملاحظه" , textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold),),
// ),
// ),
// TableCell(
// verticalAlignment: TableCellVerticalAlignment.middle,
// child: Padding(
// padding: EdgeInsets.all(8.0),
// child: Text("تاريخ" , textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold),),
// ),
// ),
// ],
// ),
// ...List.generate(
// 300,
// (index) {
// return TableRow(
// children: [
// TableCell(
// verticalAlignment: TableCellVerticalAlignment.top,
// child: Text("اسم الشركه"),
// ),
// TableCell(
// verticalAlignment: TableCellVerticalAlignment.top,
// child: Text("ملاحظه"),
// ),
// TableCell(
// verticalAlignment: TableCellVerticalAlignment.top,
// child: Text("تاريخ"),
// ),
// ],
// );
// },
// )
// ],
// ),
