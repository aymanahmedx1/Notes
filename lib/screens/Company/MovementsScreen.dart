import 'package:flutter/material.dart';
import 'package:notes/Providers/CompanyProvider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import '../../Models/MovementModel.dart';

class Movementsscreen extends StatelessWidget {
  static const String rout = "Movementsscreen";
  final ScrollController controller = ScrollController();
  final TextEditingController filterController = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    // Define our pink color
    final primaryColor = Colors.pink[600] ?? Color(0xFFD81B60);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "تفاصيل الصرف",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          centerTitle: true,
          elevation: 2,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
        ),
        body: Consumer<CompanyProvider>(
          builder: (context, accountingProvider, child) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.grey[50],
              ),
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: [


                    // Table container
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.15),
                              blurRadius: 15,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return Column(
                              children: [
                                // Table header
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: primaryColor.withOpacity(0.05),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      // Header row with fancy styling
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          'ت',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: primaryColor,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Center(
                                          child: Text(
                                            'العدد المصروف',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: primaryColor,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: constraints.maxWidth > 500 ? 3 : 2,
                                        child: Center(
                                          child: Text(
                                            'التاريخ ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: primaryColor,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Divider
                                Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.1)),

                                // Table body
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20),
                                    ),
                                    child: ListView.builder(
                                      padding: EdgeInsets.zero,
                                      itemCount: accountingProvider.movemensModels.length,
                                      itemBuilder: (context, index) {
                                        final item = accountingProvider.movemensModels[index];
                                        final isEven = index % 2 == 0;


                                        return Container(
                                          decoration: BoxDecoration(
                                            color: isEven ? Colors.grey.withOpacity(0.03) : Colors.white,
                                            border: Border(
                                              bottom: BorderSide(
                                                color: Colors.grey.withOpacity(0.1),
                                                width: 1,
                                              ),
                                            ),
                                          ),
                                          child: IntrinsicHeight(
                                            child: Row(
                                              children: [
                                                // Index column
                                                Expanded(
                                                  flex: 1,
                                                  child: Center(
                                                    child: Padding(
                                                      padding: EdgeInsets.symmetric(vertical: 14),
                                                      child: Container(
                                                        width: 36,
                                                        height: 36,
                                                        decoration: BoxDecoration(
                                                          gradient: LinearGradient(
                                                            colors: [
                                                              primaryColor,
                                                              Color.lerp(primaryColor, Colors.pink[300], 0.3) ?? primaryColor,
                                                            ],
                                                            begin: Alignment.topLeft,
                                                            end: Alignment.bottomRight,
                                                          ),
                                                          borderRadius: BorderRadius.circular(10),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: primaryColor.withOpacity(0.2),
                                                              blurRadius: 4,
                                                              offset: Offset(0, 2),
                                                            ),
                                                          ],
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            "${index + 1}",
                                                            style: TextStyle(
                                                              color: Colors.white,
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),

                                                // Quantity column
                                                Expanded(
                                                  flex: 2,
                                                  child: Center(
                                                    child: Padding(
                                                      padding: EdgeInsets.symmetric(vertical: 16),
                                                      child: Container(
                                                        padding: EdgeInsets.symmetric(
                                                          horizontal: 18,
                                                          vertical: 8,
                                                        ),
                                                        decoration: BoxDecoration(
                                                          color: primaryColor.withOpacity(0.08),
                                                          borderRadius: BorderRadius.circular(8),
                                                        ),
                                                        child: Text(
                                                          item.qty.toString(),
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.w600,
                                                            color: primaryColor.withOpacity(0.8),
                                                            fontSize: 15,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),

                                                // Date column
                                                Expanded(
                                                  flex: constraints.maxWidth > 500 ? 3 : 2,
                                                  child: Center(
                                                    child: Padding(
                                                      padding: EdgeInsets.symmetric(vertical: 16),
                                                      child: Container(
                                                        padding: EdgeInsets.symmetric(
                                                          horizontal: 12,
                                                          vertical: 8,
                                                        ),
                                                        decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius: BorderRadius.circular(10),
                                                          border: Border.all(
                                                            color: primaryColor.withOpacity(0.2),
                                                            width: 1,
                                                          ),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors.grey.withOpacity(0.1),
                                                              blurRadius: 4,
                                                              offset: Offset(0, 2),
                                                            ),
                                                          ],
                                                        ),
                                                        child: Text(
                                                          item.date,
                                                          style: TextStyle(
                                                            color: Colors.grey[800],
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),


                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}