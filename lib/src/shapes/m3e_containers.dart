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
/// Use the factory constructors like [M3EContainer.gem] or [M3EContainer.slanted]
/// for a more declarative and readable way to create a shaped container.
///
/// Using [gradient] along with [color] will override the [color].
///
/// {@tool snippet}
///
/// ```dart
/// M3EContainer.gem(
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
class M3EContainer extends StatelessWidget {
  final Widget child;
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

  const M3EContainer(
    this.shape, {
    super.key,
    required this.child,
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
          child: child,
        ),
      ),
    );
  }

  /// Creates a container with a circle shape.
  factory M3EContainer.circle({
    required Widget child,
    double? width,
    double? height,
    Color? color,
    Gradient? gradient,
    BorderSide border = BorderSide.none,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Clip clipBehavior = Clip.antiAlias,
  }) => M3EContainer(
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
    child: child,
  );

  /// Creates a container with a square shape.
  factory M3EContainer.square({
    required Widget child,
    double? width,
    double? height,
    Color? color,
    Gradient? gradient,
    BorderSide border = BorderSide.none,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Clip clipBehavior = Clip.antiAlias,
  }) => M3EContainer(
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
    child: child,
  );

  /// Creates a container with a slanted shape.
  factory M3EContainer.slanted({
    required Widget child,
    double? width,
    double? height,
    Color? color,
    Gradient? gradient,
    BorderSide border = BorderSide.none,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Clip clipBehavior = Clip.antiAlias,
  }) => M3EContainer(
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
    child: child,
  );

  /// Creates a container with an arch shape.
  factory M3EContainer.arch({
    required Widget child,
    double? width,
    double? height,
    Color? color,
    Gradient? gradient,
    BorderSide border = BorderSide.none,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Clip clipBehavior = Clip.antiAlias,
  }) => M3EContainer(
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
    child: child,
  );

  /// Creates a container with a semicircle shape.
  factory M3EContainer.semicircle({
    required Widget child,
    double? width,
    double? height,
    Color? color,
    Gradient? gradient,
    BorderSide border = BorderSide.none,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Clip clipBehavior = Clip.antiAlias,
  }) => M3EContainer(
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
    child: child,
  );

  /// Creates a container with a clampShell shape.
  factory M3EContainer.clampShell({
    required Widget child,
    double? width,
    double? height,
    Color? color,
    Gradient? gradient,
    BorderSide border = BorderSide.none,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Clip clipBehavior = Clip.antiAlias,
  }) => M3EContainer(
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
    child: child,
  );

  /// Creates a container with an oval shape.
  factory M3EContainer.oval({
    required Widget child,
    double? width,
    double? height,
    Color? color,
    Gradient? gradient,
    BorderSide border = BorderSide.none,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Clip clipBehavior = Clip.antiAlias,
  }) => M3EContainer(
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
    child: child,
  );

  /// Creates a container with a pill shape.
  factory M3EContainer.pill({
    required Widget child,
    double? width,
    double? height,
    Color? color,
    Gradient? gradient,
    BorderSide border = BorderSide.none,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Clip clipBehavior = Clip.antiAlias,
  }) => M3EContainer(
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
    child: child,
  );

  /// Creates a container with a triangle shape.
  factory M3EContainer.triangle({
    required Widget child,
    double? width,
    double? height,
    Color? color,
    Gradient? gradient,
    BorderSide border = BorderSide.none,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Clip clipBehavior = Clip.antiAlias,
  }) => M3EContainer(
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
    child: child,
  );

  /// Creates a container with an arrow shape.
  factory M3EContainer.arrow({
    required Widget child,
    double? width,
    double? height,
    Color? color,
    Gradient? gradient,
    BorderSide border = BorderSide.none,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Clip clipBehavior = Clip.antiAlias,
  }) => M3EContainer(
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
    child: child,
  );

  /// Creates a container with a fan shape.
  factory M3EContainer.fan({
    required Widget child,
    double? width,
    double? height,
    Color? color,
    Gradient? gradient,
    BorderSide border = BorderSide.none,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Clip clipBehavior = Clip.antiAlias,
  }) => M3EContainer(
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
    child: child,
  );

  /// Creates a container with a diamond shape.
  factory M3EContainer.diamond({
    required Widget child,
    double? width,
    double? height,
    Color? color,
    Gradient? gradient,
    BorderSide border = BorderSide.none,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Clip clipBehavior = Clip.antiAlias,
  }) => M3EContainer(
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
    child: child,
  );

  /// Creates a container with a pentagon shape.
  factory M3EContainer.pentagon({
    required Widget child,
    double? width,
    double? height,
    Color? color,
    Gradient? gradient,
    BorderSide border = BorderSide.none,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Clip clipBehavior = Clip.antiAlias,
  }) => M3EContainer(
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
    child: child,
  );

  /// Creates a container with a gem shape.
  factory M3EContainer.gem({
    required Widget child,
    double? width,
    double? height,
    Color? color,
    Gradient? gradient,
    BorderSide border = BorderSide.none,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Clip clipBehavior = Clip.antiAlias,
  }) => M3EContainer(
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
    child: child,
  );

  /// Creates a container with a very_sunny shape.
  factory M3EContainer.verySunny({
    required Widget child,
    double? width,
    double? height,
    Color? color,
    Gradient? gradient,
    BorderSide border = BorderSide.none,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Clip clipBehavior = Clip.antiAlias,
  }) => M3EContainer(
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
    child: child,
  );

  /// Creates a container with a sunny shape.
  factory M3EContainer.sunny({
    required Widget child,
    double? width,
    double? height,
    Color? color,
    Gradient? gradient,
    BorderSide border = BorderSide.none,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Clip clipBehavior = Clip.antiAlias,
  }) => M3EContainer(
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
    child: child,
  );

  /// Creates a container with a 4-sided cookie shape.
  factory M3EContainer.c4SidedCookie({
    required Widget child,
    double? width,
    double? height,
    Color? color,
    Gradient? gradient,
    BorderSide border = BorderSide.none,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Clip clipBehavior = Clip.antiAlias,
  }) => M3EContainer(
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
    child: child,
  );

  /// Creates a container with a 6-sided cookie shape.
  factory M3EContainer.c6SidedCookie({
    required Widget child,
    double? width,
    double? height,
    Color? color,
    Gradient? gradient,
    BorderSide border = BorderSide.none,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Clip clipBehavior = Clip.antiAlias,
  }) => M3EContainer(
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
    child: child,
  );

  /// Creates a container with a 7-sided cookie shape.
  factory M3EContainer.c7SidedCookie({
    required Widget child,
    double? width,
    double? height,
    Color? color,
    Gradient? gradient,
    BorderSide border = BorderSide.none,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Clip clipBehavior = Clip.antiAlias,
  }) => M3EContainer(
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
    child: child,
  );

  /// Creates a container with a 9-sided cookie shape.
  factory M3EContainer.c9SidedCookie({
    required Widget child,
    double? width,
    double? height,
    Color? color,
    Gradient? gradient,
    BorderSide border = BorderSide.none,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Clip clipBehavior = Clip.antiAlias,
  }) => M3EContainer(
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
    child: child,
  );

  /// Creates a container with a 12-sided cookie shape.
  factory M3EContainer.c12SidedCookie({
    required Widget child,
    double? width,
    double? height,
    Color? color,
    Gradient? gradient,
    BorderSide border = BorderSide.none,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Clip clipBehavior = Clip.antiAlias,
  }) => M3EContainer(
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
    child: child,
  );

  /// Creates a container with a 4-leaf clover shape.
  factory M3EContainer.l4LeafClover({
    required Widget child,
    double? width,
    double? height,
    Color? color,
    Gradient? gradient,
    BorderSide border = BorderSide.none,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Clip clipBehavior = Clip.antiAlias,
  }) => M3EContainer(
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
    child: child,
  );

  /// Creates a container with an 8-leaf clover shape.
  factory M3EContainer.l8LeafClover({
    required Widget child,
    double? width,
    double? height,
    Color? color,
    Gradient? gradient,
    BorderSide border = BorderSide.none,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Clip clipBehavior = Clip.antiAlias,
  }) => M3EContainer(
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
    child: child,
  );

  /// Creates a container with a burst shape.
  factory M3EContainer.burst({
    required Widget child,
    double? width,
    double? height,
    Color? color,
    Gradient? gradient,
    BorderSide border = BorderSide.none,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Clip clipBehavior = Clip.antiAlias,
  }) => M3EContainer(
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
    child: child,
  );

  /// Creates a container with a soft_burst shape.
  factory M3EContainer.softBurst({
    required Widget child,
    double? width,
    double? height,
    Color? color,
    Gradient? gradient,
    BorderSide border = BorderSide.none,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Clip clipBehavior = Clip.antiAlias,
  }) => M3EContainer(
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
    child: child,
  );

  /// Creates a container with a boom shape.
  factory M3EContainer.boom({
    required Widget child,
    double? width,
    double? height,
    Color? color,
    Gradient? gradient,
    BorderSide border = BorderSide.none,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Clip clipBehavior = Clip.antiAlias,
  }) => M3EContainer(
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
    child: child,
  );

  /// Creates a container with a soft_boom shape.
  factory M3EContainer.softBoom({
    required Widget child,
    double? width,
    double? height,
    Color? color,
    Gradient? gradient,
    BorderSide border = BorderSide.none,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Clip clipBehavior = Clip.antiAlias,
  }) => M3EContainer(
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
    child: child,
  );

  /// Creates a container with a flower shape.
  factory M3EContainer.flower({
    required Widget child,
    double? width,
    double? height,
    Color? color,
    Gradient? gradient,
    BorderSide border = BorderSide.none,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Clip clipBehavior = Clip.antiAlias,
  }) => M3EContainer(
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
    child: child,
  );

  /// Creates a container with a puffy shape.
  factory M3EContainer.puffy({
    required Widget child,
    double? width,
    double? height,
    Color? color,
    Gradient? gradient,
    BorderSide border = BorderSide.none,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Clip clipBehavior = Clip.antiAlias,
  }) => M3EContainer(
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
    child: child,
  );

  /// Creates a container with a puffy_diamond shape.
  factory M3EContainer.puffyDiamond({
    required Widget child,
    double? width,
    double? height,
    Color? color,
    Gradient? gradient,
    BorderSide border = BorderSide.none,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Clip clipBehavior = Clip.antiAlias,
  }) => M3EContainer(
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
    child: child,
  );

  /// Creates a container with a ghostish shape.
  factory M3EContainer.ghostish({
    required Widget child,
    double? width,
    double? height,
    Color? color,
    Gradient? gradient,
    BorderSide border = BorderSide.none,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Clip clipBehavior = Clip.antiAlias,
  }) => M3EContainer(
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
    child: child,
  );

  /// Creates a container with a pixel_circle shape.
  factory M3EContainer.pixelCircle({
    required Widget child,
    double? width,
    double? height,
    Color? color,
    Gradient? gradient,
    BorderSide border = BorderSide.none,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Clip clipBehavior = Clip.antiAlias,
  }) => M3EContainer(
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
    child: child,
  );

  /// Creates a container with a pixel_triangle shape.
  factory M3EContainer.pixelTriangle({
    required Widget child,
    double? width,
    double? height,
    Color? color,
    Gradient? gradient,
    BorderSide border = BorderSide.none,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Clip clipBehavior = Clip.antiAlias,
  }) => M3EContainer(
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
    child: child,
  );

  /// Creates a container with a bun shape.
  factory M3EContainer.bun({
    required Widget child,
    double? width,
    double? height,
    Color? color,
    Gradient? gradient,
    BorderSide border = BorderSide.none,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Clip clipBehavior = Clip.antiAlias,
  }) => M3EContainer(
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
    child: child,
  );

  /// Creates a container with a hearth shape.
  factory M3EContainer.hearth({
    required Widget child,
    double? width,
    double? height,
    Color? color,
    Gradient? gradient,
    BorderSide border = BorderSide.none,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Clip clipBehavior = Clip.antiAlias,
  }) => M3EContainer(
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
    child: child,
  );
}
