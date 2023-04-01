import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class FirestoreData with ChangeNotifier {
  CollectionReference<Map<String, dynamic>> getCollection(String collection) {
    return FirebaseFirestore.instance.collection(collection);
    notifyListeners();
  }
}
