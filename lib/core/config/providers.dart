import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_config.dart';

final appConfigProvider = Provider<AppConfig>((ref) {
  throw UnimplementedError('AppConfig precisa ser sobrescrito no bootstrap');
});
