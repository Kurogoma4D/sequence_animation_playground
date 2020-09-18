import 'package:flutter/material.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';
import 'package:sequence_animation_playground/loading_animation_page.dart';
import 'package:sequence_animation_playground/square_animation_page.dart';
import 'package:sequence_animation_playground/starlight_animation_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Animation Example'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: Text('square'),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        const SquareAnimationPage()),
              ),
            ),
            ListTile(
              title: Text('starlight'),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        const StarlightAnimationPage()),
              ),
            ),
            ListTile(
              title: Text('loading'),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        const LoadingAnimationPage()),
              ),
            )
          ],
        ),
      ),
      body: Center(
        child: Container(
          width: 300,
          height: 300,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.1),
            border: Border.all(color: Colors.grey),
          ),
          child: const AnimationArea(),
        ),
      ),
    );
  }
}

class AnimationArea extends StatefulWidget {
  const AnimationArea({Key key}) : super(key: key);

  @override
  _AnimationAreaState createState() => _AnimationAreaState();
}

class _AnimationAreaState extends State<AnimationArea>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  SequenceAnimation sequenceAnimation;

  @override
  void initState() {
    controller = AnimationController(vsync: this)
      ..addStatusListener((status) {
        switch (status) {
          case AnimationStatus.dismissed:
            controller.forward();
            break;
          case AnimationStatus.completed:
            controller.reverse();
            break;
          case AnimationStatus.forward:
          case AnimationStatus.reverse:
        }
      })
      ..addListener(() => setState(() {}));

    sequenceAnimation = SequenceAnimationBuilder()
        .addAnimatable(
            animatable: Tween(begin: 0.0, end: 1.0),
            from: Duration.zero,
            to: Duration(milliseconds: 200),
            curve: Curves.ease,
            tag: 'opacity')
        .addAnimatable(
            animatable: Tween(begin: 50.0, end: 150.0),
            from: Duration(milliseconds: 250),
            to: Duration(milliseconds: 500),
            tag: 'width',
            curve: Curves.ease)
        .addAnimatable(
            animatable: Tween(begin: 50.0, end: 150.0),
            from: Duration(milliseconds: 500),
            to: Duration(milliseconds: 750),
            tag: 'height',
            curve: Curves.ease)
        .addAnimatable(
          animatable: EdgeInsetsTween(
              begin: EdgeInsets.only(bottom: 16),
              end: EdgeInsets.only(bottom: 75)),
          from: Duration(milliseconds: 500),
          to: Duration(milliseconds: 750),
          tag: 'padding',
          curve: Curves.ease,
        )
        .addAnimatable(
          animatable: BorderRadiusTween(
              begin: BorderRadius.circular(4), end: BorderRadius.circular(75)),
          from: Duration(milliseconds: 750),
          to: Duration(milliseconds: 1000),
          tag: 'borderRadius',
          curve: Curves.ease,
        )
        .addAnimatable(
          animatable:
              ColorTween(begin: Colors.indigo[100], end: Colors.orange[400]),
          from: Duration(milliseconds: 1000),
          to: Duration(milliseconds: 1500),
          tag: 'color',
          curve: Curves.ease,
        )
        .animate(controller);

    controller.forward();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: sequenceAnimation['padding'].value,
      alignment: Alignment.bottomCenter,
      child: Opacity(
        opacity: sequenceAnimation['opacity'].value,
        child: Container(
          width: sequenceAnimation['width'].value,
          height: sequenceAnimation['height'].value,
          decoration: BoxDecoration(
            color: sequenceAnimation['color'].value,
            border: Border.all(color: Colors.indigo[300], width: 3),
            borderRadius: sequenceAnimation['borderRadius'].value,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
