import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:nyettor/constant.dart';
import 'package:nyettor/model/user.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as _path;
import 'package:image_picker/image_picker.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

class ProfilPage extends StatefulWidget {
  final User user;
  const ProfilPage(this.user);

  @override
  _ProfilPageState createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  User user = new User();
  UserDB userDB = new UserDB();
  String _urlImage = '';

  TextEditingController controlEmail = TextEditingController();
  TextEditingController controlUsername = TextEditingController();
  TextEditingController controlNoHP = TextEditingController();

  File _image;
  String _nameImage = '';
  String _message = '';

  bool result;
  bool validateUsername = true;
  bool validateAlamat = true;
  bool validateNohp = true;

  @override
  void initState() {
    user = widget.user;

    controlUsername.text = user.username;
    controlNoHP.text = user.nohp;
    controlEmail.text = user.email;

    if (user.urlPhoto != "") _urlImage = user.urlPhoto;

    super.initState();
  }

  @override
  void dispose() {
    controlEmail.dispose();
    controlUsername.dispose();
    controlNoHP.dispose();
    super.dispose();
  }

  Future getImage() async {
    File image;
    image = await ImagePicker.pickImage(source: ImageSource.gallery);
    // image = await ImagePicker.platform.pickImage(source: ImageSource.gallery);

    setState(() {
      if (image != null) {
        _image = image;
        _nameImage = _path.basename(image.path);
        print(_nameImage);
      }
    });

    if (_image != null) {
      _uploadImage();
    }
  }

  Future<String> _uploadImage() async {
    StorageReference ref = FirebaseStorage.instance.ref().child(_nameImage);
    StorageUploadTask uploadtTask = ref.putFile(_image);

    var urlDownl = await (await uploadtTask.onComplete).ref.getDownloadURL();
    setState(() {
      _urlImage = urlDownl.toString();
    });

    print('Url Gambar : $_urlImage');
    return _urlImage;
  }

  bool _checkValidate() {
    validateUsername = true;
    validateNohp = true;
   result = true;

    setState(() {
      if (controlUsername.text.trim() == "") {
        validateUsername = false;
        result = false;
      }
      if (controlNoHP.text.trim() == "") {
        validateNohp = false;
        result = false;
      }
    });
    return result;
  }

  _loadData() {
    user.username = controlUsername.text;
    user.nohp = controlNoHP.text;
    user.urlPhoto = _urlImage;
  }

  Future<void> updateUser(BuildContext context) async {
    try {
      if (_checkValidate()) {
        // bloc.add(LoadingEvent.to_show);
        _loadData();
        userDB.update(user);
        Navigator.pop(context);
        // bloc.add(LoadingEvent.to_hide);
      } else {
        _message = 'Gagal update user';
        print(_message);
        showAlert(context, _message);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> showAlert(BuildContext context, String aMessage) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Edit Profile'),
        leading: GestureDetector(
          child: Icon(Icons.arrow_back),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: warna,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Stack(children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: CircleAvatar(
                    radius: 70,
                    backgroundImage: (_urlImage == "")
                        ? AssetImage("img/User.png")
                        : NetworkImage(_urlImage),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 100,
                  child: GestureDetector(
                    onTap: () {
                      getImage();
                    },
                    child: CircleAvatar(
                        radius: 20,
                        backgroundColor: warna,
                        child: Icon(
                          Icons.photo_camera_outlined,
                          color: Colors.white,
                        )),
                  ),
                )
              ]),

              Container(
                margin: EdgeInsets.fromLTRB(20, 30, 20, 10),
                child: TextField(
                  // readOnly: true,
                  // enableInteractiveSelection: true,
                  onChanged: (value) {
                    //
                  },
                  controller: controlEmail,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(color: warna),
                  decoration: InputDecoration(
                    enabled: false,
                      // focusedBorder: OutlineInputBorder(
                      //   borderSide: BorderSide(color: Colors.blue, width: 2.0),
                      //   borderRadius: BorderRadius.circular(20),
                      // ),
                      // enabledBorder: OutlineInputBorder(
                      //   borderSide: BorderSide(color: warna, width: 2.0),
                      //   borderRadius: BorderRadius.circular(20),
                      // ),
                      filled: true,
                      fillColor: Colors.orange[100],
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
                margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: TextField(
                  onChanged: (value) {
                    //
                  },
                  controller: controlUsername,
                  keyboardType: TextInputType.text,
                  style: TextStyle(color: warna),
                  decoration: InputDecoration(
                      // focusedBorder: OutlineInputBorder(
                      //   borderSide: BorderSide(color: Colors.blue, width: 2.0),
                      //   borderRadius: BorderRadius.circular(20),
                      // ),
                      // enabledBorder: OutlineInputBorder(
                      //   borderSide: BorderSide(color: warna, width: 2.0),
                      //   borderRadius: BorderRadius.circular(20),
                      // ),
                      prefixIcon: Icon(
                        Icons.person,
                        color: warna,
                      ),
                      hintText: "Username",
                      hintStyle: TextStyle(color: warna),
                      labelStyle: TextStyle(color: warna),
                      labelText: "Username"),
                ),
              ),
              
              Container(
                margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: TextField(
                  onChanged: (value) {
                    //
                  },
                  controller: controlNoHP,
                  keyboardType: TextInputType.phone,
                  style: TextStyle(color: warna),
                  decoration: InputDecoration(
                      // focusedBorder: OutlineInputBorder(
                      //   borderSide: BorderSide(color: Colors.blue, width: 2.0),
                      //   borderRadius: BorderRadius.circular(20),
                      // ),
                      // enabledBorder: OutlineInputBorder(
                      //   borderSide: BorderSide(color: warna, width: 2.0),
                      //   borderRadius: BorderRadius.circular(20),
                      // ),
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
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: ElevatedButton(
                    onPressed: () {
                      updateUser(context);
                      
                    },
                    style: ElevatedButton.styleFrom(
                        primary: warna,
                        fixedSize: Size(MediaQuery.of(context).size.width, 40),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                    child: Text(
                      'S A V E',
                      style: TextStyle(fontSize: 18),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
