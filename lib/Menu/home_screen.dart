import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:full_screen_menu/full_screen_menu.dart';
import 'package:pizzamenu/Auth/authentication.dart';
import 'package:pizzamenu/Menu/notify_home.dart';
import 'package:pizzamenu/general/storage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Menu extends StatelessWidget {
  List pizzas = [];
  Future<void> getItems() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? s = await pref.getString("Pizzas");
    if (s != null)
      pizzas = await jsonDecode(pref.getString("Pizzas") ?? "");
     else {
      pizzas = [];
    }
    // return pizzas;
  }
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UpdateMenu>(
      create: (context) => UpdateMenu(),
      child: Consumer<UpdateMenu>(
        builder: (context, model, _) => homeMenu(context),
      ),
    );

    // return ChangeNotifierProvider(
    //     create: (_) => new UpdateMenu(),
    //     child: Consumer<UpdateMenu>(builder: (context, model, child) {return  homeMenu(context); }));


  }
Widget homeMenu(BuildContext context){
  return
    // ChangeNotifierProvider(
    //   create:(context) => UpdateMenu(),
    //   child:
      Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFFF0000),
          elevation: 0.0,
          title: Text("Main Menu"),
          centerTitle: true,
        ),
        body: FutureBuilder(
            future: getItems(),
            builder: (context, snapshot) {
              // if (pizzas == null) pizzas = [];
              return Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 10.0,
                ),
                child: ListView(
                  children: <Widget>[
                    //SearchCard(),
                    SizedBox(height: 10.0),
                    ListView.builder(
                      primary: false,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: pizzas == null ? 0 : pizzas.length,
                      itemBuilder: (BuildContext context, int index) {
                        var pizza = pizzas[index];
                        return new PizzaItem(
                          img: pizza["img"],
                          title: pizza["title"],
                          desc: pizza["desc"],
                          // variations: variation
                        );
                      },
                    ),
                    SizedBox(height: 10.0),
                  ],
                ),
              );
            }),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xFFFF0000),
          onPressed: () => showFullScreenMenu(context),
          child: Icon(Icons.menu),
        ),
      )
    //)
  ;
}
  void showFullScreenMenu(BuildContext context) {
    FullScreenMenu.show(
      context,
      backgroundColor: Colors.black,
      items: [
        FSMenuItem(
          icon: Icon(Icons.local_pizza_outlined, color: Colors.white),
          text: Text('Add Product', style: TextStyle(color: Colors.white)),
          gradient: blueGradient,
          onTap: () {
            Navigator.pushNamed(context, '/AddPizza');
            FullScreenMenu.hide();
          },
        ),
        FSMenuItem(
          onTap: () {
            AuthenticationHelper().signOut().then((result) {
              if (result == null) {
                SharedPrefUtils.saveBool("isLogged", false);

                Navigator.pushNamedAndRemoveUntil(
                    context, '/SplashScreen', (route) => false);
              } else {
                showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      _buildPopupDialog(context, result),
                );
              }
            });
          },
          icon: Icon(Icons.logout_outlined, color: Colors.white),
          text: Text('Log out', style: TextStyle(color: Colors.white)),
          gradient: orangeGradient,
        ),
        FSMenuItem(
          onTap: () {
            Navigator.pushNamed(context, '/Menu');
            FullScreenMenu.hide();
          },
          icon: Icon(Icons.restaurant_menu_outlined, color: Colors.white),
          text: Text('Menu', style: TextStyle(color: Colors.white)),
          gradient: deepPurpleGradient,
        ),
        FSMenuItem(
          onTap: () {
            Navigator.pushReplacementNamed(context, '/ScrollingMapBody');
            FullScreenMenu.hide();
          },
          icon: Icon(Icons.location_on_outlined, color: Colors.white),
          text: Text('Trucks Locations', style: TextStyle(color: Colors.white)),
          gradient: deepPurpleGradient,
        ),
      ],
    );
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
}

class PizzaItem extends StatefulWidget {
  String? img;
  String? title;
  String? desc;

  List<Map<String, dynamic>>? variations;

  PizzaItem({
    required this.img,
    required this.title,
    required this.desc,
     this.variations,
  });
  PizzaItem.fromJson(Map<String, dynamic> json) {
    img = json['img'];
    title = json['title'];
    desc = json['desc'];
    variations = json['variations'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['img'] = this.img;
    data['title'] = this.title;
    data['desc'] = this.desc;
    data['variations'] = this.variations;
    return data;
  }

  @override
  _PizzaItemState createState() => _PizzaItemState();
}

class _PizzaItemState extends State<PizzaItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
      child: Container(
        height: MediaQuery.of(context).size.height / 2.5,
        width: MediaQuery.of(context).size.width,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          elevation: 3.0,
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height / 3.5,
                    width: MediaQuery.of(context).size.width,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      child:(widget.img!=null && widget.img !="" )?Image(image: FileImage(File(widget.img!))) : Image.asset(
                        "assets/logo.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 6.0,
                    left: 6.0,
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3.0)),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 7.0),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    "${widget.title}",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w800,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              SizedBox(height: 7.0),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    "${widget.desc}",
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.0),
            ],
          ),
        ),
      ),
    );
  }
}
