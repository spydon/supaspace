import 'dart:math';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

/// Identity for the player controlling this client. The call sign is chosen by
/// the player (never random) and persisted across sessions; the [id] is the
/// authenticated account id (auth.uid) — stable across sessions and used as the
/// key for presence, ship/bullet/capture attribution, and server-side win
/// awarding (so every client refers to a player by the same id).
class LocalPlayer {
  LocalPlayer({required this.id, required this.name, required this.color});

  /// Creates an identity for [name], using the signed-in account id so the
  /// player is identifiable across clients; falls back to a random id when
  /// there is no session (e.g. tests / auth disabled). The ship colour is
  /// random unless restored from a previous session.
  factory LocalPlayer.create({required String name, Color? color}) {
    final id =
        Supabase.instance.client.auth.currentUser?.id ?? const Uuid().v4();
    return LocalPlayer(id: id, name: name, color: color ?? _randomColor());
  }

  final String id;

  /// The player's chosen call sign. Mutable so it can be edited in the lobby
  /// without discarding the session [id] or [color].
  String name;

  final Color color;

  /// Encodes the colour as an int for transport in presence/broadcast payloads
  /// and for persistence between sessions.
  int get colorValue => color.toARGB32();

  static Color _randomColor() {
    final hue = Random().nextDouble() * 360;
    return HSLColor.fromAHSL(1, hue, 0.7, 0.6).toColor();
  }
}
