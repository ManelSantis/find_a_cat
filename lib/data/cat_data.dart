import 'package:flutter/cupertino.dart';
import '../models/cat_item.dart';

class CatData extends ChangeNotifier {
  List<CatItem> listAllCats = [];

  //Listar todos os gastos
  List<CatItem> getAllCatsList() {
    return listAllCats;
  }

  CatItem getByIndex(int index) {
    return getAllCatsList()[index];
  }

  //Adicionar novo gasto
  void addNewCat(CatItem cat) {
    listAllCats.add(cat);
    notifyListeners();
  }

  //Deletar gato da lista
  void deleteCat(CatItem cat) {
    listAllCats.remove(cat);
    notifyListeners();
  }

  //Pegar dia da semana que foi encontrado
  String getDayName(DateTime dateTime) {
    switch (dateTime.weekday) {
      case 1:
        return "Seg";
      case 2:
        return "Ter";
      case 3:
        return "Qua";
      case 4:
        return "Qui";
      case 5:
        return "Sex";
      case 6:
        return "Sab";
      case 7:
        return "Dom";
      default:
        return '';
    }
  }

  //Pegar mês do ano que foi encontrado
  String getMonthName(DateTime dateTime) {
    switch (dateTime.month) {
      case 1:
        return "Jan";
      case 2:
        return "Fer";
      case 3:
        return "Mar";
      case 4:
        return "Abr";
      case 5:
        return "Mai";
      case 6:
        return "Jun";
      case 7:
        return "Jul";
      case 8:
        return "Ago";
      case 9:
        return "Set";
      case 10:
        return "Out";
      case 11:
        return "Nov";
      case 12:
        return "Dez";
      default:
        return '';
    }
  }

  //Pegar inicio da semana
  DateTime startOfWeek() {
    DateTime startWeek = DateTime.now();

    DateTime today = DateTime.now();

    for (int i = 0; i < 7; i++) {
      if (getDayName(today.subtract(Duration(days: i))) == "Dom") {
        startWeek = today.subtract(Duration(days: i));
      }
    }
    return startWeek;
  }

  //Converter DateTime para String
  String convertDateTimeToString(DateTime date) {
    String year = date.year.toString();

    String month = date.month.toString();

    if (month.length == 1) {
      month = '0' + month;
    }

    String day = date.day.toString();

    if (day.length == 1) {
      day = '0' + day;
    }

    String format = day + "/" + month + "/" + year;

    return format;
  }

  //Quantidade de gatos achadas diariamente
  Map<String, double> calculateDailyCats() {
    Map<String, double> dailyCats = {};

    for (var cat in listAllCats) {
      String date = convertDateTimeToString(cat.dateTime);
      double value = 1;

      if (dailyCats.containsKey(date)) {
        double currentValue = dailyCats[date]!;
        currentValue += value;
        dailyCats[date] = currentValue;
      } else {
        dailyCats.addAll({date: value});
      }
    }

    return dailyCats;
  }
}
