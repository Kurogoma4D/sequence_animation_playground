import 'package:flutter/material.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';

class LoadingAnimationPage extends StatelessWidget {
  const LoadingAnimationPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Loading Animation'),
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
  final labels = List.generate(5, (index) => 'circle$index');

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this)
      ..addListener(() => setState(() {}));

    final inCurve = Cubic(.62, .01, .53, .54);
    final outCurve = Cubic(.5, .5, .51, .99);

    const baseFirst = Duration(milliseconds: 500);
    const baseSecond = Duration(milliseconds: 1200);
    const baseThird = Duration(milliseconds: 1700);

    const delay = Duration(milliseconds: 200);

    sequence = reset()
        .addAnimatable(
            animatable: Tween(begin: 0.0, end: 0.4),
            from: Duration.zero,
            to: baseFirst,
            tag: 'circle0',
            curve: inCurve)
        .addAnimatable(
            animatable: Tween(begin: 0.4, end: 0.6),
            from: baseFirst,
            to: baseSecond,
            tag: 'circle0',
            curve: Curves.linear)
        .addAnimatable(
            animatable: Tween(begin: 0.6, end: 1.0),
            from: baseSecond,
            to: baseThird,
            tag: 'circle0',
            curve: outCurve)
        .addAnimatable(
            animatable: Tween(begin: 0.0, end: 0.4),
            from: Duration.zero,
            to: baseFirst + delay,
            tag: 'circle1',
            curve: inCurve)
        .addAnimatable(
            animatable: Tween(begin: 0.4, end: 0.6),
            from: baseFirst + delay,
            to: baseSecond + delay,
            tag: 'circle1',
            curve: Curves.linear)
        .addAnimatable(
            animatable: Tween(begin: 0.6, end: 1.0),
            from: baseSecond + delay,
            to: baseThird + delay,
            tag: 'circle1',
            curve: outCurve)
        .addAnimatable(
            animatable: Tween(begin: 0.0, end: 0.4),
            from: Duration.zero,
            to: baseFirst + delay * 2,
            tag: 'circle2',
            curve: inCurve)
        .addAnimatable(
            animatable: Tween(begin: 0.4, end: 0.6),
            from: baseFirst + delay * 2,
            to: baseSecond + delay * 2,
            tag: 'circle2',
            curve: Curves.linear)
        .addAnimatable(
            animatable: Tween(begin: 0.6, end: 1.0),
            from: baseSecond + delay * 2,
            to: baseThird + delay * 2,
            tag: 'circle2',
            curve: outCurve)
        .addAnimatable(
            animatable: Tween(begin: 0.0, end: 0.4),
            from: Duration.zero,
            to: baseFirst + delay * 3,
            tag: 'circle3',
            curve: inCurve)
        .addAnimatable(
            animatable: Tween(begin: 0.4, end: 0.6),
            from: baseFirst + delay * 3,
            to: baseSecond + delay * 3,
            tag: 'circle3',
            curve: Curves.linear)
        .addAnimatable(
            animatable: Tween(begin: 0.6, end: 1.0),
            from: baseSecond + delay * 3,
            to: baseThird + delay * 3,
            tag: 'circle3',
            curve: outCurve)
        .addAnimatable(
            animatable: Tween(begin: 0.0, end: 0.4),
            from: Duration.zero,
            to: baseFirst + delay * 4,
            tag: 'circle4',
            curve: inCurve)
        .addAnimatable(
            animatable: Tween(begin: 0.4, end: 0.6),
            from: baseFirst + delay * 4,
            to: baseSecond + delay * 4,
            tag: 'circle4',
            curve: Curves.linear)
        .addAnimatable(
            animatable: Tween(begin: 0.6, end: 1.0),
            from: baseSecond + delay * 4,
            to: baseThird + delay * 4,
            tag: 'circle4',
            curve: outCurve)
        .animate(controller);

    controller.repeat();
  }

  SequenceAnimationBuilder reset() {
    return SequenceAnimationBuilder()
        .addAnimatable(
            animatable: Tween(begin: 0.0, end: 0.0),
            from: Duration.zero,
            to: Duration.zero,
            tag: 'circle0',
            curve: Curves.ease)
        .addAnimatable(
            animatable: Tween(begin: 0.0, end: 0.0),
            from: Duration.zero,
            to: Duration.zero,
            tag: 'circle1',
            curve: Curves.ease)
        .addAnimatable(
            animatable: Tween(begin: 0.0, end: 0.0),
            from: Duration.zero,
            to: Duration.zero,
            tag: 'circle2',
            curve: Curves.ease)
        .addAnimatable(
            animatable: Tween(begin: 0.0, end: 0.0),
            from: Duration.zero,
            to: Duration.zero,
            tag: 'circle3',
            curve: Curves.ease)
        .addAnimatable(
            animatable: Tween(begin: 0.0, end: 0.0),
            from: Duration.zero,
            to: Duration.zero,
            tag: 'circle4',
            curve: Curves.ease);
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        size: Size(
          MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height,
        ),
        painter: _Painter(sequence, labels),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class _Painter extends CustomPainter {
  static const circleRadius = 8.0;
  static const total = 5;

  final SequenceAnimation sequence;
  final List<String> labels;

  _Painter(this.sequence, this.labels);

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = Colors.blueAccent
      ..style = PaintingStyle.fill;

    for (int i = 0; i < total; i++) {
      final actualScreenWidth = size.width + 2 * (circleRadius * 2 * (i + 1));
      final offset = Offset(0.0 - circleRadius * 2 * (i + 1), size.height / 2);
      final current =
          offset + Offset(actualScreenWidth * sequence[labels[i]].value, 0);
      canvas.drawCircle(current, circleRadius, p);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
