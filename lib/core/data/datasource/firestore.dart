import 'package:cloud_firestore/cloud_firestore.dart';

class FbRemote {
  final String collection;

  FbRemote({required this.collection});

  Future<List> get() async {
    List<QueryDocumentSnapshot> documents = [];

    try {
      await FirebaseFirestore.instance.collection(collection).orderBy('name').get(GetOptions(source: Source.cache)).then((QuerySnapshot querySnapshot) {
        documents = querySnapshot.docs;
        print('from cache');
      });
      if (documents.toString() == '[]') {
        await FirebaseFirestore.instance.collection(collection).orderBy('name').get(GetOptions(source: Source.server)).then((QuerySnapshot querySnapshot) {
          documents = querySnapshot.docs;
          print('from remote');
        });
      }
      return documents;
    } catch (_) {
      return [];
    }
  }
}
