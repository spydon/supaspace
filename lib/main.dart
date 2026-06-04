import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supaspace/app.dart';
import 'package:supaspace/game/settings_service.dart';
import 'package:supaspace/game/sound_service.dart';
import 'package:supaspace/supabase_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  assert(
    supabaseAnonKey.isNotEmpty,
    'Missing SUPABASE_ANON_KEY — pass it at build/run time with '
    '--dart-define=SUPABASE_ANON_KEY=<publishable key>.',
  );
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);

  // A persistent anonymous account gives each browser a stable id (auth.uid),
  // which the high score and the 1-point-per-5-minutes rule are keyed on. The
  // session is restored from local storage on reload, so the id is reused.
  final auth = Supabase.instance.client.auth;
  if (auth.currentSession == null) {
    await auth.signInAnonymously();
  }

  // Settings and audio are non-critical: if persistence or the audio engine
  // fail to initialise, fall back to defaults and keep the game playable.
  try {
    await SettingsService.instance.init();
  } on Object catch (error) {
    debugPrint('Settings init failed, using defaults: $error');
  }
  try {
    await SoundService.instance.init();
  } on Object catch (error) {
    debugPrint('Sound init failed, continuing without audio: $error');
  }

  runApp(const SupaspaceApp());
}
