import 'package:flutter/material.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';

/// AppBar customizado para o app
class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  
  const AppAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showBackButton = false,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: showBackButton
          ? IconButton(
              icon: const Icon(BootstrapIcons.arrow_left),
              onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
            )
          : null,
      title: Text(title),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _AppSearchDelegate extends SearchDelegate<String?> {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          tooltip: 'Limpar',
          icon: const Icon(Icons.clear),
          onPressed: () => query = '',
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Voltar',
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.trim().isEmpty) {
      return const _SearchPlaceholder(text: 'Digite para buscar');
    }
    return ListView(
      children: [
        ListTile(
          leading: const Icon(Icons.search),
          title: Text("Buscar '$query'"),
          onTap: () => close(context, query),
        ),
      ],
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return const _SearchPlaceholder(text: 'Digite para buscar');
    }
    return ListView(
      children: [
        ListTile(
          leading: const Icon(Icons.search),
          title: Text("Buscar '$query'"),
          onTap: () => showResults(context),
        ),
      ],
    );
  }
}

class _SearchPlaceholder extends StatelessWidget {
  final String text;
  const _SearchPlaceholder({required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}

/// AppBar para páginas internas com busca
class AppSearchBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onSearchTap;
  final List<Widget>? actions;
  
  const AppSearchBar({
    super.key,
    required this.title,
    this.onSearchTap,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: [
        IconButton(
          icon: const Icon(BootstrapIcons.search),
          onPressed: onSearchTap ?? () {
            showSearch<String?>(
              context: context,
              delegate: _AppSearchDelegate(),
            );
            return;
          },
        ),
        ...?actions,
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
