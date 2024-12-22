import 'package:flutter/material.dart';
import 'package:notes/CustomWidgets/CustomButton.dart';
import 'package:notes/CustomWidgets/NoDataWidget.dart';
import 'package:notes/CustomWidgets/Spacers.dart';
import 'package:notes/Models/CompanyModel.dart';
import 'package:notes/Providers/CompanyProvider.dart';
import 'package:notes/screens/Company/CompanyFinishScreen.dart';
import 'package:notes/screens/Company/Widgets/table_data.dart';
import 'package:notes/screens/Company/Widgets/table_header.dart';
import 'package:provider/provider.dart';

class CompanyProfileScreen extends StatelessWidget {
  static const String rout = "CompanyProfileScreen";
  final ScrollController controller = ScrollController();

  final TextEditingController searchController =
      TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    //double width = context.size!.width ;
    double width = MediaQuery.sizeOf(context).width;
    final companyModel =
        ModalRoute.of(context)!.settings.arguments as CompanyModel;
    return Consumer<CompanyProvider>(
      builder: (context, companyProvider, child) {
        return SafeArea(
            child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "تفاصيل شركة ",
                ),
                Text(
                  companyModel.name,
                  style: const TextStyle(
                    color: Colors.deepOrange,
                  ),
                )
              ],
            ),
            actions: [
              PopupMenuButton<String>(
                iconSize: 30,
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      child: CustomButton(
                        text: "اضافه مندوب",
                        icon: Icons.add,
                        onPressed: () async {
                          Navigator.pop(context);
                          companyProvider.createWorker(
                              context, companyModel, null);
                        },
                      ),
                    ),
                    PopupMenuItem(
                        child: CustomButton(
                            text: "المنتهي",
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pushNamed(
                                  context, CompanyFinishScreen.rout,
                                  arguments: companyModel);
                            },
                            icon: Icons.check)),
                  ];
                },
              ),
            ],
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(width: 50, child: Text("بحث")),
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: 300,
                    height: 70,
                    child: TextFormField(
                      onChanged: (value) {
                        companyProvider.workerFilter(value);
                      },
                      textAlign: TextAlign.center,
                      controller: searchController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        hintText: "اسم المندوب او العلاج",
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 50,
                  ),
                  Row(
                    children: [
                      const Text("انتهاء قريب"),
                      widthSpace,
                      Checkbox(
                        value: companyProvider.nearExpire,
                        onChanged: (value) {
                          companyProvider.updateNearExpire(value);
                          companyProvider.workerFilter(searchController.text);
                        },)
                    ],
                  )
                ],
              ),
              TableHeader(width: width,),
              Expanded(
                  child: companyProvider.filter.isEmpty
                      ? NoDataWidget()
                      : SingleChildScrollView(
                          // scroll list
                          child: TableData(
                            width: width,
                            filter: companyProvider.filter,
                            companyModel: companyModel,
                            controller: controller,
                          ),
                        ))
            ],
          ),
        ));
      },
    );
  }
}
