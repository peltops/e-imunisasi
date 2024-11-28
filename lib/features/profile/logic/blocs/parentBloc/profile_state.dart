part of 'profile_bloc.dart';

class ProfileState extends Equatable {
  const ProfileState({
    this.user,
    this.statusGet = FormzSubmissionStatus.initial,
    this.statusUpdate = FormzSubmissionStatus.initial,
    this.statusUpdateAvatar = FormzSubmissionStatus.initial,
    this.errorMessage,
  });

  final UserProfile? user;
  final FormzSubmissionStatus statusGet;
  final FormzSubmissionStatus statusUpdate;
  final FormzSubmissionStatus statusUpdateAvatar;
  final String? errorMessage;

  ProfileState copyWith({
    UserProfile? user,
    FormzSubmissionStatus? statusGet,
    FormzSubmissionStatus? statusUpdate,
    FormzSubmissionStatus? statusUpdateAvatar,
    String? errorMessage,
  }) {
    return ProfileState(
      user: user ?? this.user,
      statusGet: statusGet ?? this.statusGet,
      statusUpdate: statusUpdate ?? this.statusUpdate,
      statusUpdateAvatar: statusUpdateAvatar ?? this.statusUpdateAvatar,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        user,
        statusGet,
        statusUpdate,
        statusUpdateAvatar,
        errorMessage,
      ];
}
