import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:eimunisasi/core/utils/list_constant.dart';
import 'package:eimunisasi/features/profile/data/models/anak.dart';
import 'package:eimunisasi/features/profile/data/repositories/child_repository.dart';
import 'package:eimunisasi/features/profile/logic/blocs/childBloc/child_profile_bloc.dart';
import 'package:formz/formz.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'child_profile_bloc_test.mocks.dart';

@GenerateMocks([ChildRepository])
void main() {
  const id = 'id';
  const parentId = 'parentId';
  const name = 'name';
  const placeOfBirth = 'placeOfBirth';
  final dateOfBirth = DateTime(2021, 1, 1);
  const identityNumber = '1111111111111111';
  final bloodType = ListConstant.TYPE_BLOOD[0];
  final genderType = ListConstant.GENDER[0];

  final child = Anak(
    id: id,
    parentId: parentId,
    nama: name,
    tempatLahir: placeOfBirth,
    tanggalLahir: dateOfBirth,
    nik: identityNumber,
    golDarah: bloodType,
    jenisKelamin: genderType,
    photoURL: '',
  );

  group("OnInitialEvent", () {
    late ChildRepository mockChildRepository;
    setUp(() {
      mockChildRepository = MockChildRepository();
    });

    blocTest<ChildProfileBloc, ChildProfileState>(
      'OnInitialEvent',
      build: () => ChildProfileBloc(mockChildRepository),
      act: (bloc) => bloc.add(OnInitialEvent(child: child)),
      expect: () => [
        ChildProfileState(
          child: child,
        )
      ],
    );
  });

  group("OnGetChildrenEvent", () {
    late ChildRepository mockChildRepository;
    setUp(() {
      mockChildRepository = MockChildRepository();
    });

    blocTest<ChildProfileBloc, ChildProfileState>(
      "success",
      build: () {
        when(mockChildRepository.getAllChildren())
            .thenAnswer((_) async => [child]);
        return ChildProfileBloc(mockChildRepository);
      },
      act: (bloc) => bloc.add(OnGetChildrenEvent()),
      expect: () => [
        ChildProfileState(
          statusGetChildren: FormzStatus.submissionInProgress,
        ),
        ChildProfileState(
          statusGetChildren: FormzStatus.submissionSuccess,
          children: [child],
        )
      ],
    );

    blocTest<ChildProfileBloc, ChildProfileState>(
      "failed",
      build: () {
        when(mockChildRepository.getAllChildren()).thenThrow(Exception());
        return ChildProfileBloc(mockChildRepository);
      },
      act: (bloc) => bloc.add(OnGetChildrenEvent()),
      expect: () => [
        ChildProfileState(
          statusGetChildren: FormzStatus.submissionInProgress,
        ),
        ChildProfileState(
          statusGetChildren: FormzStatus.submissionFailure,
          errorMessage: 'Gagal memuat data anak',
        )
      ],
    );
  });

  group("OnChangeNameEvent", () {
    late ChildRepository mockChildRepository;
    setUp(() {
      mockChildRepository = MockChildRepository();
    });

    blocTest<ChildProfileBloc, ChildProfileState>(
      "success",
      build: () => ChildProfileBloc(mockChildRepository)
        ..add(OnInitialEvent(child: child)),
      act: (bloc) => bloc.add(OnChangeNameEvent(name)),
      expect: () => [
        ChildProfileState(
          child: child.copyWith(nama: name),
        )
      ],
    );
  });

  group("OnChangeIdentityNumberEvent", () {
    late ChildRepository mockChildRepository;
    setUp(() {
      mockChildRepository = MockChildRepository();
    });

    blocTest<ChildProfileBloc, ChildProfileState>(
      "success",
      build: () => ChildProfileBloc(mockChildRepository)
        ..add(OnInitialEvent(child: child)),
      act: (bloc) => bloc.add(OnChangeIdentityNumberEvent(identityNumber)),
      expect: () => [
        ChildProfileState(
          child: child.copyWith(nik: identityNumber),
        )
      ],
    );
  });

  group("OnChangePlaceOfBirthEvent", () {
    late ChildRepository mockChildRepository;
    setUp(() {
      mockChildRepository = MockChildRepository();
    });

    blocTest<ChildProfileBloc, ChildProfileState>(
      "success",
      build: () => ChildProfileBloc(mockChildRepository)
        ..add(OnInitialEvent(child: child)),
      act: (bloc) => bloc.add(OnChangePlaceOfBirthEvent(placeOfBirth)),
      expect: () => [
        ChildProfileState(
          child: child.copyWith(tempatLahir: placeOfBirth),
        )
      ],
    );
  });

  group("OnChangeDateOfBirthEvent", () {
    late ChildRepository mockChildRepository;
    setUp(() {
      mockChildRepository = MockChildRepository();
    });

    blocTest<ChildProfileBloc, ChildProfileState>(
      "success",
      build: () => ChildProfileBloc(mockChildRepository)
        ..add(OnInitialEvent(child: child)),
      act: (bloc) => bloc.add(OnChangeDateOfBirthEvent(dateOfBirth)),
      expect: () => [
        ChildProfileState(
          child: child.copyWith(tanggalLahir: dateOfBirth),
        )
      ],
    );
  });

  group("OnChangeGenderEvent", () {
    late ChildRepository mockChildRepository;
    setUp(() {
      mockChildRepository = MockChildRepository();
    });

    blocTest<ChildProfileBloc, ChildProfileState>(
      "success",
      build: () => ChildProfileBloc(mockChildRepository)
        ..add(OnInitialEvent(child: child)),
      act: (bloc) => bloc.add(OnChangeGenderEvent(genderType)),
      expect: () => [
        ChildProfileState(
          child: child.copyWith(jenisKelamin: genderType),
        )
      ],
    );
  });

  group("OnChangeBloodTypeEvent", () {
    late ChildRepository mockChildRepository;
    setUp(() {
      mockChildRepository = MockChildRepository();
    });

    blocTest<ChildProfileBloc, ChildProfileState>(
      "success",
      build: () => ChildProfileBloc(mockChildRepository)
        ..add(OnInitialEvent(child: child)),
      act: (bloc) => bloc.add(OnChangeBloodTypeEvent(bloodType)),
      expect: () => [
        ChildProfileState(
          child: child.copyWith(golDarah: bloodType),
        )
      ],
    );
  });

  group("OnUpdateChildEvent", () {
    late ChildRepository mockChildRepository;
    setUp(() {
      mockChildRepository = MockChildRepository();
    });

    blocTest<ChildProfileBloc, ChildProfileState>(
      "success",
      build: () {
        when(mockChildRepository.updateChild(child))
            .thenAnswer((_) async => null);
        when(mockChildRepository.getAllChildren())
            .thenAnswer((_) async => [child]);
        return ChildProfileBloc(mockChildRepository)
          ..add(OnInitialEvent(child: child));
      },
      act: (bloc) => bloc.add(UpdateProfileEvent()),
      expect: () => [
        ChildProfileState(
          statusUpdate: FormzStatus.pure,
          child: child,
        ),
        ChildProfileState(
          child: child,
          statusUpdate: FormzStatus.submissionInProgress,
        ),
        ChildProfileState(
          child: child,
          statusUpdate: FormzStatus.submissionSuccess,
        ),
        ChildProfileState(
          statusUpdate: FormzStatus.pure,
          child: child,
        ),
        ChildProfileState(
          child: child,
          statusGetChildren: FormzStatus.submissionInProgress,
        ),
        ChildProfileState(
          statusGetChildren: FormzStatus.submissionSuccess,
          children: [child],
          child: child,
        ),
      ],
    );

    blocTest<ChildProfileBloc, ChildProfileState>(
      "failed",
      build: () {
        when(mockChildRepository.updateChild(child)).thenThrow(Exception());
        return ChildProfileBloc(mockChildRepository);
      },
      act: (bloc) => bloc.add(UpdateProfileEvent()),
      expect: () => [
        ChildProfileState(
          statusUpdate: FormzStatus.submissionInProgress,
        ),
        ChildProfileState(
          statusUpdate: FormzStatus.submissionFailure,
          errorMessage: 'Gagal memperbarui profil anak',
        )
      ],
    );
  });

  group("OnCreateChildEvent", () {
    late ChildRepository mockChildRepository;
    setUp(() {
      mockChildRepository = MockChildRepository();
    });

    blocTest<ChildProfileBloc, ChildProfileState>(
      "success",
      build: () {
        when(mockChildRepository.setChild(child))
            .thenAnswer((_) async => child);
        when(mockChildRepository.getAllChildren())
            .thenAnswer((_) async => [child]);
        return ChildProfileBloc(mockChildRepository)
          ..add(OnInitialEvent(child: child));
      },
      act: (bloc) => bloc.add(CreateProfileEvent()),
      expect: () => [
        ChildProfileState(
          child: child,
        ),
        ChildProfileState(
          child: child,
          statusCreate: FormzStatus.submissionInProgress,
        ),
        ChildProfileState(
          child: child,
          statusCreate: FormzStatus.submissionSuccess,
        ),
        ChildProfileState(
          statusCreate: FormzStatus.pure,
          child: child,
        ),
        ChildProfileState(
          child: child,
          statusGetChildren: FormzStatus.submissionInProgress,
        ),
        ChildProfileState(
          statusGetChildren: FormzStatus.submissionSuccess,
          children: [child],
          child: child,
        ),
      ],
    );

    blocTest<ChildProfileBloc, ChildProfileState>(
      "failed",
      build: () {
        when(mockChildRepository.setChild(child)).thenThrow(Exception());
        return ChildProfileBloc(mockChildRepository);
      },
      act: (bloc) => bloc.add(CreateProfileEvent()),
      expect: () => [
        ChildProfileState(
          statusCreate: FormzStatus.submissionInProgress,
        ),
        ChildProfileState(
          statusCreate: FormzStatus.submissionFailure,
          errorMessage: 'Gagal membuat profil anak',
        )
      ],
    );
  });

  group("OnUpdateAvatar", () {
    late ChildRepository mockChildRepository;
    final file = File('test');
    final url = 'url';
    setUp(() {
      mockChildRepository = MockChildRepository();
    });

    blocTest<ChildProfileBloc, ChildProfileState>(
      "success",
      build: () {
        when(mockChildRepository.updateChildAvatar(file: file, id: id))
            .thenAnswer((_) async => url);
        when(mockChildRepository.getAllChildren())
            .thenAnswer((_) async => [child.copyWith(photoURL: url)]);
        return ChildProfileBloc(mockChildRepository)
          ..add(OnInitialEvent(child: child));
      },
      act: (bloc) => bloc.add(UpdateProfilePhotoEvent(photo: file, id: id)),
      expect: () => [
        ChildProfileState(
          child: child,
        ),
        ChildProfileState(
          child: child,
          statusUpdateAvatar: FormzStatus.submissionInProgress,
        ),
        ChildProfileState(
          child: child.copyWith(photoURL: url),
          statusUpdateAvatar: FormzStatus.submissionSuccess,
        ),
        ChildProfileState(
          child: child.copyWith(photoURL: url),
          statusUpdateAvatar: FormzStatus.pure,
        ),
        ChildProfileState(
          child: child.copyWith(photoURL: url),
          statusGetChildren: FormzStatus.submissionInProgress,
        ),
        ChildProfileState(
          statusGetChildren: FormzStatus.submissionSuccess,
          children: [child.copyWith(photoURL: url)],
          child: child.copyWith(photoURL: url),
        ),
      ],
    );

    blocTest<ChildProfileBloc, ChildProfileState>(
      "failed",
      build: () {
        when(mockChildRepository.updateChildAvatar(file: file, id: id))
            .thenThrow(Exception());
        return ChildProfileBloc(mockChildRepository);
      },
      act: (bloc) => bloc.add(UpdateProfilePhotoEvent(photo: file, id: id)),
      expect: () => [
        ChildProfileState(
          statusUpdateAvatar: FormzStatus.submissionInProgress,
        ),
        ChildProfileState(
          statusUpdateAvatar: FormzStatus.submissionFailure,
          errorMessage: 'Gagal memperbarui foto profil anak',
        ),
      ],
    );
  });
}
