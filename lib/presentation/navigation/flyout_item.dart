import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/router/app_router.dart';

class FlyoutItem extends StatelessWidget {
  final FlyoutRouteConfig route;
  final bool isActive;
  final VoidCallback onTap;

  const FlyoutItem({
    super.key,
    required this.route,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary.withValues(alpha: 0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.primary
                : AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            route.icon,
            color: isActive ? AppColors.textOnPrimary : AppColors.primary,
            size: 22,
          ),
        ),
        title: Text(
          route.label,
          style: TextStyle(
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            color: isActive ? AppColors.primary : AppColors.textPrimary,
          ),
        ),
        trailing: route.tabs != null && route.tabs!.isNotEmpty
            ? Icon(
                Icons.chevron_right,
                color: isActive ? AppColors.primary : AppColors.textHint,
              )
            : null,
        onTap: onTap,
      ),
    );
  }
}
