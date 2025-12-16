import 'dart:math' as math;
import 'package:flutter/material.dart';

/// An animated logo widget that displays a 3D-style geometric logo
/// with bouncing animations and gradient effects.
class AnimatedLogo extends StatefulWidget {
  /// The size of the logo (width and height)
  final double size;

  /// Background color of the container
  final Color backgroundColor;

  const AnimatedLogo({
    super.key,
    this.size = 200,
    this.backgroundColor = const Color(0xFF414141),
  });

  @override
  State<AnimatedLogo> createState() => _AnimatedLogoState();
}

class _AnimatedLogoState extends State<AnimatedLogo>
    with TickerProviderStateMixin {
  late AnimationController _bounceController;
  late AnimationController _bounce2Controller;
  late AnimationController _umbralController;
  late AnimationController _particlesController;

  late Animation<double> _bounceAnimation;
  late Animation<double> _bounce2Animation;
  late Animation<double> _umbralAnimation;
  late Animation<double> _particlesAnimation;

  @override
  void initState() {
    super.initState();

    // Bounce animation (4s ease-in-out infinite)
    _bounceController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);
    _bounceAnimation = Tween<double>(begin: 36.0, end: 46.0).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
    );

    // Bounce2 animation (4s ease-in-out infinite, 0.5s delay)
    _bounce2Controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );
    _bounce2Animation = Tween<double>(begin: 46.0, end: 56.0).animate(
      CurvedAnimation(parent: _bounce2Controller, curve: Curves.easeInOut),
    );
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) _bounce2Controller.repeat(reverse: true);
    });

    // Umbral animation (color animation, 4s infinite)
    _umbralController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();
    _umbralAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _umbralController, curve: Curves.linear));

    // Particles animation (4s ease-in-out infinite)
    _particlesController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);
    _particlesAnimation = Tween<double>(begin: 16.0, end: 6.0).animate(
      CurvedAnimation(parent: _particlesController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _bounce2Controller.dispose();
    _umbralController.dispose();
    _particlesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size,
      height: widget.size,
      color: widget.backgroundColor,
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _bounceAnimation,
          _bounce2Animation,
          _umbralAnimation,
          _particlesAnimation,
        ]),
        builder: (context, child) {
          return CustomPaint(
            painter: _LogoPainter(
              bounceOffset: _bounceAnimation.value,
              bounce2Offset: _bounce2Animation.value,
              umbralProgress: _umbralAnimation.value,
              particlesOffset: _particlesAnimation.value,
              size: widget.size,
            ),
          );
        },
      ),
    );
  }
}

class _LogoPainter extends CustomPainter {
  final double bounceOffset;
  final double bounce2Offset;
  final double umbralProgress;
  final double particlesOffset;
  final double size;

