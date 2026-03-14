import 'dart:async';

import 'package:firebase_core/firebase_core.dart';

Future<bool> ensureFirebaseInitialized() {
  _initFuture ??= _ensure();
  return _initFuture!;
}

Future<bool> _ensure() async {
  try {
    if (Firebase.apps.isNotEmpty) return true;
    await Firebase.initializeApp();
    return Firebase.apps.isNotEmpty;
  } catch (_) {
    // Firebase não configurado (ex.: sem google-services / plist). Push é opcional.
    return false;
  }
}

Future<bool>? _initFuture;
