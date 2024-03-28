part of 'checkup_bloc.dart';

class CheckupState extends Equatable {
  const CheckupState({
    this.statusGet = FormzStatus.pure,
    this.errorMessage,
    this.checkups = const [],
  });

  final FormzStatus statusGet;
  final String? errorMessage;
  final List<CheckupModel> checkups;

  CheckupState copyWith({
    FormzStatus? statusGet,
    String? errorMessage,
    List<CheckupModel>? checkups,
  }) {
    return CheckupState(
      statusGet: statusGet ?? this.statusGet,
      errorMessage: errorMessage ?? this.errorMessage,
      checkups: checkups ?? this.checkups,
    );
  }

  @override
  List<Object?> get props => [
    statusGet,
    errorMessage,
    checkups,
  ];
}

