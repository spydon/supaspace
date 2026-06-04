import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supaspace/game/powerup_type.dart';
import 'package:supaspace/game/space_game.dart';

/// Shared rendering for both local and remote ships. The hull is drawn rotated
/// by [facing] inside `render`, while the component itself stays unrotated so
/// the name tag child can remain upright.
abstract class ShipComponent extends PositionComponent {
  ShipComponent({
    required this.id,
    required this.shipName,
    required this.color,
    required Vector2 position,
  }) : super(
         position: position,
         size: Vector2(46, 34),
         anchor: Anchor.center,
       );

  final String id;
  final String shipName;
  final Color color;

  final Vector2 velocity = Vector2.zero();
  double facing = 0; // radians, positive x axis = 0
  bool thrusting = false;
  bool alive = true;

  double get radius => 18;

  // Reused across frames — Paints are mutable, so we never allocate one in
  // [render]. The hull colour is fixed per ship, so these can be built once.
  final Paint _flamePaint = Paint()
    ..color = const Color(0xFFFFB74D).withValues(alpha: 0.9)
    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
  late final Paint _hullGlowPaint = Paint()
    ..color = color.withValues(alpha: 0.35)
    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
  late final Paint _hullPaint = Paint()..color = color;
  final Paint _hullStrokePaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.5
    ..color = Colors.white.withValues(alpha: 0.8);
  final Paint _cockpitPaint = Paint()
    ..color = Colors.white.withValues(alpha: 0.85);

  // Also reused across frames so [render] allocates nothing: the hull shape is
  // constant, and the flame is rebuilt in place each frame (its length flickers
  // via [_flameRandom]).
  late final Path _hull = Path()
    ..moveTo(20, 0)
    ..lineTo(-14, -12)
    ..lineTo(-8, 0)
    ..lineTo(-14, 12)
    ..close();
  final Path _flamePath = Path();
  final Random _flameRandom = Random();

