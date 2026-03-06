import 'package:flutter/widgets.dart';
import 'package:m3e_core/src/shapes/clipper.dart';
import 'package:m3e_core/src/shapes/enums/shapes.dart';
import 'package:m3e_core/src/shapes/m3e_shapeborders.dart';

// Assuming Shapes enum and M3EClipper class are defined elsewhere.
// enum Shapes { ... }
// class M3EClipper extends CustomClipper<Path> { ... }

/// A container widget that clips its child into a predefined shape.
///
/// This widget uses a [ClipPath] with a custom [M3EClipper] to create a
/// variety of shapes defined in the [Shapes] enum. It centers the resulting
/// clipped container and allows for customization of size and background color.
///
/// Use the factory constructors like [M3EShape.gem] or [M3EShape.slanted]
/// for a more declarative and readable way to create a shaped container.
///
/// Using [gradient] along with [color] will override the [color].
///
/// {@tool snippet}
///
/// ```dart
/// M3EShape.gem(
///   color: Colors.blue,
///   width: 200,
///   height: 200,
///   gradient: LinearGradient(
///     colors: [Colors.blue, Colors.lightBlueAccent],
///     begin: Alignment.topLeft,
///     end: Alignment.bottomRight,
///   ),
///   border: BorderSide(color: Colors.black, width: 2),
///   boxShadow: [
///     BoxShadow(
///       color: Colors.black26,
///       offset: Offset(0, 2),
///       blurRadius: 4,
///     ),
///   ],
///   padding: EdgeInsets.all(16),
///   margin: EdgeInsets.all(8),
///   clipBehavior: Clip.antiAlias,
///   child: Center(
///     child: Text(
///       'Gem!',
///       style: TextStyle(color: Colors.white, fontSize: 24),
///     ),
///   ),
/// )
/// ```
/// {@end-tool}
///
/// @see [ClipPath], [M3EClipper], [Shapes]
class M3EShape extends StatelessWidget {
  final Shapes shape;
  final double? width;
  final double? height;
  final Color? color;
  final Gradient? gradient;
  final BorderSide border;
  final List<BoxShadow>? boxShadow;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Clip clipBehavior;

  const M3EShape(
    this.shape, {
    super.key,
    this.width,
    this.height,
    this.color,
    this.gradient,
    this.border = BorderSide.none,
    this.boxShadow,
    this.padding,
    this.margin,
    this.clipBehavior = Clip.antiAlias,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: ShapeDecoration(
        shadows: boxShadow,
        shape: M3EShapeBorder(shape: shape, side: border),
      ),
      child: ClipPath(
        clipper: M3EClipper(shape),
        clipBehavior: clipBehavior,
        child: Container(
          decoration: BoxDecoration(color: color, gradient: gradient),
          padding: padding,
        ),
      ),
    );
  }

  /// Creates a container with a circle shape.
  factory M3EShape.circle({
    double? width,
    double? height,
    Color? color,
    Gradient? gradient,
    BorderSide border = BorderSide.none,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Clip clipBehavior = Clip.antiAlias,
  }) => M3EShape(
    Shapes.circle,
    height: height,
    width: width,
    color: color,
    gradient: gradient,
    border: border,
    boxShadow: boxShadow,
    padding: padding,
    margin: margin,
    clipBehavior: clipBehavior,
  );

  /// Creates a container with a square shape.
  factory M3EShape.square({
    double? width,
    double? height,
    Color? color,
    Gradient? gradient,
    BorderSide border = BorderSide.none,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Clip clipBehavior = Clip.antiAlias,
  }) => M3EShape(
    Shapes.square,
    height: height,
    width: width,
    color: color,
    gradient: gradient,
    border: border,
    boxShadow: boxShadow,
    padding: padding,
    margin: margin,
    clipBehavior: clipBehavior,
  );

  /// Creates a container with a slanted shape.
  factory M3EShape.slanted({
    double? width,
    double? height,
    Color? color,
    Gradient? gradient,
    BorderSide border = BorderSide.none,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Clip clipBehavior = Clip.antiAlias,
  }) => M3EShape(
    Shapes.slanted,
    height: height,
    width: width,
    color: color,
    gradient: gradient,
    border: border,
    boxShadow: boxShadow,
    padding: padding,
    margin: margin,
    clipBehavior: clipBehavior,
  );

