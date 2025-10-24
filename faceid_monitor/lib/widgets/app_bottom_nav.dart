import 'package:flutter/material.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:go_router/go_router.dart';

/// Bottom Navigation Bar do aplicativo
class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  
  const AppBottomNav({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) => _onItemTapped(context, index),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(BootstrapIcons.gear),
          label: '',
          tooltip: 'Configurações',
        ),
        BottomNavigationBarItem(
          icon: Icon(BootstrapIcons.house),
          label: '',
          tooltip: 'Início',
        ),
        BottomNavigationBarItem(
          icon: Icon(BootstrapIcons.person),
          label: '',
          tooltip: 'Perfil',
        ),
      ],
      showSelectedLabels: false,
      showUnselectedLabels: false,
    );
  }
  
  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        // Configurações
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Configurações - Em desenvolvimento')),
        );
        break;
      case 1:
        // Home
        context.go('/');
        break;
      case 2:
        // Perfil
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Perfil - Em desenvolvimento')),
        );
        break;
    }
  }
}
