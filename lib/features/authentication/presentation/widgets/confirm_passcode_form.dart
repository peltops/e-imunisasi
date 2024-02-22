import 'package:eimunisasi/pages/widget/snackbar_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../../../../core/utils/constant.dart';
import '../../../../pages/widget/button_custom.dart';
import '../../../bottom_navbar/presentation/screens/bottom_navbar.dart';
import '../../logic/cubit/local_auth_cubit/local_auth_cubit.dart';

class ConfirmPasscodeForm extends StatelessWidget {
  const ConfirmPasscodeForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<LocalAuthCubit, LocalAuthState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          snackbarCustom(state.errorMessage ?? 'Gagal').show(context);
        }
      },
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(AppConstant.PIN_CONFIRM_LABEL),
              const SizedBox(height: 16),
              _PasscodeInput(),
              const SizedBox(height: 16),
              _NextButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _PasscodeInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocalAuthCubit, LocalAuthState>(
      builder: (context, state) {
        return TextField(
          maxLength: 4,
          key: const Key('confirmPasscodeForm_passcodeInput_textField'),
          onChanged: (value) =>
              context.read<LocalAuthCubit>().passcodeConfirmChanged(value),
          keyboardType: TextInputType.number,
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Masukkan kembali PIN',
            helperText: 'Konfirmasi 4-digit PIN',
            // ignore: unrelated_type_equality_checks
            errorText: state.confirmPasscode != state.passcode.value
                ? 'PIN Tidak Sama!'
                : null,
          ),
        );
      },
    );
  }
}

class _NextButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<LocalAuthCubit, LocalAuthState>(
      listener: (context, state) {
        if (state.status.isSubmissionSuccess) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const BottomNavbarWrapper(),
              ),
              (route) => false);
        } else if (state.status.isSubmissionFailure) {
          snackbarCustom(state.errorMessage ?? 'Gagal').show(context);
        }
      },
      child: BlocBuilder<LocalAuthCubit, LocalAuthState>(
        builder: (context, state) {
          return ButtonCustom(
            key: const Key('confirmPasscodeForm_next_raisedButton'),
            loading: state.status.isSubmissionInProgress,
            child: Text(
              AppConstant.CONFIRMATION,
              style: TextStyle(fontSize: 15.0, color: Colors.white),
            ),
            onPressed: () {
              context.read<LocalAuthCubit>().confirmPasscode();
            },
          );
        },
      ),
    );
  }
}
