import 'package:flutter/material.dart';
import 'package:cubef/cubef.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:vibration/vibration.dart';
import 'dart:math' as math;

void main() => runApp(App());

class Score extends StatefulWidget {
  Score({Key key}) : super(key: key);
  @override
  _ScoreState createState() => _ScoreState();
}

class _ScoreState extends State<Score> {
  int _counter = 0;
  void clicked() {
    _counter++;
    setState(() {});
  }

  @override
  Widget build(BuildContext ctx) {
    Size scr = MediaQuery.of(ctx).size;
    return Positioned(top: scr.height - 50, left: 10,
      child: Material(
        child: Text("Count: " + _counter.toString(), style: TextStyle(color: Colors.black, fontFamily: "Bebas", fontSize: 40.0))));
  }
}

class App extends StatelessWidget {
  final GlobalKey<CubefState> dcKey = GlobalKey<CubefState>();
  final GlobalKey<_ScoreState> scrKey = GlobalKey<_ScoreState>();
  final AudioCache snd = AudioCache();

  FloatingActionButton rollbtn(Action act) {
    return FloatingActionButton(
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.black,
      onPressed: 
        () => (act == Action.up) ? dcKey.currentState.rollUp() : 
          (act == Action.down) ? dcKey.currentState.rollDown() : 
          (act == Action.left) ? dcKey.currentState.rollLeft() : 
          dcKey.currentState.rollRight(),
      child: Icon(
        (act == Action.up) ? Icons.keyboard_arrow_up : 
        (act == Action.down) ? Icons.keyboard_arrow_down : 
        (act == Action.left) ? Icons.keyboard_arrow_left : 
        Icons.keyboard_arrow_right),
    );
  }

  Expanded rowSide(int i) {
    Widget fbtn = Transform.scale(
      scale: 0.7,
      child: FloatingActionButton(
        elevation: 0.5,
        backgroundColor: Colors.black,
        onPressed: () {scrKey.currentState.clicked(); snd.play("clk.mp3"); Vibration.vibrate(); })
    );

    return Expanded(
      flex: 1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[(i == 2) ? fbtn : Text(""), (i == 1) ? fbtn : Text(""), (i == 2) ? fbtn : Text("")]
      )
    );
  }

  Container side(int idx) {
    return Container(
      height: 160, width: 160,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          stops: [0.1,0.5,0.7,0.9],
          colors: [Colors.black12,Colors.black26,Colors.black38,Colors.black45]),
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [BoxShadow( color: Colors.black38, offset: Offset(0.0, 5.0), blurRadius: 20.0)]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          rowSide((idx == 2 || idx == 3) ? 1 : (idx == 4 || idx == 5 || idx == 6) ? 2 : 0),
          rowSide((idx == 1 || idx == 3 || idx == 5) ? 1 : (idx == 6) ? 2 : 0),
          rowSide((idx == 3 || idx == 2) ? 1 : (idx == 4 || idx == 5 || idx == 6) ? 2 : 0)
        ],
      ));
  }

  @override
  Widget build(BuildContext ctx) {
    Widget header = Positioned(top: 44, left: 10,
      child: Material(
        child: Text("FIDGET DICE", style: TextStyle(color: Colors.black, fontFamily: "Bebas", fontSize: 60.0))));

    Cubef cubef = Cubef(key: dcKey, width: 160, height: 160,
      sides: [side(1), side(2), side(3), side(4), side(5), side(6)],
    );

    Widget content = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        rollbtn(Action.up),
        Container(
          padding: EdgeInsets.all(30.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              rollbtn(Action.left),
              Container(
                alignment: Alignment.center,
                width: 160, height: 160,
                child: cubef
              ),
              rollbtn(Action.right)
            ]),
        ),
        rollbtn(Action.down)],
    );

    List<Widget> backgnd = List<Widget>();

    for(int i=0; i < 6; i++) {
      backgnd.add(
        Center(
          child: Transform(
            alignment: FractionalOffset.center,
            transform: Matrix4.identity()
            ..setEntry(3,2,0.001)
            ..rotateZ(math.pi / 4),
            child: Container(
              width: 250.0 + (i * 50), height: 250.0 + (i * 50),
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: Color.fromRGBO(200, 200, 200, 1 - (0.1 * i)), width: 1),
                borderRadius: BorderRadius.all(Radius.circular(10))),
              )
          )
        )
      );
    }
    return MaterialApp(
      home: Stack(
        fit: StackFit.expand,
        children: [Material(color: Colors.white), header] + backgnd + [content, Score(key: scrKey)]
      )
    );
  }
}
