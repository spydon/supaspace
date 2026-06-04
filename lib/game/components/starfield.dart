import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'package:supaspace/game/space_game.dart';

/// Full-screen animated starfield rendered by `shaders/starfield.frag`.
///
/// Installed as the camera's backdrop so it renders behind the world (fixed on
/// screen), and receives the camera's world position as a uniform so the star
/// layers parallax as the player flies around.
class Starfield extends PositionComponent
    with HasGameReference<SpaceGame>, HasPaint {
  Starfield();

  /// Multiplier on real time fed to the shader; below 1 slows the drift.
  static const _animationSpeed = 0.3;

  ui.FragmentShader? _shader;
  double _elapsedTime = 0;

  // Reused across frames instead of allocating in [render]. [_bounds] is
  // recomputed only when the size changes (on resize), not every frame.
  final Paint _fallbackPaint = Paint()..color = const Color(0xFF05060F);
  final Paint _shaderPaint = Paint();
  Rect _bounds = Rect.zero;

  @override
  Future<void> onLoad() async {
    final program = await ui.FragmentProgram.fromAsset(
      'shaders/starfield.frag',
    );
    _shader = program.fragmentShader();
    size = game.size.clone();
    _bounds = size.toRect();
  }

  @override
  void onGameResize(Vector2 newSize) {
    super.onGameResize(newSize);
    size = newSize.clone();
    _bounds = size.toRect();
  }

  @override
  void update(double deltaTime) {
    _elapsedTime += deltaTime * _animationSpeed;
  }

  @override
  void render(Canvas canvas) {
    final shader = _shader;
    if (shader == null) {
      canvas.drawRect(_bounds, _fallbackPaint);
      return;
    }
    final cameraPosition = game.camera.viewfinder.position;
    shader
      ..setFloat(0, size.x)
      ..setFloat(1, size.y)
      ..setFloat(2, _elapsedTime)
      ..setFloat(3, cameraPosition.x)
      ..setFloat(4, cameraPosition.y);
    canvas.drawRect(_bounds, _shaderPaint..shader = shader);
  }
}
