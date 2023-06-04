import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/models/passcode.dart';

part 'local_auth_state.dart';

@Injectable()
class LocalAuthCubit extends Cubit<LocalAuthState> {
  LocalAuthCubit() : super(const LocalAuthState());

  void passcodeChanged(String value) {
    final code = Passcode.dirty(value);
    emit(state.copyWith(
      passcode: code,
      status: Formz.validate([code]),
    ));
  }

  void passcodeConfirmChanged(String value) {
    emit(
      state.copyWith(
        confirmPasscode: value,
        status: value == state.passcode.value
            ? FormzStatus.valid
            : FormzStatus.invalid,
      ),
    );
  }

  void setPasscode(int passcode) async {
    // if (!state.status.isValidated) return;
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    try {
      sharedPreferences.setInt('passCode', passcode);
      final code = Passcode.dirty(passcode.toString());
      emit(state.copyWith(
          passcode: code, status: FormzStatus.submissionSuccess));
    } catch (e) {
      emit(state.copyWith(
          errorMessage: e.toString(), status: FormzStatus.submissionFailure));
    }
  }

  void getPasscode() async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    try {
      int? passcode = sharedPreferences.getInt('passCode');
      debugPrint("**************" + passcode.toString());
      final code = Passcode.dirty(passcode.toString());
      emit(state.copyWith(savedPasscode: code, status: FormzStatus.valid));
    } catch (e) {
      emit(state.copyWith(
          errorMessage: e.toString(), status: FormzStatus.submissionFailure));
    }
  }

  void checkPasscode(String passcode) async {
    if (passcode.isEmpty) {
      return emit(state.copyWith(
          errorMessage: 'Silahkan isi PIN',
          status: FormzStatus.submissionFailure));
    }
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    try {
      int? savedPasscode = sharedPreferences.getInt('passCode');
      debugPrint("**************" + savedPasscode.toString());
      if (savedPasscode == int.parse(passcode)) {
        emit(state.copyWith(status: FormzStatus.submissionSuccess));
      } else {
        emit(state.copyWith(
            errorMessage: "Password Salah",
            status: FormzStatus.submissionFailure));
      }
    } catch (e) {
      log('Error Passcode: $e');
      emit(state.copyWith(
          errorMessage: 'Terjadi Kesalahan',
          status: FormzStatus.submissionFailure));
    }
  }

  void confirmPasscode() async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      final String passcode = state.passcode.value;
      final String confirmPasscode = state.confirmPasscode;
      if (passcode == confirmPasscode) {
        setPasscode(int.parse(passcode));
      } else {
        emit(state.copyWith(
            errorMessage: "Passcode Salah",
            status: FormzStatus.submissionFailure));
      }
    } catch (e) {
      emit(state.copyWith(
          errorMessage: e.toString(), status: FormzStatus.submissionFailure));
    }
  }

  void destroyPasscode() async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    try {
      sharedPreferences.remove('passCode');
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } catch (e) {
      emit(state.copyWith(
          errorMessage: e.toString(), status: FormzStatus.submissionFailure));
    }
  }
}
