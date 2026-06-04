/// The four powerups, renamed from the source art to their in-game purpose.
///
/// - [bulletSpeed] (art: `health`) — each pickup makes your bullets faster.
/// - [shipSpeed] (art: `power`) — each pickup makes your ship faster.
/// - [shotgun] (art: `mana`) — fire three shots in a forward spread.
/// - [homing] (art: `speed`) — your shots gently track nearby ships.
enum PowerupType {
  bulletSpeed('bullet_speed'),
  shipSpeed('ship_speed'),
  shotgun('shotgun'),
  homing('homing');

  const PowerupType(this.assetName);

  /// File name (without extension) of the spritesheet under
  /// `assets/images/powerups/`.
  final String assetName;

  String get imagePath => 'powerups/$assetName.png';

  /// Short toast shown when the powerup is picked up.
  String get pickupMessage => switch (this) {
    PowerupType.bulletSpeed => 'Bullet Speed +1',
    PowerupType.shipSpeed => 'Ship Speed +1',
    PowerupType.shotgun => 'Shotgun!',
    PowerupType.homing => 'Homing Shots!',
  };
}
