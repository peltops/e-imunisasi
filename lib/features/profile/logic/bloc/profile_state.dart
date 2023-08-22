part of 'profile_bloc.dart';

class ProfileState extends Equatable {
  const ProfileState({
    this.user,
    this.statusGet = FormzStatus.pure,
    this.statusUpdate = FormzStatus.pure,
    this.errorMessage,
  });

  final Users? user;
  final FormzStatus statusGet;
  final FormzStatus statusUpdate;
  final String? errorMessage;

  ProfileState copyWith({
    Users? user,
    FormzStatus? status,
    String? errorMessage,
  }) {
    return ProfileState(
      user: user ?? this.user,
      statusGet: status ?? this.statusGet,
      statusUpdate: status ?? this.statusUpdate,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [];
}
