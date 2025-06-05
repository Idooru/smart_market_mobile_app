String parseDate(DateTime dateTime) {
  return "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
}

String parseStringDate(String dateTime) {
  return dateTime.split(" ")[0];
}
