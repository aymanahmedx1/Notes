import 'package:intl/intl.dart';

formattedDate() {
  DateTime currentDate = DateTime.now();
  return DateFormat('yyyy-MM-dd').format(currentDate);
}

formatNumber(number) {
  String formattedNumber = NumberFormat('###,###').format(number);
  return formattedNumber;
}
