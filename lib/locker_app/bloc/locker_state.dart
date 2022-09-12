part of 'locker_bloc.dart';

@immutable
abstract class LockerState {}

class LockerLoading extends LockerState {}

class LokerLoaded extends LockerState {
  final List<LockerModel> lockers;
  LokerLoaded({required this.lockers});
  List<Object> get props => [lockers];
}

class LockerInitial extends LockerState {}
