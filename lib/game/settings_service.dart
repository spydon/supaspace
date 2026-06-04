import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persisted user settings. Currently just the audio toggles, exposed as
/// [ValueNotifier]s so the UI and the sound service react to changes and the
/// values survive between sessions. Modelled on sokobros' SettingsService.
class SettingsService {
  SettingsService._();

  static final instance = SettingsService._();

  static const _musicKey = 'musicEnabled';
  static const _sfxKey = 'sfxEnabled';

  late final SharedPreferences _preferences;

  final ValueNotifier<bool> musicEnabled = ValueNotifier(true);
  final ValueNotifier<bool> sfxEnabled = ValueNotifier(true);

  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
    musicEnabled.value = _preferences.getBool(_musicKey) ?? true;
    sfxEnabled.value = _preferences.getBool(_sfxKey) ?? true;
    musicEnabled.addListener(() {
      _preferences.setBool(_musicKey, musicEnabled.value);
    });
    sfxEnabled.addListener(() {
      _preferences.setBool(_sfxKey, sfxEnabled.value);
    });
  }
}
