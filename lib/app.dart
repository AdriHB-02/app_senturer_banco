import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';

class AppSenturer extends StatelessWidget {
  const AppSenturer({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SENTURER',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: RouteNames.splash,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
