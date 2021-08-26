import 'dart:convert';
import 'package:pizzamenu/Menu/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefUtils {
  static saveStr(String key, String message) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString(key, message);
  }

  static saveInt(String key, int value) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setInt(key, value);
  }

  static readPrefStr(String key) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(key);
  }

  static saveBool(String key, bool value) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setBool(key, value);
  }

  static readPrefBool(String key) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool(key);
    return pref.getBool(key);
  }

  static readPrefInt(String key) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getInt(key);
  }

  static saveItemsList(String key, List<PizzaItem> pizzas) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, json.encode(pizzas));
  }

  Future<List<PizzaItem>> getMenuInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    List PizzaItemMap;
    List<PizzaItem> savedItems = [];
    final String? itemStr = prefs.getString('PizzaItems');
    if (itemStr != null) {
      PizzaItemMap = jsonDecode(itemStr)  as List;

      // if (PizzaItemMap != null) {
      for(var i in PizzaItemMap){
          var pizza = PizzaItem.fromJson(jsonDecode(itemStr));
        print("HIIII $pizza");
        savedItems.add(pizza);
      }

        return savedItems;
      // }
    }
    return [];
    // return [];
  }

  Future<void> saveItemsInfo(List<PizzaItem> PizzaItem) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('PizzaItems', jsonEncode(PizzaItem));
    print(jsonEncode(PizzaItem));
  }

  static saveStringList(String key, List<String> uuids) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(key, uuids);
  }

  static readStringList(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? uuids = prefs.getStringList(key);
    return uuids;
  }

  static clearAll() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.getKeys();
    for (String key in preferences.getKeys()) {
      await preferences.remove(key);
    }
  }

  static clearRecord(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove(key);
  }
}
