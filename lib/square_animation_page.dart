import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';

class SquareAnimationPage extends StatelessWidget {
  const SquareAnimationPage({Key key}) : super(key: key);

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
    return Center(
      child: SizedBox(
        width: 300,
        height: 300,
        child: const _AnimationArea(),
      ),
    );
  }
}

class _Keyframe {
  static const basic = Duration(milliseconds: 350);
  static const toTopRight = basic;
  static final toBottomRight = toTopRight + basic;
  static final toBottomLeft = toBottomRight + basic;
  static final toTopLeft = toBottomLeft + basic;
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

    sequence = SequenceAnimationBuilder()
        .addAnimatable(
            animatable: AlignmentTween(
                begin: Alignment.topLeft, end: Alignment.topRight),
            from: Duration.zero,
            to: _Keyframe.toTopRight,
            tag: 'alignment',
            curve: Curves.easeOut)
        .addAnimatable(
            animatable: AlignmentTween(
                begin: Alignment.topRight, end: Alignment.bottomRight),
            from: _Keyframe.toTopRight,
            to: _Keyframe.toBottomRight,
            tag: 'alignment',
            curve: Curves.easeOut)
        .addAnimatable(
            animatable: AlignmentTween(
                begin: Alignment.bottomRight, end: Alignment.bottomLeft),
            from: _Keyframe.toBottomRight,
            to: _Keyframe.toBottomLeft,
            tag: 'alignment',
            curve: Curves.easeOut)
        .addAnimatable(
            animatable: AlignmentTween(
                begin: Alignment.bottomLeft, end: Alignment.topLeft),
            from: _Keyframe.toBottomLeft,
            to: _Keyframe.toTopLeft,
            tag: 'alignment',
            curve: Curves.easeOut)
        .animate(controller);

    controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: sequence['alignment'].value,
      child: Container(
        color: Colors.lightGreen,
        height: 30,
        width: 30,
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
