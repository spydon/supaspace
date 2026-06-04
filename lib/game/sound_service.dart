import 'dart:math';

import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:supaspace/game/settings_service.dart';

/// Describes a sound effect and how to load it.
///
/// A single-file effect uses [basePath] directly. An effect with
/// [variantCount] > 0 has that many numbered files (`<basePath>1.mp3` …
/// `<basePath>N.mp3`); one is chosen at random each time it plays. Declare
/// effects here and append them to [values].
///
/// (sokobros models this as an `enum`; we use a class so the list can stay
/// small and self-contained.)
class SoundEffect {
  const SoundEffect(this.basePath, {this.variantCount = 0, this.volume = 2});

  final String basePath;

  /// Number of numbered variants, or 0 for a single file at [basePath].
  final int variantCount;

  /// Playback volume passed to SoLoud.
  final double volume;

  bool get hasVariants => variantCount > 0;

  /// Played when a powerup is activated (picked up).
  static const powerup = SoundEffect('assets/sounds/powerup.mp3');

  /// Played when the match ends.
  static const gameOver = SoundEffect('assets/sounds/game_over.mp3');

  static const List<SoundEffect> values = [powerup, gameOver];
}

/// Plays the looping background music and sound effects (powerup pickup, game
/// over) via flutter_soloud. Adapted from sokobros' SoundService. Honours the
/// [SettingsService] music/sfx toggles.
class SoundService {
  SoundService._();

  static final instance = SoundService._();

  late final SoLoud _soloud;
  AudioSource? _musicSource;
  SoundHandle? _musicHandle;
  final Map<String, AudioSource> _sfxCache = {};

  final _settings = SettingsService.instance;
  final _random = Random();
  bool _initialized = false;

  Future<void> init() async {
    _soloud = SoLoud.instance;
    await _soloud.init();
    _musicSource = await _soloud.loadAsset('assets/sounds/background.mp3');
    await _preloadSoundEffects();
    _settings.musicEnabled.addListener(_onMusicToggled);
    _initialized = true;
  }

  Future<void> _preloadSoundEffects() async {
    for (final effect in SoundEffect.values) {
      if (effect.hasVariants) {
        for (var i = 1; i <= effect.variantCount; i++) {
          final path = '${effect.basePath}$i.mp3';
          _sfxCache[path] = await _soloud.loadAsset(path);
        }
      } else {
        _sfxCache[effect.basePath] = await _soloud.loadAsset(effect.basePath);
      }
    }
  }

  void _onMusicToggled() {
    if (_settings.musicEnabled.value) {
      startMusic();
    } else {
      stopMusic();
    }
  }

  /// Starts the looping background music if enabled and not already playing.
  /// Safe to call repeatedly — e.g. on first user interaction, which web
  /// autoplay policies require before audio can start.
  Future<void> startMusic() async {
    if (!_initialized ||
        !_settings.musicEnabled.value ||
        _musicHandle != null) {
      return;
    }
    final source = _musicSource;
    if (source == null) {
      return;
    }
    _musicHandle = _soloud.play(source, looping: true);
  }

  static const _fadeDuration = Duration(seconds: 1);

  void stopMusic() {
    final handle = _musicHandle;
    if (handle != null) {
      _soloud.fadeVolume(handle, 0, _fadeDuration);
      _soloud.scheduleStop(handle, _fadeDuration);
      _musicHandle = null;
    }
  }

  Future<void> playSoundEffect(SoundEffect effect) async {
    if (!_initialized || !_settings.sfxEnabled.value) {
      return;
    }
    final String assetPath;
    if (effect.hasVariants) {
      final variant = 1 + _random.nextInt(effect.variantCount);
      assetPath = '${effect.basePath}$variant.mp3';
    } else {
      assetPath = effect.basePath;
    }
    final source = _sfxCache[assetPath];
    if (source != null) {
      _soloud.play(source, volume: effect.volume);
    }
  }

  void dispose() {
    if (_initialized) {
      _soloud.deinit();
    }
  }
}
