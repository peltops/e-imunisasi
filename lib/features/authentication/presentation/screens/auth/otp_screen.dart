import 'package:eimunisasi/features/authentication/logic/cubit/login_phone_cubit/login_phone_cubit.dart';
import 'package:eimunisasi/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

import '../../widgets/otp_form.dart';

class OTPScreenArguments {
  final String phone;
  final String countryCode;
  final String verId;

  OTPScreenArguments({
    required this.phone,
    required this.countryCode,
    required this.verId,
  });
}

class OTPScreen extends StatelessWidget {
  final OTPScreenArguments state;
  const OTPScreen({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      child: BlocProvider(
        create: (context) => getIt<LoginPhoneCubit>()
          ..phoneChanged(state.phone)
          ..countryCodeChanged(state.countryCode)
          ..verIdChanged(state.verId),
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
            child: OTPForm(),
          ),
        ),
      ),
    );
  }
}
