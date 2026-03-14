import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/app_primary_button.dart';
import 'auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ui = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Entrar')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(labelText: 'E-mail'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _password,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Senha'),
            ),
            const SizedBox(height: 16),
            AppPrimaryButton(
              label: 'Entrar',
              loading: ui.loading,
              onPressed: ui.loading
                  ? null
                  : () async {
                      final ok = await ref
                          .read(authControllerProvider.notifier)
                          .login(email: _email.text, password: _password.text);
                      if (!context.mounted) return;
                      if (ok) {
                        context.go('/home');
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
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => context.push('/register'),
              child: const Text('Criar conta'),
            ),
            TextButton(
              onPressed: () => context.push('/forgot-password'),
              child: const Text('Esqueci minha senha'),
            ),
          ],
        ),
      ),
    );
  }
}
