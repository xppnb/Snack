import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_snack2/gameboard.dart';


/**
 * rank 记录
 *
 * */

class RankScaffold extends StatefulWidget {
  @override
  _RankScaffoldState createState() => _RankScaffoldState();
}

class _RankScaffoldState extends State<RankScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RankBody(),
    );
  }
}

class RankBody extends StatefulWidget {
  @override
  _RankBodyState createState() => _RankBodyState();
}


///这里才刚开始
class _RankBodyState extends State<RankBody> {

  ///用于存放原始数据的信息
  List list = [];


  ///用于存放刚玩完游戏后的数据
  List rankList = [];


  ///初始化
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    ///获取与原生交互获取保存的信息
    getData("getSp").then((value) {
      setState(() {

      });
      list = value != null ? json.decode(value.toString()) : [];
      getRank();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Container(
          width: 500,
          height: 300,
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("Rank"),
                    Text("Score"),
                    Text("Duration"),
                  ],
                ),
              ),

              ///用来显示数据的列表
              Expanded(
                flex: 8,
                  child:
                  ListView.builder(shrinkWrap: true,
                    itemBuilder: listBuild, ///将数据显示在listBuild中
                    itemCount: list.length,)
              ),
            ],
          ),
        ),
      ),
    );
  }


  ///获取刚才玩游戏获取的数据
  void getRank() {
    int rank = 1;
    int currentIndex = 1;
    rankList.add(rank);
    currentIndex++;
    for (int i = 1; i < list.length; i++) {
      if (list[i] == list[i - 1]) {
        rankList.add(rank);
      } else {
        rank = currentIndex;
        rankList.add(rank);
      }
      currentIndex++;
    }
  }

  ///显示数据
  Widget listBuild(BuildContext context, int index) {
      return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Spacer(flex: 3,),
            Expanded(child: Text(rankList[index].toString()),flex: 4,),
            Expanded(child: Text(list[index]["score"].toString()),flex: 4,),
            Expanded(child: Text(list[index]["duration"].toString()),flex: 4,),
          ],
        ),
      );
  }
}
