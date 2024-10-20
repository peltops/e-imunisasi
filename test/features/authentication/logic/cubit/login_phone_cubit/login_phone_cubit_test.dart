import 'package:bloc_test/bloc_test.dart';
import 'package:eimunisasi/features/authentication/data/models/country_code.dart';
import 'package:eimunisasi/features/authentication/data/models/otp.dart';
import 'package:eimunisasi/features/authentication/data/models/phone.dart';
import 'package:eimunisasi/features/authentication/logic/cubit/login_phone_cubit/login_phone_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';


void main() {

  final phone = "85211011003";
  final phoneInvalid = "8123456789";
  final countryCode = "+62";
  final countryCodeInvalid = "62";
  final otp = "123456";
  final otpInvalid = "12345";

  group("phoneChanged", () {
    blocTest<LoginPhoneCubit, LoginPhoneState>(
      'phoneChanged: phone invalid and countryCode invalid',
      build: () => LoginPhoneCubit(),
      seed: () => LoginPhoneState(
        phone: Phone.dirty(phoneInvalid),
        countryCode: CountryCode.dirty(countryCodeInvalid),
      ),
      act: (cubit) => cubit.phoneChanged(phone),
      expect: () => [
        LoginPhoneState(
          phone: Phone.dirty(phone),
          countryCode: CountryCode.dirty(countryCodeInvalid),
        )
      ],
    );

    blocTest<LoginPhoneCubit, LoginPhoneState>(
      'phoneChanged: phone valid and countryCode invalid',
      build: () => LoginPhoneCubit(),
      seed: () => LoginPhoneState(
        phone: Phone.dirty(phoneInvalid),
        countryCode: CountryCode.dirty(countryCodeInvalid),
      ),
      act: (cubit) => cubit.phoneChanged(phone),
      expect: () => [
        LoginPhoneState(
          phone: Phone.dirty(phone),
          countryCode: CountryCode.dirty(countryCodeInvalid),
        )
      ],
    );

    blocTest<LoginPhoneCubit, LoginPhoneState>(
      'phoneChanged: phone invalid and countryCode valid',
      build: () => LoginPhoneCubit(),
      seed: () => LoginPhoneState(
        phone: Phone.dirty(phoneInvalid),
        countryCode: CountryCode.dirty(countryCode),
      ),
      act: (cubit) => cubit.phoneChanged(phone),
      expect: () => [
        LoginPhoneState(
          phone: Phone.dirty(phone),
          countryCode: CountryCode.dirty(countryCode),
        )
      ],
    );

    blocTest<LoginPhoneCubit, LoginPhoneState>(
      'phoneChanged: phone valid and countryCode valid',
      build: () => LoginPhoneCubit(),
      seed: () => LoginPhoneState(
        phone: Phone.dirty(phoneInvalid),
        countryCode: CountryCode.dirty(countryCode),
      ),
      act: (cubit) => cubit.phoneChanged(phone),
      expect: () => [
        LoginPhoneState(
          phone: Phone.dirty(phone),
          countryCode: CountryCode.dirty(countryCode),
        )
      ],
    );
  });

  group("countryCodeChanged", () {
    blocTest<LoginPhoneCubit, LoginPhoneState>(
      'countryCodeChanged: countryCode invalid and phone invalid',
      build: () => LoginPhoneCubit(),
      seed: () => LoginPhoneState(
        phone: Phone.dirty(phoneInvalid),
        countryCode: CountryCode.dirty(countryCodeInvalid),
      ),
      act: (cubit) => cubit.countryCodeChanged(countryCode),
      expect: () => [
        LoginPhoneState(
          phone: Phone.dirty(phoneInvalid),
          countryCode: CountryCode.dirty(countryCode),
        )
      ],
    );

    blocTest<LoginPhoneCubit, LoginPhoneState>(
      'countryCodeChanged: countryCode valid and phone invalid',
      build: () => LoginPhoneCubit(),
      seed: () => LoginPhoneState(
        phone: Phone.dirty(phoneInvalid),
        countryCode: CountryCode.dirty(countryCodeInvalid),
      ),
      act: (cubit) => cubit.countryCodeChanged(countryCode),
      expect: () => [
        LoginPhoneState(
          phone: Phone.dirty(phoneInvalid),
          countryCode: CountryCode.dirty(countryCode),
        )
      ],
    );

    blocTest<LoginPhoneCubit, LoginPhoneState>(
      'countryCodeChanged: countryCode invalid and phone valid',
      build: () => LoginPhoneCubit(),
      seed: () => LoginPhoneState(
        phone: Phone.dirty(phone),
        countryCode: CountryCode.dirty(countryCodeInvalid),
      ),
      act: (cubit) => cubit.countryCodeChanged(countryCode),
      expect: () => [
        LoginPhoneState(
          phone: Phone.dirty(phone),
          countryCode: CountryCode.dirty(countryCode),
        )
      ],
    );

    blocTest<LoginPhoneCubit, LoginPhoneState>(
      'countryCodeChanged: countryCode valid and phone valid',
      build: () => LoginPhoneCubit(),
      seed: () => LoginPhoneState(
        phone: Phone.dirty(phone),
        countryCode: CountryCode.dirty(countryCodeInvalid),
      ),
      act: (cubit) => cubit.countryCodeChanged(countryCode),
      expect: () => [
        LoginPhoneState(
          phone: Phone.dirty(phone),
          countryCode: CountryCode.dirty(countryCode),
        )
      ],
    );
  });

  group("otpCodeChanged", () {
    blocTest<LoginPhoneCubit, LoginPhoneState>(
      'otpCodeChanged: otpCode invalid',
      build: () => LoginPhoneCubit(),
      seed: () => LoginPhoneState(
        otpCode: OTP.dirty("123456"),
      ),
      act: (cubit) => cubit.otpCodeChanged("1234567"),
      expect: () => [
        LoginPhoneState(
          otpCode: OTP.dirty("1234567"),
        )
      ],
    );

    blocTest<LoginPhoneCubit, LoginPhoneState>(
      'otpCodeChanged: otpCode invalid',
      build: () => LoginPhoneCubit(),
      act: (cubit) => cubit.otpCodeChanged(otpInvalid),
      expect: () => [
        LoginPhoneState(
          otpCode: OTP.dirty(otpInvalid),
        )
      ],
    );

    blocTest<LoginPhoneCubit, LoginPhoneState>(
      'otpCodeChanged: otpCode valid',
      build: () => LoginPhoneCubit(),
      seed: () => LoginPhoneState(
        phone: Phone.dirty(phone),
        countryCode: CountryCode.dirty(countryCode),
      ),
      act: (cubit) => cubit.otpCodeChanged(otp),
      expect: () => [
        LoginPhoneState(
          otpCode: OTP.dirty(otp),
          phone: Phone.dirty(phone),
          countryCode: CountryCode.dirty(countryCode),
        )
      ],
    );
  });

  group("verIdChanged", () {
    blocTest<LoginPhoneCubit, LoginPhoneState>(
      'verIdChanged: verId valid',
      build: () => LoginPhoneCubit(),
      act: (cubit) => cubit.verIdChanged("123456"),
      expect: () => [
        LoginPhoneState(
          verId: "123456",
          status: FormzSubmissionStatus.initial,
        )
      ],
    );
  });
}
