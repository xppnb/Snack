import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'Snack.dart';

class GameScaffold extends StatefulWidget {
  @override
  _GameScaffoldState createState() => _GameScaffoldState();
}

class _GameScaffoldState extends State<GameScaffold> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: GameBody(width, height),
    );
  }
}

class GameBody extends StatefulWidget {
  var width;
  var height;

  GameBody(double width, double height) {
    this.width = width;
    this.height = height;
  }

  @override
  _GameBoayState createState() => _GameBoayState();
}

///定义格子类型 是食物还是空还是蛇部分
enum BoardType { food, none, snack }

class _GameBoayState extends State<GameBody> {
  ///格子大小
  static double borderSize = 20;

  ///定义格子之间的间距
  static double borderSpace = 0.5;

  ///定义格子的宽度
  static double borderWidth = borderSize - borderSpace * 2;

  ///初始化格子
  List<List<BoardType>> boardList = [];

  ///初始化宽高
  int row;
  int column;

  ///初始化蛇
  Snack snack;

  ///初始化长度
  int initLength = 4;

  ///初始化分数
  int score = 0;

  ///初始化时间
  int duration = 0;

  Timer timer1;
  Timer timer2;

  ///食物坐标
  Point food;

  ///初始化移动距离
  double movePosition = 0;

  ///重新开始后格子需要重置
  initBoard() {
    row = (widget.height) ~/ borderSize;
    column = (widget.width - 370) ~/ borderSize;
    boardList?.clear();
    for (int i = 0; i < row; i++) {
      boardList.add(List.generate(column, (index) => BoardType.none));
    }
  }

  ///初始化蛇身
  initSnack() {
    int start = (column - initLength) ~/ 2;
    List<Point> point =
        List.generate(initLength, (index) => Point(row ~/ 2, start + index));
    snack = new Snack(points: point);
  }

  ///定时器开始 蛇开始移动
  startTimer() {
    timer1 = new Timer.periodic(Duration(milliseconds: 200), (timer) {
      startGame();
    });
    timer2 = new Timer.periodic(Duration(seconds: 1), (t) {
      duration++;
    });
  }

  ///重新开始方法
  restart() {
    timer1?.cancel();
    timer2?.cancel();
    score = 0;
    duration = 0;
    initBoard();
    initSnack();
    startTimer();
  }

