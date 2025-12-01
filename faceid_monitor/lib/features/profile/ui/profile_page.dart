import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../theme/app_theme.dart';
import '../../../widgets/app_bottom_nav.dart';
import '../../../widgets/k_spacers.dart';
import '../../auth/state/auth_controller.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  bool _isLoggingOut = false;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final idUser = user?.uid.trim();
    final email = (user?.email ?? '').trim();

    final userDocStream = idUser == null
        ? null
        : FirebaseFirestore.instance.collection('users').doc(idUser).snapshots();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
      ),
      body: SingleChildScrollView(
        padding: KPadding.a16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildProfileCard(context, user, email, userDocStream),
            KSpacer.v16,
            _buildLogoutCard(context),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 2),
    );
  }

  Widget _buildProfileCard(
    BuildContext context,
    User? user,
    String email,
    Stream<DocumentSnapshot<Map<String, dynamic>>>? userDocStream,
  ) {
    return Container(
      padding: KPadding.a16,
      decoration: BoxDecoration(
        color: AppTheme.cardBackground(context),
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        border: Border.all(color: Theme.of(context).dividerColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: userDocStream,
        builder: (context, snapshot) {
          final data = snapshot.data?.data();
          final first = (data?['firstName'] ?? '').toString().trim();
          final last = (data?['lastName'] ?? '').toString().trim();
          final displayName = _resolveName(
            firstName: first,
            lastName: last,
            fallbackDisplayName: (user?.displayName ?? '').trim(),
            email: email,
          );

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildAvatarPlaceholder(displayName),
                  KSpacer.h16,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          displayName,
                          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        KSpacer.v4,
                        Text(
                          email.isNotEmpty ? email : 'Email nao informado',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        if ((user?.uid ?? '').isNotEmpty) ...[
                          KSpacer.v8,
                          _buildBadge('ID', user!.uid),
                        ],
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Em breve voce podera trocar sua foto aqui.'),
                        ),
                      );
                    },
                    icon: const Icon(BootstrapIcons.pencil),
                    tooltip: 'Editar perfil',
                  ),
                ],
              ),
              KSpacer.v16,
              const Divider(),
              KSpacer.v12,
              _buildInfoTile(
                icon: BootstrapIcons.envelope,
                label: 'Conta',
                value: email.isNotEmpty ? email : 'Email nao informado',
              ),
              KSpacer.v12,
              _buildInfoTile(
                icon: BootstrapIcons.shield_lock,
                label: 'Seguranca',
                value: 'Autenticado via Firebase',
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAvatarPlaceholder(String displayName) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [AppTheme.accentCyan, AppTheme.accentCyanDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.accentCyan.withOpacity(0.35),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Container(
        margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppTheme.surfaceMuted(context),
        shape: BoxShape.circle,
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: const Center(
        child: Icon(
            BootstrapIcons.person,
            color: AppTheme.accentCyan,
            size: 32,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: KPadding.a16,
      decoration: BoxDecoration(
        color: AppTheme.surfaceMuted(context).withOpacity(
          Theme.of(context).brightness == Brightness.dark ? 0.5 : 1,
        ),
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.primaryNavy,
              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
            ),
            child: Icon(icon, color: AppTheme.accentCyan),
          ),
          KSpacer.h12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                KSpacer.v4,
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.accentCyan.withOpacity(0.12),
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        border: Border.all(color: AppTheme.accentCyan),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$label: ',
          style: TextStyle(
            color:
                Theme.of(context).textTheme.bodySmall?.color ?? AppTheme.textSecondaryLight,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          value,
            style: const TextStyle(
              color: AppTheme.accentCyan,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutCard(BuildContext context) {
    return Container(
      padding: KPadding.a16,
      decoration: BoxDecoration(
        color: AppTheme.cardBackground(context),
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(BootstrapIcons.box_arrow_right, color: AppTheme.errorRed),
              KSpacer.h12,
              Text(
                'Sair do app',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
              ),
            ],
          ),
          KSpacer.v8,
          Text(
            'Encerre sua sessao e volte para a tela de login.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          KSpacer.v16,
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.errorRed,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                ),
              ),
              onPressed: _isLoggingOut ? null : () => _handleLogout(context),
              icon: _isLoggingOut
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(BootstrapIcons.power),
              label: Text(_isLoggingOut ? 'Saindo...' : 'Sair do app'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleLogout(BuildContext context) async {
    setState(() {
      _isLoggingOut = true;
    });

    await ref.read(authControllerProvider.notifier).logout();

    if (!mounted) return;

    final error = ref.read(authControllerProvider).errorMessage;
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
      setState(() {
        _isLoggingOut = false;
      });
      return;
    }

    context.go('/login');
  }

  String _resolveName({
    required String firstName,
    required String lastName,
    required String fallbackDisplayName,
    required String email,
  }) {
    final full = [firstName, lastName].where((s) => s.isNotEmpty).join(' ').trim();

    if (full.isNotEmpty) return full;
    if (fallbackDisplayName.isNotEmpty) return fallbackDisplayName;
    if (email.contains('@')) return email.split('@').first;
    return 'Usuario';
  }
}
