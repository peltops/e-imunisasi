import '../../../../../injection.dart';
import '../../../logic/cubit/local_auth_cubit/local_auth_cubit.dart';
import '../../widgets/passcode_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PasscodeScreen extends StatelessWidget {
  const PasscodeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<LocalAuthCubit>()..getPasscode(),
      child: const Scaffold(
        body: Padding(
          padding: EdgeInsets.all(20.0),
          child: PasscodeForm(),
        ),
      ),
    );
  }
}
