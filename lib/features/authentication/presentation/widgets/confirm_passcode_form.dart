import 'package:eimunisasi/core/widgets/snackbar_custom.dart';
import 'package:eimunisasi/routers/route_paths/root_route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/constant.dart';
import '../../../../core/widgets/button_custom.dart';
import '../../logic/cubit/local_auth_cubit/local_auth_cubit.dart';
import 'package:formz/formz.dart';

class ConfirmPasscodeForm extends StatelessWidget {
  const ConfirmPasscodeForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<LocalAuthCubit, LocalAuthState>(
      listener: (context, state) {
        if (state.statusSet.isFailure) {
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
            errorText: state.confirmPasscode.value != state.passcode.value
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
      listenWhen: (previous, current) =>
          previous.statusSet != current.statusSet,
      listener: (context, state) {
        if (state.statusSet.isSuccess) {
          context.pushReplacement(RootRoutePaths.dashboard.fullPath);
        } else if (state.statusSet.isFailure) {
          snackbarCustom(state.errorMessage ?? 'Gagal').show(context);
        }
      },
      child: BlocBuilder<LocalAuthCubit, LocalAuthState>(
        builder: (context, state) {
          return ButtonCustom(
            key: const Key('confirmPasscodeForm_next_raisedButton'),
            loading: state.statusSet.isInProgress,
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
