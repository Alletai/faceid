import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../../widgets/app_appbar.dart';
import '../../../widgets/app_bottom_nav.dart';
import '../../../widgets/app_loading_indicator.dart';
import '../../../widgets/app_empty_state.dart';
import '../../../widgets/app_error_state.dart';
import '../../../widgets/k_spacers.dart';
import '../../../theme/app_theme.dart';
import '../../../models/recording.dart';
import 'widgets/calendar_widget.dart';
import 'widgets/recording_item.dart';
import '../state/recordings_controller.dart';

class RecordingsPage extends ConsumerStatefulWidget {
  const RecordingsPage({super.key});
  @override
  ConsumerState<RecordingsPage> createState() => _RecordingsPageState();
}

class _RecordingsPageState extends ConsumerState<RecordingsPage> {
  final PagingController<int, Recording> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await ref
          .read(recordingsControllerProvider.notifier)
          .fetchRecordings(pageKey);

      final isLastPage = newItems.length < 10;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedDate = ref.watch(recordingsControllerProvider).selectedDate;

    return Scaffold(
      appBar: const AppSearchBar(title: 'Gravações'),
      body: Column(
        children: [
          // Calendário
          Container(
            color: AppTheme.cardDark,
            child: CalendarWidget(
              selectedDate: selectedDate,
              onDateSelected: (date) {
                ref.read(recordingsControllerProvider.notifier).selectDate(date);
                _pagingController.refresh();
              },
            ),
          ),
          KSpacer.v16,

          // Lista de gravações
          Expanded(
            child: PagedListView<int, Recording>(
              pagingController: _pagingController,
              padding: KPadding.a16,
              builderDelegate: PagedChildBuilderDelegate<Recording>(
                itemBuilder: (context, item, index) => RecordingItem(
                  recording: item,
                  onTap: () => _showRecordingPlayer(context, item),
                ),
                firstPageProgressIndicatorBuilder: (context) =>
                    const AppLoadingIndicator(message: 'Carregando gravações...'),
                newPageProgressIndicatorBuilder: (context) =>
                    const Padding(
                  padding: EdgeInsets.all(16),
                  child: AppLoadingIndicator(),
                ),
                noItemsFoundIndicatorBuilder: (context) => const AppEmptyState(
                  title: 'Nenhuma gravação encontrada',
                  message: 'Não há gravações para a data selecionada.',
                ),
                firstPageErrorIndicatorBuilder: (context) => AppErrorState(
                  message: _pagingController.error.toString(),
                  onRetry: () => _pagingController.refresh(),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 1),
    );
  }

  void _showRecordingPlayer(BuildContext context, Recording recording) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.cardDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: KPadding.a24,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            KSpacer.v24,

            // Título
            Text(
              'Gravação do dia ${recording.timestamp.day.toString().padLeft(2, '0')}/${recording.timestamp.month.toString().padLeft(2, '0')}/${recording.timestamp.year}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            KSpacer.v8,
            Text(
              recording.cameraName,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            KSpacer.v24,

            // Preview da gravação
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                ),
                child: const Center(
                  child: Icon(
                    Icons.play_circle_outline,
                    size: 64,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ),
            ),
            KSpacer.v24,

            // Botões de ação
            Row(
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
                      // TODO: Implementar download
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Download - Em desenvolvimento'),
                        ),
                      );
                    },
                    child: const Text('Download'),
                  ),
                ),
              ],
            ),
            KSpacer.v16,
          ],
        ),
      ),
    );
  }
}
