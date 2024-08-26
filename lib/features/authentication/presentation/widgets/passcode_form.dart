import 'package:eimunisasi/core/utils/constant.dart';
import 'package:eimunisasi/core/widgets/snackbar_custom.dart';

import '../../../../core/widgets/button_custom.dart';
import '../../../bottom_navbar/presentation/screens/bottom_navbar.dart';
import '../../logic/cubit/local_auth_cubit/local_auth_cubit.dart';
import '../screens/local_auth/confirm_passcode_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class PasscodeForm extends StatelessWidget {
  const PasscodeForm({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocListener<LocalAuthCubit, LocalAuthState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          snackbarCustom(state.errorMessage ?? 'Gagal').show(context);
        }
      },
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const _TextHeader(),
              const SizedBox(height: 16),
              _PasscodeInput(),
              const SizedBox(height: 16),
              const _NextButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _TextHeader extends StatelessWidget {
  const _TextHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocalAuthCubit, LocalAuthState>(
      builder: (context, state) {
        return Text(
          state.savedPasscode.isNotValid
              ? AppConstant.PLEASE_SET_PASSCODE
              : AppConstant.PLEASE_ENTER_PASSCODE,
        );
      },
    );
  }
}

class _PasscodeInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocalAuthCubit, LocalAuthState>(
      builder: (context, state) {
        return Column(
          children: [
            TextField(
              maxLength: 4,
              key: const Key('passcodeForm_passcodeInput_textField'),
              onChanged: (value) =>
                  context.read<LocalAuthCubit>().passcodeChanged(value),
              keyboardType: TextInputType.number,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'PIN',
                helperText: 'Masukkan 4-digit PIN',
                errorText: state.passcode.isNotValid ? 'Format salah!' : null,
              ),
            ),
            const SizedBox(height: 16),
            state.savedPasscode.isNotValid
                ? const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      AppConstant.PASSCODE_FORM_HINT,
                      style: TextStyle(fontSize: 12, color: Colors.red),
                    ))
                : Container(),
          ],
        );
      },
    );
  }
}

class _NextButton extends StatelessWidget {
  const _NextButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocListener<LocalAuthCubit, LocalAuthState>(
      listener: (context, state) {
        if (state.status.isSuccess) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const BottomNavbarWrapper(),
              ),
              (route) => false);
        } else if (state.status.isFailure) {
          snackbarCustom(state.errorMessage ?? 'Gagal').show(context);
        }
      },
      child: BlocBuilder<LocalAuthCubit, LocalAuthState>(
        builder: (context, state) {
          return ButtonCustom(
            loading: state.status.isInProgress,
            child: Text(
              AppConstant.NEXT,
              style: TextStyle(fontSize: 15.0, color: Colors.white),
            ),
            onPressed: () {
              if (state.savedPasscode.isNotValid) {
                if (state.passcode.isValid) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: context.read<LocalAuthCubit>(),
                        child: const ConfirmPasscodeScreen(),
                      ),
                    ),
                  );
                }
              } else {
                context
                    .read<LocalAuthCubit>()
                    .checkPasscode(state.passcode.value);
              }
            },
          );
        },
      ),
    );
  }
}
