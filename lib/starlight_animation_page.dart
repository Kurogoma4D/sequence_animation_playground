import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';

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
    controller = AnimationController(vsync: this)
      ..addListener(() => setState(() {}));

    final curve = Cubic(.6, 0, .39, .99);

    sequence = SequenceAnimationBuilder()
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
            from: Duration(milliseconds: 2500),
            to: Duration(milliseconds: 2850),
            curve: Curves.easeInOut,
            tag: 'line-width')
        .addAnimatable(
            animatable: Tween(begin: 1.0, end: 0.0),
            from: Duration(milliseconds: 4000),
            to: Duration(milliseconds: 4400),
            tag: 'opacity')
        .animate(controller);
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
          child: Opacity(
            opacity: sequence['opacity'].value,
            child: RepaintBoundary(
              child: CustomPaint(
                painter: _EffectPainter(sequence),
              ),
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

    canvas.drawLine(Offset(center.dx - lineHalfWidth, center.dy + 20),
        Offset(center.dx + lineHalfWidth, center.dy + 20), lineWhite);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
