import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/app_primary_button.dart';
import '../../../l10n/app_localizations.dart';
import 'auth_controller.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  ConsumerState<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _token = TextEditingController();
  final _newPassword = TextEditingController();
  final _confirm = TextEditingController();

  @override
  void dispose() {
    _token.dispose();
    _newPassword.dispose();
    _confirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ui = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.resetTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _token,
              decoration: InputDecoration(labelText: l10n.resetToken),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _newPassword,
              obscureText: true,
              decoration: InputDecoration(labelText: l10n.resetNewPassword),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _confirm,
              obscureText: true,
              decoration: InputDecoration(labelText: l10n.resetConfirmPassword),
            ),
            const SizedBox(height: 16),
            AppPrimaryButton(
              label: l10n.resetSubmit,
              loading: ui.loading,
              onPressed: ui.loading
                  ? null
                  : () async {
                      if (_newPassword.text != _confirm.text) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.resetPasswordsMismatch)),
                        );
                        return;
                      }

                      final ok = await ref
                          .read(authControllerProvider.notifier)
                          .resetPassword(
                            token: _token.text,
                            newPassword: _newPassword.text,
                          );
                      if (!context.mounted) return;
                      if (ok) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.resetSuccess)),
                        );
                        context.go('/login');
                      }
                    },
            ),
            if (ui.errorMessage != null) ...[
              const SizedBox(height: 12),
              Text(
                ui.errorMessage!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
