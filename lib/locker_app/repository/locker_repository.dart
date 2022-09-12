import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mylockery/locker_app/model/locker_model.dart';
import 'package:mylockery/locker_app/repository/base_locker_repository.dart';


class LockerRepository extends BaseLockerRepository {
  final FirebaseFirestore _firebaseFirestore;
  LockerRepository({
    FirebaseFirestore? firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;
/*   @override
  Stream<List<LockerModel>> getAllLoker() {
    return _firebaseFirestore.collection('locker_list').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => LockerModel.fromSnapshot(doc)).toList();
    });
  } */

  @override
  Future<List<LockerModel>> getAllLoker() async {
    List<LockerModel> lockerList = [];
    try {
      final list = await _firebaseFirestore.collection('locker_list').get();
      list.docs.forEach((element) {
        print(element.data());
        return lockerList.add(LockerModel.fromJson(element.data()));
      });
      print("*****************OK");
      return lockerList;
    } on FirebaseException catch (e) {
      print(e.code);
    } catch (e) {
      print(e);
    }
    return lockerList;
  }
}
