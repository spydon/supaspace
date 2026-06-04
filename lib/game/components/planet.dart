import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'package:supaspace/game/planet_field.dart';

/// A capturable planet. Visual state is driven by the game:
/// [ownerColor] (null = neutral) and [captureProgress] (0..1, the local
/// player's hover progress, rendered as a sweeping ring).
class PlanetComponent extends PositionComponent {
  PlanetComponent(this.specification)
    : super(
        position: specification.position.clone(),
        size: Vector2.all(specification.radius * 2),
        anchor: Anchor.center,
      );

  final PlanetSpecification specification;

  String? ownerId;
  Color? ownerColor;
  int capturedAt = 0; // epoch ms of current ownership (earliest wins on ties)

  /// 0..1 local-player capture progress; reset to 0 when not hovering.
  double captureProgress = 0;

  double get radius => specification.radius;

  late final Color _baseColor = HSLColor.fromAHSL(
    1,
    specification.hue,
    0.55,
    0.55,
  ).toColor();
  late final Color _baseDarkColor = HSLColor.fromAHSL(
    1,
    specification.hue,
    0.6,
    0.25,
  ).toColor();

  // Reused across frames instead of allocating in [render]. The body/glow/rim
  // appearance only changes while ownership is fading, so their shaders/colours
  // are rebuilt only then (see [_renderedBlend]) — a static planet just issues
  // the draw calls. Geometry is fixed per planet, so the rects are cached too.
  final Paint _glowPaint = Paint();
  final Paint _bodyPaint = Paint();
  final Paint _rimPaint = Paint()..style = PaintingStyle.stroke;
  final Paint _trackPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 5
    ..color = Colors.white.withValues(alpha: 0.12);
  final Paint _sweepPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 5;

  late final Offset _center = Offset(radius, radius);
  late final Rect _bodyRect = Rect.fromCircle(center: _center, radius: radius);
  late final Rect _glowRect = Rect.fromCircle(
    center: _center,
    radius: radius * 1.7,
  );
  late final Rect _captureRingRect = Rect.fromCircle(
    center: _center,
    radius: radius + 12,
  );

  // The (blend, tint) the body/glow/rim paints were last built for, so they are
  // rebuilt only when ownership actually changes.
  double _renderedBlend = -1;
  Color? _renderedTint;

  /// Seconds for ownership to fully fade in, out, or shift to a new owner.
  static const _fadeDuration = 0.6;

  /// The owner colour currently being drawn, and how strongly (0..1). These
  /// ease toward [ownerColor] in [update] so a capture fades in rather than
  /// snapping; a takeover crossfades between colours and losing it fades out.
  Color? _tintColor;
  double _ownershipBlend = 0;

  @override
  void update(double deltaTime) {
    super.update(deltaTime);
    final step = (deltaTime / _fadeDuration).clamp(0.0, 1.0);
    final owner = ownerColor;
    if (owner != null) {
      if (_tintColor == null || _ownershipBlend == 0) {
        // Fresh capture from neutral: adopt the colour and fade it in.
        _tintColor = owner;
      } else {
        // Changing hands: ease the displayed colour toward the new owner.
        _tintColor = Color.lerp(_tintColor, owner, step);
      }
      _ownershipBlend = min(1, _ownershipBlend + step);
    } else {
      _ownershipBlend = max(0, _ownershipBlend - step);
      if (_ownershipBlend == 0) {
        _tintColor = null;
      }
    }
  }

  @override
  void render(Canvas canvas) {
    // Rebuild the ownership-tinted paints only when the fade state changed.
    if (_ownershipBlend != _renderedBlend || _tintColor != _renderedTint) {
      _rebuildOwnershipPaints();
      _renderedBlend = _ownershipBlend;
      _renderedTint = _tintColor;
    }

    // Owner halo / atmosphere glow, fading in with ownership.
    if (_tintColor != null && _ownershipBlend > 0) {
      canvas.drawCircle(_center, radius * 1.7, _glowPaint);
    }
    // Shaded sphere body, then the rim light.
    canvas.drawCircle(_center, radius, _bodyPaint);
    canvas.drawCircle(_center, radius, _rimPaint);

    // Capture progress ring (local player hovering) — only while capturing.
    if (captureProgress > 0) {
      // faint track
      canvas.drawArc(_captureRingRect, 0, 2 * pi, false, _trackPaint);
      // progress sweep. Rotate the sweep so its colours start where the arc
      // starts (top, -pi/2) instead of the gradient's default 0 (3 o'clock),
      // so the fade follows the progress arc.
      _sweepPaint.shader = const SweepGradient(
        colors: [Color(0xFF66E0FF), Color(0xFFB388FF)],
        transform: GradientRotation(-pi / 2),
      ).createShader(_captureRingRect);
      canvas.drawArc(
        _captureRingRect,
        -pi / 2,
        2 * pi * captureProgress.clamp(0, 1),
        false,
        _sweepPaint,
      );
    }
  }

  /// Rebuilds the glow/body/rim paints for the current ownership fade. Called
  /// from [render] only when the fade state changes, so a static planet does no
  /// gradient/shader work per frame.
  void _rebuildOwnershipPaints() {
    final tint = _tintColor;
    final blend = _ownershipBlend;

    if (tint != null && blend > 0) {
      _glowPaint.shader = RadialGradient(
        colors: [
          tint.withValues(alpha: 0.45 * blend),
          tint.withValues(alpha: 0.0),
        ],
      ).createShader(_glowRect);
    }

    // As ownership fades in, both the lit and dark sides tint ever more
    // strongly toward the owner's colour, so the whole planet reads as taken.
    final litColor = Color.lerp(_baseColor, tint ?? _baseColor, 0.7 * blend)!;
    final darkColor = Color.lerp(
      _baseDarkColor,
      tint ?? _baseDarkColor,
      0.5 * blend,
    )!;
    _bodyPaint.shader = RadialGradient(
      center: const Alignment(-0.4, -0.4),
      colors: [litColor, darkColor],
    ).createShader(_bodyRect);

    _rimPaint
      ..strokeWidth = 2 + 1.5 * blend
      ..color = Color.lerp(
        _baseColor.withValues(alpha: 0.6),
        tint ?? _baseColor,
        blend,
      )!;
  }
}
