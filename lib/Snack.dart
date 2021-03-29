///蛇前进的坐标点
class Point {
  int row;
  int column;

  Point(this.row, this.column);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Point &&
          runtimeType == other.runtimeType &&
          row == other.row &&
          column == other.column;

  @override
  int get hashCode => row.hashCode ^ column.hashCode;

  ///根据蛇的左边和方位让蛇进行移动
  static neighbor(Point point, Direction direction) {
    int row = point.row;
    int column = point.column;
    switch (direction) {
      case Direction.left:
        --column;
        break;
      case Direction.right:
        ++column;
        break;
      case Direction.up:
        --row;
        break;
      case Direction.down:
        ++row;
        break;
    }
    return Point(row, column);
  }
}

///定义蛇方向
enum Direction { left, right, down, up }

///定义蛇
class Snack {
  ///初始化蛇的坐标
  List<Point> points = [];

  ///初始化蛇的方向
  Direction direction;

  ///是否撞墙
  bool _vaild = false;

  Snack({List<Point> points, Direction direction = Direction.left}) {
    assert(points != null);
    this.points = points;
    this.direction = direction;
  }

  ///是否为头
  isHand(Point point) {
    return points.first == point;
  }

  ///是否为蛇身
  isContain(Point point) {
    return points.contains(point);
  }

  ///
  bool get vaild => _vaild;

  ///前进方法
  forward() {
    var point = Point.neighbor(points[0], direction);
    _vaild = isContain(point);
    points
      ..insert(0, point)
      ..removeLast();
    return point;
  }

  ///吃到食物方法
  eat(Point point) {
    points.insert(0, point);
  }
}
