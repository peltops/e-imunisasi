import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:injectable/injectable.dart';

import '../../../data/models/anak.dart';
import '../../../data/repositories/child_repository.dart';

part 'child_profile_event.dart';

part 'child_profile_state.dart';

@injectable
class ChildProfileBloc extends Bloc<ChildProfileEvent, ChildProfileState> {
  final ChildRepository _childRepository;

  ChildProfileBloc(this._childRepository) : super(const ChildProfileState()) {
    on<OnInitialEvent>(_onInitialEvent);
    on<OnGetChildrenEvent>(_onGetChildrenEvent);
    on<OnChangeNameEvent>(_onChangeNameEvent);
    on<OnChangeIdentityNumberEvent>(_onChangeIdentityNumberEvent);
    on<OnChangePlaceOfBirthEvent>(_onChangePlaceOfBirthEvent);
    on<OnChangeDateOfBirthEvent>(_onChangeDateOfBirthEvent);
    on<OnChangeGenderEvent>(_onChangeGenderEvent);
    on<OnChangeBloodTypeEvent>(_onChangeBloodTypeEvent);
    on<UpdateProfileEvent>(_onUpdateChildEvent);
    on<CreateProfileEvent>(_onCreateChildEvent);
    on<UpdateProfilePhotoEvent>(_onUpdateAvatarEvent);
  }

  void _onInitialEvent(OnInitialEvent event, Emitter emit) {
    emit(state.copyWith(
      child: event.child,
    ));
  }

  void _onGetChildrenEvent(OnGetChildrenEvent event, Emitter emit) async {
    emit(state.copyWith(statusGetChildren: FormzStatus.submissionInProgress));
    try {
      final children = await _childRepository.getAllChildren();
      emit(state.copyWith(
        statusGetChildren: FormzStatus.submissionSuccess,
        children: children,
      ));
    } catch (e) {
      emit(
        state.copyWith(
          statusGetChildren: FormzStatus.submissionFailure,
          errorMessage: 'Gagal memuat data anak',
        ),
      );
    }
  }

  void _onChangeNameEvent(OnChangeNameEvent event, Emitter emit) {
    emit(state.copyWith(
      child: state.child?.copyWith(nama: event.name),
    ));
  }

  void _onChangeIdentityNumberEvent(
      OnChangeIdentityNumberEvent event, Emitter emit) {
    emit(state.copyWith(
      child: state.child?.copyWith(nik: event.identityNumber),
    ));
  }

  void _onChangePlaceOfBirthEvent(
      OnChangePlaceOfBirthEvent event, Emitter emit) {
    emit(state.copyWith(
      child: state.child?.copyWith(tempatLahir: event.placeOfBirth),
    ));
  }

  void _onChangeDateOfBirthEvent(OnChangeDateOfBirthEvent event, Emitter emit) {
    emit(state.copyWith(
      child: state.child?.copyWith(tanggalLahir: event.dateOfBirth),
    ));
  }

  void _onChangeGenderEvent(OnChangeGenderEvent event, Emitter emit) {
    emit(state.copyWith(
      child: state.child?.copyWith(jenisKelamin: event.gender),
    ));
  }

  void _onChangeBloodTypeEvent(OnChangeBloodTypeEvent event, Emitter emit) {
    emit(state.copyWith(
      child: state.child?.copyWith(golDarah: event.bloodType),
    ));
  }

  void _onUpdateChildEvent(UpdateProfileEvent event, Emitter emit) async {
    emit(state.copyWith(statusUpdate: FormzStatus.submissionInProgress));
    try {
      await _childRepository.updateChild(state.child!);
      add(OnGetChildrenEvent());
      emit(state.copyWith(statusUpdate: FormzStatus.submissionSuccess));
      emit(state.copyWith(child: null, statusUpdate: FormzStatus.pure));
    } catch (e) {
      emit(state.copyWith(
          statusUpdate: FormzStatus.submissionFailure,
          errorMessage: 'Gagal memperbarui profil anak'));
    }
  }

  void _onCreateChildEvent(CreateProfileEvent event, Emitter emit) async {
    emit(state.copyWith(statusCreate: FormzStatus.submissionInProgress));
    try {
      await _childRepository.setChild(state.child!);
      add(OnGetChildrenEvent());
      emit(
        state.copyWith(
          statusCreate: FormzStatus.submissionSuccess,
          child: null,
        ),
      );
      emit(state.copyWith(statusCreate: FormzStatus.pure));
    } catch (e) {
      emit(
        state.copyWith(
            statusCreate: FormzStatus.submissionFailure,
            errorMessage: 'Gagal membuat profil anak'),
      );
    }
  }

  void _onUpdateAvatarEvent(UpdateProfilePhotoEvent event, Emitter emit) async {
    emit(state.copyWith(
      statusUpdateAvatar: FormzStatus.submissionInProgress,
    ));
    try {
     final url = await _childRepository.updateChildAvatar(
        file: event.photo,
        id: event.id,
      );
      emit(state.copyWith(
        statusUpdateAvatar: FormzStatus.submissionSuccess,
        child: state.child?.copyWith(photoURL: url),
      ));
      emit(state.copyWith(
        statusUpdateAvatar: FormzStatus.pure,
      ));
      add(OnGetChildrenEvent());
    } catch (e) {
      emit(state.copyWith(
        statusUpdateAvatar: FormzStatus.submissionFailure,
        errorMessage: 'Gagal memperbarui foto profil anak',
      ));
    }
  }
}
