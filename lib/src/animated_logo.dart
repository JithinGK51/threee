import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// An animated logo widget that displays a 3D-style geometric logo
/// with bouncing animations and gradient effects.
/// Proper Flutter implementation using flutter_svg and AnimationController.
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

    // CSS: @keyframes bounce - 0%,100% translate: 0px 36px, 50% translate: 0px 46px
    _bounceController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);
    _bounceAnimation = Tween<double>(begin: 36.0, end: 46.0).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
    );

    // CSS: @keyframes bounce2 - 0%,100% translate: 0px 46px, 50% translate: 0px 56px
    // animation-delay: 0.5s
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

    // CSS: @keyframes umbral - 0% #d3a5102e, 50% rgba(211, 165, 16, 0.519), 100% #d3a5102e
    _umbralController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();
    _umbralAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _umbralController, curve: Curves.linear));

    // CSS: @keyframes partciles - 0%,100% translate: 0px 16px, 50% translate: 0px 6px
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
    final scale = widget.size / 200.0;

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
          // Calculate umbral color for gradient stops
          final umbralOpacityValue =
              (math.sin(_umbralAnimation.value * 2 * math.pi) + 1) / 2;
          final umbralOpacity = 0.1804 + (0.519 - 0.1804) * umbralOpacityValue;
          final umbralHex = (umbralOpacity * 255)
              .round()
              .toRadixString(16)
              .padLeft(2, '0');
          final umbralColor = '#d3a510$umbralHex';

          return Stack(
            alignment: Alignment.center,
            children: [
              // Main SVG with all static elements
              SvgPicture.string(
                _getMainSvg(umbralColor),
                width: widget.size,
                height: widget.size,
              ),
              // Bounce polygon layer (first outline)
              Transform.translate(
                offset: Offset(0, _bounceAnimation.value * scale),
                child: SvgPicture.string(
                  _getBounceSvg(),
                  width: widget.size,
                  height: widget.size,
                ),
              ),
              // Bounce2 polygon layer (second outline)
              Transform.translate(
                offset: Offset(0, _bounce2Animation.value * scale),
                child: SvgPicture.string(
                  _getBounce2Svg(),
                  width: widget.size,
                  height: widget.size,
                ),
              ),
              // Particles layer
              Transform.translate(
                offset: Offset(0, _particlesAnimation.value * scale),
                child: SvgPicture.string(
                  _getParticlesSvg(),
                  width: widget.size,
                  height: widget.size,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _getMainSvg(String umbralColor) {
    return '''
<svg xmlns="http://www.w3.org/2000/svg" height="200" width="200" viewBox="0 0 200 200">
  <defs>
    <linearGradient y2="100%" x2="10%" y1="0%" x1="0%" id="gradiente">
      <stop style="stop-color: #1e2026;stop-opacity:1" offset="20%"></stop>
      <stop style="stop-color:#414750;stop-opacity:1" offset="60%"></stop>
    </linearGradient>
    <linearGradient y2="100%" x2="0%" y1="-17%" x1="10%" id="gradiente2">
      <stop style="stop-color: #d3a51000;stop-opacity:1" offset="20%"></stop>
      <stop style="stop-color:$umbralColor;stop-opacity:1" offset="100%" id="animatedStop"></stop>
    </linearGradient>
    <linearGradient y2="100%" x2="10%" y1="0%" x1="0%" id="gradiente3">
      <stop style="stop-color: #d3a51000;stop-opacity:1" offset="20%"></stop>
      <stop style="stop-color:$umbralColor;stop-opacity:1" offset="100%" id="animatedStop"></stop>
    </linearGradient>
  </defs>
  <g>
    <polygon
      transform="rotate(45 100 100)"
      stroke-width="2"
      stroke=""
      fill="#414750"
      points="70,70 150,50 130,130 50,150"
    ></polygon>
    <polygon
      stroke-width="2"
      stroke=""
      fill="url(#gradiente)"
      points="100,70 150,100 100,130 50,100"
    ></polygon>
    <polygon
      transform="translate(20, 31)"
      stroke-width="2"
      stroke=""
      fill="#b7870f"
      points="80,50 80,75 80,99 40,75"
    ></polygon>
    <polygon
      transform="translate(20, 31)"
      stroke-width="2"
      stroke=""
      fill="url(#gradiente2)"
      points="40,-40 80,-40 80,99 40,75"
    ></polygon>
    <polygon
      transform="rotate(180 100 100) translate(20, 20)"
      stroke-width="2"
      stroke=""
      fill="#d3a410"
      points="80,50 80,75 80,99 40,75"
    ></polygon>
    <polygon
      transform="rotate(0 100 100) translate(60, 20)"
      stroke-width="2"
      stroke=""
      fill="url(#gradiente3)"
      points="40,-40 80,-40 80,85 40,110.2"
    ></polygon>
    <polygon
      stroke-width="2"
      stroke=""
      fill="#292d34"
      points="29.5,99.8 100,142 100,172 29.5,130"
    ></polygon>
    <polygon
      transform="translate(50, 92)"
      stroke-width="2"
      stroke=""
      fill="#1f2127"
      points="50,50 120.5,8 120.5,35 50,80"
    ></polygon>
  </g>
</svg>
''';
  }

  String _getBounceSvg() {
    return '''
<svg xmlns="http://www.w3.org/2000/svg" height="200" width="200" viewBox="0 0 200 200">
  <g>
    <polygon
      transform="rotate(45 100 100)"
      stroke-width="1"
      stroke="#d3a410"
      fill="none"
      points="70,70 148,50 130,130 50,150"
      id="bounce"
    ></polygon>
  </g>
</svg>
''';
  }

  String _getBounce2Svg() {
    return '''
<svg xmlns="http://www.w3.org/2000/svg" height="200" width="200" viewBox="0 0 200 200">
  <g>
    <polygon
      transform="rotate(45 100 100)"
      stroke-width="1"
      stroke="#d3a410"
      fill="none"
      points="70,70 148,50 130,130 50,150"
      id="bounce2"
    ></polygon>
  </g>
</svg>
''';
  }

  String _getParticlesSvg() {
    return '''
<svg xmlns="http://www.w3.org/2000/svg" height="200" width="200" viewBox="0 0 200 200">
  <g>
    <polygon
      transform="rotate(45 100 100) translate(80, 95)"
      stroke-width="2"
      stroke=""
      fill="#ffe4a1"
      points="5,0 5,5 0,5 0,0"
      id="particles"
    ></polygon>
    <polygon
      transform="rotate(45 100 100) translate(80, 55)"
      stroke-width="2"
      stroke=""
      fill="#ccb069"
      points="6,0 6,6 0,6 0,0"
      id="particles"
    ></polygon>
    <polygon
      transform="rotate(45 100 100) translate(70, 80)"
      stroke-width="2"
      stroke=""
      fill="#fff"
      points="2,0 2,2 0,2 0,0"
      id="particles"
    ></polygon>
  </g>
</svg>
''';
  }
}
