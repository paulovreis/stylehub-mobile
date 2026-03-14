import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/app_primary_button.dart';
import '../../../l10n/app_localizations.dart';
import 'auth_controller.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _email = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ui = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.forgotTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(labelText: l10n.loginEmail),
            ),
            const SizedBox(height: 16),
            AppPrimaryButton(
              label: l10n.forgotSubmit,
              loading: ui.loading,
              onPressed: ui.loading
                  ? null
                  : () async {
                      await ref
                          .read(authControllerProvider.notifier)
                          .forgotPassword(email: _email.text);
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.forgotSuccess)),
                      );
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
