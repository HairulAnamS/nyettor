import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class Finance {
  int idFinance;
  int idUser;
  String subjek;
  String kategori;
  DateTime tglTrans;
  String bulanTrans;
  int nominal;
  bool isDebet;
  DateTime tglCreate;

  Finance(
      {this.idFinance,
      this.idUser,
      this.subjek,
      this.kategori,
      this.tglTrans,
      this.bulanTrans,
      this.nominal,
      this.isDebet,
      this.tglCreate});

  factory Finance.fromJson(Map<String, dynamic> map) {
    return Finance(
        idFinance: map["idFinance"],
        idUser: map["idUser"],
        subjek: map["subjek"],
        kategori: map["kategori"],
        tglTrans: DateTime.fromMillisecondsSinceEpoch(
            map["tglTrans"].millisecondsSinceEpoch),
        bulanTrans: map["bulanTrans"],
        nominal: map["nominal"],
        isDebet: map["isDebet"],
        tglCreate: DateTime.fromMillisecondsSinceEpoch(
            map["tglCreate"].millisecondsSinceEpoch));
  }

  Map<String, dynamic> toJson() {
    return {
      "idFinance": idFinance,
      "idUser": idUser,
      "subjek": subjek,
      "kategori": kategori,
      "tglTrans": tglTrans,
      "bulanTrans": bulanTrans,
      "nominal": nominal,
      "isDebet": isDebet,
      "tglCreate": tglCreate
    };
  }

  @override
  String toString() {
    return "Finance{idFinance: $idFinance, subjek: $subjek, isDebet: $isDebet}";
  }

  factory Finance.clear() {
    return Finance(
        idFinance: 0,
        idUser: 0,
        subjek: "",
        kategori: "",
        tglTrans: DateTime.now(),
        bulanTrans: "",
        nominal: 0,
        isDebet: false,
        tglCreate: DateTime.now());
  }
}

List<Finance> objectFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<Finance>.from(data.map((item) => Finance.fromJson(item)));
}

String objectToJson(Finance data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}

class FinanceDB {
  Finance finance = new Finance();
  static CollectionReference dataCollection =
      Firestore.instance.collection('finance');

  Future<void> insert(Finance finance) async {
    await dataCollection.document(finance.idFinance.toString()).setData({
      'idFinance': finance.idFinance,
      'idUser': finance.idUser,
      'subjek': finance.subjek,
      'kategori': finance.kategori,
      'tglTrans': finance.tglTrans,
      'bulanTrans': finance.bulanTrans,
      'nominal': finance.nominal,
      'isDebet': finance.isDebet,
      'tglCreate': finance.tglCreate
    });
  }

  Future<void> update(Finance finance) async {
    await dataCollection.document(finance.idFinance.toString()).setData({
      'subjek': finance.subjek,
      'kategori': finance.kategori,
      'tglTrans': finance.tglTrans,
      'bulanTrans': finance.bulanTrans,
      'nominal': finance.nominal,
      'isDebet': finance.isDebet
    }, merge: true);
  }

  Future<void> delete(String id) async {
    await dataCollection.document(id).delete();
  }

  // selectByID(int id) {
  //   return dataCollection.where('idFinance', isEqualTo: id).getDocuments();
  // }

  // Future<Finance> selectByIDNew(int id) async {
  //   QuerySnapshot docs =
  //       await dataCollection.where('idFinance', isEqualTo: id).getDocuments();

  //   if (docs.documents.length > 0) {
  //     finance = Finance.fromJson(docs.documents[0].data);
  //   }

  //   return finance;
  // }

  // Finance selectByIDNew2(int id) {
  //   dataCollection
  //       .where('idFinance', isEqualTo: id)
  //       .getDocuments()
  //       .then((docs) {
  //     if (docs.documents.length > 0) {
  //       finance = Finance.fromJson(docs.documents[0].data);
  //     }
  //   });

  //   return finance;
  // }

  Future<int> getMaxID() async {
    int id = 0;
    await dataCollection
        .orderBy('idFinance', descending: true)
        .limit(1)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((result) {
        print('idFinance finance: ${result.data["idFinance"] + 1}');

        id = result.data["idFinance"] + 1;
      });
    });
    if (id == 0) id = id + 1;
    return id;
  }

  Future<void> getData(String aBulanTrans, int aidUser) async {
    QuerySnapshot _myData = await dataCollection
        .where('bulanTrans', isEqualTo: aBulanTrans)
        .where('idUser', isEqualTo: aidUser)
        .orderBy('tglTrans', descending: true)
        .getDocuments();
    return _myData.documents;
  }

  Future<List<Finance>> getFinance(String aBulanTrans, int aidUser) async {
    List<Finance> financeList = [];
    await dataCollection
        .where('bulanTrans', isEqualTo: aBulanTrans)
        .where('idUser', isEqualTo: aidUser)
        .orderBy('tglTrans', descending: true)
        .getDocuments()
        .then((docs) {
      if (docs.documents.length > 0) {
        financeList.clear();
        for (int i = 0; i < docs.documents.length; i++) {
          financeList.add(Finance.fromJson(docs.documents[i].data));
        }
      }
    });

    return financeList;
  }

  Future<int> getSaldo(int aidUser) async {
    int saldo = 0;
    List<Finance> financeList = [];
    await dataCollection
        .where('idUser', isEqualTo: aidUser)
        .orderBy('tglTrans', descending: true)
        .getDocuments()
        .then((docs) {
      if (docs.documents.length > 0) {
        financeList.clear();
        for (int i = 0; i < docs.documents.length; i++) {
          financeList.add(Finance.fromJson(docs.documents[i].data));
          if (financeList[i].isDebet) {
            saldo = saldo + financeList[i].nominal;
          } else {
            saldo = saldo - financeList[i].nominal;
          }
        }
      }
    });

    return saldo;
  }

  Future<List<Finance>> getFinanceFilter(
      DateTime aTglAwal, DateTime aTglAkhir, int aidUser) async {
    List<Finance> financeList = [];

    await dataCollection
        .where('tglTrans', isGreaterThanOrEqualTo: aTglAwal)
        .where('tglTrans', isLessThanOrEqualTo: aTglAkhir.add(Duration(days: 1)))
        .where('idUser', isEqualTo: aidUser)
        .orderBy('tglTrans', descending: true)
        .getDocuments()
        .then((docs) {
      if (docs.documents.length > 0) {
        financeList.clear();
        for (int i = 0; i < docs.documents.length; i++) {
          financeList.add(Finance.fromJson(docs.documents[i].data));
        }
      }
    });

    return financeList;
  }
}
