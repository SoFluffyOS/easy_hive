# Easy Hive
[Easy Hive](https://pub.dev/packages/easy_hive) is a simple and easy to use wrapper for [Hive](https://pub.dev/packages/hive) package.

## Installation 💻

Add `easy_hive` to your `pubspec.yaml`:

```yaml

dependencies:

  easy_hive: ^1.0.0

```

Install it:

```sh

flutter pub get

```

## Usage 📖


You can either define your boxes as _Singleton_ classes **or** use a service locator like [_get_it_](https://pub.dev/packages/get_it).


### 1. Define a box 📦

```dart

import 'package:easy_hive/easy_hive.dart';

class SettingsBox extends EasyBox {
  @override
  String get boxKey => BoxKeys.hiveSettingsBoxKey;

  static final SettingsBox _instance = SettingsBox._();

  factory SettingsBox() => _instance;

  SettingsBox._();
}

```


<details>
<summary>Or to use with get_it</summary>

```dart

import 'package:easy_hive/easy_hive.dart';

class SettingsBox extends EasyBox {
  @override
  String get boxKey => BoxKeys.hiveSettingsBoxKey;
}

```
</details>

### 2. Initialize box 🚀

```dart

import 'package:easy_hive/easy_hive.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  await SettingsBox().init();

  // runApp...
}

```


<details>
<summary>Or to use with get_it</summary>

```dart

import 'package:easy_hive/easy_hive.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  final settingsBox = SettingsBox();
  await settingsBox.init();
  GetIt.I.registerSingleton<SettingsBox>(settingsBox);

  // runApp...
}

```
</details>

### 3. Define getter & setter for your data 💄

```dart
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
```

### 4. Use it anywhere 🔥

```dart
    Text(
      'You have pushed: ${SettingsBox().counter} times.',
      style: Theme.of(context).textTheme.headlineMedium,
    ),
    FilledButton(
      onPressed: () {
        SettingsBox().counter++;
      },
      child: Text('Increment'),
    ),
    FilledButton(
      onPressed: () {
        SettingsBox().themeMode = ThemeMode.dark;
      },
      child: Text('Dark Theme'),
    ),
```


<details>
<summary>Or to use with get_it</summary>

```dart
    Text(
      'Count: ${GetIt.I<SettingsBox>().counter}',
      style: Theme.of(context).textTheme.headlineMedium,
    ),
```
</details>

## Advanced Usage 😈

`// TODO: TBD.`