  ///初始化方法，进入restart()方法。
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    restart();
  }

  ///主要方法
  @override
  Widget build(BuildContext context) {
    ///用来从头到尾逐个扫描看格子是否为普通格子还是蛇头还是蛇身，将每个格子发送给createBoard，交给他判读
    List<Row> rowList = [];
    for (int i = 0; i < row; i++) {
      List<Container> columnList = [];
      for (int j = 0; j < column; j++) {
        columnList.add(createBoard(i, j));
      }
      rowList.add(Row(
        children: columnList,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      ));
    }

    ///主要的显示区域(可以用手势的区域)
    return Container(
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 1),
                ),
                child: Column(
                  children: rowList,
                ),
              ),

              ///监听垂直方向
              onVerticalDragUpdate: (event) {
                movePosition += event.delta.dy;
              },
              onVerticalDragEnd: (event) {
                ///根据根据movePosition的大小判断垂直方向移动
                moveVer(movePosition);
                movePosition = 0;
              },

              ///监听水平方向
              onHorizontalDragUpdate: (event) {
                movePosition += event.delta.dx;
              },
              onHorizontalDragEnd: (event) {
                ///根据根据movePosition的大小判断水平方向移动
                moveHor(movePosition);
                movePosition = 0;
              },
            ),
            flex: 5,
          ),
          SizedBox(
            width: 40,
          ),

          ///左边的显示时间和分数的区域
          Expanded(
            child: Container(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("score:$score"),
                Text("duration:$duration"),
              ],
            )),
            flex: 2,
          )
        ],
      ),
    );
  }

  ///判断上面传下来的坐标，再将坐标发给getCellType方法进行判断是否为蛇头
  Container createBoard(int row, int column) {
    var cellType = getCellType(Point(row, column));

    ///创建表格和表格颜色
    return Container(
      width: borderWidth,
      height: borderWidth,
      color: cellType.isHand ? Colors.purple : cellType.color,
    );
  }

  ///
  CellType getCellType(Point point) {
    ///判断蛇身是否包含蛇
    BoardType boardType = snack.isContain(point)
        ? BoardType.snack
        : boardList[point.row][point.column];
    Color color;

    ///判断每一个格子的状态(如果为蛇身，食物，没有状态)的情况
    switch (boardType) {
      case BoardType.snack:
        color = Colors.lightGreenAccent;
        break;
      case BoardType.food:
        color = Colors.pinkAccent;
        break;
      case BoardType.none:
        color = Colors.white;
        break;
    }

    bool f = false;

    ///如果是蛇身则判断是否包含蛇头
    if (boardType == BoardType.snack) {
      if (snack.isHand(point)) {
        f = true;
      }
    }

    ///最后将数据给CellType方法
    return CellType(boardType: boardType, color: color, isHand: f);
  }

  ///开始游戏(吃到食物后添加分数，撞到身体后游戏结束，)
  void startGame() {
    setState(() {});
    var point = snack.forward();
    vaild(point);
    if (!snack.vaild) {
      if (point == food) {
        clearFood(point);
        score++;
        snack.eat(point);
      }
    } else {
      gameOver();
    }
    addFood();
  }

  ///添加食物
  void addFood() {
    setState(() {});
    if (food == null) {
      int row = Random().nextInt(this.row);
      int col = Random().nextInt(this.column);
      if (!snack.isContain(Point(row, col)) &&
          boardList[row][col] == BoardType.none) {
        food = Point(row, col);
        boardList[row][col] = BoardType.food;
      }
    }
  }

  ///吃掉食物或游戏结束后清除食物
  void clearFood(Point point) {
    setState(() {});
    if (food != null) {
      food = null;
      boardList[point.row][point.column] = BoardType.none;
    }
  }

  ///判断是否撞墙
  void vaild(Point point) {
    if (point.row > row) {
      point.row = 0;
    } else if (point.row == 0) {
      point.row = row;
    } else if (point.column > column) {
      point.column = 0;
    } else if (point.column == 0) {
      point.column = column;
    }
  }

  ///游戏结束
  gameOver() {
    timer1.cancel();
    timer2.cancel();
    getData("getSp").then((value) {
      List tempList = value != null ? json.decode(value.toString()) : [];
      Map map = {"score": score, "duration": duration};
      tempList.add(map);
      tempList.sort((a, b) {
        if (a["score"] != b["score"]) {
          return b["score"].hashCode.compareTo(a["score"]);
        } else {
          return b["duration"].hashCode.compareTo(a["duration"]);
        }
      });
      String string = json.encode(tempList).toString();
      print(string);
      getData("setSp", arguments: string);
    });

    ///游戏结束后弹出框
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Game over"),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context, 1);
                  },
                  child: Text("play again")),
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context, 2);
                  },
                  child: Text("Back to home")),
            ],
          );
        }).then((value) {
      if (value == 1) {
        restart();
      } else {
        Navigator.pop(context);
      }
    });
  }

  ///垂直方向的移动
  void moveVer(double movePosition) {
    setState(() {});
    if (movePosition > 0) {
      if (snack.direction != Direction.up) {
        snack.direction = Direction.down;
      }
    } else if (snack.direction != Direction.down) {
      snack.direction = Direction.up;
    }
  }

  ///水平方向的移动
  void moveHor(double movePosition) {
    setState(() {});
    if (movePosition > 0) {
      if (snack.direction != Direction.left) {
        snack.direction = Direction.right;
      }
    } else if (snack.direction != Direction.right) {
      snack.direction = Direction.left;
    }
  }
}

///负责接收格子的的状态，是否为头，还有颜色(包含蛇头，蛇身和普通格子)
class CellType {
  BoardType boardType;
  bool isHand;
  Color color;

  CellType({this.boardType, this.isHand, this.color});
}

/// 定义和原生交互的名字
class Utils {
  static final methodChannel = MethodChannel("android");
}

///与原生交互 存储数据
Future getData(String name, {String arguments}) async {
  if (arguments == null) {
    return Utils.methodChannel.invokeMethod(name);
  } else {
    return Utils.methodChannel.invokeMethod(name, arguments);
  }
}
