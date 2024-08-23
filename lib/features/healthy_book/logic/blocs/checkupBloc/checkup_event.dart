part of 'checkup_bloc.dart';

abstract class CheckupEvent extends Equatable {
  const CheckupEvent();
}

class OnGetCheckupsEvent extends CheckupEvent {
  final String? childId;

  OnGetCheckupsEvent({this.childId});

  @override
  List<Object?> get props => [childId];
}
