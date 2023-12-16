import 'dart:io';
import 'dart:math';
import 'package:collection/collection.dart';

void solve(String fileName) {
  var lines = File(fileName).readAsLinesSync();
  easy(lines);
  hard(lines);
}

void easy(List<String> lines) {
  var (sx, sy) = (0, 0);
  var dir = Point(0, 1);

  print(getNumOfEnergizedTiles(lines, sx, sy, dir));
}

void hard(List<String> lines) {
  var maxNum = -1;
  for (var (x, _) in lines.indexed) {
    var (sx, sy) = (x, 0);
    var dir = Point(0, 1);
    maxNum = max(maxNum, getNumOfEnergizedTiles(lines, sx, sy, dir));

    (sx, sy) = (x, lines.length - 1);
    dir = Point(0, -1);
    maxNum = max(maxNum, getNumOfEnergizedTiles(lines, sx, sy, dir));
  }

  for (var (y, _) in lines[0].split("").indexed) {
    var (sx, sy) = (0, y);
    var dir = Point(1, 0);
    maxNum = max(maxNum, getNumOfEnergizedTiles(lines, sx, sy, dir));

    (sx, sy) = (lines[0].length - 1, y);
    dir = Point(-1, 0);
    maxNum = max(maxNum, getNumOfEnergizedTiles(lines, sx, sy, dir));
  }

  print(maxNum);
}

int getNumOfEnergizedTiles(List<String> lines, int sx, int sy, Point<int> dir) {
  var vis = [for (var i = 0; i < lines.length; i++) List.filled(lines[0].length, false)];
  traverse(lines, sx, sy, vis, dir);
  
  var numOfVisited = vis.flattened.where((x) => x == true).length;
  return numOfVisited;
}

void traverse(List<String> lines, int x, int y, List<List<bool>> vis, Point<int> dir) {
  if (!inside(lines, x, y)) {
    return;
  }
  if (vis[x][y] && (lines[x][y] == "|" || lines[x][y] == "-")) {
    return;
  }
  
  vis[x][y] = true;
  switch(lines[x][y]) {
    case ".":
      traverse(lines, x + dir.x, y + dir.y, vis, dir);
      break;
    case r"\":
      var newDir = mirror(dir);
      traverse(lines, x + newDir.x, y + newDir.y, vis, newDir);
      break;
    case "/":
      var newDir = backMirror(dir);
      traverse(lines, x + newDir.x, y + newDir.y, vis, newDir);
      break;
    case "-":
      if (dir.x == 0) {
        traverse(lines, x + dir.x, y + dir.y, vis, dir);
      } else {
        traverse(lines, x, y - 1, vis, Point(0, -1));        
        traverse(lines, x, y + 1, vis, Point(0, 1));        
      }
      break;
    case "|":
      if (dir.y == 0) {
        traverse(lines, x + dir.x, y + dir.y, vis, dir);
      } else {
        traverse(lines, x - 1, y, vis, Point(-1, 0));        
        traverse(lines, x + 1, y, vis, Point(1, 0));        
      }
      break;
  }

  return;
}

Point<int> mirror(Point<int> dir) {
  return Point(dir.y, dir.x);
}

Point<int> backMirror(Point<int> dir) {
  return Point(-dir.y, -dir.x);
}

bool inside(List<String> lines, int x, int y) {
  return 0 <= x && x < lines.length && 0 <= y && y < lines[0].length;
}
