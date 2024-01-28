String getDate(String date) {
  String year = date.substring(0, 4);
  String month = date.substring(5, 7);
  String day = date.substring(8, 10);
  return '${day}/${month}/${year}';
}
