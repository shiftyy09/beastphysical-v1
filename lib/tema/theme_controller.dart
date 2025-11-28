import 'package:flutter/foundation.dart';

/// Global theme controller. Use `themeNotifier.value` (true = light, false = dark)
final ValueNotifier<bool> themeNotifier = ValueNotifier<bool>(false);

void toggleTheme() {
  themeNotifier.value = !themeNotifier.value;
}

void setLightTheme(bool light) {
  themeNotifier.value = light;
}