  /// Creates a container with an arch shape.
  factory M3EShape.arch({
    double? width,
    double? height,
    Color? color,
    Gradient? gradient,
    BorderSide border = BorderSide.none,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Clip clipBehavior = Clip.antiAlias,
  }) => M3EShape(
    Shapes.arch,
    height: height,
    width: width,
    color: color,
    gradient: gradient,
    border: border,
    boxShadow: boxShadow,
    padding: padding,
    margin: margin,
    clipBehavior: clipBehavior,
  );

  /// Creates a container with a semicircle shape.
  factory M3EShape.semicircle({
    double? width,
    double? height,
    Color? color,
    Gradient? gradient,
    BorderSide border = BorderSide.none,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Clip clipBehavior = Clip.antiAlias,
  }) => M3EShape(
    Shapes.semicircle,
    height: height,
    width: width,
    color: color,
    gradient: gradient,
    border: border,
    boxShadow: boxShadow,
    padding: padding,
    margin: margin,
    clipBehavior: clipBehavior,
  );

  /// Creates a container with a clampShell shape.
  factory M3EShape.clampShell({
    double? width,
    double? height,
    Color? color,
    Gradient? gradient,
    BorderSide border = BorderSide.none,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Clip clipBehavior = Clip.antiAlias,
  }) => M3EShape(
    Shapes.clampShell,
    height: height,
    width: width,
    color: color,
    gradient: gradient,
    border: border,
    boxShadow: boxShadow,
    padding: padding,
    margin: margin,
    clipBehavior: clipBehavior,
  );

  /// Creates a container with an oval shape.
  factory M3EShape.oval({
    double? width,
    double? height,
    Color? color,
    Gradient? gradient,
    BorderSide border = BorderSide.none,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Clip clipBehavior = Clip.antiAlias,
  }) => M3EShape(
    Shapes.oval,
    height: height,
    width: width,
    color: color,
    gradient: gradient,
    border: border,
    boxShadow: boxShadow,
    padding: padding,
    margin: margin,
    clipBehavior: clipBehavior,
  );

  /// Creates a container with a pill shape.
  factory M3EShape.pill({
    double? width,
    double? height,
    Color? color,
    Gradient? gradient,
    BorderSide border = BorderSide.none,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Clip clipBehavior = Clip.antiAlias,
  }) => M3EShape(
    Shapes.pill,
    height: height,
    width: width,
    color: color,
    gradient: gradient,
    border: border,
    boxShadow: boxShadow,
    padding: padding,
    margin: margin,
    clipBehavior: clipBehavior,
  );

  /// Creates a container with a triangle shape.
  factory M3EShape.triangle({
    double? width,
    double? height,
    Color? color,
    Gradient? gradient,
    BorderSide border = BorderSide.none,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Clip clipBehavior = Clip.antiAlias,
  }) => M3EShape(
    Shapes.triangle,
    height: height,
    width: width,
    color: color,
    gradient: gradient,
    border: border,
    boxShadow: boxShadow,
    padding: padding,
    margin: margin,
    clipBehavior: clipBehavior,
  );

  /// Creates a container with an arrow shape.
  factory M3EShape.arrow({
    double? width,
    double? height,
    Color? color,
    Gradient? gradient,
    BorderSide border = BorderSide.none,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Clip clipBehavior = Clip.antiAlias,
  }) => M3EShape(
    Shapes.arrow,
    height: height,
    width: width,
    color: color,
    gradient: gradient,
    border: border,
    boxShadow: boxShadow,
    padding: padding,
    margin: margin,
    clipBehavior: clipBehavior,
  );

  /// Creates a container with a fan shape.
  factory M3EShape.fan({
    double? width,
    double? height,
    Color? color,
    Gradient? gradient,
    BorderSide border = BorderSide.none,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Clip clipBehavior = Clip.antiAlias,
  }) => M3EShape(
    Shapes.fan,
    height: height,
    width: width,
    color: color,
    gradient: gradient,
    border: border,
    boxShadow: boxShadow,
    padding: padding,
    margin: margin,
    clipBehavior: clipBehavior,
  );

