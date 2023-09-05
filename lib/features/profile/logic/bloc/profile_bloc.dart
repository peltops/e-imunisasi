import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:injectable/injectable.dart';

import '../../../authentication/data/models/user.dart';
import '../../../authentication/data/repositories/auth_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

@Injectable()
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthRepository _authRepository;

  ProfileBloc(this._authRepository) : super(ProfileState()) {
    on<ProfileGetEvent>(_onProfileGetEvent);
    on<ProfileUpdateEvent>(_onProfileUpdateEvent);
    on<ProfileUpdateAvatarEvent>(_onProfileUpdateAvatarEvent);
    
    on<OnChangeNameEvent>((event, emit) {
      emit(
        state.copyWith(
          user: state.user?.copyWith(momName: event.name),
        ),
      );
    });
    on<OnChangePlaceOfBirthEvent>((event, emit) {
      emit(
        state.copyWith(
          user: state.user?.copyWith(tempatLahir: event.placeOfBirth),
          statusUpdate: FormzStatus.pure,
        ),
      );
    });
    on<OnChangeDateOfBirthEvent>((event, emit) {
      emit(
        state.copyWith(
          user: state.user?.copyWith(tanggalLahir: event.dateOfBirth),
          statusUpdate: FormzStatus.pure,
        ),
      );
    });
    on<OnChangeIdentityNumberEvent>((event, emit) {
      emit(
        state.copyWith(
          user: state.user?.copyWith(noKTP: event.identityNumber),
          statusUpdate: FormzStatus.pure,
        ),
      );
    });
    on<OnChangeFamilyCardNumberEvent>((event, emit) {
      emit(
        state.copyWith(
          user: state.user?.copyWith(noKK: event.familyCardNumber),
          statusUpdate: FormzStatus.pure,
        ),
      );
    });
    on<OnChangeJobEvent>((event, emit) {
      emit(
        state.copyWith(
          user: state.user?.copyWith(pekerjaanIbu: event.job),
          statusUpdate: FormzStatus.pure,
        ),
      );
    });
    on<OnChangeBloodTypeEvent>((event, emit) {
      emit(
        state.copyWith(
          user: state.user?.copyWith(golDarahIbu: event.bloodType),
          statusUpdate: FormzStatus.pure,
        ),
      );
    });
  }

  void _onProfileGetEvent(
    ProfileGetEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(statusGet: FormzStatus.submissionInProgress));
    try {
      final user = await _authRepository.getUser();
      emit(
        state.copyWith(user: user, statusGet: FormzStatus.submissionSuccess),
      );
    } catch (e) {
      emit(state.copyWith(statusGet: FormzStatus.submissionFailure));
    }
  }

  void _onProfileUpdateEvent(
    ProfileUpdateEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(statusUpdate: FormzStatus.submissionInProgress));
    try {
      if (state.user == null) {
        emit(state.copyWith(
          statusUpdate: FormzStatus.submissionFailure,
          errorMessage: 'User tidak ditemukan',
        ));
        return;
      }
      await _authRepository.insertUserToDatabase(user: state.user!);
      emit(state.copyWith(statusUpdate: FormzStatus.submissionSuccess));
    } catch (e) {
      emit(state.copyWith(statusUpdate: FormzStatus.submissionFailure));
    }
  }

  void _onProfileUpdateAvatarEvent(
    ProfileUpdateAvatarEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(statusUpdate: FormzStatus.submissionInProgress));
    try {
      final url = await _authRepository.uploadImage(event.file);
      await _authRepository.updateUserAvatar(url);
      emit(state.copyWith(statusUpdate: FormzStatus.submissionSuccess));
    } catch (e) {
      emit(state.copyWith(statusUpdate: FormzStatus.submissionFailure));
    }
  }
}
