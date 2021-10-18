import 'package:flutter/material.dart';
import 'package:nyettor/constant.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nyettor/model/finance.dart';
import 'package:intl/intl.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:nyettor/view/financeInput_page.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:nyettor/model/user.dart';
import 'package:nyettor/auth_service.dart';
import 'package:nyettor/view/profil_page.dart';

class HistoryPage extends StatefulWidget {
  final User user;
  HistoryPage(this.user);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

enum options { logOut, profil }

class _HistoryPageState extends State<HistoryPage> with AutomaticKeepAliveClientMixin<HistoryPage> {
  bool isLoading;
  bool isDelete;
  Finance finance;
  FinanceDB financeDB;
  List<Finance> financeList = [];
  int saldo, income, outcome;
  DateTime tglSkrg, tglAwal, tglAkhir;

  User user = new User();
  UserDB userDB = new UserDB();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    user = widget.user;

    isLoading = true;
    isDelete = false;
    finance = new Finance();
    financeDB = new FinanceDB();
    saldo = 0;
    income = 0;
    outcome = 0;
    tglSkrg = DateTime.now();
    tglAwal = DateTime(tglSkrg.year, tglSkrg.month, 1);
    tglAkhir = DateTime(tglSkrg.year, tglSkrg.month + 1, 0);
    ambilData(true);

    super.initState();
  }

  void ambilData(bool isUseFilter) async {
    print('start ambil data');
    if (isUseFilter) {
      financeList = await financeDB.getFinanceFilter(
          tglAwal, tglAkhir, (user.iduser == null) ? 0 : user.iduser);
    } else {
      financeList = await financeDB.getFinance(getBulan(DateTime.now(), true),
          (user.iduser == null) ? 0 : user.iduser);
    }
    saldo = await financeDB.getSaldo((user.iduser == null) ? 0 : user.iduser);
    getCome(financeList);
    print('start selesai data');
    setState(() {
      isLoading = false;
    });
  }

  void getCome(List<Finance> finances) {
    income = 0;
    outcome = 0;
    for (int i = 0; i < finances.length; i++) {
      if (finances[i].isDebet) {
        //saldo = saldo + finances[i].nominal;
        income = income + finances[i].nominal;
      } else {
        //saldo = saldo - finances[i].nominal;
        outcome = outcome + finances[i].nominal;
      }
    }

    print('saldo: $saldo , income: $income, outcome: $outcome');
  }

