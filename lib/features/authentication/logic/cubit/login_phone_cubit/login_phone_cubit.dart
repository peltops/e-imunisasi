import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../data/models/country_code.dart';
import '../../../data/models/otp.dart';
import '../../../data/models/phone.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

part 'login_phone_state.dart';

@Injectable()
class LoginPhoneCubit extends Cubit<LoginPhoneState> {
  LoginPhoneCubit() : super(const LoginPhoneState());


  void phoneChanged(String value) {
    final phone = Phone.dirty(value);
    emit(state.copyWith(
      phone: phone,
    ));
  }

  void otpCodeChanged(String value) {
    final otpCode = OTP.dirty(value);
    emit(state.copyWith(
      otpCode: otpCode,
    ));
  }

  void countryCodeChanged(String value) {
    final countryCode = CountryCode.dirty(value);
    emit(state.copyWith(
      countryCode: countryCode,
    ));
  }

  void verIdChanged(String value) {
    emit(state.copyWith(verId: value, status: FormzSubmissionStatus.initial));
  }
}
