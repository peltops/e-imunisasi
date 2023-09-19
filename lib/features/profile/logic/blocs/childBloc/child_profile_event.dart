part of 'child_profile_bloc.dart';

abstract class ChildProfileEvent extends Equatable {
  const ChildProfileEvent();
}

class OnChangeNameEvent extends ChildProfileEvent {
  final String name;

  OnChangeNameEvent(this.name);

  @override
  List<Object> get props => [name];
}

class OnChangeIdentityNumberEvent extends ChildProfileEvent {
  final String identityNumber;

  OnChangeIdentityNumberEvent(this.identityNumber);

  @override
  List<Object> get props => [identityNumber];
}

class OnChangePlaceOfBirthEvent extends ChildProfileEvent {
  final String placeOfBirth;

  OnChangePlaceOfBirthEvent(this.placeOfBirth);

  @override
  List<Object> get props => [placeOfBirth];
}

class OnChangeDateOfBirthEvent extends ChildProfileEvent {
  final DateTime dateOfBirth;

  OnChangeDateOfBirthEvent(this.dateOfBirth);

  @override
  List<Object> get props => [dateOfBirth];
}

class OnChangeGenderEvent extends ChildProfileEvent {
  final String gender;

  OnChangeGenderEvent(this.gender);

  @override
  List<Object> get props => [gender];
}

class OnChangeBloodTypeEvent extends ChildProfileEvent {
  final String bloodType;

  OnChangeBloodTypeEvent(this.bloodType);

  @override
  List<Object> get props => [bloodType];
}

class UpdateProfileEvent extends ChildProfileEvent {
  UpdateProfileEvent();

  @override
  List<Object> get props => [];
}

class CreateProfileEvent extends ChildProfileEvent {
  CreateProfileEvent();

  @override
  List<Object> get props => [];
}

class UpdateProfilePhotoEvent extends ChildProfileEvent {
  final String id;
  final File photo;

  UpdateProfilePhotoEvent({
    required this.photo,
    required this.id,
  });

  @override
  List<Object> get props => [photo];
}
