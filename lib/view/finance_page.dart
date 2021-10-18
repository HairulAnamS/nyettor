import 'dart:async';

import 'package:flutter/material.dart';
import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';
import 'package:circular_bottom_navigation/tab_item.dart';
import 'package:nyettor/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nyettor/view/history_page.dart';
import 'package:nyettor/view/grafik_page.dart';
import 'package:nyettor/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class FinancePage extends StatefulWidget {
  final FirebaseUser userLogin;
  FinancePage(this.userLogin);

  @override
  _FinancePageState createState() => _FinancePageState();
}

class _FinancePageState extends State<FinancePage> {
  int selectedPos_ = 0;
  double bottomNavBarHeight = 60;
  int gIdUser = 0;
  bool isLoading;

  User user = new User();
  UserDB userDB = new UserDB();
  var _user;
  Timer _timer;

  CircularBottomNavigationController _navigationController;
  List<TabItem> tabItems = List.of([
    new TabItem(Icons.history, "History", Colors.white,
        labelStyle:
            TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
    new TabItem(Icons.stacked_line_chart, "Graph", Colors.white,
        labelStyle:
            TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
  ]);

  @override
  void initState() {
    super.initState();
    isLoading = true;
    startTimer();
    // getIDUser();
    getUser();

    _navigationController =
        new CircularBottomNavigationController(selectedPos_);
  }

  // getIDUser() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     gIdUser = (prefs.getInt('ID') ?? 0);
  //   });
  // }

  // saveIDUser() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     prefs.setInt('ID', gIdUser);
  //   });
  // }

  void getUser() async {
    print('mulai');
    await userDB
        .selectByEmail(widget.userLogin.email)
        .then((QuerySnapshot docs) {
      if (docs.documents.isNotEmpty) {
        _user = docs.documents[0].data;
        user = User.fromJson(_user);
      }
    });
    print('selesai, iduser: ' + user.iduser.toString());
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (user.iduser == null) {
          isLoading = true;
        } else {
          timer.cancel();
          isLoading = false;
        }
      });
    });
  }

  Widget getTab(int idx, User aUser) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    } else {
      if (idx == 0) {
        return HistoryPage(aUser);
      } else {
        return GrafikPage(aUser);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(1),
              child: getTab(selectedPos_, user),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: CircularBottomNavigation(
                tabItems,
                controller: _navigationController,
                barHeight: bottomNavBarHeight,
                barBackgroundColor: warna,
                selectedIconColor: Colors.orange,
                animationDuration: Duration(milliseconds: 300),
                selectedCallback: (int selectedPos) {
                  setState(() {
                    selectedPos_ = selectedPos;
                    print(_navigationController.value);
                    print('pos: ' + selectedPos.toString());
                    print('iduser bro: ' + user.iduser.toString());
                  });
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
