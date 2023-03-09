import 'package:easy_hive/easy_hive.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const EasyHiveDemo());
}

class EasyHiveDemo extends StatelessWidget {
  const EasyHiveDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: SettingsBox().themeMode,
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'You have pushed the button this many times:',
              ),
              StreamBuilder(
                initialData: SettingsBox().counter,
                stream: SettingsBox().box.watch(
                      key: BoxKeys.hiveSettingsKeyCounter,
                    ),
                builder: (BuildContext context, _) {
                  return Text(
                    '${SettingsBox().counter}',
                    style: Theme.of(context).textTheme.headlineMedium,
                  );
                },
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            SettingsBox().counter++;
          },
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}

/// Example path: lib/data/local/boxes/keys.dart
class BoxKeys {
  static const String hiveSettingsBoxKey = 'hiveSettingsBoxKey';
  static const String hiveSettingsKeyThemeMode = 'hiveSettingsKeyThemeMode';
  static const String hiveSettingsKeyCounter = 'hiveSettingsKeyCounter';
}

/// Example path: lib/data/local/boxes/settings.dart
class SettingsBox extends EasyBox {
  @override
  String get boxKey => BoxKeys.hiveSettingsBoxKey;

  /// Singleton.
  static final SettingsBox _instance = SettingsBox._();

  factory SettingsBox() => _instance;

  SettingsBox._();
}

extension GeneralSettingsExtension on SettingsBox {
  ThemeMode get themeMode {
    final index = box.get(
      BoxKeys.hiveSettingsKeyThemeMode,
      defaultValue: 0,
    );
    return ThemeMode.values[index];
  }

  set themeMode(ThemeMode value) {
    box.put(
      BoxKeys.hiveSettingsKeyThemeMode,
      value.index,
    );
  }

  int get counter {
    return box.get(
      BoxKeys.hiveSettingsKeyCounter,
      defaultValue: 0,
    );
  }

  set counter(int value) {
    box.put(
      BoxKeys.hiveSettingsKeyCounter,
      value,
    );
  }
}
