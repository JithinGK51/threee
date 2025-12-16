import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// An animated isometric logo widget with smooth live wave animations.
/// Creates a premium, alive feeling with phase-shifted wave motions.
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
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  // Main vertical wave bounce (entire cube stack)
  late Animation<double> _verticalWave;

  // Gold outline wave delay (slight lag behind main wave)
  late Animation<double> _outlineWave;

  // Particles floating (vertical + horizontal drift)
  late Animation<double> _particlesVertical;
  late Animation<double> _particlesHorizontal;

  @override
  void initState() {
    super.initState();

    // Main controller: 4 seconds for smooth, calm wave
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();

    // 1. Vertical wave bounce - smooth sine-like motion
    // Entire cube stack moves up and down (0 to 8px)
    _verticalWave = Tween<double>(
      begin: 0.0,
      end: 8.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // 2. Gold outline wave delay - phase offset
    // Lags behind main wave by 0.2 seconds (creates depth)
    // Uses Interval to create phase shift
    _outlineWave = Tween<double>(begin: 0.0, end: 6.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.05, 1.0, curve: Curves.easeInOut),
      ),
    );

    // 3. Particles floating - independent wave motion
    // Vertical: gentle up/down (0 to 4px)
    _particlesVertical = Tween<double>(begin: 0.0, end: 4.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.1, 1.0, curve: Curves.easeInOut),
      ),
    );

    // Horizontal: subtle drift (0 to 2px)
    _particlesHorizontal = Tween<double>(begin: 0.0, end: 2.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.9, curve: Curves.easeInOut),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scale = widget.size / 200.0;

    return Container(
      width: widget.size,
      height: widget.size,
      color: widget.backgroundColor,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          // Calculate sine-based wave for smoother motion
          final waveValue = math.sin(_controller.value * 2 * math.pi);
          final verticalOffset = (waveValue + 1) / 2 * _verticalWave.value;
          final outlineOffset = (waveValue + 1) / 2 * _outlineWave.value;
          final particlesVOffset =
              (waveValue + 1) / 2 * _particlesVertical.value;
          final particlesHOffset =
              (waveValue + 1) / 2 * _particlesHorizontal.value;

          // Beam breathing uses sine for smooth pulse
          final beamOpacity =
              0.3 + (math.sin(_controller.value * 2 * math.pi) + 1) / 2 * 0.4;

          return Stack(
            alignment: Alignment.center,
            children: [
              // 1. Gold outline (bottom layer, with wave delay)
              Transform.translate(
                offset: Offset(0, outlineOffset * scale),
                child: SvgPicture.asset(
                  'assets/svg/gold_outline.svg',
                  width: widget.size,
                  height: widget.size,
                  fit: BoxFit.contain,
                ),
              ),

              // 2. Base shadow (moves with main wave)
              Transform.translate(
                offset: Offset(0, verticalOffset * scale),
                child: SvgPicture.asset(
                  'assets/svg/base_shadow.svg',
                  width: widget.size,
                  height: widget.size,
                  fit: BoxFit.contain,
                ),
              ),

              // 3. Base cube (moves with main wave)
              Transform.translate(
                offset: Offset(0, verticalOffset * scale),
                child: SvgPicture.asset(
                  'assets/svg/base_cube.svg',
                  width: widget.size,
                  height: widget.size,
                  fit: BoxFit.contain,
                ),
              ),

              // 4. Gold top (moves with main wave)
              Transform.translate(
                offset: Offset(0, verticalOffset * scale),
                child: SvgPicture.asset(
                  'assets/svg/gold_top.svg',
                  width: widget.size,
                  height: widget.size,
                  fit: BoxFit.contain,
                ),
              ),

              // 5. Particles (independent floating wave)
              Transform.translate(
                offset: Offset(
                  particlesHOffset * scale,
                  particlesVOffset * scale,
                ),
                child: SvgPicture.asset(
                  'assets/svg/particles.svg',
                  width: widget.size,
                  height: widget.size,
                  fit: BoxFit.contain,
                ),
              ),

              // 6. Light beam (top layer, with breathing opacity)
              Opacity(
                opacity: beamOpacity,
                child: SvgPicture.asset(
                  'assets/svg/light_beam.svg',
                  width: widget.size,
                  height: widget.size,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
