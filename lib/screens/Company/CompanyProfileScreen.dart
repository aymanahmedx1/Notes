import 'package:flutter/material.dart';
import 'package:notes/CustomWidgets/CustomButton.dart';
import 'package:notes/CustomWidgets/NoDataWidget.dart';
import 'package:notes/CustomWidgets/Spacers.dart';
import 'package:notes/Models/CompanyModel.dart';
import 'package:notes/Providers/CompanyProvider.dart';
import 'package:notes/screens/Company/CompanyFinishScreen.dart';
import 'package:provider/provider.dart';

import '../../Commons/Helpers.dart';
import 'MovementsScreen.dart';
import 'Widgets/CompanyDialogs.dart'; // Import CompanyDialogs

class CompanyProfileScreen extends StatefulWidget {
  static const String rout = "CompanyProfileScreen";

  @override
  State<CompanyProfileScreen> createState() => _CompanyProfileScreenState();
}

class _CompanyProfileScreenState extends State<CompanyProfileScreen> {
  // Vertical scroll controller for data rows
  final ScrollController verticalScrollController = ScrollController();

  // Single shared horizontal scroll controller for both header and data
  final ScrollController horizontalScrollController = ScrollController();

  final TextEditingController searchController = TextEditingController(
    text: "",
  );

  // Primary color for the theme - pink[600]
  final Color primaryColor = Colors.pink[600]!;

