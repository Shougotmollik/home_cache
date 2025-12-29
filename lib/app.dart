import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:home_cache/config/helper/app_snackbar.dart';
import 'package:home_cache/config/theme/app_theme.dart';
import 'package:home_cache/controller_binder.dart';
import 'package:home_cache/config/route/routes.dart';

import 'config/route/route_names.dart';

GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
// final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
//     GlobalKey<ScaffoldMessengerState>();

class HomeCache extends StatelessWidget {
  const HomeCache({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Home Cache',
          scaffoldMessengerKey: rootScaffoldMessengerKey,
          themeMode: ThemeMode.light,
          theme: AppTheme.lightTheme,
          initialRoute: RouteNames.splash,
          getPages: AppRoutes.pages,
          initialBinding: ControllerBinder(),
        );
      },
    );
  }
}
