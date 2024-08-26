import 'package:bloc_test/bloc_test.dart';
import 'package:eimunisasi/features/healthy_book/data/models/checkup_model.dart';
import 'package:eimunisasi/features/healthy_book/data/repositories/checkup_repository.dart';
import 'package:eimunisasi/features/healthy_book/logic/blocs/checkupBloc/checkup_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'checkup_bloc_test.mocks.dart';

@GenerateMocks([CheckupRepository])
@GenerateNiceMocks([MockSpec<CheckupModel>()])
void main() {
  late CheckupRepository mockCheckupRepository;
  late CheckupModel mockCheckupModel;

  setUp(() {
    mockCheckupRepository = MockCheckupRepository();
    mockCheckupModel = MockCheckupModel();
  });

  blocTest<CheckupBloc, CheckupState>(
    "CheckupBloc on get checkups emit success",
    setUp: () {
      when(mockCheckupRepository.getCheckups(
        any,
      )).thenAnswer((_) async => [
            mockCheckupModel,
          ]);
    },
    build: () => CheckupBloc(
      mockCheckupRepository,
    ),
    act: (bloc) => bloc.add(OnGetCheckupsEvent()),
    expect: () => [
      CheckupState(statusGet: FormzSubmissionStatus.inProgress),
      CheckupState(
          statusGet: FormzSubmissionStatus.success,
          checkups: [mockCheckupModel]),
    ],
  );

  blocTest<CheckupBloc, CheckupState>(
    "CheckupBloc on get checkups emit failure",
    setUp: () {
      when(mockCheckupRepository.getCheckups(
        any,
      )).thenThrow(Exception());
    },
    build: () => CheckupBloc(
      mockCheckupRepository,
    ),
    act: (bloc) => bloc.add(OnGetCheckupsEvent()),
    expect: () => [
      CheckupState(statusGet: FormzSubmissionStatus.inProgress),
      CheckupState(
          statusGet: FormzSubmissionStatus.failure, errorMessage: "Exception"),
    ],
  );
}