  /// Creates a container with a diamond shape.
  factory M3EShape.diamond({
    double? width,
    double? height,
    Color? color,
    Gradient? gradient,
    BorderSide border = BorderSide.none,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Clip clipBehavior = Clip.antiAlias,
  }) => M3EShape(
    Shapes.diamond,
    height: height,
    width: width,
    color: color,
    gradient: gradient,
    border: border,
    boxShadow: boxShadow,
    padding: padding,
    margin: margin,
    clipBehavior: clipBehavior,
  );

  /// Creates a container with a pentagon shape.
  factory M3EShape.pentagon({
    double? width,
    double? height,
    Color? color,
    Gradient? gradient,
    BorderSide border = BorderSide.none,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Clip clipBehavior = Clip.antiAlias,
  }) => M3EShape(
    Shapes.pentagon,
    height: height,
    width: width,
    color: color,
    gradient: gradient,
    border: border,
    boxShadow: boxShadow,
    padding: padding,
    margin: margin,
    clipBehavior: clipBehavior,
  );

  /// Creates a container with a gem shape.
  factory M3EShape.gem({
    double? width,
    double? height,
    Color? color,
    Gradient? gradient,
    BorderSide border = BorderSide.none,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Clip clipBehavior = Clip.antiAlias,
  }) => M3EShape(
    Shapes.gem,
    height: height,
    width: width,
    color: color,
    gradient: gradient,
    border: border,
    boxShadow: boxShadow,
    padding: padding,
    margin: margin,
    clipBehavior: clipBehavior,
  );

  /// Creates a container with a very_sunny shape.
  factory M3EShape.verySunny({
    double? width,
    double? height,
    Color? color,
    Gradient? gradient,
    BorderSide border = BorderSide.none,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Clip clipBehavior = Clip.antiAlias,
  }) => M3EShape(
    Shapes.very_sunny,
    height: height,
    width: width,
    color: color,
    gradient: gradient,
    border: border,
    boxShadow: boxShadow,
    padding: padding,
    margin: margin,
    clipBehavior: clipBehavior,
  );

  /// Creates a container with a sunny shape.
  factory M3EShape.sunny({
    double? width,
    double? height,
    Color? color,
    Gradient? gradient,
    BorderSide border = BorderSide.none,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Clip clipBehavior = Clip.antiAlias,
  }) => M3EShape(
    Shapes.sunny,
    height: height,
    width: width,
    color: color,
    gradient: gradient,
    border: border,
    boxShadow: boxShadow,
    padding: padding,
    margin: margin,
    clipBehavior: clipBehavior,
  );

  /// Creates a container with a 4-sided cookie shape.
  factory M3EShape.c4SidedCookie({
    double? width,
    double? height,
    Color? color,
    Gradient? gradient,
    BorderSide border = BorderSide.none,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Clip clipBehavior = Clip.antiAlias,
  }) => M3EShape(
    Shapes.c4_sided_cookie,
    height: height,
    width: width,
    color: color,
    gradient: gradient,
    border: border,
    boxShadow: boxShadow,
    padding: padding,
    margin: margin,
    clipBehavior: clipBehavior,
  );

  /// Creates a container with a 6-sided cookie shape.
  factory M3EShape.c6SidedCookie({
    double? width,
    double? height,
    Color? color,
    Gradient? gradient,
    BorderSide border = BorderSide.none,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Clip clipBehavior = Clip.antiAlias,
  }) => M3EShape(
    Shapes.c6_sided_cookie,
    height: height,
    width: width,
    color: color,
    gradient: gradient,
    border: border,
    boxShadow: boxShadow,
    padding: padding,
    margin: margin,
    clipBehavior: clipBehavior,
  );

  /// Creates a container with a 7-sided cookie shape.
  factory M3EShape.c7SidedCookie({
    double? width,
    double? height,
    Color? color,
    Gradient? gradient,
    BorderSide border = BorderSide.none,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Clip clipBehavior = Clip.antiAlias,
  }) => M3EShape(
    Shapes.c7_sided_cookie,
    height: height,
    width: width,
    color: color,
    gradient: gradient,
    border: border,
    boxShadow: boxShadow,
    padding: padding,
    margin: margin,
    clipBehavior: clipBehavior,
  );

