// DataTable(
// columns: const <DataColumn>[
// DataColumn(
// label: Expanded(
// child: Text(
// 'م',
// style: TextStyle(fontWeight: FontWeight.bold),
// ),
// ),
// ),
// DataColumn(
// label: Expanded(
// child: Text(
// 'الاسم',
// style: TextStyle(fontWeight: FontWeight.bold),
// ),
// ),
// ),
// DataColumn(
// label: Expanded(
// child: Text(
// 'الجوال',
// style: TextStyle(fontWeight: FontWeight.bold),
// ),
// ),
// ),
// DataColumn(
// label: Expanded(
// child: Text(
// 'المنتجات',
// style: TextStyle(fontWeight: FontWeight.bold),
// ),
// ),
// ),
// DataColumn(
// label: Expanded(
// child: Text(
// textAlign: TextAlign.center,
// softWrap: true,
// 'العدد الكلي',
// style: TextStyle(fontWeight: FontWeight.bold),
// ),
// ),
// ),
// DataColumn(
// label: Expanded(
// child: Text(
// textAlign: TextAlign.center,
// softWrap: true,
// 'العدد المنصرف',
// style: TextStyle(fontWeight: FontWeight.bold),
// ),
// ),
// ),
// DataColumn(
// label: Expanded(
// child: Text(
// 'ملاحظه',
// style: TextStyle(fontWeight: FontWeight.bold),
// ),
// ),
// ),
// DataColumn(
// label: Expanded(
// child: Text(
// 'تاريخ',
// style: TextStyle(fontWeight: FontWeight.bold),
// ),
// ),
// ),
// ],
// rows: List.generate(
// companyProvider.filter.length,
// (index) {
// return DataRow(
// cells: <DataCell>[
// DataCell(Text("${index + 1}")),
// DataCell(Text(companyProvider.filter[index].name)),
// DataCell(Text(companyProvider.filter[index].phone)),
// DataCell(Text(companyProvider.filter[index].drug)),
// DataCell(
// Text("${companyProvider.filter[index].total}")),
// DataCell(
// Text("${companyProvider.filter[index].out}")),
// DataCell(Text(companyProvider.filter[index].note)),
// DataCell(Text(companyProvider.filter[index].date)),
// ],
// );
// },
// )),