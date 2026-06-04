/// The four powerups, renamed from the source art to their in-game purpose.
///
/// - [bulletSpeed] — each pickup makes your bullets faster.
/// - [shipSpeed] — each pickup makes your ship faster.
/// - [shotgun] — fire three shots in a forward spread.
/// - [homing] — your shots gently track nearby ships.
enum PowerupType {
  bulletSpeed,
  shipSpeed,
  shotgun,
  homing;

  /// Spritesheet under `assets/images/powerups/`, named after the enum value.
  String get imagePath => 'powerups/$name.png';

  /// Short toast shown when the powerup is picked up.
  String get pickupMessage => switch (this) {
    PowerupType.bulletSpeed => 'Bullet Speed +1',
    PowerupType.shipSpeed => 'Ship Speed +1',
    PowerupType.shotgun => 'Shotgun!',
    PowerupType.homing => 'Homing Shots!',
  };
}
