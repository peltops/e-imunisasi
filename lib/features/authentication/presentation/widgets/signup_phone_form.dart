import 'package:country_code_picker/country_code_picker.dart';
import 'package:eimunisasi/core/utils/constant.dart';
import 'package:eimunisasi/features/authentication/logic/cubit/signup_cubit/signup_cubit.dart';
import 'package:eimunisasi/core/widgets/snackbar_custom.dart';
import 'package:eimunisasi/features/authentication/presentation/screens/auth/otp_screen.dart';
import 'package:eimunisasi/routers/route_paths/auth_route_paths.dart';
import 'package:eimunisasi/core/utils/string_extension.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/text_form_custom.dart';
import '../../../../core/widgets/button_custom.dart';
import '../../../../core/utils/dismiss_keyboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';


class SignUpPhoneForm extends StatelessWidget {
  const SignUpPhoneForm({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpCubit, SignUpState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          snackbarCustom(state.errorMessage ?? 'Authentication Failure')
              .show(context);
        } else if (state.verId.isNotNullOrEmpty) {
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
              Text(
                AppConstant.SIGN_UP_ACTION,
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
                    AppConstant.ALREADY_HAVE_ACCOUNT_QUESTION,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  InkWell(
                    child: Text(
                      ' ${AppConstant.LOGIN}',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).primaryColor),
                    ),
                    onTap: () => context.pop(),
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
                    label: AppConstant.PHONE_NUMBER_PARENT_LABEL,
                    keyboardType: TextInputType.phone,
                    hintText: 'Contoh: 876543210',
                    onChanged: (phone) =>
                        context.read<SignUpCubit>().phoneChanged(phone),
                    errorText: state.phone.isNotValid
                        ? AppConstant.PHONE_NUMBER_INVALID_ERROR
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
            AppConstant.LOGIN,
            style: TextStyle(fontSize: 15.0, color: Colors.white),
          ),
          loading: state.status.isInProgress,
          onPressed: state.phone.isValid
              ? () {
                  dismissKeyboard(context);
                  // state.phone.isValid
                  //     ? context.read<SignUpCubit>().sendOTPCode()
                  //     : snackbarCustom(AppConstant.PLEASE_ENTER_PHONE_NUMBER)
                  //         .show(context);
                }
              : null,
        );
      },
    );
  }
}
