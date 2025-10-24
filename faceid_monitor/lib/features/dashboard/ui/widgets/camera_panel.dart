import 'package:flutter/material.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import '../../../../theme/app_theme.dart';
import '../../../../widgets/k_spacers.dart';

/// Painel de visualização da câmera
class CameraPanel extends StatelessWidget {
  final String cameraName;
  final bool isLive;
  final int fps;

  const CameraPanel({
    super.key,
    required this.cameraName,
    required this.isLive,
    required this.fps,
  });

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
          // Header com nome da câmera
          Padding(
            padding: KPadding.a16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  cameraName,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                _buildStatusBadge(),
              ],
            ),
          ),

          // Preview da câmera
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              margin: KPadding.h16,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              ),
              child: Stack(
                children: [
                  // Placeholder da câmera
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isLive ? BootstrapIcons.camera_video : BootstrapIcons.camera_video_off,
                          size: 48,
                          color: AppTheme.textSecondary,
                        ),
                        KSpacer.v12,
                        Text(
                          isLive
                              ? 'Transmissão ao vivo'
                              : 'Câmera offline',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),

                  // Controles de playback no centro
                  Center(
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: AppTheme.secondaryNavy.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          BootstrapIcons.pause_fill,
                          size: 32,
                        ),
                        onPressed: () {
                          // TODO: Implementar controle de playback
                        },
                      ),
                    ),
                  ),

                  // Badge LIVE no canto superior esquerdo
                  if (isLive)
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.statusLive,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                            KSpacer.h4,
                            Text(
                              'LIVE',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          KSpacer.v16,
        ],
      ),
    );
  }

  Widget _buildStatusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: (isLive ? AppTheme.statusLive : AppTheme.statusOffline).withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: isLive ? AppTheme.statusLive : AppTheme.statusOffline,
              shape: BoxShape.circle,
            ),
          ),
          KSpacer.h4,
          Text(
            isLive ? 'Online' : 'Offline',
            style: TextStyle(
              fontSize: 12,
              color: isLive ? AppTheme.statusLive : AppTheme.statusOffline,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
