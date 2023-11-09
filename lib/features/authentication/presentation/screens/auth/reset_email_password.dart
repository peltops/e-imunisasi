import 'package:eimunisasi/injection.dart';

import '../../../logic/cubit/reset_password_cubit/reset_password_cubit.dart';
import '../../widgets/reset_email_password_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

class ResetEmailPasswordScreen extends StatelessWidget {
  const ResetEmailPasswordScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          iconTheme: const IconThemeData(color: Colors.black),
          elevation: 0.0,
        ),
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: BlocProvider(
            create: (context) => getIt<ResetPasswordCubit>(),
            child: const ResetEmailPasswordForm(),
          ),
        ),
      ),
    );
  }
}
