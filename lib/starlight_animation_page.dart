import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';

const CLIP_OFFSET = 20.0;
const CROWN_SIZE = 40.0;

double degreesToRads(num deg) {
  return (deg * math.pi) / 180.0;
}

class StarlightAnimationPage extends StatelessWidget {
  const StarlightAnimationPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('STARLIGHT'),
      ),
      body: const _Contents(),
    );
  }
}

class _Contents extends StatelessWidget {
  const _Contents({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const _AnimationArea();
  }
}

class _AnimationArea extends StatefulWidget {
  const _AnimationArea({Key key}) : super(key: key);

  @override
  __AnimationAreaState createState() => __AnimationAreaState();
}

class __AnimationAreaState extends State<_AnimationArea>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  SequenceAnimation sequence;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this);
    final curve = Cubic(.6, 0, .39, .99);

    const easeToLinear = Cubic(.62, .01, .53, .54);
    const linearToEase = Cubic(.5, .5, .51, .99);

    const rotateOffset = 1900;

    sequence = reset()
        .addAnimatable(
            animatable: Tween(begin: 0.0, end: 900.0),
            from: Duration.zero,
            to: Duration(milliseconds: 500),
            tag: 'first',
            curve: curve)
        .addAnimatable(
            animatable: Tween(begin: 0.0, end: 900.0),
            from: Duration(milliseconds: 120),
            to: Duration(milliseconds: 720),
            tag: 'second',
            curve: curve)
        .addAnimatable(
            animatable: Tween(begin: 0.0, end: 900.0),
            from: Duration(milliseconds: 180),
            to: Duration(milliseconds: 750),
            tag: 'third',
            curve: curve)
        .addAnimatable(
            animatable: Tween(begin: 0.0, end: 100.0),
            from: Duration(milliseconds: 1000),
            to: Duration(milliseconds: 1300),
            curve: Curves.easeInOut,
            tag: 'line-width')
        .addAnimatable(
            animatable: Tween(begin: 100.0, end: 0.0),
            from: Duration(milliseconds: 3500),
            to: Duration(milliseconds: 3850),
            curve: Curves.easeInOut,
            tag: 'line-width')
        .addAnimatable(
            animatable: Tween(begin: CLIP_OFFSET + CROWN_SIZE, end: -30.0),
            from: Duration(milliseconds: 1300),
            to: Duration(milliseconds: 1550),
            curve: Curves.easeOutCubic,
            tag: 'crown-offset')
        .addAnimatable(
            animatable: Tween(begin: -30.0, end: CLIP_OFFSET + CROWN_SIZE),
            from: Duration(milliseconds: 3350),
            to: Duration(milliseconds: 3700),
            curve: Curves.easeInCubic,
            tag: 'crown-offset')
        .addAnimatable(
            animatable: Tween(begin: 0.0, end: degreesToRads(15)),
            from: Duration(milliseconds: rotateOffset),
            to: Duration(milliseconds: rotateOffset + 60),
            curve: easeToLinear,
            tag: 'crown-rotate')
        .addAnimatable(
            animatable:
                Tween(begin: degreesToRads(15), end: degreesToRads(-15)),
            from: Duration(milliseconds: rotateOffset + 60),
            to: Duration(milliseconds: rotateOffset + 160),
            curve: Curves.linear,
            tag: 'crown-rotate')
        .addAnimatable(
            animatable: Tween(begin: degreesToRads(-15), end: degreesToRads(0)),
            from: Duration(milliseconds: rotateOffset + 160),
            to: Duration(milliseconds: rotateOffset + 220),
            curve: linearToEase,
            tag: 'crown-rotate')
        .addAnimatable(
            animatable: Tween(begin: 1.0, end: 0.0),
            from: Duration(milliseconds: 4000),
            to: Duration(milliseconds: 4400),
            tag: 'opacity')
        .animate(controller);
  }

  SequenceAnimationBuilder reset() {
    return SequenceAnimationBuilder()
        .addAnimatable(
            animatable: Tween(begin: 0.0, end: 0.0),
            from: Duration.zero,
            to: Duration.zero,
            tag: 'line-width')
        .addAnimatable(
            animatable: Tween(begin: 0.0, end: 1.0),
            from: Duration.zero,
            to: Duration.zero,
            tag: 'opacity')
        .addAnimatable(
            animatable: Tween(
                begin: CLIP_OFFSET + CROWN_SIZE, end: CLIP_OFFSET + CROWN_SIZE),
            from: Duration.zero,
            to: Duration.zero,
            tag: 'crown-offset')
        .addAnimatable(
            animatable: Tween(begin: 0.0, end: 0.0),
            from: Duration.zero,
            to: Duration.zero,
            tag: 'crown-rotate');
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Center(
          child: GestureDetector(
            onTap: () => controller.forward(from: 0.0),
            child: Text('CLICK ME'),
          ),
        ),
        Center(
          child: AnimatedBuilder(
            builder: (context, _) => Opacity(
              opacity: sequence['opacity'].value,
              child: RepaintBoundary(
                child: CustomPaint(
                  painter: _EffectPainter(sequence),
                ),
              ),
            ),
            animation: controller,
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ClipRect(
            clipper: _HalfClipper(),
            child: AnimatedBuilder(
              builder: (context, _) => Center(
                child: Transform.translate(
                  offset: Offset(0, sequence['crown-offset'].value),
                  child: Transform.rotate(
                    angle: sequence['crown-rotate'].value,
                    child: SizedBox(
                      height: CROWN_SIZE,
                      width: CROWN_SIZE,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          '😋',
                          style: TextStyle(height: 1.2),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              animation: controller,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class _EffectPainter extends CustomPainter {
  final SequenceAnimation sequence;

  _EffectPainter(this.sequence);

  @override
  void paint(Canvas canvas, Size size) {
    final red = Paint()
      ..color = Color(0xffff5357)
      ..style = PaintingStyle.fill;

    final white = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final lineWhite = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final center = Offset(size.width / 2, size.height / 2);

    canvas.drawCircle(center, sequence['first'].value, red);

    canvas.drawCircle(center, sequence['second'].value, white);

    canvas.drawCircle(center, sequence['third'].value, red);

    final lineHalfWidth = sequence['line-width'].value / 2;

    canvas.drawLine(Offset(center.dx - lineHalfWidth, center.dy + CLIP_OFFSET),
        Offset(center.dx + lineHalfWidth, center.dy + CLIP_OFFSET), lineWhite);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class _HalfClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(0.0, 0.0, size.width, size.height / 2 + CLIP_OFFSET);
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) => false;
}
