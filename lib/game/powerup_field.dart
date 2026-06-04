import 'dart:math';

import 'package:flame/components.dart';
import 'package:supaspace/game/planet_field.dart';
import 'package:supaspace/game/powerup_type.dart';

/// Immutable description of a powerup, produced deterministically from the
/// shared game seed so every client lays out an identical set.
class PowerupSpecification {
  PowerupSpecification({
    required this.id,
    required this.type,
    required this.position,
  });

  final int id;
  final PowerupType type;
  final Vector2 position;
}

/// Scatters [count] powerups across [worldSize], avoiding the [planets] and one
/// another. Pure function of its inputs, so every client agrees. The seed is
/// offset from the planet seed so powerups don't land in lockstep with planets.
List<PowerupSpecification> generatePowerups(
  int seed,
  Vector2 worldSize,
  List<PlanetSpecification> planets, {
  int count = 8,
}) {
  final random = Random(seed ^ 0x9E3779B9);
  const margin = 280.0;
  const powerupRadius = 40.0;
  const minimumGap = 200.0;
  final powerups = <PowerupSpecification>[];
  const types = PowerupType.values;

  var attempts = 0;
  while (powerups.length < count && attempts < 5000) {
    attempts++;
    final position = Vector2(
      margin + random.nextDouble() * (worldSize.x - 2 * margin),
      margin + random.nextDouble() * (worldSize.y - 2 * margin),
    );
    final clearOfPlanets = planets.every(
      (planet) =>
          planet.position.distanceTo(position) >
          planet.radius + powerupRadius + minimumGap,
    );
    final clearOfPowerups = powerups.every(
      (powerup) => powerup.position.distanceTo(position) > minimumGap,
    );
    if (clearOfPlanets && clearOfPowerups) {
      powerups.add(
        PowerupSpecification(
          id: powerups.length,
          // Cycle the types so each appears roughly evenly.
          type: types[powerups.length % types.length],
          position: position,
        ),
      );
    }
  }
  return powerups;
}
