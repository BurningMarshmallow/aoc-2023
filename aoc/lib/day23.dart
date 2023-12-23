import 'dart:io';
import 'dart:math';

void solve(String fileName) {
  var lines = File(fileName).readAsLinesSync();
  var bricks = parseBricks(lines);

  bricks.sort((x, y) => x.botLeft.z == y.botLeft.z
      ? x.topRight.z.compareTo(y.topRight.z)
      : x.botLeft.z.compareTo(y.botLeft.z));

  var isMoving = true;
  while (isMoving) {
    isMoving = false;
    for (var (i, brick) in bricks.indexed) {
      while (isFreeUnder(brick, i, bricks)) {
        brick.botLeft.z--;
        brick.topRight.z--;
        isMoving = true;
      }
    }
  }

  print("Initial simulation is over");

  var numOfSafeDisintegrations = 0;
  var numOfFalling = 0;
  for (var (i, brick) in bricks.indexed) {
    if (canDisintegrate(bricks, i, brick)) {
      numOfSafeDisintegrations++;
    } else {
      numOfFalling += numOfFallingIfDisintegrate(bricks, i);
    }
  }

  print(numOfSafeDisintegrations);
  print(numOfFalling);
}

List<Cube> parseBricks(List<String> lines) {
  var bricks = <Cube>[];
  for (var line in lines) {
    var parts = line.split("~");
    var [lx, ly, lz] = parts[0].split(",").map(int.parse).toList();
    var [rx, ry, rz] = parts[1].split(",").map(int.parse).toList();

    bricks.add(Cube(V(lx, ly, lz), V(rx, ry, rz)));
  }
  return bricks;
}

bool canDisintegrate(List<Cube> bricks, int i, Cube brick) {
  for (var (j, other) in bricks.indexed) {
    if (i == j) {
      continue;
    }
    if (brick.topRight.z != other.botLeft.z - 1) {
      continue;
    }
    var r1 = getRectangle(brick);
    var r2 = getRectangle(other);
    if (!r1.intersects(r2)) {
      continue;
    }

    var numOfSupporting = 0;
    for (var (k, supporter) in bricks.indexed) {
      if (j == k) {
        continue;
      }
      if (supporter.topRight.z != other.botLeft.z - 1) {
        continue;
      }

      var r3 = getRectangle(supporter);
      if (r3.intersects(r2)) {
        numOfSupporting++;
        if (numOfSupporting > 1) {
          break;
        }
      }
    }

    if (numOfSupporting == 1) {
      return false;
    }
  }

  return true;
}

int numOfFallingIfDisintegrate(List<Cube> bricks, int i) {
  var newBricks = [
    for (var (j, cube) in bricks.indexed)
      if (i != j) cube.clone()
  ];
  var movedBricks = <int>{};
  for (var (k, brick) in newBricks.indexed) {
    if (isFreeUnder(brick, k, newBricks)) {
      brick.botLeft.z--;
      brick.topRight.z--;
      movedBricks.add(k);
    }
  }
  return movedBricks.length;
}

bool isFreeUnder(Cube brick, int i, List<Cube> bricks) {
  if (brick.botLeft.z == 1) {
    return false;
  }
  for (var (j, other) in bricks.indexed) {
    if (i == j) {
      continue;
    }
    if (other.topRight.z != brick.botLeft.z - 1) {
      continue;
    }

    var r1 = getRectangle(brick);
    var r2 = getRectangle(other);
    if (r1.intersects(r2)) {
      return false;
    }
  }

  return true;
}

Rectangle getRectangle(Cube brick) {
  return Rectangle.fromPoints(Point(brick.botLeft.x, brick.botLeft.y),
      Point(brick.topRight.x, brick.topRight.y));
}

class V {
  V(this.x, this.y, this.z);
  int x, y, z;

  @override
  String toString() {
    return "($x,$y,$z)";
  }

  V clone() => V(x, y, z);
}

class Cube {
  Cube(this.botLeft, this.topRight);
  V botLeft, topRight;

  @override
  String toString() {
    return "[$botLeft, $topRight]";
  }

  Cube clone() => Cube(botLeft.clone(), topRight.clone());
}
