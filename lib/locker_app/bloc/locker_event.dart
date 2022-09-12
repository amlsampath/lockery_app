part of 'locker_bloc.dart';

@immutable
abstract class LockerEvent {}

class LoadLocker extends LockerEvent {}

class UpdateLocker extends LockerEvent {
  final List<LockerModel> locker;
  UpdateLocker({required this.locker});
  List<Object> get props => [locker];
}
