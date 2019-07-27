import 'package:flutter/material.dart';
import 'package:flutter_trip/pages/search_page.dart';
import 'package:flutter_trip/plugin/asr_manager.dart';
import 'package:flutter_trip/utils/navigator_util.dart';
import 'package:flutter_trip/widgets/webview.dart';

class SpeakPage extends StatefulWidget {
  @override
  _SpeakPageState createState() => _SpeakPageState();
}

class _SpeakPageState extends State<SpeakPage>
    with SingleTickerProviderStateMixin {
  String speakTip = '长按说话';
  String speakResult = '';
  Animation<double> animation;
  AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn)
      ..addStatusListener((state) {
        if (state == AnimationStatus.completed) {
          controller.reverse();
        } else if (state == AnimationStatus.dismissed) {
          controller.forward();
        }
      });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(30),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[_topItem(), _bottomItem()],
          ),
        ),
      ),
    );
  }

  _topItem() {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(0, 30, 0, 30),
          child: Text(
            '你可以这样说',
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ),
        Text(
          '故宫门票\n\n北京一日游\n\n迪士尼乐园',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            speakResult,
            style: TextStyle(color: Colors.blue),
          ),
        )
      ],
    );
  }

  _bottomItem() {
    return FractionallySizedBox(
      widthFactor: 1,
      child: Stack(
        children: <Widget>[
          GestureDetector(
            onTapDown: (e) {
              _speakStart();
            },
            onTapUp: (e) {
              _speakStop();
            },
            onTapCancel: () {
              _speakStop();
            },
            child: Center(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      speakTip,
                      style: TextStyle(fontSize: 14, color: Colors.blue),
                    ),
                  ),
                  Stack(
                    children: <Widget>[
                      Container(
                        width: MIC_SIZE,
                        height: MIC_SIZE,
                      ),
                      Center(
                        child: AnimatedMic(
                          animation: animation,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Positioned(
              right: 0,
              bottom: 20,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.close,
                  size: 30,
                  color: Colors.black87,
                ),
              ))
        ],
      ),
    );
  }

  void _speakStart() {
    setState(() {
      speakTip = '- 说话中 -';
    });
    controller.forward();
    AsrManager.start().then((result) {
      if (result != null && result.length > 0) {
        setState(() {
          speakResult = result;
        });
        Navigator.pop(context);
        NavigatorUtil.push(context, SearchPage(keyword: result,));
      }
    }).catchError((e) {
      print(e);
    });
  }

  void _speakStop() {
    setState(() {
      speakTip = '长按说话';
    });
    controller.reset();
    controller.stop();
    AsrManager.stop();
  }
}

const double MIC_SIZE = 80;

class AnimatedMic extends AnimatedWidget {
  static final Tween<double> _opacityTween = Tween(begin: 1, end: 0.5);
  static final Tween<double> _sizeTween =
      Tween(begin: MIC_SIZE, end: MIC_SIZE - 20);

  AnimatedMic({Key key, Animation<double> animation})
      : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return Opacity(
      opacity: _opacityTween.evaluate(animation),
      child: Container(
        width: _sizeTween.evaluate(animation),
        height: _sizeTween.evaluate(animation),
        decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(MIC_SIZE / 2)),
        child: Icon(
          Icons.mic,
          size: 30,
          color: Colors.white,
        ),
      ),
    );
  }
}
