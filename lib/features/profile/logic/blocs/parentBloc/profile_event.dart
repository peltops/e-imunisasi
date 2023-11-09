part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class ProfileGetEvent extends ProfileEvent {}

class ProfileUpdateEvent extends ProfileEvent {
  ProfileUpdateEvent();

  @override
  List<Object> get props => [];
}

class ProfileUpdateAvatarEvent extends ProfileEvent {
  final File file;

  ProfileUpdateAvatarEvent(this.file);

  @override
  List<Object> get props => [file];
}

class OnChangeNameEvent extends ProfileEvent {
  final String name;

  OnChangeNameEvent(this.name);

  @override
  List<Object> get props => [name];
}

class OnChangePlaceOfBirthEvent extends ProfileEvent {
  final String placeOfBirth;

  OnChangePlaceOfBirthEvent(this.placeOfBirth);

  @override
  List<Object> get props => [placeOfBirth];
}

class OnChangeDateOfBirthEvent extends ProfileEvent {
  final DateTime dateOfBirth;

  OnChangeDateOfBirthEvent(this.dateOfBirth);

  @override
  List<Object> get props => [dateOfBirth];
}

class OnChangeIdentityNumberEvent extends ProfileEvent {
  final String identityNumber;

  OnChangeIdentityNumberEvent(this.identityNumber);

  @override
  List<Object> get props => [identityNumber];
}

class OnChangeFamilyCardNumberEvent extends ProfileEvent {
  final String familyCardNumber;

  OnChangeFamilyCardNumberEvent(this.familyCardNumber);

  @override
  List<Object> get props => [familyCardNumber];
}

class OnChangeJobEvent extends ProfileEvent {
  final String job;

  OnChangeJobEvent(this.job);

  @override
  List<Object> get props => [job];
}

class OnChangeBloodTypeEvent extends ProfileEvent {
  final String bloodType;

  OnChangeBloodTypeEvent(this.bloodType);

  @override
  List<Object> get props => [bloodType];
}

class VerifyEmailEvent extends ProfileEvent {
  VerifyEmailEvent();

  @override
  List<Object> get props => [];
}
