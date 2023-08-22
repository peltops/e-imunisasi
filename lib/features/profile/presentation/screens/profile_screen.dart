import 'package:eimunisasi/core/extension.dart';
import 'package:eimunisasi/core/utils/assets_constant.dart';
import 'package:eimunisasi/core/utils/constant.dart';
import 'package:eimunisasi/core/utils/themes/padding_constant.dart';
import 'package:eimunisasi/core/widgets/spacer.dart';
import 'package:eimunisasi/core/widgets/text.dart';
import 'package:eimunisasi/core/widgets/top_app_bar.dart';
import 'package:eimunisasi/features/profile/presentation/screens/parent_profile_screen.dart';
import 'package:eimunisasi/pages/widget/snackbar_custom.dart';
import 'package:eimunisasi/pages/wrapper.dart';
import 'package:eimunisasi/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/utils/themes/shape.dart';
import '../../../authentication/logic/bloc/authentication_bloc/authentication_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarPeltops(title: 'Profil'),
      body: Container(
        color: Colors.pink[100],
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 4,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: Shape.roundedM,
                ),
                padding: const EdgeInsets.all(AppPadding.paddingL),
                child: SvgPicture.asset(AppAssets.PROFILE_ILUSTRATION),
              ),
              VerticalSpacer(),
              Card(
                color: Colors.white,
                elevation: 0,
                child: ListTile(
                  shape: Shape.roundedRectangleM,
                  onTap: () => context.navigateTo(ParentProfileScreen()),
                  title: LabelText(text: 'Profil'),
                  trailing: Icon(Icons.keyboard_arrow_right_rounded),
                ),
              ),
              Expanded(
                child: Container(),
              ),
              _LogoutButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).primaryColor,
      child: ListTile(
        onTap: () {
          context.read<AuthenticationBloc>().add(LoggedOut());
        },
        title: LabelText(
          text: AppConstant.LOGOUT_LABEL,
          color: Colors.white,
        ),
        trailing: Icon(
          Icons.logout,
          color: Colors.white,
        ),
      ),
    );
  }
}
