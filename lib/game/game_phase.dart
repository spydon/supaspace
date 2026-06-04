/// The phase this client is in. Also used as the presence phase advertised to
/// peers (serialized via [name], parsed back with [fromString]); `results` is
/// only ever a local phase and is never sent over presence.
enum GamePhase {
  lobby,
  playing,
  spectating,
  results;

  /// Parses a [name] back into a phase, falling back to [lobby] for anything
  /// unknown or missing.
  static GamePhase fromString(String? value) {
    return GamePhase.values.firstWhere(
      (phase) => phase.name == value,
      orElse: () => GamePhase.lobby,
    );
  }
}
