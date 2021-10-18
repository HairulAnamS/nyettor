import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nyettor/auth_service.dart';
// import 'package:project1/main_page.dart';
import 'package:nyettor/loading.dart';
import 'package:nyettor/constant.dart';
import 'package:nyettor/view/register_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nyettor/bloc/visibility_bloc.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController controlEmail = TextEditingController();
  TextEditingController controPassword = TextEditingController();

  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  bool result;
  String message = "";
  FirebaseUser userLogin, userSignUp;

  bool _checkEmailPassword(bool isSignIn) {
    setState(() {
      result = true;
      if (isSignIn) {
        if (controlEmail.text.trim() == "") {
          result = false;
          message = "Email belum diisi";
        } else if (controPassword.text.trim() == "") {
          result = false;
          message = "Password belum diisi";
        }
      } else {
        if (controlEmail.text.trim() == "") {
          result = false;
          message = "Email belum diisi";
        } else if (controPassword.text.trim() == "") {
          result = false;
          message = "Password belum diisi";
        } else if (!controlEmail.text.contains('@')) {
          result = false;
          message = "Format email salah";
        } else if (controPassword.text.length < 6) {
          result = false;
          message = "Password harus 6 karakter";
        }
      }
    });
    return result;
  }

  Future<void> _showAlert(BuildContext context, String aMessage) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          //title: Text(''),
          content: Text(aMessage),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleSubmit(BuildContext context, bool isLogin) async {
    try {
      if (isLogin) {
        if (_checkEmailPassword(true)) {
          Dialogs.showLoadingDialog(context, _keyLoader); //invoking login
          userLogin =
              await AuthServices.signIn(controlEmail.text, controPassword.text);
          Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();

          if (userLogin == null) {
            message = "Email dan password salah.";
            _showAlert(context, message);
          }
        } else {
          _showAlert(context, message);
        }
      } else {
        if (_checkEmailPassword(false)) {
          Dialogs.showLoadingDialog(context, _keyLoader); //invoking signUp
          userSignUp =
              await AuthServices.signUp(controlEmail.text, controPassword.text);
          Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();

          if (userSignUp == null) {
            message = "Daftar user gagal.";
            _showAlert(context, message);
          } else {
            message = "Daftar user berhasil";
            _showAlert(context, message);
          }
        } else {
          _showAlert(context, message);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    controlEmail.dispose();
    controPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    VisibilityBloc bloc = BlocProvider.of<VisibilityBloc>(context);

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.white,
          body: new ListView(padding: EdgeInsets.all(0), children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  //width: MediaQuery.of(context).size.width,
                  //height: MediaQuery.of(context).size.height * 0.35,
                  padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                  // decoration: BoxDecoration(
                  //     // color: Colors.red,
                  //     borderRadius: BorderRadius.circular(20)),
                  child: Image(
                    image: AssetImage("img/Saving-money1.png"),
                    width: 200,
                    height: 200,
                    fit: BoxFit.contain,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(25, 0, 20, 0),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text('Login',
                        style: TextStyle(
                            color: warna,
                            fontWeight: FontWeight.bold,
                            fontSize: 35)),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(20),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {});
                    },
                    controller: controlEmail,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(color: warna),
                    //maxLength: 12,
                    decoration: InputDecoration(
                        //icon: Icon(Icons.people),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blue, width: 2.0),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: warna, width: 2.0),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        prefixIcon: Icon(
                          Icons.email,
                          color: warna,
                        ),
                        //prefixText: "Username",
                        hintText: "Email",
                        hintStyle: TextStyle(color: warna),
                        labelStyle: TextStyle(color: warna),
                        labelText: "Email"),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: BlocBuilder<VisibilityBloc, bool>(
                    builder: (context, currentIsShowPassword) => TextField(
                      obscureText: currentIsShowPassword,
                      onChanged: (value) {
                        setState(() {});
                      },
                      controller: controPassword,
                      maxLength: 6,
                      keyboardType: TextInputType.text,
                      style: TextStyle(color: warna),
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blue, width: 2.0),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: warna, width: 2.0),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        prefixIcon: Icon(Icons.vpn_key, color: warna),
                        hintStyle: TextStyle(color: warna),
                        labelStyle: TextStyle(color: warna),
                        hintText: "Password",
                        labelText: "Password",
                        suffixIcon: GestureDetector(
                            onTap: () {
                              //print('focus: Pass Conf');
                              // print('iduser ontap: $fiduser');
                              bloc.add((currentIsShowPassword == true)
                                  ? VisibilityEvent.to_hide
                                  : VisibilityEvent.to_show);
                            },
                            child: Icon(
                              (currentIsShowPassword == true)
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: warna,
                            )),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 40,
                  padding: EdgeInsets.only(top: 20),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: warna, // background
                      onPrimary: Colors.white, // foreground
                    ),
                    onPressed: () async {
                      _handleSubmit(context, true);
                    },
                    child: Text(
                      "L O G I N",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                ),
                // ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Belum punya akun, ',
                          style: TextStyle(color: Colors.black)),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            new MaterialPageRoute(
                                builder: (context) => new RegisterPage()),
                          );
                        },
                        child: Text('Daftar disini',
                            style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            )),
                      )
                    ],
                  ),
                )
              ],
            )
          ]),
        ));
  }
}
