import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:e_imunisasi/models/user.dart';
import 'package:path/path.dart';

class DatabaseService {
  final String uid;
  final String email;
  DatabaseService({this.uid, this.email});

  //Colection Reference
  final CollectionReference imunisasiCollection =
      Firestore.instance.collection('eimunisasi');

  Future<void> addEventKalender(final product) async {
    return await Firestore.instance
        .collection('KalenderData')
        .add(product)
        .then((DocumentReference document) {
      print(document.documentID);
    }).catchError((onError) {
      print(onError);
    });
  }

  Future<void> updateEventKalender(final product, final documentID) async {
    return await Firestore.instance
        .collection('KalenderData')
        .document(documentID)
        .updateData(product);
  }

  Future<void> addPerkembangan(final data) async {
    return await Firestore.instance
        .collection('DataTumbuh')
        .add(data)
        .then((DocumentReference document) {
      print(document.documentID);
    }).catchError((onError) {
      print(onError);
    });
  }

  Future<void> addRiwayatImunisasi(final data) async {
    return await Firestore.instance
        .collection('DataRiwayatImunisasi')
        .add(data)
        .then((DocumentReference document) {
      print(document.documentID);
    }).catchError((onError) {
      print(onError);
    });
  }

  Future updateUserDataAnak(
      String email,
      String nama,
      String nik,
      String tgllahir,
      String namaAyah,
      String pekerjaanAyah,
      String namaIbu,
      String pekerjaanIbu,
      String alamat,
      String noTlp) async {
    return {
      await Firestore.instance
          .collection('PersonalData')
          .document(uid)
          .setData({
        'typeUser': 'anakCollection',
        'email': email,
        'nama': nama,
        'nik': nik,
        'tgllahir': tgllahir,
        'namaAyah': namaAyah,
        'pekerjaanAyah': pekerjaanAyah,
        'namaIbu': namaIbu,
        'pekerjaanIbu': pekerjaanIbu,
        'alamat': alamat,
        'noTelp': noTlp,
      }, merge: true),
    };
  }

  Future updateUserDataMedis(String email, String nama, String nik,
      String tgllahir, String alamat, String unitKerja, String noTlp) async {
    return {
      await Firestore.instance
          .collection('PersonalData')
          .document(uid)
          .setData({
        'typeUser': 'medisCollection',
        'email': email,
        'nama': nama,
        'nik': nik,
        'tgllahir': tgllahir,
        'alamat': alamat,
        'unitKerja': unitKerja,
        'noTelp': noTlp,
      }, merge: true),
    };
  }

  Future uploadAvatarAnak(String avatarURL, String typeUser) async {
    Firestore.instance.collection('PersonalData').document(uid).setData({
      'avatarURL': avatarURL,
    }, merge: true);
  }

