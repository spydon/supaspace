import 'dart:math';

import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

/// A small overview of the whole arena, pinned to the upper-left corner.
///
/// Following Flame's padracing example, this is a second [CameraComponent]
/// looking at the same [world] through a fixed-size viewport, zoomed out far
/// enough that the entire [worldSize] fits. Planets and ships therefore show up
/// at their real positions, scaled down. A dark backdrop sits behind the world
/// (so it reads as a panel rather than blending into the main view) and a thin
/// border frames it.
class Minimap extends CameraComponent {
  Minimap({required World world, required this.worldSize})
    : super(
        world: world,
        viewport: FixedSizeViewport(viewSize.x, viewSize.y)..position = margin,
      );

  final Vector2 worldSize;

  static final Vector2 viewSize = Vector2(210, 150);
  static final Vector2 margin = Vector2.all(16);

  @override
  Future<void> onLoad() async {
    // Zoom so the whole world fits within the viewport (limited by whichever
    // axis is tighter), centred on the middle of the arena.
    final zoom = min(viewSize.x / worldSize.x, viewSize.y / worldSize.y);
    viewfinder
      ..anchor = Anchor.center
      ..position = worldSize / 2
      ..zoom = zoom;

    backdrop = RectangleComponent(
      size: viewSize,
      paint: Paint()..color = const Color(0xCC05060F),
    );

    viewport.add(
      RectangleComponent(
        size: viewSize,
        paint: Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = Colors.white.withValues(alpha: 0.3),
      ),
    );
  }
}
