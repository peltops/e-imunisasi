import 'package:country_code_picker/country_code_picker.dart';
import 'package:eimunisasi/core/utils/constant.dart';
import 'package:eimunisasi/features/authentication/presentation/screens/auth/register_phone_screen.dart';
import 'package:eimunisasi/injection.dart';
import 'package:eimunisasi/core/widgets/snackbar_custom.dart';
import 'package:eimunisasi/utils/string_extension.dart';
import 'package:form_field_validator/form_field_validator.dart';
import '../../../../core/widgets/button_custom.dart';
import '../../../../core/widgets/text_form_custom.dart';
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
          snackbarCustom(state.errorMessage ?? 'Authentication Failure')
              .show(context);
        } else if (state.verId != null) {
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
              Image.asset(
                'assets/images/logo.png',
                width: 80,
              ),
              SizedBox(height: 30.0),
              Text(
                AppConstant.PLEASE_LOGIN,
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
                  Text(AppConstant.NEW_USER_QUESTION,
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterPhoneScreen(),
                        ),
                      );
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
                      .countryCodeChanged(countryCode?.dialCode ?? '+62'),
                  onChanged: (countryCode) => context
                      .read<LoginPhoneCubit>()
                      .countryCodeChanged(countryCode.dialCode.orEmpty),
                  initialSelection: 'ID',
                  showCountryOnly: false,
                  showOnlyCountryWhenClosed: false,
                  alignLeft: false,
                ),
                Expanded(
                  child: TextFormCustom(
                    label: AppConstant.PHONE_NUMBER_LABEL,
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
            AppConstant.LOGIN,
            style: TextStyle(fontSize: 15.0, color: Colors.white),
          ),
          loading: state.status.isSubmissionInProgress,
          onPressed: state.phone.valid && state.countryCode.valid
              ? () {
                  dismissKeyboard(context);
                  context.read<LoginPhoneCubit>().sendOTPCode();
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
            AppConstant.LOGIN_WITH_EMAIL,
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
