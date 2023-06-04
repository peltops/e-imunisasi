import 'package:eimunisasi/injection.dart';

import '../../../logic/cubit/signup_cubit/signup_cubit.dart';
import '../../widgets/signup_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

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
          child: BlocProvider<SignUpCubit>(
            create: (_) => getIt<SignUpCubit>(),
            child: const SignUpForm(),
          ),
        ),
      ),
    );
  }
}
