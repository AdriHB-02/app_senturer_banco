import 'package:flutter/material.dart';
import '../../presentation/splash/splash_screen.dart';
import '../../presentation/home/home_page.dart';
import '../../presentation/cuentas/cuentas_page.dart';
import '../../presentation/transferencias/transferencias_page.dart';
import '../../presentation/perfil/perfil_page.dart';
import '../constants/app_strings.dart';

class RouteNames {
  RouteNames._();

  static const String splash = '/';
  static const String home = '/home';
  static const String cuentas = '/cuentas';
  static const String transferencias = '/transferencias';
  static const String perfil = '/perfil';
}

class FlyoutRouteConfig {
  final String route;
  final String label;
  final IconData icon;
  final String? imageAsset;
  final List<FlyoutTabConfig>? tabs;
  final bool isMenuAction;
  final VoidCallback? onAction;

  const FlyoutRouteConfig({
    required this.route,
    required this.label,
    required this.icon,
    this.imageAsset,
    this.tabs,
    this.isMenuAction = false,
    this.onAction,
  });
}

class FlyoutTabConfig {
  final String label;
  final IconData icon;

  const FlyoutTabConfig({
    required this.label,
    required this.icon,
  });
}

class AppRouter {
  AppRouter._();

  static const List<FlyoutRouteConfig> flyoutRoutes = [
    FlyoutRouteConfig(
      route: RouteNames.home,
      label: AppStrings.menuInicio,
      icon: Icons.home_outlined,
    ),
    FlyoutRouteConfig(
      route: RouteNames.cuentas,
      label: AppStrings.menuCuentas,
      icon: Icons.account_balance_wallet_outlined,
      tabs: [
        FlyoutTabConfig(
          label: AppStrings.tabMisCuentas,
          icon: Icons.credit_card_outlined,
        ),
        FlyoutTabConfig(
          label: AppStrings.tabMovimientos,
          icon: Icons.receipt_long_outlined,
        ),
      ],
    ),
    FlyoutRouteConfig(
      route: RouteNames.transferencias,
      label: AppStrings.menuTransferencias,
      icon: Icons.swap_horiz_outlined,
    ),
    FlyoutRouteConfig(
      route: RouteNames.perfil,
      label: AppStrings.menuPerfil,
      icon: Icons.person_outline,
    ),
  ];

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.splash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
          settings: settings,
        );
      case RouteNames.home:
        return MaterialPageRoute(
          builder: (_) => const HomePage(),
          settings: settings,
        );
      case RouteNames.cuentas:
        return MaterialPageRoute(
          builder: (_) => const CuentasPage(),
          settings: settings,
        );
      case RouteNames.transferencias:
        return MaterialPageRoute(
          builder: (_) => const TransferenciasPage(),
          settings: settings,
        );
      case RouteNames.perfil:
        return MaterialPageRoute(
          builder: (_) => const PerfilPage(),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const HomePage(),
          settings: settings,
        );
    }
  }

  static void navigateTo(BuildContext context, String routeName) {
    Navigator.of(context).pushReplacementNamed(routeName);
  }

  static void navigateToAndCloseDrawer(BuildContext context, String routeName) {
    Navigator.of(context).pop();
    Navigator.of(context).pushReplacementNamed(routeName);
  }
}
