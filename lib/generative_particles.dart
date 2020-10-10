import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';

const MAX_PARTICLES = 20;
const POSITION_TAG = 'particle_position';

class GenerativeParticles extends StatelessWidget {
  const GenerativeParticles({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generative Particles'),
      ),
      body: const _AnimationArea(),
    );
  }
}

class _AnimationArea extends StatefulWidget {
  const _AnimationArea({Key key}) : super(key: key);

  @override
  __AnimationAreaState createState() => __AnimationAreaState();
}

class __AnimationAreaState extends State<_AnimationArea>
    with TickerProviderStateMixin {
  List<AnimationController> controllers = [];
  List<SequenceAnimation> sequences = [];
  final random = math.Random();

  SequenceAnimation _generateAnimation(AnimationController controller) {
    /// 半径 50 ~ 90 の範囲
    final radius = random.nextInt(40) + 50;

    /// 角度は全方位ランダム
    final angle = random.nextDouble() * 2 * math.pi;

    /// 目標地点を極座標から定義
    final objective =
        Offset(radius * math.cos(angle), radius * math.sin(angle));
    // TODO: durationもバラけさせる
    return SequenceAnimationBuilder()
        .addAnimatable(
            animatable: Tween<Offset>(begin: Offset.zero, end: objective),
            from: Duration.zero,
            to: Duration(milliseconds: 1200),
            tag: POSITION_TAG)
        .animate(controller);
  }

  @override
  void initState() {
    controllers = List.generate(
      MAX_PARTICLES,
      (index) =>
          AnimationController(vsync: this)..addListener(() => setState(() {})),
    );

    for (final controller in controllers) {
      final sequence = _generateAnimation(controller);
      sequences.add(sequence);

      controller.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          final index = controllers.indexOf(controller);
          // TODO: sequenceを変える
        }
      });

      controller.repeat();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        size: Size(
          MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height,
        ),
        painter: _Painter(sequences),
      ),
    );
  }

  @override
  void dispose() {
    for (final controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }
}

class _Painter extends CustomPainter {
  static const circleRadius = 8.0;

  final List<SequenceAnimation> sequences;

  _Painter(this.sequences);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.greenAccent
      ..style = PaintingStyle.fill;

    for (final sequence in sequences) {
      final animatePosition = sequence[POSITION_TAG].value as Offset;
      final position = size / 2 + animatePosition;
      canvas.drawCircle(
          Offset(position.width, position.height), circleRadius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
