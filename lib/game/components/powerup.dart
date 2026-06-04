import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:supaspace/game/powerup_field.dart';
import 'package:supaspace/game/powerup_type.dart';

/// A collectable powerup floating in the world, shown as its looping magic-sign
/// animation. Picked up the same way a planet is taken — fly your ship onto it
/// and hold for the capture time, which fills the ring drawn around it — after
/// which [collect] animates it away with [Effect]s.
class PowerupComponent extends SpriteAnimationComponent {
  PowerupComponent({
    required this.specification,
    required SpriteAnimation animation,
  }) : super(
         animation: animation,
         position: specification.position.clone(),
         size: Vector2.all(_diameter),
         anchor: Anchor.center,
       );

  static const double _diameter = 140;

  final PowerupSpecification specification;

  /// True once picked up; it then animates out and is ignored by pickup checks.
  bool collected = false;

  /// 0..1 local-player pickup progress; reset to 0 when not hovering. Drives
  /// the sweep ring, mirroring a planet capture.
  double captureProgress = 0;

  int get id => specification.id;
  PowerupType get type => specification.type;

  /// Pickup radius — a little tighter than the sprite so you have to fly onto
  /// it rather than merely graze its glow.
  double get radius => _diameter * 0.4;

  // Reused across frames instead of allocating in [render]. The sweep's shader
  // depends on the ring rect, so it is reassigned each frame, but the Paint is
  // not reallocated.
  final Paint _trackPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 5
    ..color = Colors.white.withValues(alpha: 0.12);
  final Paint _sweepPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 5;

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (collected || captureProgress <= 0) {
      return;
    }
    final center = Offset(width / 2, height / 2);
    final ringRectangle = Rect.fromCircle(
      center: center,
      radius: width / 2 + 4,
    );
    // Faint track.
    canvas.drawArc(ringRectangle, 0, 2 * pi, false, _trackPaint);
    // Progress sweep, starting at the top and following the arc.
    _sweepPaint.shader = const SweepGradient(
      colors: [Color(0xFF66E0FF), Color(0xFFB388FF)],
      transform: GradientRotation(-pi / 2),
    ).createShader(ringRectangle);
    canvas.drawArc(
      ringRectangle,
      -pi / 2,
      2 * pi * captureProgress.clamp(0, 1),
      false,
      _sweepPaint,
    );
  }

  /// Marks the powerup collected and animates it away (a quick grow + fade),
  /// removing it once the fade completes.
  void collect() {
    if (collected) {
      return;
    }
    collected = true;
    add(
      ScaleEffect.to(
        Vector2.all(1.8),
        EffectController(duration: 0.35, curve: Curves.easeOut),
      ),
    );
    add(
      OpacityEffect.fadeOut(
        EffectController(duration: 0.35, curve: Curves.easeIn),
        onComplete: removeFromParent,
      ),
    );
  }
}
