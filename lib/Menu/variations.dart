import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pizzamenu/Menu/home_screen.dart';
import 'package:pizzamenu/general/storage.dart';
import 'package:pizzamenu/values/values.dart';
import 'package:pizzamenu/widgets/custom_text_form_field.dart';
import 'package:pizzamenu/widgets/dark_overlay.dart';
import 'package:pizzamenu/widgets/potbelly_button.dart';
import 'package:pizzamenu/widgets/spaces.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VariationsList extends StatefulWidget {
  int? optionId;
  String? name;
  int? min;
  int? max;
  String? itemName;
  String? des;
  String? imgPath;

  VariationsList({
    required this.optionId,
    required this.name,
    required this.min,
    required this.max,
  });
  @override
  _VariationsListState createState() => _VariationsListState();
}

class _VariationsListState extends State<VariationsList> {
  List<Map<String, dynamic>> _values = [];
  List<Map<String, dynamic>> optionsValues = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  int variantsCount = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          backgroundColor: AppColors.secondaryElement,
          title: Text('${widget.name} Variants'),
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () async {
                setState(() {
                  variantsCount = 0;
                });
              },
            )
          ],
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: FloatingActionButton(
                heroTag: "Add Variant",
                backgroundColor: Color(0xFFFF0000),
                onPressed: () {
                  setState(() {
                    variantsCount++;
                  });
                },
                child: Icon(Icons.add_box),
              ),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        body: Container(

            padding: EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/signup.jpg"), fit: BoxFit.cover)),
            child: Stack(children: <Widget>[
              DarkOverLay(),
              Positioned(
                left: 0,
                top: 0,
                right: 0,
                bottom: 0,
                child: list(),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: PotbellyButton("Save", onTap: () async {
                  List pizzas;
                  final SharedPreferences pref = await SharedPreferences.getInstance();
                  if(pref.getString("PizzaItems") != null){
                      pizzas = await jsonDecode(pref.getString("PizzaItems")!);
                  }
                  else{
                    pizzas = [];

                  }
                  PizzaItem newPizza = new PizzaItem(
                    title: widget.itemName,
                    desc: widget.des,
                    img: widget.imgPath,
                    variations: optionsValues,
                  );
                  int found = pizzas.indexWhere((element) => element["title"] == widget.itemName);
                  if(found != -1) pizzas[found] =newPizza;

                 else pizzas.add(newPizza);
                  await pref.setString ("PizzaItems",jsonEncode(pizzas));
                  print("ddddd ${pizzas}");

                 }),
              ),
            ])));
  }

  Widget list() {
    return Container(
        child: ListView.builder(
      shrinkWrap: true,
      itemCount: variantsCount,
      itemBuilder: (context, index) {
        return Column(
          children: [
            SpaceH16(),
            _row(index),
          ],
        );
      },
    ));
  }

  Widget _row(int index) {
    String varName = '';
    String price = '';
    return Row(
      children: [
        SpaceH20(),
        Text(
          'Variant : $index',
          textAlign: TextAlign.center,
          style: Styles.normalTextStyle,
        ),
        SpaceW12(),
        Expanded(
          child: CustomTextFormField(
            contentPaddingHorizontal: 5.00,
            onChanged: (val) {
              varName = val;
              _onUpdate(index, varName, price);
            },
            hintText: 'Extra Name',
            prefixIconImagePath: '',
            onFieldSubmitted: (String val) {
              varName = val;
              _onUpdate(index, varName, price);
            },
            controller: new TextEditingController(),
            obscured: false,
          ),
        ),
        SpaceW12(),
        Expanded(
          child: CustomTextFormField(
            contentPaddingHorizontal: 5.00,
            hintText: 'price',
            prefixIconImagePath: '',
            onFieldSubmitted: (String val2) {
              price = val2;
              _onUpdate(index, varName, price);
            },
            controller: new TextEditingController(),
            obscured: false,
            onChanged: (val2) {
              price = val2;
              _onUpdate(index, varName, price);
            },
          ),
        ),
      ],
    );
  }

  _onUpdate(int index, String val, String val2) async {
    int foundKey = -1;
    for (var map in _values) {
      if (map.containsKey("id")) {
        if (map["id"] == index) {
          foundKey = index;
          break;
        }
      }
    }
    if (-1 != foundKey) {
      _values.removeWhere((map) {
        return map["id"] == foundKey;
      });
    }
    Map<String, dynamic> json = {
      "id": index,
      "value": val,
      "value2": val2,
    };
    _values.add(json);
    print(json);
    _onUpdateOptions(_values);
  }

  _onUpdateOptions(List<Map<String, dynamic>> _values) async {
    int foundKey = -1;
    for (var map in optionsValues) {
      if (map.containsKey("id")) {
        if (map["id"] == widget.optionId) {
          foundKey = widget.optionId ?? -1;
          break;
        }
      }
    }
    if (-1 != foundKey) {
      optionsValues.removeWhere((map) {
        return map["id"] == foundKey;
      });
    }
    Map<String, dynamic> json = {
      "id": widget.optionId,
      "name": widget.name,
      "min": widget.min.toString(),
      "max": widget.max.toString(),
      "options":(_values)
    };
    optionsValues.add(json);
    print(jsonEncode(json));

  }
}
//{id: 1, name: er, min: 7, max: 7, options: [{id: 0, value: fsss, value2: 57}, {id: 1, value: erf, value2: 5}]}
