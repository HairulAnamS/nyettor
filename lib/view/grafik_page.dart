import 'package:flutter/material.dart';
import 'package:nyettor/auth_service.dart';
import 'package:nyettor/model/user.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:nyettor/model/finance.dart';
import 'package:nyettor/constant.dart';

class GrafikPage extends StatefulWidget {
  // const HistoryPage({ Key? key }) : super(key: key);
  final User user;
  GrafikPage(this.user);

  @override
  _GrafikPageState createState() => _GrafikPageState();
}

Future<void> logOut(BuildContext context) async {
  Navigator.of(context).pop();
  AuthServices.signOut();
}

class _GrafikPageState extends State<GrafikPage> {
  bool isLoading;
  Finance finance;
  FinanceDB financeDB;
  User user;
  UserDB userDB;
  List<Finance> financeList = [];
  DateTime tglSkrg, tglAwal, tglAkhir;
  List<int> income = [];
  List<int> outcome = [];
  String bln0, bln1, bln2;
  List<String> bulanList = [];
  String bulan = '';

  List<charts.Series> seriesList;
  List<charts.Series<Graph, String>> _createData() {
    var incomeData = [
      // Graph(bln0, 110),
      // Graph(bln1, 250),
      // Graph(bln2, 300),
      Graph(bln0, income[0]),
      Graph(bln1, income[1]),
      Graph(bln2, income[2]),
    ];

    var outcomeData = [
      // Graph(bln0, 57),
      // Graph(bln1, 99),
      // Graph(bln2, 120),
      Graph(bln0, outcome[0]),
      Graph(bln1, outcome[1]),
      Graph(bln2, outcome[2]),
    ];

    return [
      charts.Series<Graph, String>(
          data: incomeData,
          id: 'Graph',
          domainFn: (Graph graph, _) => graph.bulan,
          measureFn: (Graph graph, _) => graph.nominal,
          fillColorFn: (Graph graph, _) =>
              charts.MaterialPalette.green.shadeDefault,
          labelAccessorFn: (Graph graph, _) => graph.nominal.toString()),
      charts.Series<Graph, String>(
          data: outcomeData,
          id: 'Graph',
          domainFn: (Graph graph, _) => graph.bulan,
          measureFn: (Graph graph, _) => graph.nominal,
          fillColorFn: (Graph graph, _) =>
              charts.MaterialPalette.red.shadeDefault,
          labelAccessorFn: (Graph graph, _) => graph.nominal.toString())
    ];
  }

  barChart() {
    return charts.BarChart(
      seriesList,
      animate: true,
      vertical: true,
      //barRendererDecorator: charts.BarLabelDecorator<String>(),
    );
  }

  @override
  void initState() {
    print('iduser: ' + widget.user.iduser.toString());
    super.initState();

    isLoading = true;
    finance = new Finance();
    financeDB = new FinanceDB();
    userDB = new UserDB();
    user = widget.user;
    generateBulan(DateTime.now());
    ambilData(false, DateTime.now());
  }

  void ambilData(bool isFilter, DateTime date) async {
    isLoading = true;
    if (isFilter) {
      tglSkrg = date;
    } else {
      tglSkrg = DateTime.now();
    }
    tglAwal = DateTime(tglSkrg.year, tglSkrg.month - 2, 1);
    tglAkhir = DateTime(tglSkrg.year, tglSkrg.month + 1, 0);

    bln2 = getBulan(tglSkrg, true);
    bln1 = getBulan(DateTime(tglSkrg.year, tglSkrg.month - 1, 1), true);
    bln0 = getBulan(DateTime(tglSkrg.year, tglSkrg.month - 2, 1), true);

    print('start ambil data');
    financeList =
        await financeDB.getFinanceFilter(tglAwal, tglAkhir, user.iduser);
    getCome(financeList);
    seriesList = _createData();
    print('start selesai data');
    setState(() {
      isLoading = false;
    });
  }

  void getCome(List<Finance> finances) {
    income = [0, 0, 0];
    outcome = [0, 0, 0];

    for (int i = 0; i < finances.length; i++) {
      if (finances[i].bulanTrans == bln0) {
        if (finances[i].isDebet) {
          income[0] = income[0] + finances[i].nominal;
        } else {
          outcome[0] = outcome[0] + finances[i].nominal;
        }
      } else if (finances[i].bulanTrans == bln1) {
        if (finances[i].isDebet) {
          income[1] = income[1] + finances[i].nominal;
        } else {
          outcome[1] = outcome[1] + finances[i].nominal;
        }
      } else if (finances[i].bulanTrans == bln2) {
        if (finances[i].isDebet) {
          income[2] = income[2] + finances[i].nominal;
        } else {
          outcome[2] = outcome[2] + finances[i].nominal;
        }
      }
    }

    print(' income: $income, outcome: $outcome');
  }

  void generateBulan(DateTime aDate) {
    String month;
    bulanList.clear();

    for (int i = 0; i < 6; i++) {
      month = getBulan(aDate, true);
      bulanList.add(month);
      aDate = DateTime(aDate.year, aDate.month - 1, 1);
    }
    bulan = bulanList[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: warna,
        title: Text('Income vs Outcome',
            style: GoogleFonts.play(
                textStyle: TextStyle(fontSize: 20, color: Colors.white))),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: Container(
              color: warna,
              height: 50,
              child: Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: Container(
                      margin: EdgeInsets.all(3),
                      color: Colors.white,
                      //width: 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(5, 0, 10, 0),
                                width: 25,
                                height: 10,
                                color: Colors.green,
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Text('Income',
                                  style: GoogleFonts.play(
                                      textStyle: TextStyle(
                                          fontSize: 14, color: warna)))
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(5, 0, 10, 0),
                                width: 25,
                                height: 10,
                                color: Colors.red,
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Text('Outcome',
                                  style: GoogleFonts.play(
                                      textStyle: TextStyle(
                                          fontSize: 14, color: warna)))
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Container(
                      margin: EdgeInsets.fromLTRB(0, 3, 3, 3),
                      color: Colors.white,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Bulan :',
                                style: GoogleFonts.play(
                                    textStyle:
                                        TextStyle(fontSize: 14, color: warna))),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Container(
                            width: 150,
                            //color: Colors.redAccent,
                            child: DropdownButton(
                              isExpanded: true,
                              icon: Icon(Icons.keyboard_arrow_down),
                              dropdownColor: warna,
                              hint: Text("Pilih Bulan",
                                  style: TextStyle(color: Colors.white)),
                              value: bulan,
                              items: bulanList.map((value) {
                                return DropdownMenuItem(
                                  child: Text(
                                    value,
                                    style: GoogleFonts.play(
                                        textStyle: TextStyle(
                                            fontSize: 16, color: Colors.green)),
                                  ),
                                  value: value,
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  bulan = value;
                                  ambilData(true, convertBulan(bulan));
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.63,
              child: (isLoading)
                  ? Center(child: CircularProgressIndicator())
                  : barChart(),
            ),
          ),
        ],
      ),
    );
  }
}

class Graph {
  final String bulan;
  final int nominal;

  Graph(this.bulan, this.nominal);
}
