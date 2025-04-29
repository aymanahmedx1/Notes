import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes/CustomWidgets/CustomButton.dart';
import 'package:notes/CustomWidgets/NoDataWidget.dart';
import 'package:notes/CustomWidgets/Spacers.dart';
import 'package:notes/Models/CompanyModel.dart';
import 'package:notes/Providers/CompanyProvider.dart';
import 'package:provider/provider.dart';
import 'CompanyProfileScreen.dart';

class CompanyScreen extends StatelessWidget {
  static const String rout = "CompanyScreen";
  final ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;

    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text(
              "المندوبين",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                child: ElevatedButton.icon(
                  onPressed: ()  {
                    Provider.of<CompanyProvider>(context, listen: false)
                        .createOrUpdate(context, null) ;
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("أضافة شركة"),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.pink[600],
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),


            ],
          ),
          body: Consumer<CompanyProvider>(
            builder: (context, companyProvider, child) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    // Responsive search bar
                    Container(
                      padding:  EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width *0.01 ),
                      child: TextFormField(
                        onChanged: (value) => companyProvider.companyFilter(value),
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          hintText: "بحث بأسم الشركة",
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Expanded(
                      child: companyProvider.filterdCompanyModels.isEmpty
                          ? NoDataWidget()
                          : Scrollbar(
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
                        child: isSmallScreen
                            ? _buildListView(context, companyProvider)
                            : _buildDataTable(context, companyProvider),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ));
  }

  // Data table for larger screens
  Widget _buildDataTable(BuildContext context, CompanyProvider companyProvider) {
    return SingleChildScrollView(
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
                    'م',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    'الشركة',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    'ملاحظة',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    'تاريخ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    'المزيد',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
            rows: List.generate(
              companyProvider.filterdCompanyModels.length,
                  (index) {
                return DataRow(
                  onLongPress: () {
                    Provider.of<CompanyProvider>(context, listen: false)
                        .createOrUpdate(
                        context, companyProvider.filterdCompanyModels[index]);
                  },
                  cells: <DataCell>[
                    DataCell(Text("${index + 1}")),
                    DataCell(Text(companyProvider.filterdCompanyModels[index].name)),
                    DataCell(Text(companyProvider.filterdCompanyModels[index].notes)),
                    DataCell(Text(companyProvider.filterdCompanyModels[index].date)),
                    DataCell(Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Provider.of<CompanyProvider>(context, listen: false)
                                .fillWorkerList(
                                companyProvider.filterdCompanyModels[index].id,
                                0);
                            Navigator.pushNamed(
                              context,
                              CompanyProfileScreen.rout,
                              arguments:
                              companyProvider.filterdCompanyModels[index],
                            );
                          },
                          child: const Icon(
                            Icons.open_in_browser_outlined,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                        widthSpace,
                        ElevatedButton(
                          onPressed: () {
                            showDeleteDialog(context,
                                companyProvider.filterdCompanyModels[index]);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            elevation: 5,
                          ),
                          child: const Icon(
                            Icons.delete,
                            size: 25,
                            color: Colors.red,
                          ),
                        )
                      ],
                    )),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  // List view for smaller screens
  Widget _buildListView(BuildContext context, CompanyProvider companyProvider) {
    return ListView.builder(
      controller: controller,
      itemCount: companyProvider.filterdCompanyModels.length,
      itemBuilder: (context, index) {
        final company = companyProvider.filterdCompanyModels[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),





          child: ListTile(
            onLongPress: () {
              Provider.of<CompanyProvider>(context, listen: false)
                  .createOrUpdate(context, company);
            },
            contentPadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            title: Text(
              company.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            subtitle: LayoutBuilder(
                builder: (context, constraints) {
                  // Determine if we're on a small screen
                  final isSmallScreen = constraints.maxWidth < 350;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       widthSpace,
                      Row(
                        children: [
                          const Icon(Icons.note, size: 16, color: Colors.grey),
                          const SizedBox(width: 2),
                          Expanded(
                            child: Text(
                              "ملاحظة: ${company.notes}",
                              style: const TextStyle(color: Colors.black87),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                          const SizedBox(width: 2),
                          Text(
                            "تاريخ: ${company.date}",
                            style: const TextStyle(color: Colors.black87),
                          ),
                        ],
                      ),
                    ],
                  );
                }
            ),
            isThreeLine: true,
            leading: CircleAvatar(
              radius: 7,
              backgroundColor: Colors.pink[600],
              child: Text(
                "${index + 1}",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 10
                ),
              ),
            ),
            trailing: LayoutBuilder(
              builder: (context, constraints) {
                // Determine screen size for adaptive buttons
                final screenWidth = MediaQuery.of(context).size.width;
                final isSmallScreen = screenWidth < 600;

                if (isSmallScreen) {
                  // On small screens, show a popup menu instead of buttons
                  return PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert),
                    onSelected: (value) {
                      if (value == 'view') {
                        Provider.of<CompanyProvider>(context, listen: false)
                            .fillWorkerList(company.id, 0);
                        Navigator.pushNamed(
                          context,
                          CompanyProfileScreen.rout,
                          arguments: company,
                        );
                      } else if (value == 'delete') {
                        showDeleteDialog(context, company);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'view',
                        child: Row(
                          children: [
                            Icon(Icons.folder_open, color: Colors.blue),
                            SizedBox(width: 4),
                            Text("عرض"),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red),
                            SizedBox(width: 4),
                            Text("حذف"),
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  // On larger screens, show both buttons
                  return Container(
                    width: screenWidth * 0.25, // Adaptive width based on screen size
                    constraints: const BoxConstraints(maxWidth: 120, minWidth: 80),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.folder_open, color: Colors.blue),
                            onPressed: () {
                              Provider.of<CompanyProvider>(context, listen: false)
                                  .fillWorkerList(company.id, 0);
                              Navigator.pushNamed(
                                context,
                                CompanyProfileScreen.rout,
                                arguments: company,
                              );
                            },
                            tooltip: "عرض",
                          ),
                        ),
                        const SizedBox(width: 4),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              showDeleteDialog(context, company);
                            },
                            tooltip: "حذف",
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ),














        );
      },
    );
  }

  void showDeleteDialog(BuildContext context, CompanyModel companymodel) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          icon: const Icon(
            Icons.dangerous,
            size: 40,
            color: Colors.red,
          ),
          actions: isSmallScreen
              ? [
            Column(
              children: [
                CustomButton(
                  icon: Icons.check,
                  onPressed: () {
                    Provider.of<CompanyProvider>(context, listen: false)
                        .deleteCompany(companymodel);
                    Navigator.pop(context);
                  },
                  text: "تاكيد",
                ),
                heightSpace,
                CustomButton(
                  icon: Icons.cancel,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  text: "رجوع",
                )
              ],
            )
          ]
              : [
            CustomButton(
              icon: Icons.check,
              onPressed: () {
                Provider.of<CompanyProvider>(context, listen: false)
                    .deleteCompany(companymodel);
                Navigator.pop(context);
              },
              text: "تاكيد",
            ),                heightSpace,

            CustomButton(
              icon: Icons.cancel,
              onPressed: () {
                Navigator.pop(context);
              },
              text: "رجوع",
            )
          ],
          title: const Text(
              "هل انت متاكد من حذف الشركه والمندوبين التابعين لها ؟"),
        );
      },
    );
  }
}