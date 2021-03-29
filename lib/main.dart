import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_snack2/RankBoard.dart';

import 'gameboard.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight,DeviceOrientation.landscapeLeft]).then((value) =>runApp(MyApp()));
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("贪吃蛇"),
          centerTitle: true,
        ),
        body: MyBody(),
      ),
    );
  }
}
class MyBody extends StatefulWidget {
  @override
  _MyBodyState createState() => _MyBodyState();
}

class _MyBodyState extends State<MyBody> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [


            ///开始游戏按钮
            RaisedButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return GameScaffold();
                }));
            },child: Container(alignment: Alignment.center,child: Text("Start Game"),width: 150,height: 50,),),
            SizedBox(height: 20,),

            ///查看记录按钮
            RaisedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context){
                return RankScaffold();
              }));
            },child: Container(alignment: Alignment.center,child: Text("Ranking"),width: 150,height: 50,),),
          ],
        ),
      ),
    );
  }
}



