import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import '../../../widgets/app_appbar.dart';
import '../../../widgets/app_bottom_nav.dart';
import '../../../widgets/k_spacers.dart';
import '../../../theme/app_theme.dart';
import 'widgets/capture_preview.dart';
import '../state/capture_controller.dart';
class CapturePage extends ConsumerWidget {
  const CapturePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final captureState = ref.watch(captureControllerProvider);

    return Scaffold(
      appBar: const AppAppBar(
        title: 'Captura de Fotos',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: KPadding.a16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Preview da câmera
            const CapturePreview(),
            KSpacer.v24,

            // Botões de ação
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ref.read(captureControllerProvider.notifier).capture();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Foto capturada!'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                    icon: const Icon(BootstrapIcons.camera),
                    label: const Text('Capturar'),
                  ),
                ),
                KSpacer.h12,
                OutlinedButton.icon(
                  onPressed: () {
                    ref.read(captureControllerProvider.notifier).clear();
                  },
                  icon: const Icon(BootstrapIcons.trash),
                  label: const Text('Limpar'),
                ),
              ],
            ),
            KSpacer.v24,

            // Grid de fotos capturadas
            if (captureState.capturedPhotos.isNotEmpty) ...[
              Text(
                'Fotos Capturadas (${captureState.capturedPhotos.length})',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              KSpacer.v16,
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: captureState.capturedPhotos.length,
                itemBuilder: (context, index) {
                  final photo = captureState.capturedPhotos[index];
                  return _buildPhotoThumbnail(context, ref, photo, index);
                },
              ),
              KSpacer.v24,

              // Botões de ação da sessão
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        ref.read(captureControllerProvider.notifier).saveDraft();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Rascunho salvo!'),
                          ),
                        );
                      },
                      icon: const Icon(BootstrapIcons.save),
                      label: const Text('Salvar Rascunho'),
                    ),
                  ),
                  KSpacer.h12,
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ref.read(captureControllerProvider.notifier).saveAll();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Fotos salvas com sucesso!'),
                          ),
                        );
                      },
                      icon: const Icon(BootstrapIcons.cloud_upload),
                      label: const Text('Salvar Tudo'),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 1),
    );
  }

  Widget _buildPhotoThumbnail(
      BuildContext context, WidgetRef ref, String photoId, int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        border: Border.all(color: AppTheme.dividerColor),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Placeholder da foto
          const Center(
            child: Icon(
              BootstrapIcons.image,
              size: 32,
              color: AppTheme.textSecondary,
            ),
          ),

          // Número da foto
          Positioned(
            top: 4,
            left: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppTheme.primaryNavy.withOpacity(0.8),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '${index + 1}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),

          // Botão de remover
          Positioned(
            top: 4,
            right: 4,
            child: InkWell(
              onTap: () {
                ref
                    .read(captureControllerProvider.notifier)
                    .removePhoto(photoId);
              },
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppTheme.errorRed.withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  BootstrapIcons.x,
                  size: 12,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
