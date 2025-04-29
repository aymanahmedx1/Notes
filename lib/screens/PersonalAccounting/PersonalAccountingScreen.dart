import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:notes/Commons/Helpers.dart';
import 'package:notes/CustomWidgets/CustomButton.dart';
import 'package:notes/CustomWidgets/CutomTextInput.dart';
import 'package:notes/CustomWidgets/Spacers.dart';
import 'package:notes/Models/SectionModel.dart';
import 'package:notes/screens/Accounting/Widgets/Dialogs.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import '../../CustomWidgets/CustomColumnButton.dart';
import '../../Providers/PersonalAccountingProvider.dart';
import 'PersoanlAccountingDetailsScreen.dart';
import 'Widgets/Dialogs.dart';

class PersonalAccountingscreen extends StatelessWidget {
  static const String rout = "PersonalAccountingscreen";

  final ScrollController controller = ScrollController();

  final TextEditingController filterController = TextEditingController(
    text: "",
  );

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final Size screenSize = MediaQuery.of(context).size;
    final bool isSmallScreen = screenSize.width < 600;
    final bool isMediumScreen =
        screenSize.width > 600; //= 600 && screenSize.width < 900;

    // Theme colors for better aesthetics
    final Color primaryColor = Theme.of(context).primaryColor;
    final Color secondaryColor = Theme.of(context).colorScheme.secondary;
    final Color backgroundColor = Theme.of(context).scaffoldBackgroundColor;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("الحسابات الشخصية"),
          centerTitle: true,
          elevation: 4, // Add shadow for depth
          actions: [
            Padding(
              padding: const EdgeInsets.only(left: 4.0, right: 4.0),
              child: ElevatedButton.icon(
                onPressed: () async {
                  await PersonalAccountingDialog().createPersonalSection(
                    context,
                    null,
                  );
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
        body: Consumer<PersonalAccountingProvider>(
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
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(Icons.filter_list, color: primaryColor),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              width:
                                  isSmallScreen
                                      ? double.infinity
                                      : screenSize.width / 3,
                              child: CustomTextInput(
                                label: "فلتر الحسابات ",
                                controller: filterController,
                                valueChange: (value) {
                                  Provider.of<PersonalAccountingProvider>(
                                    context,
                                    listen: false,
                                  ).filterAccounts(value);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.001),
                  // Animated summary statistics (if available)
                  if (accountingProvider.filteredAccountingList.isNotEmpty)
                    _buildSummaryCards(accountingProvider, isSmallScreen),
                  SizedBox(height: MediaQuery.of(context).size.height / 400),
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
                            interactive: true,
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
                                  primaryColor,
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

  Widget _buildSummaryCards(
    PersonalAccountingProvider provider,
    bool isSmallScreen,
  ) {
    // Calculate total balance
    double totalBalance = provider.filteredAccountingList.fold(
      0,
      (sum, section) => sum + (section.totalIn - section.totalOut),
    );

    return Container(
      height: 90,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildSummaryCard(
            "مجموع المبلغ",
            formatNumber(totalBalance),
            totalBalance >= 0 ? Icons.trending_up : Icons.attach_money_outlined,
            totalBalance >= 0 ? Colors.green.shade700 : Colors.red.shade700,
            isSmallScreen,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    IconData icon,
    Color color,
    bool isSmallScreen,
  ) {
    return Container(
      width: isSmallScreen ? 330 : 400,

      margin: const EdgeInsets.only(right: 4, left: 4),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [color.withOpacity(0.8), color],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(icon, color: Colors.white, size: 28),
                  widthSpace,
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  widthSpace,

                  Text(
                    value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              Text(
                "الرقم بالسالب يعني  أطلب والرقم بالموجب يعني مطلوب",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBeautifulDataTable(
    BuildContext context,
    PersonalAccountingProvider accountingProvider,
    bool isSmallScreen,
    Color primaryColor,
  ) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isMediumScreen =
        screenSize.width > 600 && screenSize.width < 900;
    return SizedBox(
      width: screenSize.width-50,
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
            dataTextStyle: const TextStyle(fontSize: 12, color: Colors.black87),
          ),
        ),
        child: DataTable(
          //  columnSpacing: isSmallScreen ? 28 : 40,
          columnSpacing: isSmallScreen ? 16 : (isMediumScreen ? 28 : 40),
          dataRowHeight: isSmallScreen ? 55 : (isMediumScreen ? 60 : 65),
          horizontalMargin: isSmallScreen ? 1 : (isMediumScreen ? 1.5 : 2),

          //   dataRowHeight: 65, // More height for better spacing
          //    horizontalMargin: 2,
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
                child: Text(
                  'ت',
                  style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
                ),
              ),
            ),
            DataColumn(
              label: Container(
                alignment: Alignment.center,
                child: Text(
                  'أسم الحساب',
                  style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
                ),
              ),
            ),
            DataColumn(
              label: Container(
                alignment: Alignment.center,
                child: Text(
                  'الرصيد',
                  style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
                ),
              ),
            ),
            DataColumn(
              label: Container(
                alignment: Alignment.center,
                child: Text(
                  'العمليات',
                  style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
                ),
              ),
            ),
          ],
          rows: List.generate(accountingProvider.filteredAccountingList.length, (
            index,
          ) {
            final section = accountingProvider.filteredAccountingList[index];
            final balance = section.totalIn - section.totalOut;
            final bool isPositiveBalance = balance >= 0;

            return DataRow(
              color:
                  index % 2 == 0
                      ? MaterialStateProperty.all(Colors.grey.shade50)
                      : null,
              onLongPress: () {
                PersonalAccountingDialog().createPersonalSection(
                  context,
                  section,
                );
              },
              cells: <DataCell>[
                DataCell(
                  Container(

                    child: CircleAvatar(
                      radius: isSmallScreen ? 10 : 12,
                      backgroundColor: Colors.pink[600],
                      child: Text(
                        "${index + 1}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isSmallScreen ? 9 : 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                DataCell(
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: isSmallScreen ? 2.0 : 4.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          section.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: isSmallScreen ? 12 : 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                DataCell(
                  Container(

                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isSmallScreen ? 8 : 12,
                        vertical: isSmallScreen ? 4 : 6,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isPositiveBalance
                                ? Colors.green.shade50
                                : Colors.red.shade50,
                        borderRadius: BorderRadius.circular(
                          isSmallScreen ? 8 : 12,
                        ),
                        border: Border.all(
                          color:
                              isPositiveBalance
                                  ? Colors.green.shade200
                                  : Colors.red.shade200,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        formatNumber(balance),
                        style: TextStyle(
                          color:
                              isPositiveBalance
                                  ? Colors.green.shade800
                                  : Colors.red.shade800,
                          fontWeight: FontWeight.bold,
                          fontSize: isSmallScreen ? 11 : 12,
                        ),
                      ),
                    ),
                  ),
                ),
                DataCell(
                  makeBeautifulOperationRow(
                    context,
                    section,
                    isSmallScreen,
                    primaryColor,
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget makeBeautifulOperationRow(
    BuildContext context,
    SectionModel section,
    bool isSmallScreen,
    Color primaryColor,
  ) {
    // Get the medium screen value
    final Size screenSize = MediaQuery.of(context).size;
    final bool isMediumScreen =
        screenSize.width > 600 && screenSize.width < 900;

    if (isSmallScreen) {
      // For small screens, use a dropdown menu to save space
      return Center(
        child: PopupMenuButton<String>(
          icon: Icon(Icons.more_vert, color: primaryColor, size: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          onSelected: (value) {
            switch (value) {
              case 'receive':
                Provider.of<PersonalAccountingProvider>(
                  context,
                  listen: false,
                ).showAddExpenseDialog(
                  context,
                  section,
                  ExpenseType.moneyIn,
                  null,
                );
                break;
              case 'pay':
                Provider.of<PersonalAccountingProvider>(
                  context,
                  listen: false,
                ).showAddExpenseDialog(
                  context,
                  section,
                  ExpenseType.moneyOut,
                  null,
                );
                break;
              case 'details':
                Provider.of<PersonalAccountingProvider>(
                  context,
                  listen: false,
                ).fillExpenseList(section);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => PersonalAccountingDetailsScreen(section),
                  ),
                );
                break;
            }
          },
          itemBuilder:
              (context) => [
                PopupMenuItem(
                  value: 'receive',
                  child: Row(
                    children: [
                      Icon(
                        Icons.add_circle,
                        color: Colors.green.shade600,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      const Text("أستلام مبلغ", style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'pay',
                  child: Row(
                    children: [
                      Icon(
                        Icons.remove_circle,
                        color: Colors.red.shade600,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      const Text("أعطاء مبلغ", style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'details',
                  child: Row(
                    children: [
                      Icon(Icons.info, color: primaryColor, size: 18),
                      const SizedBox(width: 8),
                      const Text("تفاصيل", style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ],
        ),
      );
    } else {
      // For larger screens, use beautiful buttons with icons
      return Row(
        children: [
          _buildOperationButton(
            onPressed: () {
              Provider.of<PersonalAccountingProvider>(
                context,
                listen: false,
              ).showAddExpenseDialog(
                context,
                section,
                ExpenseType.moneyIn,
                null,
              );
            },
            icon: Icons.add_circle,
            label: "أستلام",
            color: Colors.green.shade600,
          ),
          const SizedBox(width: 4),
          _buildOperationButton(
            onPressed: () {
              Provider.of<PersonalAccountingProvider>(
                context,
                listen: false,
              ).showAddExpenseDialog(
                context,
                section,
                ExpenseType.moneyOut,
                null,
              );
            },
            icon: Icons.remove_circle,
            label: "أعطاء",
            color: Colors.red.shade600,
          ),
          const SizedBox(width: 4),
          _buildOperationButton(
            onPressed: () {
              Provider.of<PersonalAccountingProvider>(
                context,
                listen: false,
              ).fillExpenseList(section);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => PersonalAccountingDetailsScreen(section),
                ),
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
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
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
