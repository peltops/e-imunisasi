import 'package:eimunisasi/core/extension.dart';
import 'package:eimunisasi/core/loading.dart';
import 'package:eimunisasi/core/utils/list_constant.dart';
import 'package:eimunisasi/core/widgets/error.dart';
import 'package:eimunisasi/core/widgets/picker.dart';
import 'package:eimunisasi/core/widgets/spacer.dart';
import 'package:eimunisasi/core/widgets/text.dart';
import 'package:eimunisasi/core/widgets/top_app_bar.dart';
import 'package:eimunisasi/injection.dart';
import 'package:eimunisasi/core/widgets/button_custom.dart';
import 'package:eimunisasi/core/widgets/image_picker.dart';
import 'package:eimunisasi/core/widgets/snackbar_custom.dart';
import 'package:eimunisasi/core/widgets/text_form_custom.dart';
import 'package:eimunisasi/utils/dismiss_keyboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../../../../core/pair.dart';
import '../../../../core/utils/constant.dart';
import '../../../../core/utils/themes/padding_constant.dart';
import '../../../../core/widgets/dropdown.dart';
import '../../../../core/widgets/profile_picture.dart';
import '../../logic/blocs/parentBloc/profile_bloc.dart';

class ParentProfileScreen extends StatelessWidget {
  const ParentProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ProfileBloc>()..add(ProfileGetEvent()),
      child: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state.statusUpdate.isFailure) {
            snackbarCustom(state.errorMessage ?? 'Gagal menyimpan data')
                .show(context);
          } else if (state.statusUpdate.isSuccess) {
            snackbarCustom('Berhasil menyimpan data').show(context);
          } else if (state.statusUpdateAvatar.isFailure) {
            snackbarCustom(state.errorMessage ?? 'Gagal mengubah foto')
                .show(context);
          } else if (state.statusUpdateAvatar.isSuccess) {
            snackbarCustom('Berhasil mengubah foto').show(context);
          }
        },
        child: Scaffold(
          backgroundColor: Colors.pink[100],
          appBar: AppBarPeltops(title: AppConstant.APP_BAR_PROFILE),
          body: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              final bloc = context.read<ProfileBloc>();
              if (state.statusGet.isInProgress) {
                return LoadingScreen();
              }
              if (state.statusGet.isSuccess) {
                return Card(
                  margin: EdgeInsets.all(AppPadding.paddingM),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppPadding.paddingM),
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        VerticalSpacer(),
                        _PhotoProfile(url: state.user?.avatarURL),
                        VerticalSpacer(),
                        TitleText(text: AppConstant.TITLE_PARENT_PROFILE),
                        VerticalSpacer(),
                        TextFormCustom(
                          initialValue: state.user?.momName,
                          label: AppConstant.LABEL_FULL_NAME_BY_IDENTITY,
                          onChanged: (val) {
                            bloc.add(OnChangeNameEvent(val.trim()));
                          },
                        ),
                        Row(children: [
                          Expanded(
                            child: TextFormCustom(
                              initialValue: state.user?.tempatLahir,
                              label: AppConstant.LABEL_PLACE_OF_BIRTH,
                              onChanged: (val) {
                                bloc.add(OnChangePlaceOfBirthEvent(val.trim()));
                              },
                            ),
                          ),
                          HorizontalSpacer(),
                          Expanded(
                            child: TextFormCustom(
                              onTap: () async {
                                final date = await Picker.pickDate(context);
                                if (date != null) {
                                  bloc.add(OnChangeDateOfBirthEvent(date));
                                }
                              },
                              readOnly: true,
                              label: AppConstant.LABEL_DATE_OF_BIRTH,
                              hintText: state.user?.tanggalLahir != null
                                  ? (state.user?.tanggalLahir).formattedDate()
                                  : AppConstant.LABEL_CHOICE_DATE_OF_BIRTH,
                            ),
                          ),
                        ]),
                        TextFormCustom(
                          keyboardType: TextInputType.number,
                          initialValue: state.user?.noKTP,
                          label: AppConstant.LABEL_NO_NIK,
                          onChanged: (val) {
                            bloc.add(OnChangeIdentityNumberEvent(val.trim()));
                          },
                        ),
                        VerticalSpacer(val: 5),
                        TextFormCustom(
                          keyboardType: TextInputType.number,
                          initialValue: state.user?.noKK,
                          label: AppConstant.LABEL_NO_KK,
                          onChanged: (val) {
                            bloc.add(OnChangeFamilyCardNumberEvent(val.trim()));
                          },
                        ),
                        VerticalSpacer(val: 5),
                        DropdownPeltops(
                          label: AppConstant.LABEL_JOB,
                          initialValue: state.user?.pekerjaanIbu ?? emptyString,
                          hint: AppConstant.LABEL_CHOICE_JOB,
                          listItem:
                              ListConstant.JOB.map((e) => Pair(e, e)).toList(),
                          onChanged: (val) {
                            bloc.add(OnChangeJobEvent(val ?? emptyString));
                          },
                        ),
                        VerticalSpacer(val: 5),
                        DropdownPeltops(
                          label: AppConstant.LABEL_BLOOD_TYPE,
                          initialValue: state.user?.golDarahIbu ?? emptyString,
                          listItem: ListConstant.TYPE_BLOOD
                              .map((e) => Pair(e, e))
                              .toList(),
                          onChanged: (val) {
                            bloc.add(
                                OnChangeBloodTypeEvent(val ?? emptyString));
                          },
                        ),
                        VerticalSpacer(),
                        TitleText(text: AppConstant.TITLE_INFO_ACCOUNT),
                        VerticalSpacer(val: 5),
                        if (state.user?.email != null &&
                            state.user?.email != emptyString)
                          TextFormCustom(
                            readOnly: true,
                            initialValue: state.user?.email,
                            label: AppConstant.LABEL_EMAIL,
                            onChanged: (val) {},
                          ),
                        if (state.user?.nomorhpIbu != null &&
                            state.user?.nomorhpIbu != emptyString)
                          TextFormCustom(
                            readOnly: true,
                            initialValue: state.user?.nomorhpIbu,
                            label: AppConstant.LABEL_MOM_PHONE_NUMBER,
                            onChanged: (val) {},
                          ),
                        VerticalSpacer(),
                        _SaveButton(),
                        VerticalSpacer(),
                      ],
                    ),
                  ),
                );
              }
              return ErrorContainer();
            },
          ),
        ),
      ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        return ButtonCustom(
          loading: state.statusUpdate.isInProgress,
          child: ButtonText(text: AppConstant.SAVE),
          onPressed: () {
            dismissKeyboard(context);
            context.read<ProfileBloc>().add(ProfileUpdateEvent());
          },
        );
      },
    );
  }
}

