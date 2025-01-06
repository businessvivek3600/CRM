import 'package:intl/intl.dart';

String formatDate(String date) {
  try {
    DateTime parsedDate = DateTime.parse(date);
    return DateFormat('dd MMM yyyy h:mm a').format(parsedDate);
  } catch (e) {
    return date;
  }
}