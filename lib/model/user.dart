import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  int iduser;
  String username;
  String email;
  String password;
  String nohp;
  String urlPhoto;
  DateTime tglCreate;

  User(
      {this.iduser,
      this.username,
      this.email,
      this.password,
      this.nohp,
      this.urlPhoto,
      this.tglCreate});

  factory User.fromJson(Map<String, dynamic> map) {
    return User(
        iduser: map["iduser"],
        username: map["username"],
        email: map["email"],
        password: map["password"],
        nohp: map["nohp"],
        urlPhoto: map["urlPhoto"],
        tglCreate: DateTime.fromMillisecondsSinceEpoch(
            map["tglCreate"].millisecondsSinceEpoch));
  }

  Map<String, dynamic> toJson() {
    return {
      "iduser": iduser,
      "username": username,
      "email": email,
      "password": password,
      "nohp": nohp,
      "urlPhoto": urlPhoto,
      "tglCreate": tglCreate
    };
  }

  @override
  String toString() {
    return "User{iduser: $iduser, username: $username, email: $email, password: $password}";
  }
}

List<User> objectFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<User>.from(data.map((item) => User.fromJson(item)));
}

String objectToJson(User data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}

class UserDB {
  User user = new User();
  static CollectionReference dataCollection =
      Firestore.instance.collection('user');

  Future<void> insert(User user) async {
    await dataCollection.document(user.iduser.toString()).setData({
      'iduser': user.iduser,
      'username': user.username,
      'email': user.email,
      'password': user.password,
      'nohp': user.nohp,
      'urlPhoto': user.urlPhoto,
      'tglCreate': user.tglCreate
    });
  }

  Future<void> update(User user) async {
    await dataCollection.document(user.iduser.toString()).setData({
      'username': user.username,
      'nohp': user.nohp,
      'urlPhoto': user.urlPhoto
    }, merge: true);
  }

  selectByID(int id) {
    return dataCollection.where('iduser', isEqualTo: id).getDocuments();
  }

  Future<User> selectByIDNew(int id) async {
    QuerySnapshot docs =
        await dataCollection.where('iduser', isEqualTo: id).getDocuments();

    if (docs.documents.length > 0) {
      user = User.fromJson(docs.documents[0].data);
    }

    return user;
  }

  User selectByIDNew2(int id)  {
    dataCollection.where('iduser', isEqualTo: id).getDocuments().then((docs) {
      if (docs.documents.length > 0) {
        user = User.fromJson(docs.documents[0].data);
      }
    });

    return user;
  }

  selectByEmail(String email) {
    return dataCollection.where('email', isEqualTo: email).getDocuments();
    // await dataCollection
    //     .where('email', isEqualTo: email)
    //user = User.fromJson(query.documents.forEach((element) { }));

    // await dataCollection
    //     .where('email', isEqualTo: email)
    //     .snapshots()
    //     .listen((snapshot) {
    //   snapshot.documents.forEach((f) {
    //     print(f.data);
    //     user = User.fromJson(f.data);
    //     print(user);
    //   });
    // });

    // print('lewat selectByEmail');
    // print(user.username);
    // return user;
  }

  Future<User> selectByEmail2(String aEmail) async {
    QuerySnapshot docs =
        await dataCollection.where('email', isEqualTo: aEmail).getDocuments();

    if (docs.documents.length > 0) {
      user = User.fromJson(docs.documents[0].data);
    }

    return user;
  }

  Future<int> getMaxID() async {
    int id = 1;
    await dataCollection
        .orderBy('iduser', descending: true)
        .limit(1)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((result) {
        print('iduser user: ${result.data["iduser"] + 1}');

        id = result.data["iduser"] + 1;
      });
    });
    return id;
  }
}
