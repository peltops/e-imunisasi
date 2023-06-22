import 'dart:async';

import 'package:eimunisasi/pages/widget/button_custom.dart';
import 'package:eimunisasi/pages/widget/snackbar_custom.dart';

import '../../../../app.dart';

import '../../logic/bloc/authentication_bloc/authentication_bloc.dart';
import '../../logic/cubit/login_phone_cubit/login_phone_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class OTPForm extends StatefulWidget {
  const OTPForm({Key? key}) : super(key: key);
  @override
  _OTPFormState createState() => _OTPFormState();
}

class _OTPFormState extends State<OTPForm> {
  static const maxSeconds = 60;
  int seconds = maxSeconds;
  bool newCode = false;
  bool loading = false;
  String error = '';
  late Timer timer;

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (seconds > 0) {
        setState(() {
          seconds--;
        });
      } else {
        setState(() {
          newCode = true;
        });
        timer.cancel();
      }
    });
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void reloadCodeSent(String phone) {
      context.read<LoginPhoneCubit>().sendOTPCode();
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text('Code sent to $phone'),
          ),
        );
    }

    return BlocListener<LoginPhoneCubit, LoginPhoneState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          snackbarCustom(state.errorMessage ?? 'Otentikasi gagal!')
              .show(context);
        } else if (state.status.isSubmissionSuccess) {
          BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const AppView()));
        }
      },
      child: Column(
        children: [
          const Text(
            "Masukan Kode OTP 6 Digit",
            style: TextStyle(
                fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 50.0,
          ),
          Align(
            alignment: Alignment.topLeft,
            child: BlocBuilder<LoginPhoneCubit, LoginPhoneState>(
              builder: (context, state) {
                return Text(
                    "Nomor Handphone: ${state.countryCode.value + state.phone.value}",
                    style: const TextStyle(fontSize: 15, color: Colors.black));
              },
            ),
          ),
          const SizedBox(height: 5.0),
          const _OTPCodeInput(),
          const SizedBox(height: 16),
          const _LoginButton(),
          const SizedBox(height: 16),
          const Text("Belum Menerima Kode?"),
          const SizedBox(height: 10),
          !newCode && seconds > 0
              ? Row(
                  children: [
                    const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text("Tunggu $seconds ..."),
                  ],
                )
              : BlocBuilder<LoginPhoneCubit, LoginPhoneState>(
                  builder: (context, state) {
                    return InkWell(
                      child: const Text("Minta kode baru!",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      onTap: () {
                        reloadCodeSent(state.phone.value);
                        setState(() {
                          seconds = maxSeconds;
                          newCode = false;
                        });
                        startTimer();
                      },
                    );
                  },
                )
        ],
      ),
    );
  }
}

class _OTPCodeInput extends StatelessWidget {
  const _OTPCodeInput({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginPhoneCubit, LoginPhoneState>(
      buildWhen: (previous, current) => previous.otpCode != current.otpCode,
      builder: (context, state) {
        return TextField(
          key: const Key('loginPhoneForm_otpCodeInput_textField'),
          onChanged: (otpCode) =>
              context.read<LoginPhoneCubit>().otpCodeChanged(otpCode),
          keyboardType: TextInputType.number,
          maxLength: 6,
          decoration: const InputDecoration(
            labelText: 'OTP Code',
            helperText: 'contoh: 000000',
          ),
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginPhoneCubit, LoginPhoneState>(
      builder: (context, state) {
        return ButtonCustom(
          loading: state.status.isSubmissionInProgress,
          child: Text(
            "Verifikasi",
            style: TextStyle(fontSize: 15.0, color: Colors.white),
          ),
          onPressed: () {
            if (state.otpCode.valid) {
              context.read<LoginPhoneCubit>().logInWithOTP();
            } else
              snackbarCustom("Kode OTP tidak valid").show(context);
          },
        );
      },
    );
  }
}
