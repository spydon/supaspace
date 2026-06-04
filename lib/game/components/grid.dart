import 'dart:ui' show Vertices, VertexMode;

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:supaspace/game/components/minimap.dart';

/// A faint reference grid spanning the whole world.
///
/// The starfield backdrop is fixed to the screen, so on its own it gives no
/// sense of motion while flying. This grid lives in world space, so it scrolls
/// beneath the ship as the camera moves and the player no longer feels lost.
///
/// Every grid line is expanded into a thin quad (two triangles); all lines are
/// built once into a single triangle mesh and drawn with one
/// [Canvas.drawVertices] call. It is skipped while the [Minimap] renders, to
/// keep the overview uncluttered.
class GridComponent extends PositionComponent {
  GridComponent({required Vector2 worldSize})
    : super(size: worldSize, priority: -1);

  static const double _spacing = 160;
  static const int _majorEvery = 4; // every 4th line is emphasised
  static const double _minorWidth = 1.5;
  static const double _majorWidth = 2.5;

  late final Vertices _minorMesh;
  late final Vertices _majorMesh;

  final Paint _minorPaint = Paint()..color = const Color(0x12FFFFFF);
  final Paint _majorPaint = Paint()..color = const Color(0x2866E0FF);

  /// A clear bright border marking the edge of the playable world.
  final Paint _borderPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 6
    ..color = const Color(0xFF66E0FF).withValues(alpha: 0.85);

  /// Cached world bounds — the size is fixed, so this never needs rebuilding.
  late final Rect _bounds = size.toRect();

  @override
  Future<void> onLoad() async {
    final minor = <Offset>[];
    final major = <Offset>[];

    var index = 0;
    for (var x = 0.0; x <= size.x; x += _spacing) {
      final isMajor = index % _majorEvery == 0;
      _addLine(
        isMajor ? major : minor,
        Offset(x, 0),
        Offset(x, size.y),
        isMajor ? _majorWidth : _minorWidth,
      );
      index++;
    }

    index = 0;
    for (var y = 0.0; y <= size.y; y += _spacing) {
      final isMajor = index % _majorEvery == 0;
      _addLine(
        isMajor ? major : minor,
        Offset(0, y),
        Offset(size.x, y),
        isMajor ? _majorWidth : _minorWidth,
      );
      index++;
    }

    _minorMesh = Vertices(VertexMode.triangles, minor);
    _majorMesh = Vertices(VertexMode.triangles, major);
  }

  /// Appends the two triangles of a [width]-thick line from [a] to [b].
  void _addLine(List<Offset> out, Offset a, Offset b, double width) {
    final delta = b - a;
    final length = delta.distance;
    if (length == 0) {
      return;
    }
    final half = width / 2;
    // Offset perpendicular to the line direction, scaled to half-width.
    final perpendicular = Offset(-delta.dy, delta.dx) / length * half;
    final corner1 = a + perpendicular;
    final corner2 = a - perpendicular;
    final corner3 = b - perpendicular;
    final corner4 = b + perpendicular;
    out
      ..add(corner1)
      ..add(corner2)
      ..add(corner3)
      ..add(corner1)
      ..add(corner3)
      ..add(corner4);
  }

  @override
  void render(Canvas canvas) {
    if (CameraComponent.currentCamera is Minimap) {
      return;
    }
    canvas.drawVertices(_minorMesh, BlendMode.srcOver, _minorPaint);
    canvas.drawVertices(_majorMesh, BlendMode.srcOver, _majorPaint);
    canvas.drawRect(_bounds, _borderPaint);
  }
}
