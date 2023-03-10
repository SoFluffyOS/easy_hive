import 'package:easy_hive/easy_hive.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  await EasyBox.initialize();

  await SettingsBox().init();

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
              ValueListenableBuilder(
                valueListenable: [
                  Settings.counter,
                ].of(SettingsBox()),
                builder: (context, _, __) {
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

enum Settings {
  key,
  themeMode,
  counter,
}

class SettingsBox extends EasyBox {
  @override
  String get boxKey => Settings.key.toString();

  /// Singleton.
  static final SettingsBox _instance = SettingsBox._();

  factory SettingsBox() => _instance;

  SettingsBox._();
}

extension GeneralSettingsExtension on SettingsBox {
  ThemeMode get themeMode {
    final index = get(
      Settings.themeMode,
      defaultValue: 0,
    );
    return ThemeMode.values[index];
  }

  set themeMode(ThemeMode value) => put(Settings.themeMode, value.index);

  int get counter => get(Settings.counter, defaultValue: 0);

  set counter(int value) => put(Settings.counter, value);
}
