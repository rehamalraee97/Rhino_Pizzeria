import 'package:flutter/material.dart';
import 'package:pizzamenu/Auth/authentication.dart';
import 'package:pizzamenu/Auth/register_screen.dart';
import 'package:pizzamenu/general/storage.dart';
import 'package:pizzamenu/values/values.dart';
import 'package:pizzamenu/widgets/custom_text_form_field.dart';
import 'package:pizzamenu/widgets/dark_overlay.dart';
import 'package:pizzamenu/widgets/potbelly_button.dart';
import 'package:pizzamenu/widgets/spaces.dart';

class LoginScreen extends StatelessWidget {
  TextEditingController emailController = new TextEditingController();
  TextEditingController passController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  TextEditingController confirmPassController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/login.jpg"), fit: BoxFit.cover)),
          child: Stack(
            children: <Widget>[
              DarkOverLay(),
              Positioned(
                left: 0,
                top: 0,
                right: 0,
                bottom: 36,
                child: ListView(
                  children: <Widget>[
                    _buildHeader(),
                    SizedBox(height: Sizes.HEIGHT_10),
                    _buildLogo(),
                    SizedBox(height: Sizes.HEIGHT_10),
                    _buildForm(),
                    SpaceH36(),
                    _buildFooter(context)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

//
  Widget _buildHeader() {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        margin: EdgeInsets.only(top: Sizes.MARGIN_60),
        child: Text(
          "Rhino's Pizzeria",
          textAlign: TextAlign.center,
          style: Styles.titleTextStyleWithSecondaryTextColor,
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Image.asset(
      "assets/logo.png",
      width: 150.00,
      height: 100.00,
    );
  }

//
  Widget _buildForm() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: Sizes.MARGIN_48),
      child: Column(
        children: <Widget>[
          CustomTextFormField(
            obscured: false,
            hasPrefixIcon: true,
            prefixIconImagePath: "assets/email_icon.png",
            hintText: StringConst.HINT_TEXT_EMAIL,
            onChanged: (String? text) {
              emailController.text = text!;
            },
            onFieldSubmitted: (String? text) {
              emailController.text = text!;
            },
            controller: emailController,
          ),
          SpaceH16(),
          CustomTextFormField(
            hasPrefixIcon: true,
            prefixIconImagePath: "assets/password_icon.png",
            hintText: StringConst.HINT_TEXT_PASSWORD,
            obscured: true,
            onChanged: (String? text) {
              passController.text = text!;
            },
            onFieldSubmitted: (String? text) {
              passController.text = text!;
            },
            controller: passController,
          ),
        ],
      ),
    );
  }

//
  Widget _buildFooter(BuildContext context) {
    return Column(
      children: <Widget>[
        PotbellyButton(StringConst.LOGIN, onTap: () {
          AuthenticationHelper()
              .signIn(
                  email: emailController.text, password: passController.text)
              .then((result) {
            if (result == null) {
              SharedPrefUtils.saveBool("isLogged",true);
              Navigator.pushNamedAndRemoveUntil(
                  context, '/Menu', (route) => false);
            } else {
              showDialog(
                context: context,
                builder: (BuildContext context) =>
                    _buildPopupDialog(context, result),
              );
            }
          });
        }),
        SizedBox(height: Sizes.HEIGHT_60),
        InkWell(
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (BuildContext context) {
              return RegisterScreen();
            }));
          },
          child: Container(
            width: Sizes.WIDTH_150,
            height: Sizes.HEIGHT_24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  StringConst.CREATE_NEW_ACCOUNT,
                  textAlign: TextAlign.center,
                  style: Styles.customNormalTextStyle(),
                ),
                Spacer(),
                Container(
                  height: 1,
                  margin: EdgeInsets.symmetric(horizontal: 1),
                  decoration: Decorations.horizontalBarDecoration,
                  child: Container(),
                ),
              ],
            ),
          ),
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