  /// Creates a container with a 9-sided cookie shape.
  factory M3EShape.c9SidedCookie({
    double? width,
    double? height,
    Color? color,
    Gradient? gradient,
    BorderSide border = BorderSide.none,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Clip clipBehavior = Clip.antiAlias,
  }) => M3EShape(
    Shapes.c9_sided_cookie,
    height: height,
    width: width,
    color: color,
    gradient: gradient,
    border: border,
    boxShadow: boxShadow,
    padding: padding,
    margin: margin,
    clipBehavior: clipBehavior,
  );

  /// Creates a container with a 12-sided cookie shape.
  factory M3EShape.c12SidedCookie({
    double? width,
    double? height,
    Color? color,
    Gradient? gradient,
    BorderSide border = BorderSide.none,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Clip clipBehavior = Clip.antiAlias,
  }) => M3EShape(
    Shapes.c12_sided_cookie,
    height: height,
    width: width,
    color: color,
    gradient: gradient,
    border: border,
    boxShadow: boxShadow,
    padding: padding,
    margin: margin,
    clipBehavior: clipBehavior,
  );

  /// Creates a container with a 4-leaf clover shape.
  factory M3EShape.l4LeafClover({
    double? width,
    double? height,
    Color? color,
    Gradient? gradient,
    BorderSide border = BorderSide.none,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Clip clipBehavior = Clip.antiAlias,
  }) => M3EShape(
    Shapes.l4_leaf_clover,
    height: height,
    width: width,
    color: color,
    gradient: gradient,
    border: border,
    boxShadow: boxShadow,
    padding: padding,
    margin: margin,
    clipBehavior: clipBehavior,
  );

  /// Creates a container with an 8-leaf clover shape.
  factory M3EShape.l8LeafClover({
    double? width,
    double? height,
    Color? color,
    Gradient? gradient,
    BorderSide border = BorderSide.none,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Clip clipBehavior = Clip.antiAlias,
  }) => M3EShape(
    Shapes.l8_leaf_clover,
    height: height,
    width: width,
    color: color,
    gradient: gradient,
    border: border,
    boxShadow: boxShadow,
    padding: padding,
    margin: margin,
    clipBehavior: clipBehavior,
  );

  /// Creates a container with a burst shape.
  factory M3EShape.burst({
    double? width,
    double? height,
    Color? color,
    Gradient? gradient,
    BorderSide border = BorderSide.none,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Clip clipBehavior = Clip.antiAlias,
  }) => M3EShape(
    Shapes.burst,
    height: height,
    width: width,
    color: color,
    gradient: gradient,
    border: border,
    boxShadow: boxShadow,
    padding: padding,
    margin: margin,
    clipBehavior: clipBehavior,
  );

  /// Creates a container with a soft_burst shape.
  factory M3EShape.softBurst({
    double? width,
    double? height,
    Color? color,
    Gradient? gradient,
    BorderSide border = BorderSide.none,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Clip clipBehavior = Clip.antiAlias,
  }) => M3EShape(
    Shapes.soft_burst,
    height: height,
    width: width,
    color: color,
    gradient: gradient,
    border: border,
    boxShadow: boxShadow,
    padding: padding,
    margin: margin,
    clipBehavior: clipBehavior,
  );

  /// Creates a container with a boom shape.
  factory M3EShape.boom({
    double? width,
    double? height,
    Color? color,
    Gradient? gradient,
    BorderSide border = BorderSide.none,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Clip clipBehavior = Clip.antiAlias,
  }) => M3EShape(
    Shapes.boom,
    height: height,
    width: width,
    color: color,
    gradient: gradient,
    border: border,
    boxShadow: boxShadow,
    padding: padding,
    margin: margin,
    clipBehavior: clipBehavior,
  );

  /// Creates a container with a soft_boom shape.
  factory M3EShape.softBoom({
    double? width,
    double? height,
    Color? color,
    Gradient? gradient,
    BorderSide border = BorderSide.none,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Clip clipBehavior = Clip.antiAlias,
  }) => M3EShape(
    Shapes.soft_boom,
    height: height,
    width: width,
    color: color,
    gradient: gradient,
    border: border,
    boxShadow: boxShadow,
    padding: padding,
    margin: margin,
    clipBehavior: clipBehavior,
  );

