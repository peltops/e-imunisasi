import 'package:eimunisasi/pages/widget/snackbar_custom.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../../../../pages/widget/button_custom.dart';
import '../../../../pages/widget/text_form_custom.dart';
import '../../logic/cubit/signup_cubit/signup_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpCubit, SignUpState>(
      listener: (context, state) {
        if (state.status.isSubmissionSuccess) {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        } else if (state.status.isSubmissionFailure) {
          snackbarCustom(state.errorMessage ?? 'Pendaftaran gagal!')
              .show(context);
        }
      },
      child: Align(
        alignment: const Alignment(0, -1 / 3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Daftar dengan Email Anda"),
            const SizedBox(height: 16),
            _EmailInput(),
            const SizedBox(height: 8),
            _PasswordInput(),
            const SizedBox(height: 8),
            _SignUpButton(),
          ],
        ),
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextFormCustom(
          label: 'Email',
          hintText: 'orangtua@contoh.com',
          icon: Icon(Icons.email),
          validator: MultiValidator([
            EmailValidator(errorText: 'Masukan email yang valid'),
            RequiredValidator(errorText: 'Masukan email'),
          ]),
          errorText: state.email.invalid ? 'Format email salah!' : null,
          onChanged: (email) => context.read<SignUpCubit>().emailChanged(email),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) =>
          previous.password != current.password ||
          previous.isShowPassword != current.isShowPassword,
      builder: (context, state) {
        return TextFormCustom(
          label: 'Password',
          hintText: 'password',
          obscureText: !state.isShowPassword,
          icon: IconButton(
            icon: Icon(
              !state.isShowPassword ? Icons.visibility_off : Icons.visibility,
            ),
            onPressed: () => context.read<SignUpCubit>().showHidePassword(),
          ),
          onChanged: (password) =>
              context.read<SignUpCubit>().passwordChanged(password),
          errorText:
              state.password.invalid ? 'Password minimal 8 karakter' : null,
        );
      },
    );
  }
}

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return ButtonCustom(
          loading: state.status.isSubmissionInProgress,
          child: Text(
            "Daftar ",
            style: TextStyle(fontSize: 15.0, color: Colors.white),
          ),
          onPressed: state.status.isValidated
              ? () => context.read<SignUpCubit>().sendOTPCode()
              : null,
        );
      },
    );
  }
}
