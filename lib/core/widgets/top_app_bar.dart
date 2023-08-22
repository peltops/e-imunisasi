import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// AppBar(
//         backgroundColor: Colors.pink[300],
//         elevation: 0,
//         title: Text(
//           'Profil',
//           style: TextStyle(fontWeight: FontWeight.w700),
//         ),
//         centerTitle: true,
//       ),

class AppBarPeltops extends StatelessWidget implements PreferredSizeWidget {
  const AppBarPeltops({
    Key? key,
    required this.title,
    this.actions,
    this.leading,
    this.bottom,
    this.elevation = 0.0,
    this.brightness,
    this.iconTheme,
    this.textTheme,
    this.primary = true,
    this.centerTitle = true,
    this.titleSpacing = NavigationToolbar.kMiddleSpacing,
    this.toolbarOpacity = 1.0,
    this.bottomOpacity = 1.0,
    this.automaticallyImplyLeading = true,
  })  : preferredSize = const Size.fromHeight(kToolbarHeight + 10),
        super(key: key);

  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final PreferredSizeWidget? bottom;
  final double? elevation;
  final Brightness? brightness;
  final IconThemeData? iconTheme;
  final TextTheme? textTheme;
  final bool primary;
  final bool? centerTitle;
  final double titleSpacing;
  final double toolbarOpacity;
  final double bottomOpacity;
  final bool automaticallyImplyLeading;

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
      actions: actions,
      leading: leading,
      bottom: bottom,
      elevation: elevation,
      backgroundColor: Colors.pink[300],
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      iconTheme: iconTheme,
      toolbarTextStyle: textTheme?.titleLarge,
      titleTextStyle: textTheme?.titleLarge,
      primary: primary,
      centerTitle: centerTitle,
      titleSpacing: titleSpacing,
      toolbarOpacity: toolbarOpacity,
      bottomOpacity: bottomOpacity,
      automaticallyImplyLeading: automaticallyImplyLeading,
    );
  }
}
