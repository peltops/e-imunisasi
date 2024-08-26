import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:eimunisasi/core/utils/constant.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/models/passcode.dart';

part 'local_auth_state.dart';

@Injectable()
class LocalAuthCubit extends Cubit<LocalAuthState> {
  final SharedPreferences sharedPreferences;
  LocalAuthCubit(
    this.sharedPreferences,
  ) : super(const LocalAuthState());

  void passcodeChanged(String value) {
    final code = Passcode.dirty(value);
    emit(state.copyWith(
      passcode: code,
    ));
  }

  void passcodeConfirmChanged(String value) {
    final codeConfirm = Passcode.dirty(value);
    emit(
      state.copyWith(
        confirmPasscode: codeConfirm,
      ),
    );
  }

  void _setPasscode(int passcode) async {
    if (state.passcode.isNotValid || state.confirmPasscode.isNotValid) {
      return emit(
        state.copyWith(
          errorMessage: 'Silahkan isi PIN',
          status: FormzSubmissionStatus.failure,
        ),
      );
    }
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await sharedPreferences.setInt('passCode', passcode);
      final code = Passcode.dirty(passcode.toString());
      emit(
        state.copyWith(
          passcode: code,
          status: FormzSubmissionStatus.success,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          errorMessage: 'Gagal menyimpan passcode',
          status: FormzSubmissionStatus.failure,
        ),
      );
    }
  }

  void getPasscode() async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      int? passcode = sharedPreferences.getInt('passCode');
      debugPrint("**************" + passcode.toString());
      final code = Passcode.dirty(passcode.toString());
      emit(
        state.copyWith(
          savedPasscode: code,
          status: FormzSubmissionStatus.success,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
            errorMessage: 'Gagal mendapatkan passcode',
            status: FormzSubmissionStatus.failure),
      );
    }
  }

  void checkPasscode(String passcode) async {
    if (passcode.isEmpty) {
      return emit(state.copyWith(
          errorMessage: 'Silahkan isi PIN',
          status: FormzSubmissionStatus.failure));
    }
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      int? savedPasscode = sharedPreferences.getInt('passCode');
      debugPrint("**************" + savedPasscode.toString());
      if (savedPasscode == int.parse(passcode)) {
        emit(state.copyWith(status: FormzSubmissionStatus.success));
      } else {
        emit(state.copyWith(
            errorMessage: AppConstant.WRONG_PASSWORD,
            status: FormzSubmissionStatus.failure));
      }
    } catch (e) {
      log('Error Passcode: $e');
      emit(state.copyWith(
          errorMessage: 'Terjadi Kesalahan',
          status: FormzSubmissionStatus.failure));
    }
  }

  void confirmPasscode() async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    final String passcode = state.passcode.value;
    final String confirmPasscode = state.confirmPasscode.value;
    if (passcode == confirmPasscode) {
      _setPasscode(int.parse(passcode));
    } else {
      emit(
        state.copyWith(
          errorMessage: AppConstant.WRONG_PASSCODE,
          status: FormzSubmissionStatus.failure,
        ),
      );
    }
  }

  void destroyPasscode() async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await sharedPreferences.remove('passCode');
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          errorMessage: 'Gagal menghapus passcode',
          status: FormzSubmissionStatus.failure,
        ),
      );
    }
  }
}
