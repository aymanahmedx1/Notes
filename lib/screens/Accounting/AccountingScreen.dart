import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:notes/Providers/AccountingProvider.dart';
import 'package:notes/screens/Accounting/Widgets/Dialogs.dart';
import '../../Commons/Helpers.dart';
import '../../CustomWidgets/CustomColumnButton.dart';
import '../../Models/SectionModel.dart';
import 'AccountingDetailsScreen.dart';

class Accountingscreen extends StatelessWidget {
  static const String rout = "Accountingscreen";
  final ScrollController controller = ScrollController();
  final TextEditingController filterController = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isSmallScreen = screenSize.width < 600;
    final Color primaryColor = Theme.of(context).primaryColor;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("الاقسام"),
          centerTitle: true,
          elevation: 4, // Added shadow for depth
          actions: [
            Padding(
              padding: const EdgeInsets.only(left: 4.0, right: 4.0),
              child: ElevatedButton.icon(
                onPressed: () async {
                  await AccountingDialog().createSection(context, null);
                },
                icon: const Icon(Icons.add),
                label: const Text("جديد"),
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
        body: Consumer<AccountingProvider>(
          builder: (context, accountingProvider, child) {
            return Container(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                children: [
                  // Stylish card for filter
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        children: [
                          Icon(Icons.filter_list, color: primaryColor),
                          SizedBox(width: MediaQuery.of(context).size.width / 26),
                          Expanded(
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height /20,
                              child: TextField(
                                controller: filterController,
                                decoration: InputDecoration(
                                  labelText: "فلتر القسم",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  prefixIcon: Icon(Icons.search, color: Colors.pink[600]),
                                ),
                                onChanged: (value) {
                                  Provider.of<AccountingProvider>(context, listen: false)
                                      .filterAccounts(value);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 350),
                  // Beautiful table with data
                  Expanded(
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Scrollbar(
                            trackVisibility: true,
                         //   interactive: true,
                            thickness: 8,
                            radius: const Radius.circular(4),
                            controller: controller,
                            thumbVisibility: true,
                            child: SingleChildScrollView(
                              controller: controller,
                              scrollDirection: Axis.horizontal,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: buildBeautifulDataTable(
                                    context,
                                    accountingProvider,
                                    isSmallScreen,
                                    primaryColor
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildBeautifulDataTable(
      BuildContext context,
      AccountingProvider accountingProvider,
      bool isSmallScreen,
      Color primaryColor
      ) {

    final Size screenSize = MediaQuery.of(context).size;

    return Container(
      width: screenSize.width -50,

      child: Theme(
        // Override theme for the DataTable
        data: Theme.of(context).copyWith(
          dividerColor: Colors.grey.shade300,
          dataTableTheme: DataTableThemeData(
            headingTextStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: primaryColor,
              fontSize: 14,
            ),
            dataTextStyle: const TextStyle(
              fontSize: 12,
              color: Colors.black87,
            ),
          ),
        ),
        child: DataTable(
          columnSpacing: isSmallScreen ? 18 : 25,
          dataRowHeight: 70, // More height for better spacing
          horizontalMargin: 4,
          headingRowColor: MaterialStateProperty.all(Colors.grey.shade100),
          border: TableBorder(
            horizontalInside: BorderSide(width: 1, color: Colors.grey.shade200),
            top: BorderSide(width: 2, color: primaryColor.withOpacity(0.5)),
            bottom: BorderSide(width: 1, color: Colors.grey.shade300),
            left: BorderSide(width: 1, color: Colors.grey.shade300),
            right: BorderSide(width: 1, color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          columns: [
            DataColumn(
              label: Container(
                alignment: Alignment.center,
                child: const Text('ت'),
              ),
            ),
            DataColumn(
              label: Container(
                alignment: Alignment.center,
                child: const Text('القسم'),
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
                child: const Text('المستلم'),
              ),
            ),
            DataColumn(
              label: Container(
                alignment: Alignment.center,
                child: const Text('العمليات'),
              ),
            ),
          ],
          rows: List.generate(
            accountingProvider.filteredAccountingList.length,
                (index) {
              final section = accountingProvider.filteredAccountingList[index];

              final balance1 = section.totalOut;
              final balance2 = section.totalIn ;

              return DataRow(
                color: index % 2 == 0
                    ? MaterialStateProperty.all(Colors.grey.shade50)
                    : null,
                onLongPress: () {
                  AccountingDialog().createSection(
                    context,
                      accountingProvider
                          .filteredAccountingList[index]
                  );
                },


                cells: <DataCell>[
                  DataCell(
                    Container(
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.pink[600],
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
                  DataCell(
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            section.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  DataCell(
                    Container(
                      alignment: Alignment.center,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.red.shade200,
                            width: 1,
                          ),
                        ),
                        child: Text(
                         // section.totalOut.toString(),
                          formatNumber(balance1),

                          style: TextStyle(
                            color: Colors.red.shade800,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  DataCell(
                    Container(
                      alignment: Alignment.center,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.green.shade200,
                            width: 1,
                          ),
                        ),
                        child: Text(
                        //  section.totalIn.toString(),
                          formatNumber(balance2)   ,
                          style: TextStyle(
                            color: Colors.green.shade800,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  DataCell(makeBeautifulOperationMenu(context, section, isSmallScreen, primaryColor)),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget makeBeautifulOperationMenu(
      BuildContext context,
      dynamic section,
      bool isSmallScreen,
      Color primaryColor
      ) {
    if (isSmallScreen) {
      // For small screens, use a dropdown menu to save space
      return Center(
        child: PopupMenuButton<String>(
          icon: Icon(Icons.more_vert, color: Colors.pink[600]),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          onSelected: (String choice) {
            switch (choice) {
              case 'add':
                Provider.of<AccountingProvider>(context, listen: false)
                    .showAddExpenseDialog(context, section, ExpenseType.moneyIn, null);
                break;
              case 'remove':
                Provider.of<AccountingProvider>(context, listen: false)
                    .showAddExpenseDialog(context, section, ExpenseType.moneyOut, null);
                break;
              case 'details':
                Provider.of<AccountingProvider>(context, listen: false)
                    .fillExpenseList(section);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AccountingDetailsScreen(section)),
                );
                break;
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'add',
              child: Row(
                children: [
                  Icon(Icons.add_circle, color: Colors.green.shade600, size: 20),
                  const SizedBox(width: 8),
                  const Text("اضافة مبلغ"),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'remove',
              child: Row(
                children: [
                  Icon(Icons.remove_circle, color: Colors.red.shade600, size: 20),
                  const SizedBox(width: 8),
                  const Text("صرف مبلغ"),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'details',
              child: Row(
                children: [
                  Icon(Icons.info, color: primaryColor, size: 20),
                  const SizedBox(width: 8),
                  const Text("تفاصيل"),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      // For larger screens, use beautiful buttons with icons
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildOperationButton(
            onPressed: () {
              Provider.of<AccountingProvider>(context, listen: false)
                  .showAddExpenseDialog(context, section, ExpenseType.moneyIn, null);
            },
            icon: Icons.add_circle,
            label: "اضافة",
            color: Colors.green.shade600,
          ),
          const SizedBox(width: 8),
          _buildOperationButton(
            onPressed: () {
              Provider.of<AccountingProvider>(context, listen: false)
                  .showAddExpenseDialog(context, section, ExpenseType.moneyOut, null);
            },
            icon: Icons.remove_circle,
            label: "صرف",
            color: Colors.red.shade600,
          ),
          const SizedBox(width: 8),
          _buildOperationButton(
            onPressed: () {
              Provider.of<AccountingProvider>(context, listen: false)
                  .fillExpenseList(section);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AccountingDetailsScreen(section)),
              );
            },
            icon: Icons.info,
            label: "تفاصيل",
            color: primaryColor,
          ),
        ],
      );
    }
  }

  Widget _buildOperationButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withOpacity(0.5)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}