  late final TextComponent _nameTag = TextComponent(
    text: shipName,
    anchor: Anchor.bottomCenter,
    position: Vector2(size.x / 2, -6),
    textRenderer: TextPaint(
      style: TextStyle(
        color: color.withValues(alpha: 0.9),
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
    ),
  );

  @override
  Future<void> onLoad() async {
    add(_nameTag);
  }

  @override
  void render(Canvas canvas) {
    final centerX = size.x / 2;
    final centerY = size.y / 2;
    canvas.save();
    canvas.translate(centerX, centerY);
    canvas.rotate(facing);

    // thruster flame
    if (thrusting && alive) {
      _flamePath
        ..reset()
        ..moveTo(-14, -6)
        ..lineTo(-26 - _flameRandom.nextDouble() * 6, 0)
        ..lineTo(-14, 6)
        ..close();
      canvas.drawPath(_flamePath, _flamePaint);
    }

    // hull (nose toward positive x axis)
    canvas.drawPath(_hull, _hullGlowPaint);
    canvas.drawPath(_hull, _hullPaint);
    canvas.drawPath(_hull, _hullStrokePaint);
    // cockpit
    canvas.drawCircle(const Offset(2, 0), 4, _cockpitPaint);

    canvas.restore();

    if (!alive) {
      // dimmed when dead
      canvas.drawColor(Colors.black.withValues(alpha: 0.4), BlendMode.dstIn);
    }
  }
}

/// The ship this client controls: reads input, runs physics, fires, and
/// broadcasts its authoritative state around 20 times a second.
class LocalShip extends ShipComponent
    with KeyboardHandler, HasGameReference<SpaceGame> {
  LocalShip({
    required super.id,
    required super.shipName,
    required super.color,
    required super.position,
  });

  static const _baseThrustAcceleration = 620.0;
  static const _baseMaximumSpeed = 460.0;
  static const _baseBulletSpeed = 720.0;
  static const _fireInterval = 0.22;
  static const _knockbackImpulse = 340.0;
  static const _broadcastInterval = 0.05;

  // Per-level bonuses applied by powerups.
  static const _shipSpeedPerLevel = 95.0;
  static const _shipAccelerationPerLevel = 110.0;
  static const _bulletSpeedPerLevel = 180.0;
  static const _shotgunSpread = 0.18; // radians between the three pellets

  bool _thrustPressed = false;
  bool _brakePressed = false;
  double _fireCooldown = 0;
  double _broadcastTimer = 0;

  // Powerup state. Bullet/ship speed stack per pickup; shotgun and homing are
  // on/off abilities once collected.
  int _bulletSpeedLevel = 0;
  int _shipSpeedLevel = 0;
  bool _shotgunEnabled = false;
  bool _homingEnabled = false;

  double get _maximumSpeed =>
      _baseMaximumSpeed + _shipSpeedLevel * _shipSpeedPerLevel;
  double get _thrustAcceleration =>
      _baseThrustAcceleration + _shipSpeedLevel * _shipAccelerationPerLevel;
  double get _bulletSpeed =>
      _baseBulletSpeed + _bulletSpeedLevel * _bulletSpeedPerLevel;

  /// Reused for each shot's spawn position so firing doesn't allocate; the
  /// bullet clones it, so sharing the buffer is safe.
  final Vector2 _muzzle = Vector2.zero();

  /// Applies a collected powerup to this ship.
  void applyPowerup(PowerupType type) {
    switch (type) {
      case PowerupType.bulletSpeed:
        _bulletSpeedLevel++;
      case PowerupType.shipSpeed:
        _shipSpeedLevel++;
      case PowerupType.shotgun:
        _shotgunEnabled = true;
      case PowerupType.homing:
        _homingEnabled = true;
    }
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    _thrustPressed =
        keysPressed.contains(LogicalKeyboardKey.keyW) ||
        keysPressed.contains(LogicalKeyboardKey.arrowUp);
    _brakePressed =
        keysPressed.contains(LogicalKeyboardKey.keyS) ||
        keysPressed.contains(LogicalKeyboardKey.arrowDown);
    return true;
  }

  void applyKnockback(double directionAngle) {
    velocity.x += cos(directionAngle) * _knockbackImpulse;
    velocity.y += sin(directionAngle) * _knockbackImpulse;
  }

  @override
  void update(double deltaTime) {
    super.update(deltaTime);
    if (!alive) {
      return;
    }

    // Aim toward the mouse cursor. Scalar math avoids allocating a Vector2
    // every frame.
    final aimX = game.aimWorld.x - position.x;
    final aimY = game.aimWorld.y - position.y;
    if (aimX * aimX + aimY * aimY > 4) {
      final target = atan2(aimY, aimX);
      facing = _interpolateAngle(facing, target, min(1, deltaTime * 14));
    }

    // Thrust / brake — keyboard or the on-screen (mobile) buttons.
    final thrust = _thrustPressed || game.thrustHeld;
    final brake = _brakePressed || game.brakeHeld;
    thrusting = thrust;
    if (thrust) {
      final acceleration = _thrustAcceleration * deltaTime;
      velocity.x += cos(facing) * acceleration;
      velocity.y += sin(facing) * acceleration;
    }
    final drag = brake ? 2.6 : 0.5;
    velocity.scale(max(0, 1 - drag * deltaTime));
    if (velocity.length > _maximumSpeed) {
      velocity.scaleTo(_maximumSpeed);
    }

    position.addScaled(velocity, deltaTime);
    _clampToWorld();

    // Fire while the left mouse button is held.
    _fireCooldown -= deltaTime;
    if (game.firing && _fireCooldown <= 0) {
      _fireCooldown = _fireInterval;
      _fire();
    }

    // Broadcast authoritative state.
    _broadcastTimer -= deltaTime;
    if (_broadcastTimer <= 0) {
      _broadcastTimer = _broadcastInterval;
      game.broadcastShipState(this);
    }
  }

  /// Fires a single shot, or a three-pellet forward spread with the shotgun
  /// powerup.
  void _fire() {
    if (_shotgunEnabled) {
      _fireOne(facing - _shotgunSpread);
      _fireOne(facing);
      _fireOne(facing + _shotgunSpread);
    } else {
      _fireOne(facing);
    }
  }

  void _fireOne(double angle) {
    _muzzle.setValues(
      position.x + cos(angle) * 24,
      position.y + sin(angle) * 24,
    );
    game.fireBullet(
      ownerId: id,
      origin: _muzzle,
      angle: angle,
      speed: _bulletSpeed,
      homing: _homingEnabled,
    );
  }

  void _clampToWorld() {
    final worldSize = SpaceGame.worldSize;
    if (position.x < radius) {
      position.x = radius;
      velocity.x = velocity.x.abs() * 0.4;
    } else if (position.x > worldSize.x - radius) {
      position.x = worldSize.x - radius;
      velocity.x = -velocity.x.abs() * 0.4;
    }
    if (position.y < radius) {
      position.y = radius;
      velocity.y = velocity.y.abs() * 0.4;
    } else if (position.y > worldSize.y - radius) {
      position.y = worldSize.y - radius;
      velocity.y = -velocity.y.abs() * 0.4;
    }
  }
}

/// A ship owned by another client. Snaps to broadcast states and extrapolates
/// using the last known velocity between updates for smooth motion.
class RemoteShip extends ShipComponent {
  RemoteShip({
    required super.id,
    required super.shipName,
    required super.color,
    required super.position,
  });

  final Vector2 _target = Vector2.zero();
  double _targetFacing = 0;

  void applyState({
    required Vector2 position,
    required double facing,
    required Vector2 velocity,
    required bool alive,
  }) {
    _target.setFrom(position);
    _targetFacing = facing;
    this.velocity.setFrom(velocity);
    this.alive = alive;
    thrusting = velocity.length > 40;
  }

  @override
  void update(double deltaTime) {
    super.update(deltaTime);
    // extrapolate, then ease toward the latest target
    _target.addScaled(velocity, deltaTime);
    position.lerp(_target, min(1, deltaTime * 12));
    facing = _interpolateAngle(facing, _targetFacing, min(1, deltaTime * 12));
  }
}

double _interpolateAngle(double from, double to, double fraction) {
  var difference = (to - from) % (2 * pi);
  if (difference > pi) {
    difference -= 2 * pi;
  }
  if (difference < -pi) {
    difference += 2 * pi;
  }
  return from + difference * fraction;
}
