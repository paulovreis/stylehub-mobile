import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/network/app_failure.dart';
import '../../../core/session/session_controller.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_error_view.dart';
import '../../../core/widgets/app_primary_button.dart';
import '../../../l10n/app_localizations.dart';
import '../../push/presentation/push_controller.dart';
import '../domain/me_profile.dart';
import 'profile_controller.dart';

class ProfileTab extends ConsumerStatefulWidget {
  const ProfileTab({super.key});

  @override
  ConsumerState<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends ConsumerState<ProfileTab> {
  final _formKey = GlobalKey<FormState>();

  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();

  MeProfile? _lastSeeded;
  bool _saving = false;
  bool _editing = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    super.dispose();
  }

  void _seedControllers(MeProfile profile) {
    if (_lastSeeded == profile) return;
    _lastSeeded = profile;
    _name.text = profile.name ?? '';
    _email.text = profile.email ?? '';
    _phone.text = AppFormatters.formatPhoneBR(profile.phone);
  }

  void _resetToProfile(MeProfile profile) {
    _name.text = profile.name ?? '';
    _email.text = profile.email ?? '';
    _phone.text = AppFormatters.formatPhoneBR(profile.phone);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final profileAsync = ref.watch(profileControllerProvider);

    return RefreshIndicator(
      onRefresh: () => ref.read(profileControllerProvider.notifier).refresh(),
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            title: Text(l10n.profileTitle),
          ),
          ...profileAsync.when(
            loading: () => const [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: LinearProgressIndicator(),
                ),
              ),
            ],
            error: (err, _) => [
              SliverFillRemaining(
                hasScrollBody: false,
                child: AppErrorView(
                  message: _errorMessage(err),
                  onRetry: () => ref.read(profileControllerProvider.notifier).refresh(),
                ),
              ),
            ],
            data: (profile) {
              _seedControllers(profile);
              return [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        l10n.profileTitle,
                                        style: Theme.of(context).textTheme.titleMedium,
                                      ),
                                    ),
                                    TextButton.icon(
                                      onPressed: _editing
                                          ? null
                                          : () => setState(() => _editing = true),
                                      icon: const Icon(Icons.edit_outlined),
                                      label: const Text('Editar'),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                _InfoRow(label: l10n.profileNameLabel, value: profile.name),
                                const SizedBox(height: 8),
                                _InfoRow(label: l10n.profileEmailLabel, value: profile.email),
                                const SizedBox(height: 8),
                                _InfoRow(
                                  label: l10n.profilePhoneLabel,
                                  value: AppFormatters.formatPhoneBR(profile.phone),
                                  emptyText: '-',
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (_editing) ...[
                          const SizedBox(height: 12),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      'Editar',
                                      style: Theme.of(context).textTheme.titleMedium,
                                    ),
                                    const SizedBox(height: 12),
                                    TextFormField(
                                      controller: _name,
                                      decoration: InputDecoration(
                                        labelText: l10n.profileNameLabel,
                                        prefixIcon: const Icon(Icons.person_outline),
                                      ),
                                      textInputAction: TextInputAction.next,
                                      validator: (v) {
                                        final value = (v ?? '').trim();
                                        if (value.isEmpty) return l10n.profileNameRequired;
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 12),
                                    TextFormField(
                                      controller: _email,
                                      decoration: InputDecoration(
                                        labelText: l10n.profileEmailLabel,
                                        prefixIcon: const Icon(Icons.alternate_email),
                                      ),
                                      enabled: false,
                                      keyboardType: TextInputType.emailAddress,
                                      textInputAction: TextInputAction.next,
                                    ),
                                    const SizedBox(height: 12),
                                    TextFormField(
                                      controller: _phone,
                                      decoration: InputDecoration(
                                        labelText: l10n.profilePhoneLabel,
                                        prefixIcon: const Icon(Icons.phone_outlined),
                                      ),
                                      keyboardType: TextInputType.phone,
                                      textInputAction: TextInputAction.done,
                                      inputFormatters: const [BrPhoneTextInputFormatter()],
                                      validator: (v) {
                                        final value = (v ?? '').trim();
                                        if (value.isEmpty) return null; // telefone pode ser opcional
                                        if (!Validators.isValidPhoneBR(value)) {
                                          return l10n.profilePhoneInvalid;
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: OutlinedButton(
                                            onPressed: _saving
                                                ? null
                                                : () {
                                                    _resetToProfile(profile);
                                                    setState(() => _editing = false);
                                                  },
                                            child: Text(l10n.commonCancel),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: AppPrimaryButton(
                                            label: l10n.commonSave,
                                            loading: _saving,
                                            onPressed: _saving
                                                ? null
                                                : () async {
                                                    final ok = _formKey.currentState?.validate() ?? false;
                                                    if (!ok) return;

                                                    final messenger = ScaffoldMessenger.of(context);

                                                    setState(() => _saving = true);
                                                    final saved = await ref
                                                        .read(profileControllerProvider.notifier)
                                                        .save(
                                                          name: _name.text,
                                                          phone: AppFormatters.onlyDigits(_phone.text),
                                                        );
                                                    if (!mounted) return;
                                                    setState(() => _saving = false);

                                                    if (saved) {
                                                      setState(() => _editing = false);
                                                      messenger.showSnackBar(
                                                        SnackBar(content: Text(l10n.profileUpdatedSuccess)),
                                                      );
                                                    } else {
                                                      messenger.showSnackBar(
                                                        SnackBar(content: Text(l10n.profileUpdatedError)),
                                                      );
                                                    }
                                                  },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 24),
                        OutlinedButton.icon(
                          onPressed: () => _confirmChangeSalon(context),
                          icon: const Icon(Icons.store_outlined),
                          label: Text(l10n.profileChangeSalon),
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton.icon(
                          onPressed: () => _confirmLogout(context),
                          icon: const Icon(Icons.logout),
                          label: Text(l10n.profileLogout),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ];
            },
          ),
        ],
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.profileLogout),
        content: Text(l10n.profileLogoutConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: theme.colorScheme.error),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.profileLogout),
          ),
        ],
      ),
    );

    if (ok != true) return;

    try {
      await ref
          .read(pushControllerProvider.notifier)
          .onLogout()
          .timeout(const Duration(seconds: 3));
    } catch (_) {
      // Logout deve funcionar mesmo sem rede.
    }
    await ref.read(sessionControllerProvider.notifier).clearAccessToken();
    if (!context.mounted) return;
    context.go('/login');
  }

  Future<void> _confirmChangeSalon(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.profileChangeSalon),
        content: Text(l10n.profileChangeSalonConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton.tonal(
            style: FilledButton.styleFrom(
              backgroundColor: theme.colorScheme.errorContainer,
              foregroundColor: theme.colorScheme.onErrorContainer,
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.profileChangeSalon),
          ),
        ],
      ),
    );

    if (ok != true) return;

    try {
      await ref
          .read(pushControllerProvider.notifier)
          .onLogout()
          .timeout(const Duration(seconds: 3));
    } catch (_) {
      // Troca de salão deve funcionar mesmo sem rede.
    }
    await ref.read(sessionControllerProvider.notifier).logoutAndReset();
    if (!context.mounted) return;
    context.go('/select-salon');
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    this.emptyText,
  });

  final String label;
  final String? value;
  final String? emptyText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final v = (value ?? '').trim();
    final shown = v.isEmpty ? (emptyText ?? '-') : v;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.labelLarge),
        const SizedBox(height: 4),
        Text(
          shown,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: v.isEmpty ? theme.colorScheme.onSurfaceVariant : null,
          ),
        ),
      ],
    );
  }
}

String _errorMessage(Object err) {
  if (err is AppFailure) return err.message;
  return 'Não foi possível carregar seu perfil.';
}

