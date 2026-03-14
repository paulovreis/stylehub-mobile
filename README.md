# Beauty Salon (Cliente)

App Flutter do cliente para selecionar um salão (multi-deploy), autenticar, agendar serviços, acompanhar agendamentos, gerenciar perfil e ler notificações.

## Requisitos

- Flutter SDK (Dart >= 3.7)
- Android Studio/Xcode (para rodar em device/emulador)

## Rodando

- Dev: `flutter run -t lib/main_dev.dart`
- Prod: `flutter run -t lib/main_prod.dart`

## Multi-salão (antes do login)

- O app começa em `/select-salon`.
- O usuário informa uma URL (ou slug) do salão.
- A validação é feita com `GET {baseUrl}/mobile/public/meta`.
- Após validar, o app persiste a `baseUrl` e passa a chamar a API em `{baseUrl}/mobile/...`.

## Arquitetura

- Feature-first com camadas por feature: `data/`, `domain/`, `presentation/`.
- State management: Riverpod.
- Rotas: GoRouter com guards (salão selecionado + sessão autenticada).
- Networking: Dio com interceptor de auth (Bearer token) e logs no flavor `dev`.
- Models: Freezed + json_serializable, com parsing tolerante para payloads variados.
- Storage:
	- `flutter_secure_storage`: token JWT
	- `shared_preferences`: baseUrl/meta do salão e token FCM (não sensível)
	- `hive`: cache de catálogo (serviços/funcionários)

## Push Notifications (FCM) — opcional

O app funciona 100% mesmo sem Push configurado.

Quando o Firebase/FCM está configurado, o app tenta (best-effort):

- Registrar token após login (sem forçar permissão de forma intrusiva)
- Pedir permissão e registrar token ao abrir a aba **Notificações**
- Desregistrar token no logout/troca de salão

### Setup Android

1) Adicione `android/app/google-services.json` (do seu projeto Firebase)
2) Siga o guia oficial do Firebase para Android (FCM)

### Setup iOS

1) Adicione `ios/Runner/GoogleService-Info.plist`
2) Habilite Push Notifications e Background Modes (Remote notifications)
3) Rode `cd ios; pod install`

Se o Firebase não estiver configurado, a inicialização falha em silêncio e o app segue sem push.

