import 'package:flutter/material.dart';
import 'package:pizzamenu/Auth/authentication.dart';
import 'package:pizzamenu/general/storage.dart';
import 'package:pizzamenu/values/values.dart';
import 'package:pizzamenu/widgets/custom_text_form_field.dart';
import 'package:pizzamenu/widgets/dark_overlay.dart';
import 'package:pizzamenu/widgets/potbelly_button.dart';
import 'package:pizzamenu/widgets/spaces.dart';

class RegisterScreen extends StatelessWidget {
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
                  image: AssetImage("assets/signup.jpg"), fit: BoxFit.cover)),
          // decoration: Decorations.regularDecoration,
          child: Stack(
            children: [
              DarkOverLay(),
              Positioned(
                left: 0,
                top: 0,
                right: 0,
                bottom: 40,
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: Sizes.MARGIN_40),
                  child: ListView(
                    children: [
                      SizedBox(height: Sizes.HEIGHT_10),
                      Image.asset(
                        "assets/logo.png",
                        width: 150.00,
                        height: 100.00,
                      ),
                      SpaceH16(),
                      _buildForm(),
                      SpaceH40(),
                      PotbellyButton(StringConst.REGISTER, onTap: () {
                        AuthenticationHelper()
                            .signUp(
                                email: emailController.text,
                                password: passController.text)
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
                      }
                          // => AppRouter.navigator
                          //     .pushNamed(AppRouter.setLocationScreen),
                          ),
                      SpaceH40(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            StringConst.HAVE_AN_ACCOUNT_QUESTION,
                            textAlign: TextAlign.right,
                            style: Styles.customNormalTextStyle(),
                          ),
                          SpaceW16(),
                          InkWell(
                            onTap: () {
                              Navigator.pushReplacementNamed(
                                  context, '/loginScreen');
                            },
                            child: Text(
                              StringConst.LOGIN,
                              textAlign: TextAlign.left,
                              style: Styles.customNormalTextStyle(
                                color: AppColors.secondaryElement,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      children: <Widget>[
        CustomTextFormField(
          obscured: false,
          hasPrefixIcon: true,
          prefixIconImagePath: "assets/person_icon.png",
          hintText: StringConst.HINT_TEXT_NAME,
          onChanged: (String? text) {
            nameController.text = text!;
          },
          onFieldSubmitted: (String? text) {
            nameController.text = text!;
          },
          controller: nameController,
        ),
        SpaceH16(),
        CustomTextFormField(
          obscured: false,
          onChanged: (String? text) {
            emailController.text = text!;
          },
          onFieldSubmitted: (String? text) {
            emailController.text = text!;
          },
          controller: emailController,
          hasPrefixIcon: true,
          prefixIconImagePath: "assets/email_icon.png",
          hintText: StringConst.HINT_TEXT_EMAIL,
        ),
        SpaceH16(),
        CustomTextFormField(
          onChanged: (String? text) {
            passController.text = text!;
          },
          onFieldSubmitted: (String? text) {
            passController.text = text!;
          },
          controller: passController,
          hasPrefixIcon: true,
          prefixIconImagePath: "assets/password_icon.png",
          hintText: StringConst.HINT_TEXT_PASSWORD,
          obscured: true,
        ),
        SpaceH16(),
        CustomTextFormField(
          onChanged: (String? text) {
            confirmPassController.text = text!;
          },
          onFieldSubmitted: (String? text) {
            confirmPassController.text = text!;
          },
          controller: confirmPassController,
          hasPrefixIcon: true,
          prefixIconImagePath: "assets/password_icon.png",
          hintText: StringConst.HINT_TEXT_CONFIRM_PASSWORD,
          obscured: true,
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
