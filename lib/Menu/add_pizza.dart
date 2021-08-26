import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pizzamenu/Menu/home_screen.dart';
import 'package:pizzamenu/Menu/notify_home.dart';
import 'package:pizzamenu/Menu/options.dart';
import 'package:pizzamenu/values/values.dart';
import 'package:pizzamenu/widgets/spaces.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddPizza extends StatefulWidget {
  AddPizza({Key? key}) : super(key: key);

  @override
  _AddPizzaState createState() => _AddPizzaState();
}

class _AddPizzaState extends State<AddPizza> {
  TextEditingController titleController = new TextEditingController();
  TextEditingController descController = new TextEditingController();
  XFile? _imageFile;
  String? _uploadedFileURL;
  final ImagePicker _picker = ImagePicker();

  dynamic _pickImageError;
  String? _retrieveDataError;

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
     return
           Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.secondaryElement,
              title: Text("Add A New Super Yummi Pizza"),
            ),
            body: _handlePreview(),
            floatingActionButton: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: FloatingActionButton(
                    backgroundColor: AppColors.kpizzaDarkBackground,
                    onPressed: () {
                      _onImageButtonPressed(
                        ImageSource.gallery,
                        context: context,
                        isMultiImage: false,
                      );
                    },
                    heroTag: 'image1',
                    tooltip: 'Pick Image from gallery',
                    child: const Icon(Icons.photo_library),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: FloatingActionButton(
                    backgroundColor: AppColors.kpizzaYellow,
                    onPressed: () {
                      _onImageButtonPressed(ImageSource.camera,
                          context: context);
                    },
                    heroTag: 'image2',
                    tooltip: 'Take a Photo',
                    child: const Icon(Icons.camera_alt),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: FloatingActionButton(
                    backgroundColor: AppColors.kpizzaGreen,
                    onPressed: () async {
                      List pizzas;
                      final SharedPreferences pref =
                          await SharedPreferences.getInstance();
                      if (pref.getString("Pizzas") != null) {
                        pizzas = await jsonDecode(pref.getString("Pizzas")!);
                      } else {
                        pizzas = [];
                      }
                      PizzaItem newPizza = new PizzaItem(
                        title: titleController.text,
                        desc: descController.text,
                        img: _imageFile?.path ?? "",
                        // variations: [],
                      );
                      int found = pizzas.indexWhere(
                          (element) => element["img"] == titleController.text);
                      if (found != -1)
                        pizzas[found] = newPizza;
                      else
                        pizzas.add(newPizza);
                      await pref
                          .setString("Pizzas", jsonEncode(pizzas))
                          .then((value) {
                        // Provider.of<UpdateMenu>(context, listen: false).notifyListeners();
                        UpdateMenu().onChange();
                       });
                      print("ddddd ${pizzas}");
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                            builder: (BuildContext context) => OptionsList(
                              itemName: titleController.text,
                              des: descController.text,
                              imgPath: _imageFile?.path ?? "",
                            ),
                          ));
                    },
                    heroTag: 'Add Options',
                    tooltip: 'Add Options',
                    child: const Icon(Icons.add_circle),
                  ),
                ),
              ],
            ),
          );

  }

  Widget _previewImages() {
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_imageFile != null) {
      return SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.all(5.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.height / 4.00,
                      width: MediaQuery.of(context).size.width,
                      child: Image.file(
                        File(_imageFile!.path),
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 4,
                      ),
                    ),
                  ],
                )),
            itemDetails()
          ],
        ),
      );
    } else if (_pickImageError != null) {
      return Column(
        children: <Widget>[
          Container(
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.height / 4.00,
              width: MediaQuery.of(context).size.width,
              child: Text(
                'Pick image error: $_pickImageError',
                textAlign: TextAlign.center,
              )),
          itemDetails()
        ],
      );
    } else {
      return Column(children: <Widget>[
        Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height / 4.00,
          width: MediaQuery.of(context).size.width,
          child: Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height / 4.00,
            width: MediaQuery.of(context).size.width,
            child: GestureDetector(
              child: Image.asset(
                ("assets/upload_img.jpg"),
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 4,
              ),
              onTap: () {
                {
                  _onImageButtonPressed(
                    ImageSource.gallery,
                    context: context,
                    isMultiImage: false,
                  );
                }
              },
            ),
          ),
        ),
        itemDetails()
      ]);
    }
  }

  Widget _handlePreview() {
    return _previewImages();
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await _picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _imageFile = response.file;
      });
    } else {
      _retrieveDataError = response.exception!.code;
    }
  }

  Text? _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError!);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

  void _onImageButtonPressed(ImageSource source,
      {BuildContext? context, bool isMultiImage = false}) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 25,
      );
      setState(() {
        _imageFile = pickedFile;
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
  }

  Widget itemDetails() {
    return Column(
      children: [
        SpaceH16(),
        TextFormField(
          controller: titleController,
          decoration: const InputDecoration(
            icon: Icon(Icons.title),
            hintText: 'What do you call ths Pizza?',
            labelText: 'Title *',
          ),
          validator: (String? value) {
            return (value != null && value.contains('@'))
                ? 'Do not use the @ char.'
                : null;
          },
        ),
        SpaceH16(),
        TextFormField(
          controller: descController,
          decoration: const InputDecoration(
            icon: Icon(Icons.description),
            hintText: 'Add Description',
            labelText: 'Description *',
          ),
          onChanged: (String? value) {
            // This optional block of code can be used to run
            // code when the user saves the form.
          },
          validator: (String? value) {
            return (value != null && value.contains('@'))
                ? 'Do not use the @ char.'
                : null;
          },
        ),
      ],
    );
  }
}

typedef void OnPickImageCallback(
    double? maxWidth, double? maxHeight, int? quality);
