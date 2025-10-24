import 'package:flutter/material.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import '../../../../models/log_entry.dart';
import '../../../../theme/app_theme.dart';
import '../../../../widgets/k_spacers.dart';

/// Item de log na lista
class LogItem extends StatefulWidget {
  final LogEntry logEntry;
  final VoidCallback onTap;

  const LogItem({
    super.key,
    required this.logEntry,
    required this.onTap,
  });

  @override
  State<LogItem> createState() => _LogItemState();
}

class _LogItemState extends State<LogItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      ),
      child: Column(
        children: [
          // Cabeçalho do log
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            child: Padding(
              padding: KPadding.a16,
              child: Row(
                children: [
                  // Ícone
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppTheme.secondaryNavy,
                      borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                    ),
                    child: const Icon(
                      BootstrapIcons.list_ul,
                      size: 20,
                    ),
                  ),
                  KSpacer.h12,

                  // Conteúdo
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.logEntry.title,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        KSpacer.v4,
                        Text(
                          widget.logEntry.status.displayName,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: _getStatusColor(widget.logEntry.status),
                              ),
                        ),
                      ],
                    ),
                  ),

                  // Ícone de expansão
                  Icon(
                    _isExpanded
                        ? BootstrapIcons.chevron_up
                        : BootstrapIcons.chevron_down,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),

          // Detalhes expandidos
          if (_isExpanded)
            Container(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  KSpacer.v8,

                  // Horário
                  _buildDetailRow(
                    context,
                    'Horário',
                    '${widget.logEntry.timestamp.hour.toString().padLeft(2, '0')}:${widget.logEntry.timestamp.minute.toString().padLeft(2, '0')}:${widget.logEntry.timestamp.second.toString().padLeft(2, '0')}',
                  ),
                  KSpacer.v8,

                  // Descrição
                  Text(
                    widget.logEntry.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  KSpacer.v12,

                  // Botão de ação
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: widget.onTap,
                      child: const Text('Ver Detalhes'),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }

  Color _getStatusColor(LogStatus status) {
    switch (status) {
      case LogStatus.pending:
        return AppTheme.textSecondary;
      case LogStatus.visualized:
        return AppTheme.successGreen;
      case LogStatus.alert:
        return AppTheme.warningOrange;
      case LogStatus.success:
        return AppTheme.successGreen;
    }
  }
}
