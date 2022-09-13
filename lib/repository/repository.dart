import 'package:cloud_firestore/cloud_firestore.dart';

class Repository {
  static Future update({
    required Map<String, dynamic> values,
    required String table,
    required String conditionParameter,
    required var conditionValue,
  }) async {
    var post = await FirebaseFirestore.instance
        .collection(table)
        .where(
          conditionParameter,
          isEqualTo: conditionValue,
        )
        .limit(1)
        .get()
        .then((
      QuerySnapshot snapshot,
    ) {
      //Here we get the document reference and return to the post variable.
      return snapshot.docs[0].reference;
    });
    var batch = FirebaseFirestore.instance.batch();
    batch.update(post, values);
    batch.commit();
    return post;
  }

  /**/ static Future insert({
    required Map<String, dynamic> values,
    required String table,
  }) async {
    final currentTime = DateTime.now();
    var data = await FirebaseFirestore.instance.collection(table).add(values).then((value) {
      print('UI************');
      print(value.id);
    });

    return data;
  }
}
