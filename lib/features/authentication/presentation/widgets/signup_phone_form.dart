import 'package:country_code_picker/country_code_picker.dart';
import 'package:eimunisasi/features/authentication/logic/cubit/signup_cubit/signup_cubit.dart';
import 'package:eimunisasi/pages/widget/snackbar_custom.dart';
import 'package:eimunisasi/utils/string_extension.dart';
import 'package:form_field_validator/form_field_validator.dart';
import '../../../../injection.dart';
import '../../../../pages/widget/button_custom.dart';
import '../../../../pages/widget/text_form_custom.dart';
import '../../../../utils/dismiss_keyboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../../logic/cubit/login_phone_cubit/login_phone_cubit.dart';
import '../screens/auth/otp_screen.dart';

class SignUpPhoneForm extends StatelessWidget {
  const SignUpPhoneForm({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpCubit, SignUpState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          snackbarCustom(state.errorMessage ?? 'Authentication Failure')
              .show(context);
        } else if (state.verId.isNotNullOrEmpty) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => BlocProvider(
                create: (_) => getIt<LoginPhoneCubit>()
                  ..phoneChanged(state.phone.value)
                  ..countryCodeChanged(state.countryCode.value)
                  ..verIdChanged(state.verId.orEmpty),
                child: const OTPScreen(),
              ),
            ),
          );
        }
      },
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Daftarkan Akun",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Sudah punya akun?",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  InkWell(
                    child: Text(
                      ' Masuk',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).primaryColor),
                    ),
                    onTap: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _PhoneInput(),
              const SizedBox(height: 16),
              _SignUpButton(),
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
    return BlocBuilder<SignUpCubit, SignUpState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CountryCodePicker(
                  onInit: (countryCode) => context
                      .read<SignUpCubit>()
                      .countryCodeChanged(countryCode?.dialCode ?? '+62'),
                  onChanged: (countryCode) => context
                      .read<SignUpCubit>()
                      .countryCodeChanged(countryCode.dialCode.orEmpty),
                  initialSelection: 'ID',
                  showCountryOnly: false,
                  showOnlyCountryWhenClosed: false,
                  alignLeft: false,
                ),
                Expanded(
                  child: TextFormCustom(
                    label: "Nomor Ponsel Orang tua/Wali",
                    keyboardType: TextInputType.phone,
                    hintText: 'Contoh: 876543210',
                    validator: MultiValidator([
                      RequiredValidator(errorText: 'Masukan No. Ponsel!'),
                      MaxLengthValidator(13,
                          errorText: 'No. Ponsel terlalu panjang'),
                    ]),
                    onChanged: (phone) =>
                        context.read<SignUpCubit>().phoneChanged(phone),
                    errorText: state.phone.invalid
                        ? 'Format salah! Contoh: 876543210'
                        : null,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
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
                      ? context.read<SignUpCubit>().sendOTPCode()
                      : snackbarCustom("Silahkan masukan nomor ponsel!")
                          .show(context);
                }
              : null,
        );
      },
    );
  }
}
