import 'package:flutter/material.dart';
import 'package:nyettor/constant.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nyettor/model/finance.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:intl/intl.dart';
import 'package:nyettor/model/user.dart';
import 'package:pattern_formatter/pattern_formatter.dart';

class FinanceInputPage extends StatefulWidget {
  final Finance aFinance;
  final int aMode;
  final User user;
  FinanceInputPage(this.aFinance, this.aMode, this.user);

  @override
  _FinanceInputPageState createState() => _FinanceInputPageState();
}

class _FinanceInputPageState extends State<FinanceInputPage> {
  TextEditingController controlSubjek = TextEditingController();
  TextEditingController controlNominal = TextEditingController();
  int fIdFinance;
  Finance finance;
  FinanceDB financeDB;
  DateTime fTglTrans;
  int fMode;
  bool fIsDebet;
  int fKategori;
  List<String> options = [
    'Kebutuhan',
    'Pendapatan',
    'Belanja',
    'Sedekah',
    'Service',
    'Hiburan',
    'Lain-lain'
  ];
  bool _validationSubjek;
  bool _validationNominal;
  bool _result;

  User user = new User();

  @override
  void initState() {
    user = widget.user;
    fTglTrans = DateTime.now();
    fMode = widget.aMode;
    fKategori = 0;
    fIsDebet = false;
    _validationSubjek = true;
    _validationNominal = true;
    _result = true;

    finance = widget.aFinance;
    financeDB = new FinanceDB();
    show(finance);

    getFinanceID();
    print('idFinance init: $fIdFinance');
    super.initState();
  }

  @override
  void dispose() {
    controlSubjek.dispose();
    controlNominal.dispose();
    super.dispose();
  }

  void getFinanceID() async {
    fIdFinance = await financeDB.getMaxID();
  }

  void show(Finance finance) {
    controlSubjek.text = finance.subjek;
    controlNominal.text = finance.nominal.toString();
    if (fMode == modeEdit) {
      fKategori = options.indexOf(finance.kategori);
    } else {
      fKategori = 0;
    }
    fIsDebet = (finance.isDebet) ? true : false;
    fTglTrans = finance.tglTrans;
  }

  void loadData() {
    if (fMode == modeNew) {
      finance.idFinance = fIdFinance;
      finance.tglCreate = DateTime.now();
    }
    finance.idUser = user.iduser;
    finance.nominal = int.parse(controlNominal.text.replaceAll(',', ''));
    finance.subjek = controlSubjek.text;
    finance.kategori = options[fKategori];
    finance.tglTrans = fTglTrans;
    finance.isDebet = fIsDebet;
    finance.bulanTrans = getBulan(finance.tglTrans, true);
  }

  bool checkValidate() {
    _validationSubjek = true;
    _validationNominal = true;
    _result = true;

    if (controlSubjek.text.isEmpty) {
      setState(() {
        _validationSubjek = false;
        _result = false;
      });
    }

    if (_result) {
      if (controlNominal.text.isEmpty || controlNominal.text == '0') {
        setState(() {
          _validationNominal = false;
          _result = false;
        });
      }
    }

    return _result;
  }

