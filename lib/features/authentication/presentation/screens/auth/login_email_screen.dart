import 'package:eimunisasi/injection.dart';

import '../../../logic/cubit/login_cubit/login_cubit.dart';
import '../../widgets/login_email_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

class LoginEmailScreen extends StatelessWidget {
  const LoginEmailScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.black,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: BlocProvider(
            create: (_) => getIt<LoginCubit>(),
            child: const LoginEmailForm(),
          ),
        ),
      ),
    );
  }
}
