import 'app_flavor.dart';

class AppConfig {
  const AppConfig({
    required this.flavor,
  });

  final AppFlavor flavor;

  bool get enableNetworkLogs => flavor == AppFlavor.dev;

  Duration get connectTimeout => const Duration(seconds: 10);
  Duration get receiveTimeout => const Duration(seconds: 20);

  /// Usado quando o usuário digita um "código/slug" do salão.
  /// Ajuste este domínio para o seu ambiente real.
  String get slugBaseDomain => 'helderporto.com';

  Uri buildBaseUrlFromSlug(String slug) {
    final normalized = slug.trim().toLowerCase();
    return Uri.parse('https://$normalized.$slugBaseDomain');
  }
}
