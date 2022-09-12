import 'package:mylockery/locker_app/model/locker_model.dart';


abstract class BaseLockerRepository {
  Future<List<LockerModel>> getAllLoker();
}
