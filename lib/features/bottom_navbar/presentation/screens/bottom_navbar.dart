import 'package:eimunisasi/routers/route_paths/root_route_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/constant.dart';
import '../../../../core/widgets/snackbar_custom.dart';
import '../../../home/presentation/screens/home_screen.dart';
import '../../../message/presentation/screens/pesan_page.dart';
import '../../../authentication/logic/bloc/authentication_bloc/authentication_bloc.dart';
import '../../../profile/presentation/screens/profile_screen.dart';
import '../../logic/buttom_navbar/bottom_navbar_cubit.dart';

class BottomNavbarWrapper extends StatelessWidget {
  const BottomNavbarWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          context.pushReplacement(
            RootRoutePaths.root.fullPath,
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
                      return const HomeScreen();
                    } else if (stateNavbar is BottomNavbarProfile) {
                      return const ProfilePage();
                    } else if (stateNavbar is BottomNavbarMessage) {
                      return PesanPage();
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
