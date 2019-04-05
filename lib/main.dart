import 'package:flutter/material.dart';
import 'package:cubef/cubef.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:vibration/vibration.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  final GlobalKey<CubefState> dcKey = GlobalKey<CubefState>();
  final AudioCache snd = AudioCache();

  FloatingActionButton rollb(Action act) {
    return FloatingActionButton(
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      onPressed: () => (act == Action.up) ? dcKey.currentState.rollUp() : (act == Action.down) ? dcKey.currentState.rollDown() : (act == Action.left) ? dcKey.currentState.rollLeft() : dcKey.currentState.rollRight(),
      child: Icon((act == Action.up) ? Icons.keyboard_arrow_up : (act == Action.down) ? Icons.keyboard_arrow_down : (act == Action.left) ? Icons.keyboard_arrow_left : Icons.keyboard_arrow_right),
    );
  }

  Transform fb() {
    return Transform.scale(
      scale: 0.7,
      child: FloatingActionButton(
        elevation: 0.5,
        backgroundColor: Colors.black,
        onPressed: () { snd.play("clk.mp3"); Vibration.vibrate(); })
    );
  }

  Expanded rowSide(int i) {
    return Expanded(
      flex: 1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[(i == 2) ? fb() : Text(""), (i == 1) ? fb() : Text(""), (i == 2) ? fb() : Text("")]
      )
    );
  }

  Container side(int idx) {
    return Container(
      height: 160,
      width: 160,
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

  Cubef cb() {
    return Cubef(
      key: dcKey,
      animationEffect: Curves.decelerate,
      animationDuration: 500,
      child1: side(1), child2: side(2), child3: side(3), child4: side(4), child5: side(5), child6: side(6),
      width: 160, height: 160,
    );
  }

  Column bd() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        rollb(Action.up),
        Container(
          padding: EdgeInsets.all(30.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              rollb(Action.left),
              Container(
                alignment: Alignment.center,
                width: 160, height: 160,
                child: cb()
              ),
              rollb(Action.right)
            ]),
        ),
        rollb(Action.down)],
    );
  }

  @override
  Widget build(BuildContext ctx) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.grey),
      home: Scaffold(
        appBar: AppBar(title: Text("FIDGET DICE"), backgroundColor: Colors.white,),
        body: bd() 
      ),
    );
  }
}
