import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pizzamenu/Menu/variations.dart';
import 'package:pizzamenu/values/values.dart';
import 'package:pizzamenu/widgets/custom_text_form_field.dart';
import 'package:pizzamenu/widgets/dark_overlay.dart';
import 'package:pizzamenu/widgets/spaces.dart';

class OptionsList extends StatefulWidget {
  String? itemName;
  String? des;
  String? imgPath;
   OptionsList({
     this.itemName,
     this.des,
     this.imgPath
  });
  @override
  _OptionsListState createState() => _OptionsListState();
}

class _OptionsListState extends State<OptionsList> {
  List<Map<String, dynamic>> optionsValues = [];
  String? optName;
  int? min ;
  int? max;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  int optionsCount = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          backgroundColor: AppColors.secondaryElement,
          title: Text('Pizza Options'),
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () async {
                setState(() {
                  optName='';
                  min = 0;
                  max=0;
                  optionsCount =0;
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
                heroTag: "Add Options",
                backgroundColor: AppColors.errorColor,
                onPressed: () {
                  // setState(() {
                  if (  optName != null && min != null  && max != null  && optName != "" && min != -1  && max != -1  )
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                          builder: (BuildContext context) => VariationsList(
                            name: optName,
                            optionId: optionsCount,
                            min:min ,
                            max:max ,
                          ),
                        ));
                  else showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        _buildPopupDialog(context, "Please Enter Options Values"),
                  );
                },
                child: Icon(Icons.add_circle_outline_outlined),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: FloatingActionButton(
                heroTag: "Add Option ",
                backgroundColor: AppColors.kpizzaYellow,
                onPressed: () {
                  setState(() {
                    optionsCount++;
                  });

                },
                child: Icon(Icons.post_add_sharp),
              ),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        body: Container(
            padding: EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/login.jpg"), fit: BoxFit.cover)),
            child: Stack(children: <Widget>[
              DarkOverLay(),
              Positioned(
                left: 0,
                top: 0,
                right: 0,
                bottom: 0,
                child:

                ListView(
                    children: <Widget>[
                      list(),
                    SpaceH8()
                    ])

              ),

            ])));
  }
  Widget _buildPopupDialog(BuildContext context, String result) {
    return new AlertDialog(
      title: const Text("Error"),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(result),
        ],
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Close'),
        ),
      ],
    );
  }
  Widget list() {
    return Container(
        child: ListView.builder(
      shrinkWrap: true,
      itemCount: optionsCount,
      itemBuilder: (context, index) {
        return Column(
          children: [
            SpaceH16(),
            _option(index),
          ],
        );
      },
    ));
  }

  Widget _option(int index) {
    int indexOpt = optionsCount;

    return Row(
      children: [
        Expanded(
          child: CustomTextFormField(
            contentPaddingHorizontal: 5.00,
            onChanged: (val) {
              optName = val;
              _onUpdateOptions(indexOpt,  optName ?? "", min??-1, max??-1);
            },
            hintText: 'Name',
            prefixIconImagePath: '',
            onFieldSubmitted: (String val) {
              optName = val;
              _onUpdateOptions(indexOpt,  optName ?? "", min??-1, max??-1);
            },
            controller: new TextEditingController(),
            obscured: false,
          ),
        ),
        SpaceW8(),
        Expanded(
            child: CustomTextFormField(
          contentPaddingHorizontal: 5.00,
          onChanged: (val) {
            min = int.tryParse(val);
            _onUpdateOptions(indexOpt,  optName ?? "", min??-1, max??-1);
          },
          hintText: 'Min',
          prefixIconImagePath: '',
          onFieldSubmitted: (String val) {
            min = int.tryParse(val);
            _onUpdateOptions(indexOpt,optName ?? "", min??-1, max??-1);
          },
          controller: new TextEditingController(),
          obscured: false,
        )),
        SpaceW8(),
        IconButton(
          icon: Icon(Icons.restaurant_menu_outlined),
          color: AppColors.secondaryElement,
          onPressed: () {},
        ),
        Expanded(
            child: CustomTextFormField(
          contentPaddingHorizontal: 5.00,
          hintText: 'Max',
          prefixIconImagePath: '',
          onFieldSubmitted: (String val2) {
            max = int.tryParse(val2);
            _onUpdateOptions(indexOpt,optName ?? "", min??-1, max??-1);
          },
          controller: new TextEditingController(),
          obscured: false,
          onChanged: (val2) {
            max = int.tryParse(val2);
            _onUpdateOptions(indexOpt, optName ?? "", min??-1, max??-1);
          },
        )),
      ],
    );
  }

  _onUpdateOptions(
    int index,
    String name,
      int min,
      int max,
  ) async {
    int foundKey = -1;
    for (var map in optionsValues) {
      if (map.containsKey("id")) {
        if (map["id"] == index) {
          foundKey = index;
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
      "id": index,
      "name": name,
      "min": min,
      "max": max,
      // "options": _values
    };
    optionsValues.add(json);
    print(json);
  }
}
