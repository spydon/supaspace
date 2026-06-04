import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:supaspace/game/components/minimap.dart';

/// A highlight ring around the local player's ship, drawn only on the
/// [Minimap], so the player can pick themselves out from the other tiny ship
/// markers.
///
/// It is added as a child of the local ship, so it tracks the ship's position
/// automatically. The ring is large in world units — and therefore invisible at
/// normal zoom — but only rendered during the minimap's pass, where the heavy
/// zoom-out shrinks it to a small, readable ring.
class MinimapMarker extends PositionComponent {
  MinimapMarker({required Vector2 shipSize})
    : super(position: shipSize / 2, anchor: Anchor.center);

  static const _radius = 150.0;

  final Paint _ringPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 26
    ..color = Colors.white;

  @override
  void render(Canvas canvas) {
    if (CameraComponent.currentCamera is! Minimap) {
      return;
    }
    canvas.drawCircle(Offset.zero, _radius, _ringPaint);
  }
}