  Future<void> logOut(BuildContext context) async {
    Navigator.of(context).pop();
    AuthServices.signOut();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    return Column(
      children: [
        Padding(
            padding: EdgeInsets.fromLTRB(10, 20, 10, 5),
            child: Container(
              padding: EdgeInsets.all(5),
              height: 70,
              color: Colors.transparent,
              child: ListTile(
                  leading: CircleAvatar(
                    radius: 27,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.white,
                      backgroundImage: AssetImage("img/User.png"),
                    ),
                  ),
                  title: Text('Selamat Datang',
                      style: TextStyle(color: warna, fontSize: 18)),
                  subtitle: Text(user.username.toUpperCase(),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, color: warna)),
                  trailing: PopupMenuButton<options>(
                      onSelected: (result) {
                        if (result == options.profil) {
                          Navigator.of(context)
                              .push(
                            new MaterialPageRoute<String>(
                                builder: (context) => new ProfilPage(user)),
                          )
                              .then((String val) {
                            setState(() {
                              print('ambil data lagi habis save');
                              //ambilData(false);
                            });
                          });
                        }
                      },
                      child: Icon(Icons.settings, color: warna),
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<options>>[
                            PopupMenuItem<options>(
                              value: options.profil,
                              child: GestureDetector(
                                // onTap: () {
                                //   Navigator.of(context)
                                //       .push(
                                //     new MaterialPageRoute<String>(
                                //         builder: (context) =>
                                //             new ProfilPage(user)),
                                //   )
                                //       .then((String val) {
                                //     setState(() {
                                //       print('ambil data lagi habis save');
                                //       //ambilData(false);
                                //     });
                                //   });
                                // },
                                child: Text(
                                  'Edit Profile',
                                  style: TextStyle(color: warna),
                                ),
                              ),
                            ),
                            PopupMenuItem<options>(
                              value: options.logOut,
                              child: GestureDetector(
                                onTap: () {
                                  logOut(context);
                                },
                                child: Text(
                                  'Log Out',
                                  style: TextStyle(color: warna),
                                ),
                              ),
                            ),
                          ])),
            )),
        Container(
          height: 1,
          color: warna,
          margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Container(
            height: 160,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
              color: warna,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 15, 8, 5),
                      child: Text(
                        'Saldo :',
                        style: GoogleFonts.play(
                            textStyle:
                                TextStyle(fontSize: 21, color: Colors.white)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 15, 8, 5),
                      child: Text(
                        formatter.format(saldo),
                        style: GoogleFonts.play(
                            textStyle:
                                TextStyle(fontSize: 21, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    height: 0.5,
                    color: Colors.white,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                          child: Text(
                            'Income',
                            style: GoogleFonts.play(
                                textStyle: TextStyle(
                                    fontSize: 16, color: Colors.white)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
                          child: Text(
                            formatter.format(income),
                            style: GoogleFonts.play(
                                textStyle: TextStyle(
                                    fontSize: 16, color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                          child: Text(
                            'Outcome',
                            style: GoogleFonts.play(
                                textStyle: TextStyle(
                                    fontSize: 16, color: Colors.white)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
                          child: Text(
                            formatter.format(outcome),
                            style: GoogleFonts.play(
                                textStyle: TextStyle(
                                    fontSize: 16, color: Colors.white)),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Sisa : ',
                        style: GoogleFonts.play(
                            textStyle:
                                TextStyle(fontSize: 16, color: Colors.white)),
                      ),
                      Text(
                        formatter.format(income - outcome),
                        style: GoogleFonts.play(
                            textStyle:
                                TextStyle(fontSize: 16, color: Colors.white)),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Transactions',
                style: GoogleFonts.play(
                    textStyle: TextStyle(fontSize: 20, color: warna)),
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  return showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text(
                        "Filter",
                        style: GoogleFonts.play(
                            textStyle: TextStyle(
                                fontSize: 20,
                                color: warna,
                                fontWeight: FontWeight.bold)),
                      ),
                      content: Container(
                        height: MediaQuery.of(context).size.height * 0.3,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                              child: DateTimePicker(
                                icon: Icon(Icons.date_range),
                                dateMask: 'd MMM, yyyy',
                                initialValue: tglAwal.toString(),
                                firstDate: DateTime(2010),
                                lastDate: DateTime(2050),
                                dateLabelText: 'Tanggal Awal',
                                onChanged: (val) {
                                  setState(() {
                                    tglAwal =
                                        new DateFormat("yyyy-MM-dd").parse(val);
                                    //getBulan(tglAwal);
                                    print(val);
                                  });
                                },
                                validator: (val) {
                                  print(val);
                                  return null;
                                },
                                onSaved: (val) => print(val),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                              child: DateTimePicker(
                                icon: Icon(Icons.date_range),
                                dateMask: 'd MMM, yyyy',
                                initialValue: tglAkhir.toString(),
                                firstDate: DateTime(2010),
                                lastDate: DateTime(2050),
                                dateLabelText: 'Tanggal Akhir',
                                onChanged: (val) {
                                  setState(() {
                                    tglAkhir =
                                        new DateFormat("yyyy-MM-dd").parse(val);
                                    //getBulan(tglAkhir);
                                    print(val);
                                  });
                                },
                                validator: (val) {
                                  print(val);
                                  return null;
                                },
                                onSaved: (val) => print(val),
                              ),
                            ),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: warna,
                          ),
                          onPressed: () {
                            Navigator.of(ctx).pop();
                            if (this.mounted) {
                              setState(() {
                                print('refresh data habis filter');
                                ambilData(true);
                              });
                            }
                          },
                          child: Text(
                            "OK",
                            style: GoogleFonts.play(
                                textStyle: TextStyle(
                                    fontSize: 16, color: Colors.white)),
                          ),
                        )
                      ],
                    ),
                  );
                },
                child: Container(
                    // padding: EdgeInsets.all(7),
                    height: 30,
                    width: 40,
                    decoration: BoxDecoration(
                        color: warna, borderRadius: BorderRadius.circular(5)),
                    child: Icon(
                      Icons.search,
                      size: 20,
                      color: Colors.white,
                    )),
              ),
              SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) =>
                  //           FinanceInputPage(Finance.clear(), modeNew)),
                  // );

                  Navigator.of(context)
                      .push(
                    new MaterialPageRoute<String>(
                        builder: (context) => new FinanceInputPage(
                            Finance.clear(), modeNew, user)),
                  )
                      .then((String val) {
                    setState(() {
                      print('ambil data lagi habis save');
                      ambilData(true);
                    });
                  });
                },
                child: Container(
                    //padding: EdgeInsets.all(7),
                    height: 30,
                    width: 40,
                    decoration: BoxDecoration(
                        color: warna, borderRadius: BorderRadius.circular(5)),
                    child: Center(
                      child: Text(
                        '+',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 24, color: Colors.white),
                      ),
                    )),
              )
            ],
          ),
        ),
        (isLoading)
            ? Center(heightFactor: 5, child: CircularProgressIndicator())
            : Flexible(
                child: SafeArea(
                minimum: EdgeInsets.fromLTRB(0, 0, 0, 70),
                child: Container(
                    height: MediaQuery.of(context).size.height * 0.45,
                    child: (financeList.length > 0)
                        ? ListView.builder(
                            itemCount: financeList.length,
                            itemBuilder: (_, index) {
                              final finances = financeList[index];

                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context)
                                      .push(
                                    new MaterialPageRoute<String>(
                                        builder: (context) =>
                                            new FinanceInputPage(
                                                finances, modeEdit, user)),
                                  )
                                      .then((String val) {
                                    setState(() {
                                      print('ambil data lagi habis edit');
                                      ambilData(true);
                                    });
                                  });
                                },
                                onLongPress: () {
                                  return showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: Text(
                                        "Konfirmasi",
                                        style: GoogleFonts.play(
                                            textStyle: TextStyle(
                                                fontSize: 20,
                                                color: warna,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      content: Text(
                                        "Apakah yakin ingin menghapus subjek " +
                                            finances.subjek +
                                            ' ?',
                                        style: GoogleFonts.play(
                                            textStyle: TextStyle(
                                          fontSize: 16,
                                          color: warna,
                                        )),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          style: TextButton.styleFrom(
                                            backgroundColor: warna,
                                          ),
                                          onPressed: () {
                                            isDelete = true;
                                            financeDB.delete(
                                                finances.idFinance.toString());
                                            Navigator.of(ctx).pop();
                                            if (this.mounted) {
                                              setState(() {
                                                print(
                                                    'refresh data habis hapus');
                                                ambilData(true);
                                              });
                                            }
                                          },
                                          child: Text(
                                            "YA",
                                            style: GoogleFonts.play(
                                                textStyle: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white)),
                                          ),
                                        ),
                                        TextButton(
                                          style: TextButton.styleFrom(
                                            backgroundColor: warna,
                                          ),
                                          onPressed: () {
                                            isDelete = false;
                                            Navigator.of(ctx).pop();
                                          },
                                          child: Text(
                                            "TIDAK",
                                            style: GoogleFonts.play(
                                                textStyle: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(0, 0, 5, 5),
                                  margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
                                  height: 72,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                            color: warna,
                                            blurRadius: 8,
                                            offset: Offset(2, 2))
                                      ]),
                                  child: ListTile(
                                    leading: Container(
                                      width: 45,
                                      height: 45,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        color: warna,
                                      ),
                                      child: Icon(
                                          (finances.isDebet)
                                              ? Icons.trending_up
                                              : Icons.trending_down,
                                          color: (finances.isDebet)
                                              ? Colors.green
                                              : Colors.red),
                                    ),
                                    title: Text(
                                      formatter.format(finances.nominal),
                                      style: GoogleFonts.play(
                                          textStyle: TextStyle(
                                              fontSize: 18, color: warna)),
                                    ),
                                    subtitle: Text(
                                      finances.subjek,
                                      style: GoogleFonts.play(
                                          textStyle: TextStyle(
                                              fontSize: 16, color: warna)),
                                    ),
                                    trailing: Text(
                                      DateFormat('dd MMM yyyy')
                                          .format(finances.tglTrans),
                                      style: GoogleFonts.play(
                                          textStyle: TextStyle(
                                              fontSize: 14, color: warna)),
                                    ),
                                  ),
                                ),
                              );
                            })
                        : Center(
                            child: Text(
                              'Empty Transactions...',
                              style: GoogleFonts.play(
                                  textStyle:
                                      TextStyle(fontSize: 24, color: warna)),
                            ),
                          )),
              )),
      ],
    );
  }
}
