import 'package:eimunisasi/features/profile/data/models/child_model.dart';
import 'package:eimunisasi/routers/route_paths/profile_route_paths.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../features/profile/logic/blocs/childBloc/child_profile_bloc.dart';
import '../features/profile/presentation/screens/child_profile_screen.dart';
import '../features/profile/presentation/screens/list_children_screen.dart';

class ProfileRouter {
  static List<RouteBase> routes = [
    GoRoute(
      path: ProfileRoutePaths.children.path,
      builder: (_, __) => const ListChildrenScreen(),
      routes: [
        GoRoute(
          path: ProfileRoutePaths.addChildren.path,
          builder: (_, state) => BlocProvider.value(
            value: (state.extra as Map<String, dynamic>)['bloc']
                as ChildProfileBloc,
            child: ChildProfileScreen(
              mode: ChildProfileScreenMode.add,
              child: ChildModel.empty(),
            ),
          ),
        ),
        GoRoute(
          path: ProfileRoutePaths.editChildren.path,
          builder: (_, state) => BlocProvider.value(
            value: (state.extra as Map<String, dynamic>)['bloc']
                as ChildProfileBloc,
            child: ChildProfileScreen(
              mode: ChildProfileScreenMode.edit,
              child: (state.extra as Map<String, dynamic>)['child'],
            ),
          ),
        ),
      ],
    ),
  ];
}
