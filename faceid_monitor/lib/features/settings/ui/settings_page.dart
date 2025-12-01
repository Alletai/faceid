import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../theme/app_theme.dart';
import '../../../theme/theme_controller.dart';
import '../../../widgets/app_bottom_nav.dart';
import '../../../widgets/k_spacers.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuracoes'),
      ),
      body: Padding(
        padding: KPadding.a16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSectionTitle(context, 'Aparencia'),
            KSpacer.v12,
            _buildCard(
              context,
              child: Row(
                children: [
                  _buildIconBadge(
                    context,
                    icon: BootstrapIcons.moon_stars,
                    isActive: isDark,
                  ),
                  KSpacer.h12,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Modo escuro',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        KSpacer.v4,
                        Text(
                          isDark
                              ? 'Tema escuro ativo'
                              : 'Toque para ativar o tema escuro',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Switch.adaptive(
                    value: isDark,
                    activeColor: AppTheme.accentCyan,
                    onChanged: (value) {
                      ref.read(themeModeProvider.notifier).state =
                          value ? ThemeMode.dark : ThemeMode.light;
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 0),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }

  Widget _buildCard(BuildContext context, {required Widget child}) {
    return Container(
      padding: KPadding.a16,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        border: Border.all(
          color: Theme.of(context).dividerColor,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildIconBadge(BuildContext context,
      {required IconData icon, required bool isActive}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: (isActive ? AppTheme.accentCyan : AppTheme.surfaceMuted(context))
            .withOpacity(isActive ? 0.25 : 0.18),
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(
          color: isActive ? AppTheme.accentCyan : Theme.of(context).dividerColor,
        ),
      ),
      child: Icon(
        icon,
        color: isActive ? AppTheme.accentCyan : Theme.of(context).iconTheme.color,
      ),
    );
  }
}
