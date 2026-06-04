import 'package:flame/components.dart';
import 'package:flutter/material.dart';

/// A short-lived taunt shown above a ship: an emoji with a random phrase under
/// it. It pops in, drifts upward, and fades out before removing itself. Added
/// as a child of the ship so it tracks the ship's position.
class TauntBubble extends PositionComponent {
  TauntBubble({
    required this.emoji,
    required this.taunt,
    required Vector2 position,
  }) : super(position: position);

  final String emoji;
  final String taunt;

  static const _lifetime = 2.6;
  static const _fadeIn = 0.2;
  static const _fadeOut = 0.6;
  static const _rise = 26.0;

  double _age = 0;

  final TextPaint _emojiRenderer = TextPaint(
    style: const TextStyle(fontSize: 30),
  );
  final TextPaint _tauntRenderer = TextPaint(
    style: const TextStyle(
      color: Colors.white,
      fontSize: 13,
      fontWeight: FontWeight.w800,
      shadows: [Shadow(blurRadius: 4)],
    ),
  );

  // Reused for the fade — only its alpha changes, so it is never reallocated.
  final Paint _layerPaint = Paint();

  @override
  void update(double deltaTime) {
    _age += deltaTime;
    if (_age >= _lifetime) {
      removeFromParent();
    }
  }

  double get _opacity {
    if (_age < _fadeIn) {
      return (_age / _fadeIn).clamp(0, 1);
    }
    final remaining = _lifetime - _age;
    if (remaining < _fadeOut) {
      return (remaining / _fadeOut).clamp(0, 1);
    }
    return 1;
  }

  /// Quick pop-in to full size.
  double get _scale =>
      _age >= _fadeIn ? 1 : 0.5 + 0.5 * (_age / _fadeIn).clamp(0.0, 1.0);

  /// Bounds of the drawn content (emoji above the origin, the widest taunt
  /// below it). Passed to [Canvas.saveLayer] so it allocates a tightly-sized
  /// offscreen layer instead of one the size of the whole canvas.
  static const _layerBounds = Rect.fromLTRB(-200, -52, 200, 28);

  @override
  void render(Canvas canvas) {
    final rise = _rise * (_age / _lifetime).clamp(0.0, 1.0);
    canvas
      ..save()
      ..translate(0, -rise)
      ..scale(_scale);
    _layerPaint.color = Colors.white.withValues(alpha: _opacity);
    canvas.saveLayer(_layerBounds, _layerPaint);
    _emojiRenderer.render(
      canvas,
      emoji,
      Vector2(0, -8),
      anchor: Anchor.bottomCenter,
    );
    _tauntRenderer.render(
      canvas,
      taunt,
      Vector2(0, -6),
      anchor: Anchor.topCenter,
    );
    canvas
      ..restore()
      ..restore();
  }
}