  _LogoPainter({
    required this.bounceOffset,
    required this.bounce2Offset,
    required this.umbralProgress,
    required this.particlesOffset,
    required this.size,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = this.size / 2;
    final centerY = this.size / 2;
    final scale = this.size / 200.0; // Original SVG is 200x200

    canvas.save();

    // Helper function to create gradient
    // SVG gradients use percentages: x1, y1, x2, y2 as percentages
    LinearGradient createGradient({
      required double x1Percent,
      required double y1Percent,
      required double x2Percent,
      required double y2Percent,
      required List<Color> colors,
      required List<double> stops,
    }) {
      return LinearGradient(
        begin: Alignment(
          (x1Percent / 100 - 0.5) * 2,
          (y1Percent / 100 - 0.5) * 2,
        ),
        end: Alignment(
          (x2Percent / 100 - 0.5) * 2,
          (y2Percent / 100 - 0.5) * 2,
        ),
        colors: colors,
        stops: stops,
      );
    }

    // Animated umbral color
    final umbralColor =
        Color.lerp(
          const Color(0x2ED3A510),
          const Color(0x84D3A510),
          (math.sin(umbralProgress * 2 * math.pi) + 1) / 2,
        )!;

    // Polygon 1: bounce (rotated 45°, stroke only)
    canvas.save();
    canvas.translate(centerX, centerY);
    canvas.rotate(45 * math.pi / 180);
    canvas.translate(-centerX, -centerY);
    canvas.translate(0, bounceOffset * scale);
    _drawPolygon(
      canvas,
      [
        Offset(70 * scale, 70 * scale),
        Offset(148 * scale, 50 * scale),
        Offset(130 * scale, 130 * scale),
        Offset(50 * scale, 150 * scale),
      ],
      strokeColor: const Color(0xFFD3A410),
      strokeWidth: 1 * scale,
      fill: false,
    );
    canvas.restore();

    // Polygon 2: bounce2 (rotated 45°, stroke only)
    canvas.save();
    canvas.translate(centerX, centerY);
    canvas.rotate(45 * math.pi / 180);
    canvas.translate(-centerX, -centerY);
    canvas.translate(0, bounce2Offset * scale);
    _drawPolygon(
      canvas,
      [
        Offset(70 * scale, 70 * scale),
        Offset(148 * scale, 50 * scale),
        Offset(130 * scale, 130 * scale),
        Offset(50 * scale, 150 * scale),
      ],
      strokeColor: const Color(0xFFD3A410),
      strokeWidth: 1 * scale,
      fill: false,
    );
    canvas.restore();

    // Polygon 3: filled dark polygon (rotated 45°)
    canvas.save();
    canvas.translate(centerX, centerY);
    canvas.rotate(45 * math.pi / 180);
    canvas.translate(-centerX, -centerY);
    _drawPolygon(
      canvas,
      [
        Offset(70 * scale, 70 * scale),
        Offset(150 * scale, 50 * scale),
        Offset(130 * scale, 130 * scale),
        Offset(50 * scale, 150 * scale),
      ],
      fillColor: const Color(0xFF414750),
      strokeWidth: 2 * scale,
    );
    canvas.restore();

    // Polygon 4: gradient polygon (center diamond)
    // SVG: x1="0%" y1="0%" x2="10%" y2="100%"
    final gradient1 = createGradient(
      x1Percent: 0,
      y1Percent: 0,
      x2Percent: 10,
      y2Percent: 100,
      colors: [const Color(0xFF1E2026), const Color(0xFF414750)],
      stops: [0.2, 0.6],
    );
    _drawPolygonWithGradient(
      canvas,
      [
        Offset(100 * scale, 70 * scale),
        Offset(150 * scale, 100 * scale),
        Offset(100 * scale, 130 * scale),
        Offset(50 * scale, 100 * scale),
      ],
      gradient: gradient1,
      strokeWidth: 2 * scale,
    );

    // Polygon 5: yellow polygon (translated)
    canvas.save();
    canvas.translate(20 * scale, 31 * scale);
    _drawPolygon(
      canvas,
      [
        Offset(80 * scale, 50 * scale),
        Offset(80 * scale, 75 * scale),
        Offset(80 * scale, 99 * scale),
        Offset(40 * scale, 75 * scale),
      ],
      fillColor: const Color(0xFFB7870F),
      strokeWidth: 2 * scale,
    );
    canvas.restore();

    // Polygon 6: gradient polygon (translated)
    // SVG: x1="10%" y1="-17%" x2="0%" y2="100%"
    final gradient2 = createGradient(
      x1Percent: 10,
      y1Percent: -17,
      x2Percent: 0,
      y2Percent: 100,
      colors: [const Color(0x00D3A510), umbralColor],
      stops: [0.2, 1.0],
    );
    canvas.save();
    canvas.translate(20 * scale, 31 * scale);
    _drawPolygonWithGradient(
      canvas,
      [
        Offset(40 * scale, -40 * scale),
        Offset(80 * scale, -40 * scale),
        Offset(80 * scale, 99 * scale),
        Offset(40 * scale, 75 * scale),
      ],
      gradient: gradient2,
      strokeWidth: 2 * scale,
    );
    canvas.restore();

    // Polygon 7: yellow polygon (rotated 180°, translated)
    canvas.save();
    canvas.translate(centerX, centerY);
    canvas.rotate(180 * math.pi / 180);
    canvas.translate(-centerX, -centerY);
    canvas.translate(20 * scale, 20 * scale);
    _drawPolygon(
      canvas,
      [
        Offset(80 * scale, 50 * scale),
        Offset(80 * scale, 75 * scale),
        Offset(80 * scale, 99 * scale),
        Offset(40 * scale, 75 * scale),
      ],
      fillColor: const Color(0xFFD3A410),
      strokeWidth: 2 * scale,
    );
    canvas.restore();

    // Polygon 8: gradient polygon (rotated 0°, translated)
    // SVG: x1="0%" y1="0%" x2="10%" y2="100%"
    final gradient3 = createGradient(
      x1Percent: 0,
      y1Percent: 0,
      x2Percent: 10,
      y2Percent: 100,
      colors: [const Color(0x00D3A510), umbralColor],
      stops: [0.2, 1.0],
    );
    canvas.save();
    canvas.translate(centerX, centerY);
    canvas.rotate(0 * math.pi / 180);
    canvas.translate(-centerX, -centerY);
    canvas.translate(60 * scale, 20 * scale);
    _drawPolygonWithGradient(
      canvas,
      [
        Offset(40 * scale, -40 * scale),
        Offset(80 * scale, -40 * scale),
        Offset(80 * scale, 85 * scale),
        Offset(40 * scale, 110.2 * scale),
      ],
      gradient: gradient3,
      strokeWidth: 2 * scale,
    );
    canvas.restore();

    // Particle 1 (rotated 45°, translated, animated)
    canvas.save();
    canvas.translate(centerX, centerY);
    canvas.rotate(45 * math.pi / 180);
    canvas.translate(-centerX, -centerY);
    canvas.translate(80 * scale, 95 * scale);
    canvas.translate(0, particlesOffset * scale);
    _drawPolygon(
      canvas,
      [
        Offset(5 * scale, 0),
        Offset(5 * scale, 5 * scale),
        Offset(0, 5 * scale),
        Offset(0, 0),
      ],
      fillColor: const Color(0xFFFFE4A1),
      strokeWidth: 2 * scale,
    );
    canvas.restore();

    // Particle 2 (rotated 45°, translated, animated)
    canvas.save();
    canvas.translate(centerX, centerY);
    canvas.rotate(45 * math.pi / 180);
    canvas.translate(-centerX, -centerY);
    canvas.translate(80 * scale, 55 * scale);
    canvas.translate(0, particlesOffset * scale);
    _drawPolygon(
      canvas,
      [
        Offset(6 * scale, 0),
        Offset(6 * scale, 6 * scale),
        Offset(0, 6 * scale),
        Offset(0, 0),
      ],
      fillColor: const Color(0xFFCCB069),
      strokeWidth: 2 * scale,
    );
    canvas.restore();

    // Particle 3 (rotated 45°, translated, animated)
    canvas.save();
    canvas.translate(centerX, centerY);
    canvas.rotate(45 * math.pi / 180);
    canvas.translate(-centerX, -centerY);
    canvas.translate(70 * scale, 80 * scale);
    canvas.translate(0, particlesOffset * scale);
    _drawPolygon(
      canvas,
      [
        Offset(2 * scale, 0),
        Offset(2 * scale, 2 * scale),
        Offset(0, 2 * scale),
        Offset(0, 0),
      ],
      fillColor: Colors.white,
      strokeWidth: 2 * scale,
    );
    canvas.restore();

    // Polygon 9: dark bottom polygon
    _drawPolygon(
      canvas,
      [
        Offset(29.5 * scale, 99.8 * scale),
        Offset(100 * scale, 142 * scale),
        Offset(100 * scale, 172 * scale),
        Offset(29.5 * scale, 130 * scale),
      ],
      fillColor: const Color(0xFF292D34),
      strokeWidth: 2 * scale,
    );

    // Polygon 10: dark top polygon (translated)
    canvas.save();
    canvas.translate(50 * scale, 92 * scale);
    _drawPolygon(
      canvas,
      [
        Offset(50 * scale, 50 * scale),
        Offset(120.5 * scale, 8 * scale),
        Offset(120.5 * scale, 35 * scale),
        Offset(50 * scale, 80 * scale),
      ],
      fillColor: const Color(0xFF1F2127),
      strokeWidth: 2 * scale,
    );
    canvas.restore();

    canvas.restore();
  }

  void _drawPolygon(
    Canvas canvas,
    List<Offset> points, {
    Color? fillColor,
    Color? strokeColor,
    double strokeWidth = 0,
    bool fill = true,
  }) {
    final path = Path();
    if (points.isNotEmpty) {
      path.moveTo(points[0].dx, points[0].dy);
      for (int i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }
      path.close();
    }

    if (fill && fillColor != null) {
      canvas.drawPath(
        path,
        Paint()
          ..color = fillColor
          ..style = PaintingStyle.fill,
      );
    }

    if (strokeWidth > 0 && strokeColor != null) {
      canvas.drawPath(
        path,
        Paint()
          ..color = strokeColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth,
      );
    }
  }

  void _drawPolygonWithGradient(
    Canvas canvas,
    List<Offset> points, {
    required Gradient gradient,
    double strokeWidth = 0,
  }) {
    final path = Path();
    if (points.isNotEmpty) {
      path.moveTo(points[0].dx, points[0].dy);
      for (int i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }
      path.close();
    }

    // Calculate bounding box for gradient
    final bounds = path.getBounds();
    final rect = Rect.fromLTWH(
      bounds.left,
      bounds.top,
      bounds.width,
      bounds.height,
    );

    canvas.drawPath(
      path,
      Paint()
        ..shader = gradient.createShader(rect)
        ..style = PaintingStyle.fill,
    );

    if (strokeWidth > 0) {
      canvas.drawPath(
        path,
        Paint()
          ..color = Colors.transparent
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth,
      );
    }
  }

  @override
  bool shouldRepaint(_LogoPainter oldDelegate) {
    return oldDelegate.bounceOffset != bounceOffset ||
        oldDelegate.bounce2Offset != bounce2Offset ||
        oldDelegate.umbralProgress != umbralProgress ||
        oldDelegate.particlesOffset != particlesOffset ||
        oldDelegate.size != size;
  }
}
