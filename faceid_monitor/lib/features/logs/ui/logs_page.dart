import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../../widgets/app_appbar.dart';
import '../../../widgets/app_bottom_nav.dart';
import '../../../widgets/app_loading_indicator.dart';
import '../../../widgets/app_empty_state.dart';
import '../../../widgets/app_error_state.dart';
import '../../../widgets/k_spacers.dart';
import '../../../models/log_entry.dart';
import 'widgets/log_item.dart';
import 'widgets/log_detail.dart';
import '../state/logs_controller.dart';

/// Tela de logs - Reproduz fielmente o layout da imagem 4
class LogsPage extends ConsumerStatefulWidget {
  const LogsPage({super.key});

  @override
  ConsumerState<LogsPage> createState() => _LogsPageState();
}

class _LogsPageState extends ConsumerState<LogsPage> {
  final PagingController<int, LogEntry> _pagingController =
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
          .read(logsControllerProvider.notifier)
          .fetchLogs(pageKey);

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
    return Scaffold(
      appBar: const AppSearchBar(title: 'Logs'),
      body: PagedListView<int, LogEntry>(
        pagingController: _pagingController,
        padding: KPadding.a16,
        builderDelegate: PagedChildBuilderDelegate<LogEntry>(
          itemBuilder: (context, item, index) => LogItem(
            logEntry: item,
            onTap: () => _showLogDetail(context, item),
          ),
          firstPageProgressIndicatorBuilder: (context) =>
              const AppLoadingIndicator(message: 'Carregando logs...'),
          newPageProgressIndicatorBuilder: (context) =>
              const Padding(
            padding: EdgeInsets.all(16),
            child: AppLoadingIndicator(),
          ),
          noItemsFoundIndicatorBuilder: (context) => const AppEmptyState(
            title: 'Nenhum log encontrado',
            message: 'Não há logs disponíveis no momento.',
          ),
          firstPageErrorIndicatorBuilder: (context) => AppErrorState(
            message: _pagingController.error.toString(),
            onRetry: () => _pagingController.refresh(),
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 1),
    );
  }

  void _showLogDetail(BuildContext context, LogEntry logEntry) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => LogDetail(logEntry: logEntry),
    );
  }
}