  // USerdata from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      email: email,
      avatarURL: snapshot.data['avatarURL'] ?? '',
      nama: snapshot.data['nama'],
      nik: snapshot.data['nik'] ?? '',
      tgllahir: snapshot.data['tgllahir'] ?? '',
      namaAyah: snapshot.data['namaAyah'] ?? '',
      pekerjaanAyah: snapshot.data['pekerjaanAyah'] ?? '',
      namaIbu: snapshot.data['namaIbu'] ?? '',
      pekerjaanIbu: snapshot.data['pekerjaanIbu'] ?? '',
      alamat: snapshot.data['alamat'] ?? '',
      unitKerja: snapshot.data['unitKerja'] ?? '',
      noTlp: snapshot.data['noTelp'] ?? '',
    );
  }

  // list from Data PerkembanganAnak
  List<DataTumbuh> _listPerkembangan(QuerySnapshot snapshot) {
    return snapshot.documents.map((e) {
      return DataTumbuh(
          idMedis: e.data['idMedis'],
          nama: e.data['nama'],
          email: e.data['email'],
          tgllahir: e.data['tgllahir'],
          idPeserta: e.data['idPeserta'] ?? '',
          beratBadan: e.data['beratBadan'] ?? '',
          tinggiBadan: e.data['tinggiBadan'] ?? '',
          lingkarBadan: e.data['lingkarBadan'] ?? '',
          takeDate: e.data['take_date'].toDate(),
          documentID: e.documentID);
    }).toList();
  }

  //Get stream data PerkembanganAnak
  Stream<List<DataTumbuh>> dataPerkembangan(bool urutan, String typeUser) {
    return Firestore.instance
        .collection('DataTumbuh')
        // .orderBy('take_date', descending: urutan)
        .where(typeUser, isEqualTo: uid)
        .snapshots()
        .map(_listPerkembangan);
  }

  // list from Data PerkembanganAnak
  List<DataRiwayatImunisasi> _listRiwayatImunisasi(QuerySnapshot snapshot) {
    return snapshot.documents.map((e) {
      return DataRiwayatImunisasi(
          idMedis: e.data['idMedis'],
          nama: e.data['nama'],
          email: e.data['email'],
          tgllahir: e.data['tgllahir'],
          idPeserta: e.data['idPeserta'] ?? '',
          jenisVaksin: e.data['jenisVaksin'] ?? '',
          namaMedis: e.data['namaMedis'] ?? '',
          takeDate: e.data['take_date'].toDate(),
          documentID: e.documentID);
    }).toList();
  }

  //Get stream data PerkembanganAnak
  Stream<List<DataRiwayatImunisasi>> dataRiwayatImunisasi(String typeUser) {
    return Firestore.instance
        .collection('DataRiwayatImunisasi')
        .where(typeUser, isEqualTo: uid)
        // .orderBy('take_date', descending: urutan)
        .snapshots()
        .map(_listRiwayatImunisasi);
  }

  //Get Peltops Stream
  Stream<List<GetAllUser>> get allUserAnak {
    return Firestore.instance
        .collection('PersonalData')
        .where('typeUser', isEqualTo: 'anakCollection')
        .snapshots()
        .map(_listAllUserAnak);
  }

  // list from snapshot
  List<GetAllUser> _listAllUserAnak(QuerySnapshot snapshot) {
    return snapshot.documents.map((e) {
      return GetAllUser(
          email: e.data['email'] ?? '',
          nama: e.data['nama'] ?? '',
          tgllahir: e.data['tgllahir'] ?? '',
          documentID: e.documentID);
    }).toList();
  }

  // list from snapshot
  List<DataKalender> _listEventKalender(QuerySnapshot snapshot) {
    return snapshot.documents.map((e) {
      return DataKalender(
          id: e.data['id'] ?? '',
          title: e.data['title'] ?? '',
          description: e.data['description'] ?? '',
          eventDate: e.data['event_date'].toDate(),
          documentID: e.documentID);
    }).toList();
  }

  //Get Peltops Stream
  Stream<List<DataKalender>> get eventKalender {
    return Firestore.instance
        .collection('KalenderData')
        .snapshots()
        .map(_listEventKalender);
  }

  //get user doc stream
  Stream<UserData> userData(String typeUser) {
    return Firestore.instance
        .collection('PersonalData')
        .document(uid)
        .snapshots()
        .map(_userDataFromSnapshot);
  }

  TypeUser _typeUser(DocumentSnapshot snapshot) {
    return TypeUser(
      typeUser: snapshot.data['typeUser'],
    );
  }

  Stream<TypeUser> get typeUser {
    return Firestore.instance
        .collection('PersonalData')
        .document(uid)
        .snapshots()
        .map(_typeUser);
  }

  //Upload Image firebase Storage
  static Future<String> uploadImage(File imageFile) async {
    String fileName = basename(imageFile.path);
    StorageReference ref = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask task = ref.putFile(imageFile);
    StorageTaskSnapshot snapshot = await task.onComplete;

    return await snapshot.ref.getDownloadURL();
  }
}