class _PhotoProfile extends StatelessWidget {
  final String? url;

  const _PhotoProfile({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _currentUser = FirebaseAuth.instance.currentUser;
    final bloc = context.read<ProfileBloc>();
    final url = _currentUser?.photoURL ?? this.url;
    final isVerified =
        _currentUser?.email != null && _currentUser?.emailVerified == true;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: [
          BlocBuilder<ProfileBloc, ProfileState>(
            buildWhen: (previous, current) {
              return previous.statusUpdateAvatar != current.statusUpdateAvatar;
            },
            builder: (context, state) {
              if (state.statusUpdateAvatar.isInProgress) {
                return const CircularProgressIndicator.adaptive();
              }
              return ProfilePictureFromUrl(
                url: url,
                onPressedCamera: () async {
                  ModalPickerImage.showPicker(context, (file) {
                    bloc.add(ProfileUpdateAvatarEvent(file));
                  });
                },
              );
            },
          ),
          VerticalSpacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isVerified) ...[
                LabelText(text: AppConstant.VERIFIED),
              ],
              if (!isVerified) ...[
                GestureDetector(
                  onTap: () {
                    bloc.add(VerifyEmailEvent());
                  },
                  child: LabelText(text: AppConstant.NOT_VERIFIED),
                ),
              ]
            ],
          ),
        ],
      ),
    );
  }
}
