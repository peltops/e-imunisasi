part of 'child_profile_bloc.dart';

class ChildProfileState extends Equatable {
  const ChildProfileState({
    this.child,
    this.statusGet = FormzStatus.pure,
    this.statusUpdate = FormzStatus.pure,
    this.statusCreate = FormzStatus.pure,
    this.statusUpdateAvatar = FormzStatus.pure,
    this.errorMessage,
  });

  final Anak? child;
  final FormzStatus statusGet;
  final FormzStatus statusUpdate;
  final FormzStatus statusCreate;
  final FormzStatus statusUpdateAvatar;
  final String? errorMessage;

  ChildProfileState copyWith({
    Anak? child,
    FormzStatus? statusGet,
    FormzStatus? statusUpdate,
    FormzStatus? statusCreate,
    FormzStatus? statusUpdateAvatar,
    String? errorMessage,
  }) {
    return ChildProfileState(
      child: child ?? this.child,
      statusGet: statusGet ?? this.statusGet,
      statusUpdate: statusUpdate ?? this.statusUpdate,
      statusCreate: statusCreate ?? this.statusCreate,
      statusUpdateAvatar: statusUpdateAvatar ?? this.statusUpdateAvatar,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    child,
    statusGet,
    statusUpdate,
    statusCreate,
    statusUpdateAvatar,
    errorMessage,
  ];
}
