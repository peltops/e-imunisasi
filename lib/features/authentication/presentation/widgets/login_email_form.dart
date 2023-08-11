import 'package:eimunisasi/core/utils/constant.dart';
import 'package:eimunisasi/pages/widget/snackbar_custom.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../../../../app.dart';
import '../../../../pages/widget/button_custom.dart';
import '../../../../pages/widget/text_form_custom.dart';
import '../../logic/bloc/authentication_bloc/authentication_bloc.dart';
import '../screens/auth/reset_email_password.dart';

import '../../logic/cubit/login_cubit/login_cubit.dart';
import '../screens/auth/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class LoginEmailForm extends StatelessWidget {
  const LoginEmailForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          snackbarCustom(state.errorMessage ?? 'Otentikasi gagal!')
              .show(context);
        } else if (state.status.isSubmissionSuccess) {
          context.read<AuthenticationBloc>().add(LoggedIn());
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const AppView()));
        }
      },
      child: Align(
        alignment: const Alignment(0, -1 / 3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(AppConstant.LOGIN_WITH_EMAIL),
            const SizedBox(height: 16),
            _EmailInput(),
            const SizedBox(height: 8),
            _PasswordInput(),
            const SizedBox(height: 8),
            _LoginButton(),
            const SizedBox(height: 4),
            _SignUpButton(),
            _ResetEmailPasswordButton(),
          ],
        ),
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
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
          onChanged: (email) => context.read<LoginCubit>().emailChanged(email),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
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
            onPressed: () => context.read<LoginCubit>().showHidePassword(),
          ),
          onChanged: (password) =>
              context.read<LoginCubit>().passwordChanged(password),
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return ButtonCustom(
          loading: state.status.isSubmissionInProgress,
          child: Text(
            '${AppConstant.LOGIN} ',
            style: TextStyle(fontSize: 15.0, color: Colors.white),
          ),
          onPressed: state.status.isValidated
              ? () => context.read<LoginCubit>().logInWithCredentials()
              : null,
        );
      },
    );
  }
}

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextButton(
      key: const Key('loginEmailForm_createAccount_flatButton'),
      onPressed: () => Navigator.push(context,
          MaterialPageRoute(builder: (context) => const RegisterScreen())),
      child: Text(
        'Buat Akun',
        style: TextStyle(color: theme.primaryColor),
      ),
    );
  }
}

class _ResetEmailPasswordButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      key: const Key('resetEmailPasswordForm_createAccount_flatButton'),
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const ResetEmailPasswordScreen())),
      child: Text(
        'Lupa Password? Klik Disini',
        style: TextStyle(color: theme.primaryColor),
      ),
    );
  }
}
