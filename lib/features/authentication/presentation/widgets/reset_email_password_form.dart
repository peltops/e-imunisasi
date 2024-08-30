import 'package:eimunisasi/core/utils/constant.dart';
import 'package:eimunisasi/core/widgets/snackbar_custom.dart';

import '../../../../core/widgets/button_custom.dart';
import '../../../../core/widgets/text_form_custom.dart';
import '../../logic/cubit/reset_password_cubit/reset_password_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class ResetEmailPasswordForm extends StatelessWidget {
  const ResetEmailPasswordForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<ResetPasswordCubit, ResetPasswordState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          snackbarCustom(state.errorMessage ?? 'Reset gagal!').show(context);
        } else if (state.status.isSuccess) {
          Navigator.of(context).pop();
          snackbarCustom(
            'Berhasil! Silahkan cek email anda. ${state.email.value}',
          ).show(context);
        }
      },
      child: Align(
        alignment: const Alignment(0, -1 / 3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(AppConstant.RESET_PASSWORD_EMAIL_LABEL),
            const SizedBox(height: 16),
            _EmailInput(),
            const SizedBox(height: 8),
            _ResetButton(),
          ],
        ),
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ResetPasswordCubit, ResetPasswordState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextFormCustom(
          label: 'Email',
          hintText: 'orangtua@contoh.com',
          icon: Icon(Icons.email),
          errorText: state.email.isNotValid ? 'Format email salah!' : null,
          onChanged: (email) =>
              context.read<ResetPasswordCubit>().emailChanged(email),
        );
      },
    );
  }
}

class _ResetButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ResetPasswordCubit, ResetPasswordState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return ButtonCustom(
          loading: state.status.isInProgress,
          child: Text(
            AppConstant.RESET_PASSWORD_LINK_ACTION,
            style: TextStyle(fontSize: 15.0, color: Colors.white),
          ),
          onPressed: state.email.isValid
              ? () => context
                  .read<ResetPasswordCubit>()
                  .resetPasswordFormSubmitted()
              : null,
        );
      },
    );
  }
}
