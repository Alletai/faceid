import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import '../../../widgets/app_bottom_nav.dart';
import '../../../widgets/k_spacers.dart';
import '../../../theme/app_theme.dart';
import 'widgets/camera_panel.dart';
import 'widgets/quick_actions.dart';
import '../state/dashboard_controller.dart';

/// Dashboard principal - Reproduz fielmente o layout da imagem 2
class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(dashboardControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bem-vindo',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              'Olá, Usuário!',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(BootstrapIcons.bell),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notificações - Em desenvolvimento')),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(dashboardControllerProvider.notifier).refresh(),
        child: SingleChildScrollView(
          padding: KPadding.a16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Seção de Controle de Turma
              _buildSectionHeader(context, 'Controle de Turma'),
              KSpacer.v12,
              Text(
                'Gerenciar, acessar e visualizar',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              KSpacer.v16,

              // Painel da câmera
              CameraPanel(
                cameraName: dashboardState.cameraName,
                isLive: dashboardState.isCameraLive,
                fps: dashboardState.fps,
              ),
              KSpacer.v24,

              // Ações Rápidas
              _buildSectionHeader(context, 'Ações Rápidas'),
              KSpacer.v16,
              const QuickActions(),
              KSpacer.v24,

              // Estatísticas do dia (se houver)
              if (dashboardState.stats.isNotEmpty) ...[
                _buildSectionHeader(context, 'Estatísticas de Hoje'),
                KSpacer.v16,
                _buildStatsGrid(context, dashboardState.stats),
              ],
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 1),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }

  Widget _buildStatsGrid(BuildContext context, Map<String, dynamic> stats) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard(
          context,
          'Total de IDs',
          stats['totalIds']?.toString() ?? '0',
          BootstrapIcons.people,
          AppTheme.accentCyan,
        ),
        _buildStatCard(
          context,
          'Alertas',
          stats['alerts']?.toString() ?? '0',
          BootstrapIcons.exclamation_triangle,
          AppTheme.warningOrange,
        ),
        _buildStatCard(
          context,
          'Uptime',
          '${stats['uptime']?.toString() ?? '0'}h',
          BootstrapIcons.clock,
          AppTheme.textSecondary,
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: KPadding.a16,
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          KSpacer.v8,
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
          ),
          KSpacer.v4,
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
