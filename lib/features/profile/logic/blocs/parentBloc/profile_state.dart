part of 'profile_bloc.dart';

class ProfileState extends Equatable {
  const ProfileState({
    this.user,
    this.statusGet = FormzStatus.pure,
    this.statusUpdate = FormzStatus.pure,
    this.statusUpdateAvatar = FormzStatus.pure,
    this.errorMessage,
  });

  final Users? user;
  final FormzStatus statusGet;
  final FormzStatus statusUpdate;
  final FormzStatus statusUpdateAvatar;
  final String? errorMessage;

  ProfileState copyWith({
    Users? user,
    FormzStatus? statusGet,
    FormzStatus? statusUpdate,
    FormzStatus? statusUpdateAvatar,
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
