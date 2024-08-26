part of 'child_profile_bloc.dart';

class ChildProfileState extends Equatable {
  const ChildProfileState({
    this.children,
    this.child,
    this.statusGetChildren = FormzSubmissionStatus.initial,
    this.statusGet = FormzSubmissionStatus.initial,
    this.statusUpdate = FormzSubmissionStatus.initial,
    this.statusCreate = FormzSubmissionStatus.initial,
    this.statusUpdateAvatar = FormzSubmissionStatus.initial,
    this.errorMessage,
  });

  final List<Anak>? children;
  final Anak? child;
  final FormzSubmissionStatus statusGetChildren;
  final FormzSubmissionStatus statusGet;
  final FormzSubmissionStatus statusUpdate;
  final FormzSubmissionStatus statusCreate;
  final FormzSubmissionStatus statusUpdateAvatar;
  final String? errorMessage;

  ChildProfileState copyWith({
    List<Anak>? children,
    Anak? child,
    FormzSubmissionStatus? statusGetChildren,
    FormzSubmissionStatus? statusGet,
    FormzSubmissionStatus? statusUpdate,
    FormzSubmissionStatus? statusCreate,
    FormzSubmissionStatus? statusUpdateAvatar,
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
