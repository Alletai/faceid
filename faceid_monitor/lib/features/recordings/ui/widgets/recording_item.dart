import 'package:flutter/material.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import '../../../../models/recording.dart';
import '../../../../theme/app_theme.dart';
import '../../../../widgets/k_spacers.dart';

/// Item de gravação na lista
class RecordingItem extends StatelessWidget {
  final Recording recording;
  final VoidCallback onTap;

  const RecordingItem({
    super.key,
    required this.recording,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título da gravação
          Padding(
            padding: KPadding.a16,
            child: Row(
              children: [
                Text(
                  'Gravação dia ${recording.timestamp.day.toString().padLeft(2, '0')}/${recording.timestamp.month.toString().padLeft(2, '0')}/${recording.timestamp.year}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(BootstrapIcons.chevron_down, size: 16),
                  onPressed: onTap,
                ),
              ],
            ),
          ),

          // Câmera
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              recording.cameraName,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          KSpacer.v12,

          // Preview da gravação
          InkWell(
            onTap: onTap,
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                margin: KPadding.h16,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                ),
                child: Stack(
                  children: [
                    // Thumbnail placeholder
                    const Center(
                      child: Icon(
                        BootstrapIcons.camera_video,
                        size: 48,
                        color: AppTheme.textSecondary,
                      ),
                    ),

                    // Play button
                    Center(
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: AppTheme.secondaryNavy.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                        ),
                        child: const Icon(
                          BootstrapIcons.play_fill,
                          size: 28,
                        ),
                      ),
                    ),

                    // Badge LIVE se estiver ao vivo
                    if (recording.status == RecordingStatus.available)
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
          ),
          KSpacer.v16,
        ],
      ),
    );
  }
}