  /// Creates a container with a flower shape.
  factory M3EShape.flower({
    double? width,
    double? height,
    Color? color,
    Gradient? gradient,
    BorderSide border = BorderSide.none,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Clip clipBehavior = Clip.antiAlias,
  }) => M3EShape(
    Shapes.flower,
    height: height,
    width: width,
    color: color,
    gradient: gradient,
    border: border,
    boxShadow: boxShadow,
    padding: padding,
    margin: margin,
    clipBehavior: clipBehavior,
  );

  /// Creates a container with a puffy shape.
  factory M3EShape.puffy({
    double? width,
    double? height,
    Color? color,
    Gradient? gradient,
    BorderSide border = BorderSide.none,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Clip clipBehavior = Clip.antiAlias,
  }) => M3EShape(
    Shapes.puffy,
    height: height,
    width: width,
    color: color,
    gradient: gradient,
    border: border,
    boxShadow: boxShadow,
    padding: padding,
    margin: margin,
    clipBehavior: clipBehavior,
  );

  /// Creates a container with a puffy_diamond shape.
  factory M3EShape.puffyDiamond({
    double? width,
    double? height,
    Color? color,
    Gradient? gradient,
    BorderSide border = BorderSide.none,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Clip clipBehavior = Clip.antiAlias,
  }) => M3EShape(
    Shapes.puffy_diamond,
    height: height,
    width: width,
    color: color,
    gradient: gradient,
    border: border,
    boxShadow: boxShadow,
    padding: padding,
    margin: margin,
    clipBehavior: clipBehavior,
  );

  /// Creates a container with a ghostish shape.
  factory M3EShape.ghostish({
    double? width,
    double? height,
    Color? color,
    Gradient? gradient,
    BorderSide border = BorderSide.none,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Clip clipBehavior = Clip.antiAlias,
  }) => M3EShape(
    Shapes.ghostish,
    height: height,
    width: width,
    color: color,
    gradient: gradient,
    border: border,
    boxShadow: boxShadow,
    padding: padding,
    margin: margin,
    clipBehavior: clipBehavior,
  );

  /// Creates a container with a pixel_circle shape.
  factory M3EShape.pixelCircle({
    double? width,
    double? height,
    Color? color,
    Gradient? gradient,
    BorderSide border = BorderSide.none,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Clip clipBehavior = Clip.antiAlias,
  }) => M3EShape(
    Shapes.pixel_circle,
    height: height,
    width: width,
    color: color,
    gradient: gradient,
    border: border,
    boxShadow: boxShadow,
    padding: padding,
    margin: margin,
    clipBehavior: clipBehavior,
  );

  /// Creates a container with a pixel_triangle shape.
  factory M3EShape.pixelTriangle({
    double? width,
    double? height,
    Color? color,
    Gradient? gradient,
    BorderSide border = BorderSide.none,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Clip clipBehavior = Clip.antiAlias,
  }) => M3EShape(
    Shapes.pixel_triangle,
    height: height,
    width: width,
    color: color,
    gradient: gradient,
    border: border,
    boxShadow: boxShadow,
    padding: padding,
    margin: margin,
    clipBehavior: clipBehavior,
  );

  /// Creates a container with a bun shape.
  factory M3EShape.bun({
    double? width,
    double? height,
    Color? color,
    Gradient? gradient,
    BorderSide border = BorderSide.none,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Clip clipBehavior = Clip.antiAlias,
  }) => M3EShape(
    Shapes.bun,
    height: height,
    width: width,
    color: color,
    gradient: gradient,
    border: border,
    boxShadow: boxShadow,
    padding: padding,
    margin: margin,
    clipBehavior: clipBehavior,
  );

  /// Creates a container with a hearth shape.
  factory M3EShape.hearth({
    double? width,
    double? height,
    Color? color,
    Gradient? gradient,
    BorderSide border = BorderSide.none,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Clip clipBehavior = Clip.antiAlias,
  }) => M3EShape(
    Shapes.hearth,
    height: height,
    width: width,
    color: color,
    gradient: gradient,
    border: border,
    boxShadow: boxShadow,
    padding: padding,
    margin: margin,
    clipBehavior: clipBehavior,
  );
}
