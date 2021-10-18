import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nyettor/auth_service.dart';
import 'package:nyettor/loading.dart';
import 'package:nyettor/constant.dart';
import 'package:nyettor/model/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nyettor/bloc/visibility_bloc.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController controlEmail = TextEditingController();
  TextEditingController controlPassword = TextEditingController();
  TextEditingController controlUsername = TextEditingController();
  TextEditingController controlNoHP = TextEditingController();

  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  bool result;
  String message = "";
  FirebaseUser userRegister, userSignUp;

  User user;
  UserDB userDB;
  int fiduser;

  @override
  void initState() {
    super.initState();
    user = new User();
    userDB = new UserDB();
    getUserID();
    print('iduser init: $fiduser');
  }

  @override
  void dispose() {
    controlEmail.dispose();
    controlPassword.dispose();
    controlUsername.dispose();
    controlNoHP.dispose();
    super.dispose();
  }

  void getUserID() async {
    fiduser = await userDB.getMaxID();
  }

  loadData() {
    user.iduser = fiduser;
    user.username = controlUsername.text;
    user.email = controlEmail.text;
    user.password = controlPassword.text;
    user.nohp = controlNoHP.text;
    user.urlPhoto = "";
    user.tglCreate = DateTime.now();
  }

  bool _checkValidate() {
    setState(() {
      result = true;
      if (controlUsername.text.trim() == "") {
        result = false;
        message = "Username belum diisi";
      } else if (controlEmail.text.trim() == "") {
        result = false;
        message = "Email belum diisi";
      } else if (controlNoHP.text.trim() == "") {
        result = false;
        message = "Nomor Hp belum diisi";
      } else if (controlPassword.text.trim() == "") {
        result = false;
        message = "Password belum diisi";
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

  Future<void> registerUser(BuildContext context) async {
    try {
      if (_checkValidate()) {
        Dialogs.showLoadingDialog(context, _keyLoader); //invoking signUp
        userSignUp =
            await AuthServices.signUp(controlEmail.text, controlPassword.text);
        Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();

        if (userSignUp == null) {
          message = "Daftar akun gagal.";
          _showAlert(context, message);
        } else {
          loadData();
          userDB.insert(user);
          message = "Daftar akun berhasil";
          _showAlert(context, message);

          Navigator.of(context).pop();
        }
      } else {
        _showAlert(context, message);
      }
    } catch (e) {
      print(e);
    }
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
                  // width: MediaQuery.of(context).size.width,
                  // height: MediaQuery.of(context).size.height * 0.25,
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  // decoration: BoxDecoration(
                  //     // color: Colors.red,
                  //     borderRadius: BorderRadius.circular(20)),
                  child: Image(
                    image: AssetImage("img/Saving-money2.png"),
                    width: 150,
                    height: 150,
                    fit: BoxFit.contain,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(25, 0, 20, 0),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text('Register',
                        style: TextStyle(
                            color: warna,
                            fontWeight: FontWeight.bold,
                            fontSize: 35)),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: TextField(
                    onChanged: (value) {
                      if (fiduser == null) {
                        getUserID();
                        print('idposting change: $fiduser');
                      } else {
                        print('idposting change wes: $fiduser');
                      }
                    },
                    controller: controlUsername,
                    keyboardType: TextInputType.text,
                    style: TextStyle(color: warna),
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blue, width: 2.0),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: warna, width: 2.0),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        prefixIcon: Icon(
                          Icons.person,
                          color: warna,
                        ),
                        //prefixText: "Username",
                        hintText: "Username",
                        hintStyle: TextStyle(color: warna),
                        labelStyle: TextStyle(color: warna),
                        labelText: "Username"),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
                  child: TextField(
                    onChanged: (value) {
                      if (fiduser == null) {
                        getUserID();
                        print('idposting change: $fiduser');
                      } else {
                        print('idposting change wes: $fiduser');
                      }
                    },
                    controller: controlEmail,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(color: warna),
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blue, width: 2.0),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: warna, width: 2.0),
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
                  margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
                  child: TextField(
                    onChanged: (value) {
                      if (fiduser == null) {
                        getUserID();
                        print('idposting change: $fiduser');
                      } else {
                        print('idposting change wes: $fiduser');
                      }
                    },
                    controller: controlNoHP,
                    keyboardType: TextInputType.phone,
                    style: TextStyle(color: warna),
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blue, width: 2.0),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: warna, width: 2.0),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        prefixIcon: Icon(
                          Icons.phone,
                          color: warna,
                        ),
                        hintText: "No.HP",
                        hintStyle: TextStyle(color: warna),
                        labelStyle: TextStyle(color: warna),
                        labelText: "No.HP"),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: BlocBuilder<VisibilityBloc, bool>(
                    builder: (context, currentIsShowPassword) => TextField(
                      obscureText: currentIsShowPassword,
                      onChanged: (value) {
                        if (fiduser == null) {
                          getUserID();
                          print('idposting change: $fiduser');
                        } else {
                          print('idposting change wes: $fiduser');
                        }
                      },
                      controller: controlPassword,
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
                          borderSide:
                              BorderSide(color: warna, width: 2.0),
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
                              print('iduser ontap: $fiduser');
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
                  padding: EdgeInsets.only(top: 10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: warna, // background
                      onPrimary: Colors.white, // foreground
                    ),
                    onPressed: () async {
                      registerUser(context);
                      // if (userSignUp != null){
                      //   Navigator.of(context).pop();
                      // }
                    },
                    child: Text(
                      "DAFTAR AKUN",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                ),
                // ),
              ],
            )
          ]),
        ));
  }
}
