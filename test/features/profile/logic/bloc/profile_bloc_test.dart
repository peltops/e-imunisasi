import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:eimunisasi/core/utils/list_constant.dart';
import 'package:eimunisasi/features/authentication/data/models/user.dart';
import 'package:eimunisasi/features/authentication/data/repositories/auth_repository.dart';
import 'package:eimunisasi/features/profile/logic/blocs/parentBloc/profile_bloc.dart';
import 'package:formz/formz.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'profile_bloc_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {

  const momName = 'momName';
  const placeOfBirth = 'placeOfBirth';
  final dateOfBirth = DateTime(2021, 1, 1);
  const identityNumber = '1111111111111111';
  const familyCardNumber = '2222222222222222';
  final job = ListConstant.JOB[0];
  final bloodType = ListConstant.TYPE_BLOOD[0];

  final user = Users(
    momName: momName,
    tempatLahir: placeOfBirth,
    tanggalLahir: dateOfBirth,
    noKTP: identityNumber,
    noKK: familyCardNumber,
    pekerjaanIbu: job,
    golDarahIbu: bloodType,
  );

  group("OnChangeFieldEvent", () {
    late AuthRepository mockAuthRepository;
    setUp(() {
      mockAuthRepository = MockAuthRepository();
    });

    final ProfileState initialState = ProfileState(
      statusGet: FormzStatus.pure,
      statusUpdate: FormzStatus.pure,
    );

    blocTest<ProfileBloc, ProfileState>(
      'OnChangeNameEvent Success',
      build: () => ProfileBloc(mockAuthRepository),
      act: (bloc) => bloc.add(OnChangeNameEvent(momName)),
      expect: () => [
        initialState.copyWith(
          user: initialState.user?.copyWith(
            momName: momName,
          ),
        ),
      ],
    );

    blocTest<ProfileBloc, ProfileState>(
      'OnChangePlaceOfBirthEvent Success',
      build: () => ProfileBloc(mockAuthRepository),
      act: (bloc) => bloc.add(OnChangePlaceOfBirthEvent(placeOfBirth)),
      expect: () => [
        initialState.copyWith(
          user: initialState.user?.copyWith(
            tempatLahir: placeOfBirth,
          ),
        ),
      ],
    );

    blocTest<ProfileBloc, ProfileState>(
      'OnChangeDateOfBirthEvent Success',
      build: () => ProfileBloc(mockAuthRepository),
      act: (bloc) => bloc.add(OnChangeDateOfBirthEvent(dateOfBirth)),
      expect: () => [
        initialState.copyWith(
          user: initialState.user?.copyWith(
            tanggalLahir: dateOfBirth,
          ),
        ),
      ],
    );

    blocTest<ProfileBloc, ProfileState>(
      'OnChangeIdentityNumberEvent Success',
      build: () => ProfileBloc(mockAuthRepository),
      act: (bloc) => bloc.add(OnChangeIdentityNumberEvent(identityNumber)),
      expect: () => [
        initialState.copyWith(
          user: initialState.user?.copyWith(
            noKTP: identityNumber,
          ),
        ),
      ],
    );

    blocTest<ProfileBloc, ProfileState>(
      'OnChangeFamilyCardNumberEvent Success',
      build: () => ProfileBloc(mockAuthRepository),
      act: (bloc) => bloc.add(OnChangeFamilyCardNumberEvent(familyCardNumber)),
      expect: () => [
        initialState.copyWith(
          user: initialState.user?.copyWith(
            noKK: familyCardNumber,
          ),
        ),
      ],
    );

    blocTest<ProfileBloc, ProfileState>(
      'OnChangeJobEvent Success',
      build: () => ProfileBloc(mockAuthRepository),
      act: (bloc) => bloc.add(OnChangeJobEvent(job)),
      expect: () => [
        initialState.copyWith(
          user: initialState.user?.copyWith(
            pekerjaanIbu: job,
          ),
        ),
      ],
    );

    blocTest<ProfileBloc, ProfileState>(
      'OnChangeBloodTypeEvent Success',
      build: () => ProfileBloc(mockAuthRepository),
      act: (bloc) => bloc.add(OnChangeBloodTypeEvent(bloodType)),
      expect: () => [
        initialState.copyWith(
          user: initialState.user?.copyWith(
            golDarahIbu: bloodType,
          ),
        ),
      ],
    );
  });


  group("OnProfileGetEvent", (){
    late AuthRepository mockAuthRepository;
    setUp(() {
      mockAuthRepository = MockAuthRepository();
    });

    blocTest<ProfileBloc,ProfileState>("success",
      build: () {
        when(mockAuthRepository.getUser()).thenAnswer((_) async => user);
        return ProfileBloc(mockAuthRepository);
      },
      act: (bloc) => bloc.add(ProfileGetEvent()),
      expect: () => [
        ProfileState(
          statusGet: FormzStatus.submissionInProgress,
        ),
        ProfileState(
          user: user,
          statusGet: FormzStatus.submissionSuccess,
        )
      ],
    );

    blocTest<ProfileBloc,ProfileState>("failed",
      build: () {
        when(mockAuthRepository.getUser()).thenThrow(Exception());
        return ProfileBloc(mockAuthRepository);
      },
      act: (bloc) => bloc.add(ProfileGetEvent()),
      expect: () => [
        ProfileState(
          statusGet: FormzStatus.submissionInProgress,
        ),
        ProfileState(
          statusGet: FormzStatus.submissionFailure,
        )
      ],
    );
  });

  group("ProfileUpdateEvent", (){
    late AuthRepository mockAuthRepository;
    setUp(() {
      mockAuthRepository = MockAuthRepository();
    });

    blocTest<ProfileBloc,ProfileState>("success",
      build: () {
        when(mockAuthRepository.insertUserToDatabase(user: user)).thenAnswer((_) async => true);
        return ProfileBloc(mockAuthRepository);
      },
      seed: () => ProfileState(user: user),
      act: (bloc) => bloc.add(ProfileUpdateEvent()),
      expect: () => [
        ProfileState(
          user: user,
          statusUpdate: FormzStatus.submissionInProgress,
        ),
        ProfileState(
          user: user,
          statusUpdate: FormzStatus.submissionSuccess,
        )
      ],
    );

    blocTest<ProfileBloc,ProfileState>("failed",
      build: () {
        when(mockAuthRepository.insertUserToDatabase(user: user)).thenThrow(Exception());
        return ProfileBloc(mockAuthRepository);
      },
      seed: () => ProfileState(user: user),
      act: (bloc) => bloc.add(ProfileUpdateEvent()),
      expect: () => [
        ProfileState(
          user: user,
          statusUpdate: FormzStatus.submissionInProgress,
        ),
        ProfileState(
          user: user,
          statusUpdate: FormzStatus.submissionFailure,
        )
      ],
    );
  });

  group("ProfileUpdateAvatarEvent", (){
    late AuthRepository mockAuthRepository;

    final File file = File('test');
    final String url = 'url';

    setUp(() {
      mockAuthRepository = MockAuthRepository();
    });

    blocTest<ProfileBloc,ProfileState>("success",
      build: () {
        when(mockAuthRepository.uploadImage(file)).thenAnswer((_) async => url);
        when(mockAuthRepository.updateUserAvatar(url)).thenAnswer((_) async => true);
        when(mockAuthRepository.getUser()).thenAnswer((_) async => user);
        return ProfileBloc(mockAuthRepository);
      },
      act: (bloc) => bloc.add(ProfileUpdateAvatarEvent(file)),
      expect: () => [
        ProfileState(
          statusUpdateAvatar: FormzStatus.submissionInProgress,
        ),
        ProfileState(
          statusUpdateAvatar: FormzStatus.submissionSuccess,
        ),
        ProfileState(
          statusGet: FormzStatus.submissionInProgress,
          statusUpdateAvatar: FormzStatus.submissionSuccess,
        ),
        ProfileState(
          user: user,
          statusGet: FormzStatus.submissionSuccess,
          statusUpdateAvatar: FormzStatus.submissionSuccess,
        )
      ],
    );

    blocTest<ProfileBloc,ProfileState>("failed uploadImage",
      build: () {
        when(mockAuthRepository.uploadImage(file)).thenThrow(Exception());
        return ProfileBloc(mockAuthRepository);
      },
      act: (bloc) => bloc.add(ProfileUpdateAvatarEvent(file)),
      expect: () => [
        ProfileState(
          statusUpdateAvatar: FormzStatus.submissionInProgress,
        ),
        ProfileState(
          statusUpdateAvatar: FormzStatus.submissionFailure,
        )
      ],
    );

    blocTest<ProfileBloc,ProfileState>("failed updateUserAvatar",
      build: () {
        when(mockAuthRepository.uploadImage(file)).thenAnswer((_) async => url);
        when(mockAuthRepository.updateUserAvatar(url)).thenThrow(Exception());
        return ProfileBloc(mockAuthRepository);
      },
      act: (bloc) => bloc.add(ProfileUpdateAvatarEvent(file)),
      expect: () => [
        ProfileState(
          statusUpdateAvatar: FormzStatus.submissionInProgress,
        ),
        ProfileState(
          statusUpdateAvatar: FormzStatus.submissionFailure,
        )
      ],
    );
  });

  group('VerifyEmailEvent', (){
    late AuthRepository mockAuthRepository;
    setUp(() {
      mockAuthRepository = MockAuthRepository();
    });

    blocTest<ProfileBloc,ProfileState>("success",
      build: () {
        when(mockAuthRepository.verifyEmail()).thenAnswer((_) async => true);
        return ProfileBloc(mockAuthRepository);
      },
      act: (bloc) => bloc.add(VerifyEmailEvent()),
      expect: () => [
        ProfileState(
          statusUpdate: FormzStatus.submissionInProgress,
        ),
        ProfileState(
          statusUpdate: FormzStatus.submissionSuccess,
        )
      ],
    );

    blocTest<ProfileBloc,ProfileState>("failed",
      build: () {
        when(mockAuthRepository.verifyEmail()).thenThrow(Exception());
        return ProfileBloc(mockAuthRepository);
      },
      act: (bloc) => bloc.add(VerifyEmailEvent()),
      expect: () => [
        ProfileState(
          statusUpdate: FormzStatus.submissionInProgress,
        ),
        ProfileState(
          statusUpdate: FormzStatus.submissionFailure,
        )
      ],
    );
  });
}
