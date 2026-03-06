import 'package:flutter/widgets.dart';
import 'package:m3e_core/src/shapes/enums/shapes.dart';
import 'package:path_drawing/path_drawing.dart';
import 'package:vector_math/vector_math_64.dart';

/// Parse an svg path string ina Path object for render
/// converts the 'M', 'L', 'C', etc. commands
/// into corresponding Path method calls.
Path _parseSvgPath(String svgPath) {
  return parseSvgPathData(svgPath);
}

/// This class takes a `shape` which contains an SVG path data string. It then
/// parses this string into a Flutter [Path] object and scales it to fit the
/// dimensions of the widget it is clipping.
class M3EClipper extends CustomClipper<Path> {
  /// The shape definition containing the SVG path string.
  final Shapes shape;

  /// Creates an instance of [M3EClipper] with a specific shape.
  M3EClipper(this.shape);

  /// Returns the clipping path for the given [size].
  ///
  /// This method takes the SVG path string from the [shape], parses it,
  /// and then calculates the necessary transformations (scaling and translation)
  /// to make the path fit perfectly within the provided [size].
  @override
  Path getClip(Size size) {
    // Retrieve the SVG path data as a string.
    String svgPath = shape.svg;

    // 1. Parse the SVG path string into a Flutter Path object.
    // The `parseSvgPath` function converts the 'M', 'L', 'C', etc. commands
    // into corresponding Path method calls.
    final Path parsedPath = _parseSvgPath(svgPath);

    // 2. Get the original bounding box of the parsed path.
    // This gives us the original dimensions and position of the SVG shape.
    final Rect bounds = parsedPath.getBounds();

    // 3. Calculate the scaling factors.
    // We determine how much to scale the path on the X and Y axes
    // to make it fit the target widget's width and height.
    final double scaleX = size.width / bounds.width;
    final double scaleY = size.height / bounds.height;

    // 4. Create a transformation matrix.
    // This matrix will apply the scaling and translation to the path.
    final Matrix4 matrix4 = Matrix4.identity();

    // Apply scaling to the matrix.
    matrix4.scaleByVector3(Vector3(scaleX, scaleY, 0));

    // Apply translation to the matrix. This moves the path's top-left
    // corner to the origin (0,0) before scaling, ensuring it aligns correctly.
    matrix4.translateByVector3(Vector3(-bounds.left, -bounds.top, 0));

    // 5. Apply the transformation to the path.
    // The `transform` method creates a new path with the matrix applied.
    final Path scaledPath = parsedPath.transform(matrix4.storage);

    return scaledPath;
  }

  /// Determines if the clipper should re-clip the widget.
  ///
  /// This method returns `false` as a performance optimization. Since the `shape`
  /// is final and will not change for a given instance of [M3EClipper],
  /// the clipping path does not need to be recalculated unless a new
  /// [M3EClipper] instance is provided.
  @override
  bool shouldReclip(covariant M3EClipper oldClipper) {
    return false;
  }
}
