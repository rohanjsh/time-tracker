import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirestoreService {
  FirestoreService._();
  static final instance = FirestoreService._();
  Future<void> setData({String path, Map<String, dynamic> data}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    print('$path : $data');
    await reference.set(data);
  }

  Stream<List<T>> collectionStream<T>({
    @required String path,
    @required T Function(Map<String, dynamic> data) builder,
  }) {
    final reference = FirebaseFirestore.instance.collection(path);
    final snapshot = reference.snapshots(); //returns streams

    //factory data used
    return snapshot.map(
      (event) => event.docs
          .map(
            (e) => builder(
              e.data(),
            ),
          )
          .toList(),
    );
  }
}