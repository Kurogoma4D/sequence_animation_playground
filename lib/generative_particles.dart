import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';

const MAX_PARTICLES = 20;
const POSITION_TAG = 'particle_position';
const RADIUS_TAG = 'particle_radius';

class GenerativeParticles extends StatelessWidget {
  const GenerativeParticles({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff242424),
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
    /// 半径 50 ~ 150 の範囲
    final radius = random.nextInt(100) + 50;

    /// 角度は全方位ランダム
    final angle = random.nextDouble() * 2 * math.pi;

    /// 目標地点を極座標から定義
    final objective =
        Offset(radius * math.cos(angle), radius * math.sin(angle));

    /// 生存時間
    final duration = Duration(milliseconds: random.nextInt(1200) + 600);
    return SequenceAnimationBuilder()
        .addAnimatable(
            animatable: Tween(begin: 8.0, end: 8.0),
            from: Duration.zero,
            to: Duration.zero,
            tag: RADIUS_TAG)
        .addAnimatable(
            animatable: Tween<Offset>(begin: Offset.zero, end: objective),
            from: Duration.zero,
            to: duration,
            tag: POSITION_TAG,
            curve: Curves.ease)
        .addAnimatable(
            animatable: Tween(begin: 8.0, end: 0.0),
            from: duration * 0.4,
            to: duration,
            tag: RADIUS_TAG)
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
          sequences[index] = _generateAnimation(controller);
          controller.forward(from: 0.0);
        }
      });

      controller.forward();
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
      canvas.drawCircle(Offset(position.width, position.height),
          sequence[RADIUS_TAG].value, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
