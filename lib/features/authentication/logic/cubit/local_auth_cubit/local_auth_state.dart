part of 'local_auth_cubit.dart';

class LocalAuthState extends Equatable {
  const LocalAuthState({
    this.passcode = const Passcode.initial(),
    this.savedPasscode = const Passcode.initial(),
    this.confirmPasscode = const Passcode.initial(),
    this.status = FormzSubmissionStatus.initial,
    this.errorMessage,
  });

  final Passcode savedPasscode;
  final Passcode passcode;
  final Passcode confirmPasscode;
  final FormzSubmissionStatus status;
  final String? errorMessage;

  @override
  List<Object?> get props =>
      [passcode, confirmPasscode, status, errorMessage];

  LocalAuthState copyWith({
    Passcode? savedPasscode,
    Passcode? passcode,
    Passcode? confirmPasscode,
    FormzSubmissionStatus? status,
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
