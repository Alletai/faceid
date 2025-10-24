import 'package:flutter/material.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:go_router/go_router.dart';
import '../../../../theme/app_theme.dart';
import '../../../../widgets/k_spacers.dart';

/// Widget de ações rápidas
class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _QuickActionButton(
          icon: BootstrapIcons.list_ul,
          label: 'Logs',
          onTap: () => context.push('/logs'),
        ),
        _QuickActionButton(
          icon: BootstrapIcons.camera,
          label: 'Fotos',
          onTap: () => context.push('/capture'),
        ),
        _QuickActionButton(
          icon: BootstrapIcons.play_circle,
          label: 'Gravações',
          onTap: () => context.push('/recordings'),
        ),
      ],
    );
  }
}

/// Botão de ação rápida
class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      child: Container(
        width: 100,
        padding: KPadding.a16,
        decoration: BoxDecoration(
          color: AppTheme.cardDark,
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppTheme.secondaryNavy,
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              ),
              child: Icon(
                icon,
                size: 24,
                color: AppTheme.accentCyan,
              ),
            ),
            KSpacer.v8,
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
