import 'package:flutter/widgets.dart';

import 'app.dart';
import 'core/config/app_flavor.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runBeautySalonApp(flavor: AppFlavor.prod);
}
