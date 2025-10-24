import 'package:flutter/material.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import '../../../../theme/app_theme.dart';
import '../../../../widgets/k_spacers.dart';

class CapturePreview extends StatelessWidget {
  const CapturePreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: KPadding.a16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Preview da Câmera',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.statusLive.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: AppTheme.statusLive,
                          shape: BoxShape.circle,
                        ),
                      ),
                      KSpacer.h4,
                      Text(
                        'Ativo',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.statusLive,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Preview area
          AspectRatio(
            aspectRatio: 4 / 3,
            child: Container(
              margin: KPadding.h16,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              ),
              child: Stack(
                children: [
                  // Placeholder
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          BootstrapIcons.camera_video,
                          size: 48,
                          color: AppTheme.textSecondary,
                        ),
                        KSpacer.v12,
                        Text(
                          'Câmera ativa',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),

                  // Overlay de guia
                  Center(
                    child: Container(
                      width: 200,
                      height: 250,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppTheme.accentCyan.withOpacity(0.5),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                      ),
                      child: const Center(
                        child: Text(
                          'Posicione o rosto\naqui',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppTheme.accentCyan,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          KSpacer.v16,

          // Informações
          Padding(
            padding: KPadding.h16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildInfoChip(context, 'Resolução', '1920x1080'),
                _buildInfoChip(context, 'FPS', '30'),
                _buildInfoChip(context, 'Qualidade', 'Alta'),
              ],
            ),
          ),
          KSpacer.v16,
        ],
      ),
    );
  }

  Widget _buildInfoChip(BuildContext context, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.secondaryNavy,
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          KSpacer.v4,
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.accentCyan,
                ),
          ),
        ],
      ),
    );
  }
}
