import 'package:eimunisasi/pages/home/bantuan/bantuan_page.dart';
import 'package:eimunisasi/pages/home/utama/main.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/utils/constant.dart';
import '../../../../pages/home/pesan/pesan_page.dart';
import '../../../../pages/widget/snackbar_custom.dart';
import '../../../authentication/logic/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../authentication/presentation/screens/auth/login_phone_screen.dart';
import '../../../profile/presentation/screens/profile_screen.dart';
import '../../logic/buttom_navbar/bottom_navbar_cubit.dart';

class BottomNavbarWrapper extends StatelessWidget {
  const BottomNavbarWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => LoginPhoneScreen()
            ),
            (route) => false,
          );
          snackbarCustom(AppConstant.LOGOUT_SUCCEED);
        }
      },
      child: BlocProvider(
        create: (context) => BottomNavbarCubit(),
        child: Scaffold(
          extendBodyBehindAppBar: false,
          body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
              if (state is Authenticated) {
                return BlocBuilder<BottomNavbarCubit, BottomNavbarState>(
                  builder: (contextNavbar, stateNavbar) {
                    if (stateNavbar is BottomNavbarHome) {
                      return const MainPage();
                    } else if (stateNavbar is BottomNavbarProfile) {
                      return const ProfilePage();
                    } else if (stateNavbar is BottomNavbarMessage) {
                      return PesanPage();
                    } else if (stateNavbar is BottomNavbarSupport) {
                      return BantuanPage();
                    } else {
                      return Placeholder();
                    }
                  },
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
          bottomNavigationBar:
              BlocBuilder<BottomNavbarCubit, BottomNavbarState>(
            builder: (context, state) {
              return BottomNavigationBar(
                showSelectedLabels: false,
                showUnselectedLabels: false,
                type: BottomNavigationBarType.fixed,
                currentIndex: state.itemIndex,
                onTap: (value) =>
                    context.read<BottomNavbarCubit>().navigateTo(value),
                items: [
                  BottomNavigationBarItem(
                    icon: FaIcon(
                      FontAwesomeIcons.houseChimneyMedical,
                      size: 20,
                    ),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: FaIcon(
                      FontAwesomeIcons.userDoctor,
                      size: 20,
                    ),
                    label: 'Profile',
                  ),
                  BottomNavigationBarItem(
                    icon: FaIcon(
                      FontAwesomeIcons.solidBell,
                      size: 20,
                    ),
                    label: 'Message',
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