  @override
  void dispose() {
    verticalScrollController.dispose();
    horizontalScrollController.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final companyModel =
        ModalRoute.of(context)!.settings.arguments as CompanyModel;

    // Define minimum table width for all cases
    final double tableMinWidth =
        screenSize.width > 800 ? screenSize.width : 800;

    return Consumer<CompanyProvider>(
      builder: (context, companyProvider, child) {
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: primaryColor.withOpacity(0.9),
              centerTitle: true,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "تفاصيل شركة  ",
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    companyModel.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              actions: [
                PopupMenuButton<String>(
                  iconSize: 25,
                  color: Colors.white,
                  icon: const Icon(Icons.more_vert, color: Colors.white),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        child: Row(
                          children: [
                            CustomButton(
                              text: "أضافة مندوب",
                              icon: Icons.add_circle,
                              color: Colors.green.shade600,
                              onPressed: () async {
                                Navigator.pop(context);
                                companyProvider.createWorker(
                                  context,
                                  companyModel,
                                  null,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        child: Row(
                          children: [
                            CustomButton(
                              text: "العمليات المكتملة",
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pushNamed(
                                  context,
                                  CompanyFinishScreen.rout,
                                  arguments: companyModel,
                                );
                              },
                              icon: Icons.check_box,
                              color: Colors.red.shade600,
                            ),
                          ],
                        ),
                      ),
                    ];
                  },
                ),
              ],
            ),
            body: Container(
              decoration: BoxDecoration(color: Colors.grey[100]),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height / 400),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        return constraints.maxWidth > 600
                            ? _buildWideSearchBar(companyProvider, screenSize)
                            : _buildNarrowSearchBar(
                              companyProvider,
                              screenSize,
                            );
                      },
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height / 400),
                    // Show NoDataWidget when there's no data
                    companyProvider.filter.isEmpty
                        ? NoDataWidget()
                        : Expanded(
                          child: _buildResponsiveDataTable(
                            companyProvider,
                            screenSize,
                            companyModel,
                          ),
                        ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildResponsiveDataTable(
    CompanyProvider companyProvider,
    Size screenSize,
    CompanyModel companyModel,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWideScreen = constraints.maxWidth > 600;

        // Use a Scrollbar wrapped around SingleChildScrollView for better UX
        return Scrollbar(
          controller: verticalScrollController,
          thumbVisibility: true,
          thickness: 6,
          radius: const Radius.circular(8),
          child: SingleChildScrollView(
            controller: verticalScrollController,
            child: SingleChildScrollView(
              controller: horizontalScrollController,
              scrollDirection: Axis.horizontal,
              child: Container(
                // Ensure minimum width for the table
                constraints: BoxConstraints(
                  minWidth: isWideScreen ? constraints.maxWidth : 800,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 15,
                      spreadRadius: 2,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child:
                      isWideScreen
                          ? _buildDataTable(companyProvider, companyModel)
                          : _buildCompactDataTable(
                            companyProvider,
                            companyModel,
                          ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDataTable(
    CompanyProvider companyProvider,
    CompanyModel companyModel,
  ) {
    // Color constants for better consistency
    final Color headerBgColor = primaryColor.withOpacity(0.1);
    final Color accentColor = primaryColor;

    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.grey.shade200,
        dataTableTheme: DataTableThemeData(
          headingTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: accentColor,
            fontSize: 15,
          ),
          dataTextStyle: const TextStyle(fontSize: 10, color: Colors.black87),
        ),
      ),
      child: DataTable(
        columnSpacing: 16,
        dataRowHeight: 60,
        horizontalMargin: 8,
        headingRowHeight: 60,
        headingRowColor: MaterialStateProperty.all(headerBgColor),
        border: TableBorder(
          horizontalInside: BorderSide(width: 1, color: Colors.grey.shade200),
          top: BorderSide(width: 2, color: accentColor.withOpacity(0.5)),
          bottom: BorderSide(width: 1, color: Colors.grey.shade300),
          left: BorderSide(width: 1, color: Colors.grey.shade300),
          right: BorderSide(width: 1, color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(16),
        ),
        columns: _buildTableColumns(),
        rows: _buildDataRows(companyProvider, companyModel),
      ),
    );
  }

  Widget _buildCompactDataTable(
    CompanyProvider companyProvider,
    CompanyModel companyModel,
  ) {
    // For mobile devices - more compact version
    final Color headerBgColor = primaryColor.withOpacity(0.1);
    final Color accentColor = primaryColor;

    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.grey.shade200,
        dataTableTheme: DataTableThemeData(
          headingTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: accentColor,
            fontSize: 12,
          ),
          dataTextStyle: const TextStyle(
            fontSize: 10,
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      child: DataTable(
        columnSpacing: 10,
        dataRowHeight: 55,
        horizontalMargin: 2,
        headingRowHeight: 40,
        headingRowColor: MaterialStateProperty.all(headerBgColor),
        border: TableBorder(
          horizontalInside: BorderSide(width: 1, color: Colors.grey.shade200),
          top: BorderSide(width: 2, color: accentColor.withOpacity(0.5)),
          bottom: BorderSide(width: 1, color: Colors.grey.shade300),
          left: BorderSide(width: 1, color: Colors.grey.shade300),
          right: BorderSide(width: 1, color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(16),
        ),
        columns: _buildTableColumns(), //_buildCompactTableColumns()
        rows: _buildDataRows(
          companyProvider,
          companyModel,
        ), // _buildCompactDataRows(companyProvider, companyModel)
      ),
    );
  }

  List<DataColumn> _buildTableColumns() {
    return [
      DataColumn(
        label: Container(alignment: Alignment.center, child: const Text('ت')),
      ),
      DataColumn(
        label: Container(
          alignment: Alignment.center,
          child: const Text('المندوب'),
        ),
      ),
      DataColumn(
        label: Container(
          alignment: Alignment.center,
          child: const Text('المنتجات'),
        ),
      ),
      DataColumn(
        label: Container(
          alignment: Alignment.center,
          child: const Text('المجموع'),
        ),
      ),
      DataColumn(
        label: Container(
          alignment: Alignment.center,
          child: const Text('المصروف'),
        ),
      ),
      DataColumn(
        label: Container(
          alignment: Alignment.center,
          child: const Text('الاكسباير'),
        ),
      ),
      DataColumn(
        label: Container(
          alignment: Alignment.center,
          child: const Text('التاريخ'),
        ),
      ),
    ];
  }

  List<DataColumn> _buildCompactTableColumns() {
    return [
      DataColumn(
        label: Container(alignment: Alignment.center, child: const Text('ت')),
      ),
      DataColumn(
        label: Container(
          alignment: Alignment.center,
          child: const Text('تفاصيل'),
        ),
      ),
    ];
  }

  List<DataRow> _buildDataRows(
    CompanyProvider companyProvider,
    CompanyModel companyModel,
  ) {
    return List.generate(companyProvider.filter.length, (index) {
      final worker = companyProvider.filter[index];
      final balance = worker.total - worker.out;
      final bool isPositiveBalance = balance >= 0;
      final totAmount = worker.total;
      final outAmount = worker.out;

      return DataRow(
        color:
            index % 2 == 0
                ? MaterialStateProperty.all(Colors.grey.shade50)
                : null,

        onLongPress: () {
          // Show CompanyDialogs on long press
          _showActionDialog(context, worker, companyModel);
        },
        cells: <DataCell>[
          // Index column
          DataCell(
            Container(
              alignment: Alignment.center,
              child: CircleAvatar(
                radius: 14,
                backgroundColor: primaryColor,
                child: Text(
                  "${index + 1}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          // Name column
          DataCell(
            Text(
              worker.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
          // Drug/product column
          DataCell(
            Text(
              worker.drug,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
          // Total column
          DataCell(
            Text(
              formatNumber(totAmount),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color:
                    worker.out == worker.total ? Colors.blue : Colors.black87,
              ),
            ),
          ),
          // Out column
          DataCell(
            Text(
              formatNumber(outAmount),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color:
                    worker.out == worker.total ? Colors.blue : Colors.black87,
              ),
            ),
          ),
          // Expiry date column
          DataCell(
            Text(
              worker.expDate,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: getColor(worker.expDate),
              ),
            ),
          ),
          // Date column
          DataCell(
            Text(
              worker.date,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),

          // Actions column
        ],
      );
    });
  }

  List<DataRow> _buildCompactDataRows(
    CompanyProvider companyProvider,
    CompanyModel companyModel,
  ) {
    return List.generate(companyProvider.filter.length, (index) {
      final worker = companyProvider.filter[index];
      final balance = worker.total - worker.out;
      final bool isPositiveBalance = balance >= 0;

      return DataRow(
        color:
            index % 2 == 0
                ? MaterialStateProperty.all(Colors.grey.shade50)
                : null,
        onLongPress: () {
          // Show CompanyDialogs on long press
          _showActionDialog(context, worker, companyModel);
        },
        cells: <DataCell>[
          // Index column
          DataCell(
            Container(
              alignment: Alignment.center,
              child: CircleAvatar(
                radius: 14,
                backgroundColor: primaryColor,
                child: Text(
                  "${index + 1}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          // Combined data column for compact view
          DataCell(
            Card(
              elevation: 0,
              color: Colors.grey.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.person, size: 16, color: primaryColor),
                        const SizedBox(width: 4),
                        Text(
                          worker.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.medical_services_outlined,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          worker.drug,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            "المجموع: ${worker.total}",
                            style: TextStyle(fontSize: 12, color: primaryColor),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "المصروف: ${worker.out}",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.event, size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          "الاكسباير: ${worker.expDate}",
                          style: TextStyle(
                            fontSize: 12,
                            color:
                                _isNearExpiry(worker.expDate)
                                    ? Colors.red
                                    : Colors.black87,
                          ),
                        ),
                        Text(
                          worker.date,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Actions column
        ],
      );
    });
  }

  // Helper method to check if a date is near expiry (within 4 months)
  bool _isNearExpiry(String expDate) {
    try {
      // Simple implementation - you might need to adjust this
      // based on your date format
      final parts = expDate.split('/');
      if (parts.length != 3) return false;

      final expMonth = int.tryParse(parts[1]) ?? 0;
      final expYear = int.tryParse(parts[2]) ?? 0;

      final now = DateTime.now();
      final currentMonth = now.month;
      final currentYear = now.year;

      // Calculate months difference
      int monthsDiff = (expYear - currentYear) * 12 + (expMonth - currentMonth);

      // Return true if expiry is within next 4 months
      return monthsDiff >= 0 && monthsDiff <= 4;
    } catch (e) {
      return false;
    }
  }

  getColor(String? worker) {
    if (worker != "") {
      return DateTime.parse(
            worker!,
          ).isBefore(DateTime.now().add(Duration(days: 30 * 4)))
          ? Colors.red
          : Colors.black87;
    }
    return Colors.black87;
  }

  Widget _buildWideSearchBar(CompanyProvider companyProvider, Size screenSize) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: 10),
          SizedBox(
            width: screenSize.width * 0.3,
            child: TextFormField(
              onChanged: (value) {
                companyProvider.workerFilter(value);
              },
              textAlign: TextAlign.center,
              controller: searchController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: "بحث بأسم الشركة",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade500),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade500),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.pink),
                ),
                prefixIcon: Icon(Icons.search, color: primaryColor),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 4,
                ),
                filled: true,
                fillColor: Colors.grey.shade500,
              ),
            ),
          ),
          SizedBox(width: MediaQuery.of(context).size.width / 400),
          Expanded(
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    "عرض العمليات قريبة الاكسباير (اقرب 4 اشهر)",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                widthSpace,
                Checkbox(
                  value: companyProvider.nearExpire,
                  activeColor: primaryColor,
                  onChanged: (value) {
                    companyProvider.updateNearExpire(value);
                    companyProvider.workerFilter(searchController.text);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNarrowSearchBar(
    CompanyProvider companyProvider,
    Size screenSize,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 20,
            child: TextFormField(
              onChanged: (value) {
                companyProvider.workerFilter(value);
              },
              textAlign: TextAlign.center,
              controller: searchController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: "بحث بأسم الشركة",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: primaryColor),
                ),
                prefixIcon: Icon(Icons.search, color: primaryColor),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 4,
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height / 400),
          Row(
            children: [
              Flexible(
                child: Text(
                  "عرض العمليات قريبة الاكسباير (اقرب 4 اشهر)",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
              ),
              widthSpace,
              Checkbox(
                value: companyProvider.nearExpire,
                activeColor: primaryColor,
                onChanged: (value) {
                  companyProvider.updateNearExpire(value);
                  companyProvider.workerFilter(searchController.text);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

void _showActionDialog(
  BuildContext context,
  WorkerModel worker,
  CompanyModel companyModel,
) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("اختر إجراء للمتابعة"),
        actions: [
          CustomButton(
            onPressed: () {
              Navigator.pop(context);
              Provider.of<CompanyProvider>(context, listen: false).workerId =
                  worker.id;
              Provider.of<CompanyProvider>(
                context,
                listen: false,
              ).fillMovements();
              Navigator.of(context).pushNamed(Movementsscreen.rout);
            },
            text: "تفاصيل",
            icon: Icons.list,
          ),
          heightSpace,
          CustomButton(
            onPressed: () {
              Navigator.pop(context);
              Provider.of<CompanyProvider>(
                context,
                listen: false,
              ).createWorker(context, companyModel, worker);
            },
            text: "تعديل",
            icon: Icons.edit,
          ),
          heightSpace,
          CustomButton(
            text: "حذف",
            onPressed: () {
              Provider.of<CompanyProvider>(
                context,
                listen: false,
              ).deleteWorker(worker);
              Navigator.pop(context);
            },
            icon: Icons.delete,
          ),
          heightSpace,
          worker.out >= worker.total
              ? CustomButton(
                onPressed: () {
                  Provider.of<CompanyProvider>(
                    context,
                    listen: false,
                  ).markWorkerAsFinish(worker);
                  Navigator.pop(context);
                },
                text: "أكتمل",
                icon: Icons.check,
              )
              : Container(),
        ],
      );
    },
  );
}
