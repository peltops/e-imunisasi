part of 'local_auth_cubit.dart';

class LocalAuthState extends Equatable {
  const LocalAuthState({
    this.passcode = const Passcode.pure(),
    this.savedPasscode = const Passcode.pure(),
    this.confirmPasscode = '',
    this.status = FormzStatus.pure,
    this.errorMessage,
  });

  final Passcode savedPasscode;
  final Passcode passcode;
  final String confirmPasscode;
  final FormzStatus status;
  final String? errorMessage;

  @override
  List<Object> get props => [passcode, confirmPasscode, status];

  LocalAuthState copyWith({
    Passcode? savedPasscode,
    Passcode? passcode,
    String? confirmPasscode,
    FormzStatus? status,
    String? errorMessage,
  }) {
    return LocalAuthState(
      savedPasscode: savedPasscode ?? this.savedPasscode,
      passcode: passcode ?? this.passcode,
      confirmPasscode: confirmPasscode ?? this.confirmPasscode,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

// class LocalAuthInitial extends LocalAuthState {}

// class LocalAuthLoading extends LocalAuthState {}

// class LocalAuthPasscodeCreated extends LocalAuthState {
//   final int passcode;

//   const LocalAuthPasscodeCreated({required this.passcode});

//   @override
//   List<Object> get props => [passcode];
// }

// class LocalAuthPasscodeSucceeded extends LocalAuthState {
//   final int passcode;

//   const LocalAuthPasscodeSucceeded({required this.passcode});

//   @override
//   List<Object> get props => [passcode];
// }

// class LocalAuthPasscodeDestroyed extends LocalAuthState {}

// class LocalAuthPasscodeFailured extends LocalAuthState {
//   final String error;

//   const LocalAuthPasscodeFailured({required this.error});

//   @override
//   List<Object> get props => [error];
// }
