import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supaspace/game/player.dart';

/// Persists the player's chosen identity (call sign and ship colour) so a
/// returning player keeps their name across sessions, even after the browser
/// tab or window is closed. Backed by [SharedPreferences], which uses the
/// platform's local storage (localStorage on the web).
class PlayerStore {
  static const _nameKey = 'player_name';
  static const _colorKey = 'player_color';

  /// Restores a previously saved identity, or `null` if this is a brand-new
  /// player who has not chosen a name yet. A new session [LocalPlayer.id] is
  /// always generated; only the call sign and colour are restored.
  Future<LocalPlayer?> load() async {
    final preferences = await SharedPreferences.getInstance();
    final name = preferences.getString(_nameKey);
    if (name == null || name.isEmpty) {
      return null;
    }
    final colorValue = preferences.getInt(_colorKey);
    return LocalPlayer.create(
      name: name,
      color: colorValue == null ? null : Color(colorValue),
    );
  }

  /// Persists [player]'s call sign and colour for future sessions.
  Future<void> save(LocalPlayer player) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_nameKey, player.name);
    await preferences.setInt(_colorKey, player.colorValue);
  }

  /// Persists just an updated call sign, keeping the existing colour.
  Future<void> saveName(String name) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_nameKey, name);
  }
}
