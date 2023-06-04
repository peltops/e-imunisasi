import 'package:country_code_picker/country_code_picker.dart';
import 'package:eimunisasi/injection.dart';
import 'package:eimunisasi/pages/widget/snackbar_custom.dart';
import 'package:form_field_validator/form_field_validator.dart';
import '../../../../pages/widget/button_custom.dart';
import '../../../../pages/widget/text_form_custom.dart';
import '../../../../utils/dismiss_keyboard.dart';
import '../../logic/cubit/login_phone_cubit/login_phone_cubit.dart';
import '../screens/auth/login_email_screen.dart';
import '../screens/auth/otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class LoginPhoneForm extends StatelessWidget {
  const LoginPhoneForm({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginPhoneCubit, LoginPhoneState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Authentication Failure'),
              ),
            );
        } else if (state.verId != null) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
                builder: (_) => BlocProvider(
                      create: (_) => getIt<LoginPhoneCubit>()
                        ..phoneChanged(state.phone.value)
                        ..countryCodeChanged(state.countryCode.value)
                        ..verIdChanged(state.verId!),
                      child: const OTPScreen(),
                    )),
          );
        }
      },
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/logo.png',
                width: 80,
              ),
              SizedBox(height: 30.0),
              Text(
                "Silahkan Masuk",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Pengguna baru?",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.black)),
                  InkWell(
                    child: Text(' Buat akun',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).primaryColor)),
                    onTap: () {
                      // TODO: change navigator to registration
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => RegistrationPage()));
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _PhoneInput(),
              const SizedBox(height: 16),
              _LoginButton(),
              const SizedBox(height: 16),
              _LoginWithEmailButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _PhoneInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginPhoneCubit, LoginPhoneState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CountryCodePicker(
                  onInit: (countryCode) => context
                      .read<LoginPhoneCubit>()
                      .countryCodeChanged(countryCode!.dialCode!),
                  onChanged: (countryCode) => context
                      .read<LoginPhoneCubit>()
                      .countryCodeChanged(countryCode.dialCode!),
                  initialSelection: 'ID',
                  showCountryOnly: false,
                  showOnlyCountryWhenClosed: false,
                  alignLeft: false,
                ),
                Expanded(
                  child: TextFormCustom(
                    label: "Nomor Ponsel",
                    keyboardType: TextInputType.phone,
                    hintText: 'Contoh: 876543210',
                    validator: MultiValidator([
                      RequiredValidator(errorText: 'Masukan No. Ponsel!'),
                      MaxLengthValidator(13,
                          errorText: 'No. Ponsel terlalu panjang'),
                    ]),
                    onChanged: (phone) =>
                        context.read<LoginPhoneCubit>().phoneChanged(phone),
                  ),
                ),
              ],
            ),
            () {
              if (state.phone.invalid) {
                return Text(
                  'Format salah! Contoh: 876543210',
                  style: TextStyle(color: Colors.red[600]),
                );
              } else {
                return Container();
              }
            }()
          ],
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginPhoneCubit, LoginPhoneState>(
      builder: (context, state) {
        return ButtonCustom(
          child: Text(
            "Masuk",
            style: TextStyle(fontSize: 15.0, color: Colors.white),
          ),
          loading: state.status.isSubmissionInProgress,
          onPressed: state.phone.valid
              ? () {
                  dismissKeyboard(context);
                  state.phone.valid
                      ? context.read<LoginPhoneCubit>().sendOTPCode()
                      : snackbarCustom("Silahkan masukan nomor ponsel!")
                          .show(context);
                }
              : null,
        );
      },
    );
  }
}

class _LoginWithEmailButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginPhoneCubit, LoginPhoneState>(
      builder: (context, state) {
        return ButtonCustom(
          child: Text(
            "Masuk dengan Email",
            style: TextStyle(fontSize: 15.0, color: Colors.white),
          ),
          onPressed: state.status.isSubmissionInProgress
              ? null
              : () => Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return LoginEmailScreen();
                  })),
        );
      },
    );
  }
}
