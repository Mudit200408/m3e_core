import 'package:flutter/material.dart';
import 'package:m3e_core/src/shapes/clipper.dart';
import 'package:m3e_core/src/shapes/enums/shapes.dart';

/// A custom ShapeBorder implementation that applies borders to M3E shapes.
///
/// This class combines a shape with a border to create bordered custom shapes
/// for use in Material Design widgets.
class M3EShapeBorder extends ShapeBorder {
  final Shapes shape;

  final BorderSide side;

  const M3EShapeBorder({required this.shape, this.side = BorderSide.none});

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(side.width);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return _getPath(rect, -side.width);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return _getPath(rect, 0);
  }

  Path _getPath(Rect rect, double inset) {
    final clipper = M3EClipper(shape);
    final Size size = Size(rect.width + inset * 2, rect.height + inset * 2);
    final path = clipper.getClip(size);
    return path.shift(Offset(rect.left - inset, rect.top - inset));
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    if (side == BorderSide.none) return;

    final path = getOuterPath(rect, textDirection: textDirection);
    final paint = Paint()
      ..color = side.color
      ..strokeWidth = side.width
      ..style = PaintingStyle.stroke;

    canvas.drawPath(path, paint);
  }

  @override
  ShapeBorder scale(double t) {
    return M3EShapeBorder(shape: shape, side: side.scale(t));
  }
}
