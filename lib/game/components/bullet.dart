import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:supaspace/game/space_game.dart';

/// A projectile, drawn as an animated green flame. Spawned on every client from
/// a `shot` broadcast (or locally when firing) and simulated identically: it
/// travels along [velocity] until [lifespan] elapses. It carries a *passive*
/// hitbox; the hit (and victim knockback) is resolved by the active local-ship
/// hitbox, not here.
///
/// If [homing], it gently curves toward the nearest enemy ship once one is
/// close (the "homing shots" powerup). The flame sprite points "down" (+Y) in
/// its frames, so it is rotated to face the direction of travel.
class Bullet extends SpriteAnimationComponent with HasGameReference<SpaceGame> {
  Bullet({
    required this.ownerId,
    required SpriteAnimation animation,
    required Vector2 position,
    required this.velocity,
    this.homing = false,
    this.lifespan = 2.4,
  }) : super(
         animation: animation,
         position: position,
         size: Vector2(20, 40),
         anchor: Anchor.center,
         angle: atan2(-velocity.x, velocity.y),
       );

  /// Only steer toward ships within this range, and turn no faster than this
  /// (radians/second), so the tracking is subtle rather than a lock-on.
  static const _homingRange = 340.0;
  static const _homingTurnRate = 2.4;

  final String ownerId;
  final Vector2 velocity;
  final bool homing;
  final double lifespan;

  /// Collision radius — kept smaller than the visual flame so grazing the outer
  /// glow does not count as a hit.
  double radius = 6;

  double _age = 0;

  @override
  Future<void> onLoad() async {
    add(
      CircleHitbox(radius: radius, position: size / 2, anchor: Anchor.center)
        ..collisionType = CollisionType.passive,
    );
  }

  @override
  void update(double deltaTime) {
    super.update(deltaTime); // advances the flame animation
    _age += deltaTime;
    if (_age >= lifespan) {
      removeFromParent();
      return;
    }
    if (homing) {
      _steerTowardNearbyShip(deltaTime);
    }
    position.addScaled(velocity, deltaTime);
  }

  void _steerTowardNearbyShip(double deltaTime) {
    final target = game.nearestEnemyShipPosition(
      ownerId,
      position,
      _homingRange,
    );
    if (target == null) {
      return;
    }
    final desired = atan2(target.y - position.y, target.x - position.x);
    final current = atan2(velocity.y, velocity.x);
    var difference = (desired - current) % (2 * pi);
    if (difference > pi) {
      difference -= 2 * pi;
    } else if (difference < -pi) {
      difference += 2 * pi;
    }
    final maxTurn = _homingTurnRate * deltaTime;
    final turn = difference.clamp(-maxTurn, maxTurn);
    final newAngle = current + turn;
    final speed = velocity.length;
    velocity.setValues(cos(newAngle) * speed, sin(newAngle) * speed);
    angle = atan2(-velocity.x, velocity.y);
  }
}
