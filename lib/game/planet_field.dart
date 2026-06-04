import 'dart:math';

import 'package:flame/components.dart';

/// Immutable description of a planet, produced deterministically from the
/// shared game seed so every client lays out an identical field.
class PlanetSpecification {
  PlanetSpecification({
    required this.id,
    required this.position,
    required this.radius,
    required this.hue,
  });

  final int id;
  final Vector2 position;
  final double radius;
  final double hue; // base colour hue for unowned planet
}

/// Places [count] non-overlapping planets inside [worldSize] using a seeded
/// RNG. Pure function of ([seed], [worldSize], [count]) — identical on every
/// client given the same inputs.
List<PlanetSpecification> generatePlanets(
  int seed,
  Vector2 worldSize, {
  int count = 10,
}) {
  final random = Random(seed);
  const margin = 320.0;
  const minimumGap = 220.0;
  final planets = <PlanetSpecification>[];

  var attempts = 0;
  while (planets.length < count && attempts < 5000) {
    attempts++;
    final radius = 55 + random.nextDouble() * 70;
    final position = Vector2(
      margin + random.nextDouble() * (worldSize.x - 2 * margin),
      margin + random.nextDouble() * (worldSize.y - 2 * margin),
    );
    final noOverlap = planets.every(
      (planet) =>
          planet.position.distanceTo(position) >
          planet.radius + radius + minimumGap,
    );
    if (noOverlap) {
      planets.add(
        PlanetSpecification(
          id: planets.length,
          position: position,
          radius: radius,
          hue: random.nextDouble() * 360,
        ),
      );
    }
  }
  return planets;
}
