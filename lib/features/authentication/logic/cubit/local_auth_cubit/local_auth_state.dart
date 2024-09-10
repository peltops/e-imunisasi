part of 'local_auth_cubit.dart';

class LocalAuthState extends Equatable {
  const LocalAuthState({
    this.passcode = const Passcode.initial(),
    this.savedPasscode = const Passcode.initial(),
    this.confirmPasscode = const Passcode.initial(),
    this.statusGet = FormzSubmissionStatus.initial,
    this.statusSet = FormzSubmissionStatus.initial,
    this.statusDelete = FormzSubmissionStatus.initial,
    this.errorMessage,
  });

  final Passcode savedPasscode;
  final Passcode passcode;
  final Passcode confirmPasscode;
  final FormzSubmissionStatus statusGet;
  final FormzSubmissionStatus statusSet;
  final FormzSubmissionStatus statusDelete;
  final String? errorMessage;

  @override
  List<Object?> get props => [
        passcode,
        confirmPasscode,
        statusGet,
        statusSet,
        statusDelete,
        errorMessage,
      ];

  LocalAuthState copyWith({
    Passcode? savedPasscode,
    Passcode? passcode,
    Passcode? confirmPasscode,
    FormzSubmissionStatus? statusGet,
    FormzSubmissionStatus? statusSet,
    FormzSubmissionStatus? statusDelete,
    String? errorMessage,
  }) {
    return LocalAuthState(
      savedPasscode: savedPasscode ?? this.savedPasscode,
      passcode: passcode ?? this.passcode,
      confirmPasscode: confirmPasscode ?? this.confirmPasscode,
      statusGet: statusGet ?? this.statusGet,
      statusSet: statusSet ?? this.statusSet,
      statusDelete: statusDelete ?? this.statusDelete,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
