import 'package:country_code_picker/country_code_picker.dart';
import 'package:eimunisasi/core/utils/constant.dart';
import 'package:eimunisasi/features/authentication/presentation/screens/auth/otp_screen.dart';
import 'package:eimunisasi/core/widgets/snackbar_custom.dart';
import 'package:eimunisasi/routers/route_paths/auth_route_paths.dart';
import 'package:eimunisasi/utils/string_extension.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/button_custom.dart';
import '../../../../core/widgets/text_form_custom.dart';
import '../../../../utils/dismiss_keyboard.dart';
import '../../logic/cubit/login_phone_cubit/login_phone_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class LoginPhoneForm extends StatelessWidget {
  const LoginPhoneForm({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginPhoneCubit, LoginPhoneState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          snackbarCustom(state.errorMessage ?? 'Authentication Failure')
              .show(context);
        } else if (state.verId != null) {
          context.pushReplacement(
            AuthRoutePaths.otp.fullPath,
            extra: OTPScreenArguments(
              phone: state.phone.value,
              countryCode: state.countryCode.value,
              verId: state.verId.orEmpty,
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
                      context.push(AuthRoutePaths.registerPhone.fullPath);
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
                    onChanged: (phone) =>
                        context.read<LoginPhoneCubit>().phoneChanged(phone),
                  ),
                ),
              ],
            ),
            () {
              if (state.phone.isNotValid) {
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
          loading: state.status.isInProgress,
          onPressed: state.phone.isValid && state.countryCode.isValid
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
          onPressed: state.status.isInProgress
              ? null
              : () => context.push(AuthRoutePaths.login.fullPath),
        );
      },
    );
  }
}
