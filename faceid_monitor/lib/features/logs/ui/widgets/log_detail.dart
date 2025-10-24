import 'package:flutter/material.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import '../../../../models/log_entry.dart';
import '../../../../theme/app_theme.dart';
import '../../../../widgets/k_spacers.dart';

/// Modal de detalhes do log
class LogDetail extends StatelessWidget {
  final LogEntry logEntry;

  const LogDetail({
    super.key,
    required this.logEntry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      decoration: const BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.dividerColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          KSpacer.v24,

          // Header
          Padding(
            padding: KPadding.h24,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Detalhes do Log',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                IconButton(
                  icon: const Icon(BootstrapIcons.x_lg),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          KSpacer.v16,

          // Conteúdo
          Flexible(
            child: SingleChildScrollView(
              padding: KPadding.h24,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ID
                  _buildInfoCard(
                    context,
                    'ID',
                    logEntry.id,
                    BootstrapIcons.hash,
                  ),
                  KSpacer.v12,

                  // Timestamp
                  _buildInfoCard(
                    context,
                    'Data e Hora',
                    '${logEntry.timestamp.day.toString().padLeft(2, '0')}/${logEntry.timestamp.month.toString().padLeft(2, '0')}/${logEntry.timestamp.year} - ${logEntry.timestamp.hour.toString().padLeft(2, '0')}:${logEntry.timestamp.minute.toString().padLeft(2, '0')}:${logEntry.timestamp.second.toString().padLeft(2, '0')}',
                    BootstrapIcons.clock,
                  ),
                  KSpacer.v12,

                  // Título
                  _buildInfoCard(
                    context,
                    'Título',
                    logEntry.title,
                    BootstrapIcons.file_text,
                  ),
                  KSpacer.v12,

                  // Status
                  _buildInfoCard(
                    context,
                    'Status',
                    logEntry.status.displayName,
                    BootstrapIcons.info_circle,
                  ),
                  KSpacer.v12,

                  // Descrição
                  Container(
                    width: double.infinity,
                    padding: KPadding.a16,
                    decoration: BoxDecoration(
                      color: AppTheme.secondaryNavy,
                      borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              BootstrapIcons.align_start,
                              size: 16,
                              color: AppTheme.textSecondary,
                            ),
                            KSpacer.h8,
                            Text(
                              'Descrição',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                        KSpacer.v8,
                        Text(
                          logEntry.description,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),

                  // Pessoa (se houver)
                  if (logEntry.personName != null) ...[
                    KSpacer.v12,
                    _buildInfoCard(
                      context,
                      'Pessoa',
                      logEntry.personName!,
                      BootstrapIcons.person,
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Ações
          Padding(
            padding: KPadding.a24,
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Fechar'),
                  ),
                ),
                KSpacer.h12,
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Implementar ação
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Ação - Em desenvolvimento'),
                        ),
                      );
                    },
                    child: const Text('Visualizar'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Container(
      width: double.infinity,
      padding: KPadding.a16,
      decoration: BoxDecoration(
        color: AppTheme.secondaryNavy,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: AppTheme.textSecondary,
              ),
              KSpacer.h8,
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          KSpacer.v4,
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
