import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/router/app_router.dart';
import 'flyout_header.dart';
import 'flyout_item.dart';
import 'flyout_footer.dart';

class FlyoutMenu extends StatelessWidget {
  const FlyoutMenu({super.key});

  Future<void> _launchUrl(BuildContext context) async {
    final uri = Uri.parse(AppStrings.urlOficial);

    try {
      final canLaunch = await canLaunchUrl(uri);
      if (!canLaunch) {
        throw Exception('Cannot launch URL');
      }
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(AppStrings.errorUrlLaunch),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _exitApp() {
    // En Flutter web/móvil, esto cierra el drawer y vuelve
    // En producción móvil real se usaría SystemNavigator.pop()
    // o platform channels para cerrar la app
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ignore: use_build_context_synchronously
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name;

    return Drawer(
      child: Column(
        children: [
          const FlyoutHeader(),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const Divider(height: 1),
                ...AppRouter.flyoutRoutes.map((route) {
                  final isActive = currentRoute == route.route;
                  return FlyoutItem(
                    route: route,
                    isActive: isActive,
                    onTap: () {
                      Navigator.of(context).pop();
                      if (route.route != currentRoute) {
                        Navigator.of(context).pushReplacementNamed(route.route);
                      }
                    },
                  );
                }),
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.language,
                            color: AppColors.primary,
                          ),
                        ),
                        title: const Text(
                          AppStrings.menuItemVisitarWeb,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onTap: () => _launchUrl(context),
                      ),
                      ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.error.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.exit_to_app,
                            color: AppColors.error,
                          ),
                        ),
                        title: const Text(
                          AppStrings.menuItemSalir,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: AppColors.error,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          _exitApp();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const FlyoutFooter(),
        ],
      ),
    );
  }
}
