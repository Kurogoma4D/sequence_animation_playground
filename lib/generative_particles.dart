import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';

const MAX_PARTICLES = 12;
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
  Offset tapPosition = Offset.zero;
  bool isDragging = false;

  SequenceAnimation _generateAnimation(AnimationController controller) {
    /// 半径 20 ~ 80 の範囲
    final radius = random.nextInt(60) + 20;

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
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: (_) => _onTapUp(),
      onPanUpdate: (detail) => _updatePosition(detail.localPosition),
      onPanStart: (detail) => _updatePosition(detail.localPosition),
      onPanEnd: (_) => _onTapUp(),
      child: AnimatedOpacity(
        opacity: isDragging ? 1.0 : 0.0,
        duration: Duration(milliseconds: 550),
        child: RepaintBoundary(
          child: CustomPaint(
            size: Size(
              MediaQuery.of(context).size.width,
              MediaQuery.of(context).size.height,
            ),
            painter: _Painter(sequences, tapPosition, isDragging),
          ),
        ),
      ),
    );
  }

  void _onTapDown(TapDownDetails details) {
    isDragging = true;
    tapPosition = details.localPosition;
    for (final controller in controllers) {
      controller.forward(from: 0);
    }
  }

  void _updatePosition(Offset position) {
    tapPosition = position;
  }

  void _onTapUp() async {
    setState(() {
      isDragging = false;
    });
    for (final controller in controllers) {
      controller.stop();
    }
  }

  void stopAnimationOnCompleted(
      AnimationStatus status, AnimationController controller) {
    if (status == AnimationStatus.completed) controller.stop();
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
  final Offset tapPosition;
  final bool isDragging;

  _Painter(this.sequences, this.tapPosition, this.isDragging);

  @override
  void paint(Canvas canvas, Size size) {
    if (!isDragging) return;

    final paint = Paint()
      ..color = Colors.greenAccent
      ..style = PaintingStyle.fill;

    for (final sequence in sequences) {
      final animatePosition = sequence[POSITION_TAG].value as Offset;
      final position = tapPosition + animatePosition;
      canvas.drawCircle(
          Offset(position.dx, position.dy), sequence[RADIUS_TAG].value, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => isDragging;
}
