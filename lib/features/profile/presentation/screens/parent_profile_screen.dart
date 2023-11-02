import 'package:cached_network_image/cached_network_image.dart';
import 'package:eimunisasi/core/extension.dart';
import 'package:eimunisasi/core/loading.dart';
import 'package:eimunisasi/core/utils/list_constant.dart';
import 'package:eimunisasi/core/widgets/error.dart';
import 'package:eimunisasi/core/widgets/picker.dart';
import 'package:eimunisasi/core/widgets/spacer.dart';
import 'package:eimunisasi/core/widgets/text.dart';
import 'package:eimunisasi/core/widgets/top_app_bar.dart';
import 'package:eimunisasi/features/profile/logic/bloc/profile_bloc.dart';
import 'package:eimunisasi/injection.dart';
import 'package:eimunisasi/pages/widget/button_custom.dart';
import 'package:eimunisasi/pages/widget/image_picker.dart';
import 'package:eimunisasi/pages/widget/snackbar_custom.dart';
import 'package:eimunisasi/pages/widget/text_form_custom.dart';
import 'package:eimunisasi/services/user_database.dart';
import 'package:eimunisasi/utils/dismiss_keyboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:intl/intl.dart';

import '../../../../core/pair.dart';
import '../../../../core/utils/constant.dart';
import '../../../../core/utils/themes/padding_constant.dart';
import '../../../../core/widgets/dropdown.dart';

class ParentProfileScreen extends StatelessWidget {
  const ParentProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ProfileBloc>()..add(ProfileGetEvent()),
      child: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state.statusUpdate.isSubmissionFailure) {
            snackbarCustom(state.errorMessage ?? 'Gagal menyimpan data')
                .show(context);
          } else if (state.statusUpdate.isSubmissionSuccess) {
            snackbarCustom('Berhasil menyimpan data').show(context);
          }
        },
        child: Scaffold(
          backgroundColor: Colors.pink[100],
          appBar: AppBarPeltops(title: AppConstant.APP_BAR_PROFILE),
          body: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              final bloc = context.read<ProfileBloc>();
              if (state.statusGet.isSubmissionInProgress) {
                return LoadingScreen();
              }
              if (state.statusGet.isSubmissionSuccess) {
                return Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: AppPadding.paddingM),
                  child: Container(
                    child: ListView(
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
                              onTap: () {
                                Picker.pickDate(
                                  context,
                                  (date) => {
                                    bloc.add(OnChangeDateOfBirthEvent(date))
                                  },
                                );
                              },
                              readOnly: true,
                              label: AppConstant.LABEL_DATE_OF_BIRTH,
                              hintText: state.user?.tanggalLahir != null
                                  ? DateFormat('dd-MM-yyyy')
                                      .format(state.user!.tanggalLahir!)
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
          loading: state.statusUpdate.isSubmissionInProgress,
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
    final _currentUser = FirebaseAuth.instance.currentUser!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: [
          url == null || url!.isEmpty
              ? CircleAvatar(
                  foregroundColor: Colors.white,
                  radius: 50.0,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.bottomRight,
                        child: CircleAvatar(
                          foregroundColor: Colors.white,
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          radius: 15,
                          child: IconButton(
                              alignment: Alignment.center,
                              icon: Icon(
                                Icons.photo_camera,
                                size: 15.0,
                              ),
                              onPressed: () async {
                                ModalPickerImage().showPicker(
                                  context,
                                  (val) {
                                    UserService().updateUserAvatar(val);
                                  },
                                );
                              }),
                        ),
                      ),
                    ],
                  ),
                )
              : CircleAvatar(
                  radius: 50.0,
                  backgroundColor: Colors.transparent,
                  backgroundImage: CachedNetworkImageProvider(
                      'https://i.pinimg.com/originals/d2/4d/db/d24ddb8271b8ea9b4bbf4b67df8cbc01.gif',
                      scale: 0.1),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.transparent,
                          backgroundImage:
                              CachedNetworkImageProvider(url!, scale: 0.1),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: CircleAvatar(
                          radius: 15,
                          child: IconButton(
                              alignment: Alignment.center,
                              icon: Icon(
                                Icons.photo_camera,
                                size: 15.0,
                              ),
                              onPressed: () async {
                                ModalPickerImage().showPicker(context, (val) {
                                  UserService().updateUserAvatar(val);
                                });
                              }),
                        ),
                      ),
                    ],
                  ),
                ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _currentUser.email != null
                  ? _currentUser.emailVerified
                      ? Text(' (Terverifikasi)')
                      : GestureDetector(
                          onTap: () async {
                            try {
                              await _currentUser.sendEmailVerification();
                              snackbarCustom(
                                      "${AppConstant.EMAIL_VERIFICATION_SENT} ${_currentUser.email}")
                                  .show(context);
                            } on FirebaseException catch (e) {
                              snackbarCustom(e.message).show(context);
                            } catch (e) {
                              snackbarCustom(
                                      "${AppConstant.ERROR_OCCURRED} \n $e")
                                  .show(context);
                            }
                          },
                          child: Text(
                            AppConstant.EMAIL_NOT_VERIFIED,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        )
                  : Container(),
            ],
          ),
        ],
      ),
    );
  }
}
