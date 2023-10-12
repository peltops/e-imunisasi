part of 'child_profile_bloc.dart';

class ChildProfileState extends Equatable {
  const ChildProfileState({
    this.children,
    this.child,
    this.statusGetChildren = FormzStatus.pure,
    this.statusGet = FormzStatus.pure,
    this.statusUpdate = FormzStatus.pure,
    this.statusCreate = FormzStatus.pure,
    this.statusUpdateAvatar = FormzStatus.pure,
    this.errorMessage,
  });

  final List<Anak>? children;
  final Anak? child;
  final FormzStatus statusGetChildren;
  final FormzStatus statusGet;
  final FormzStatus statusUpdate;
  final FormzStatus statusCreate;
  final FormzStatus statusUpdateAvatar;
  final String? errorMessage;

  ChildProfileState copyWith({
    List<Anak>? children,
    Anak? child,
    FormzStatus? statusGetChildren,
    FormzStatus? statusGet,
    FormzStatus? statusUpdate,
    FormzStatus? statusCreate,
    FormzStatus? statusUpdateAvatar,
    String? errorMessage,
  }) {
    return ChildProfileState(
      children: children ?? this.children,
      child: child ?? this.child,
      statusGetChildren: statusGetChildren ?? this.statusGetChildren,
      statusGet: statusGet ?? this.statusGet,
      statusUpdate: statusUpdate ?? this.statusUpdate,
      statusCreate: statusCreate ?? this.statusCreate,
      statusUpdateAvatar: statusUpdateAvatar ?? this.statusUpdateAvatar,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        children,
        child,
        statusGetChildren,
        statusGet,
        statusUpdate,
        statusCreate,
        statusUpdateAvatar,
        errorMessage,
      ];
}