  Future<void> doSave(BuildContext context) async {
    try {
      if (checkValidate()) {
        loadData();
        if (fMode == modeNew) {
          financeDB.insert(finance);
        } else {
          financeDB.update(finance);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future<bool> _onBackPressed() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Konfirmasi',
              style: GoogleFonts.play(
                  textStyle: TextStyle(fontSize: 24, color: warna)),
            ),
            content: Text(
              'Yakin membatalkan input/edit transaksi ?',
              style: GoogleFonts.play(
                  textStyle: TextStyle(fontSize: 18, color: warna)),
            ),
            actions: [
              TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: warna,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text(
                    'OKAY',
                    style: GoogleFonts.play(
                        textStyle:
                            TextStyle(fontSize: 18, color: Colors.white)),
                  ))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return //MaterialApp(
        //debugShowCheckedModeBanner: false,
        //home:
        WillPopScope(
      onWillPop: (controlSubjek.text.isEmpty) ? null : _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: warna,
          title: Text(
            (fMode == modeNew) ? 'Add Transaction' : 'Edit Transaction',
            style: GoogleFonts.play(
                textStyle: TextStyle(fontSize: 20, color: Colors.white)),
          ),
        ),
        body: Center(
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          fIsDebet = true;
                        });
                      },
                      child: Container(
                        height: 50,
                        width: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            bottomLeft: Radius.circular(15),
                          ),
                          color: (fIsDebet) ? Colors.green : Colors.grey[300],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(
                              Icons.trending_up,
                              size: 26,
                            ),
                            Text(
                              'Income',
                              style: GoogleFonts.play(
                                  textStyle:
                                      TextStyle(fontSize: 20, color: warna)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          fIsDebet = false;
                        });
                      },
                      child: Container(
                        height: 50,
                        width: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                          ),
                          color: (fIsDebet) ? Colors.grey[300] : Colors.red,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(
                              Icons.trending_down,
                              size: 26,
                            ),
                            Text(
                              'Outcome',
                              style: GoogleFonts.play(
                                  textStyle:
                                      TextStyle(fontSize: 20, color: warna)),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(20, 15, 20, 5),
                width: MediaQuery.of(context).size.width,
                // height: MediaQuery.of(context).size.height * 0.6,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: warna, blurRadius: 8, offset: Offset(2, 2))
                    ]),
                child: Column(
                  children: [
                    Padding(
                     padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: ChipsChoice<int>.single(
                        // wrapped: true,
                        value: fKategori,
                        spacing: 0,
                        onChanged: (val) {
                          setState(() {
                            fKategori = val;
                            print(val.toString());
                            print(options[val]);
                          });
                        },
                        choiceItems: C2Choice.listFrom<int, String>(
                          source: options,
                          value: (i, v) => i,
                          label: (i, v) => v,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: TextField(
                        onChanged: (value) {
                          if (fIdFinance == null) {
                            getFinanceID();
                            print('idfinance change: $fIdFinance');
                          } else {
                            print('idfinance change wes: $fIdFinance');
                          }
                        },
                        controller: controlSubjek,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            labelText: "Subjek",
                            icon: Icon(Icons.perm_identity),
                            errorText: _validationSubjek
                                ? null
                                : 'Subjek harus diisi'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: TextField(
                        onChanged: (value) {
                          //
                        },
                        controller: controlNominal,
                        keyboardType: TextInputType.number,
                        inputFormatters: [ThousandsFormatter()],
                        decoration: InputDecoration(
                            labelText: "Nominal",
                            icon: Icon(Icons.monetization_on_outlined),
                            errorText: _validationNominal
                                ? null
                                : 'Nominal harus diisi'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                      child: DateTimePicker(
                        icon: Icon(Icons.date_range),
                        dateMask: 'd MMM, yyyy',
                        initialValue: fTglTrans.toString(),
                        firstDate: DateTime(1950),
                        lastDate: DateTime(2050),
                        dateLabelText: 'Tanggal Transaksi',
                        onChanged: (val) {
                          setState(() {
                            fTglTrans = new DateFormat("yyyy-MM-dd").parse(val);
                            getBulan(fTglTrans, true);
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
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 40, 20, 0),
                          child: Container(
                            width: 100,
                            child: ElevatedButton(
                              onPressed: () {
                                doSave(context);
                                if (_result) {
                                  Navigator.pop(context);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                primary: warna,
                              ),
                              // color: warna,
                              child: Text(
                                'S A V E',
                                style: GoogleFonts.play(
                                    textStyle: TextStyle(
                                        fontSize: 20, color: Colors.white)),
                              ),
                            ),
                          )),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
    //);
  }
}
