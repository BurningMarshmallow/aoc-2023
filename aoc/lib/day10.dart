import 'dart:io';
import 'package:aoc/utils.dart';
import 'package:collection/collection.dart';

void solve(String fileName) {
  var lines = File(fileName).readAsLinesSync();
  var (sx, sy) = (0, 0);
  for (var (x, line) in lines.indexed) {
    for (var (y, ch) in line.split("").indexed) {
      if (ch == "S") {
        (sx, sy) = (x, y);
      }
    }
  }

  var vis = [for (var i = 0; i < lines.length; i++) List.filled(lines[0].length, false)];
  traverse(lines, sx, sy, vis);
  
  var numOfVisited = vis.flattened.where((x) => x == true).length;
  print(numOfVisited ~/ 2);

  print(numOfInternalTiles(lines, sx, sy, vis));
}

void traverse(List<String> lines, int x, int y, List<List<bool>> vis) {
  vis[x][y] = true;
  for(var [nx, ny, dx, dy] in neighbours4WithDiff([x, y], lines.length, lines[0].length)) {
    while (canVisit(lines, nx, ny, dx, dy)) {
      if (lines[nx][ny] == "S") {
        return;
      }
      vis[nx][ny] = true;
      [nx, ny, dx, dy] = transform(lines, nx, ny, dx, dy);
    }
  }

  throw UnimplementedError("Did not find cycle");
}

int numOfInternalTiles(List<String> lines, int x, int y, List<List<bool>> vis) {
  var hasNorthAtStart = canVisit(lines, x - 1, y, -1, 0);

  var tilesCount = 0;
  for (var i = 0; i < lines.length; i++) {
    var norths = 0;
    for (var j = 0; j < lines[0].length; j++) {
      if (vis[i][j]) {
        if (hasNorthDirection(lines, i, j, hasNorthAtStart)) {
          norths++;
        }
        continue;
      }

      // Odd-even rule
      if (norths % 2 == 1) {
        tilesCount++;
      }
    }
  }

  return tilesCount;
}

bool hasNorthDirection(List<String> lines, int i, int j, bool hasNorthAtStart) {
  var symbol = lines[i][j];
  if (symbol == "S") {
    return hasNorthAtStart;
  }
  return symbol == "|" || symbol == "L" || symbol == "J";
}

bool canVisit(List<String> lines, int nx, int ny, int dx, int dy) {
  if (lines[nx][ny] == "|") {
    return (dx == 1 && dy == 0) || (dx == -1 && dy == 0);
  }
  if (lines[nx][ny] == "-") {
    return (dx == 0 && dy == 1) || (dx == 0 && dy == -1);
  }
  if (lines[nx][ny] == "L") {
    return (dx == 1 && dy == 0) || (dx == 0 && dy == -1);
  }
  if (lines[nx][ny] == "J") {
    return (dx == 1 && dy == 0) || (dx == 0 && dy == 1);
  }
  if (lines[nx][ny] == "7") {
    return (dx == -1 && dy == 0) || (dx == 0 && dy == 1);
  }
  if (lines[nx][ny] == "F") {
    return (dx == -1 && dy == 0) || (dx == 0 && dy == -1);
  }
  if (lines[nx][ny] == "S") {
    return true;
  }

  return false;
}

List<int> transform(List<String> lines, int nx, int ny, int dx, int dy) {
  var [newDx, newDy] = [-1, -1];
  if (lines[nx][ny] == "|" || lines[nx][ny] == "-") {
    [newDx, newDy] = [dx, dy];
  }

  if (lines[nx][ny] == "L") {
    if ((dx == 1 && dy == 0)) {
      [newDx, newDy] = [0, 1];
    }
    if ((dx == 0 && dy == -1)) {
      [newDx, newDy] = [-1, 0];
    }
  }
  if (lines[nx][ny] == "J") {
    if ((dx == 1 && dy == 0)) {
      [newDx, newDy] = [0, -1];
    }
    if ((dx == 0 && dy == 1)) {
      [newDx, newDy] = [-1, 0];
    }
  }
  if (lines[nx][ny] == "7") {
    if ((dx == -1 && dy == 0)) {
      [newDx, newDy] = [0, -1];
    }
    if ((dx == 0 && dy == 1)) {
      [newDx, newDy] = [1, 0];
    }
  }
  if (lines[nx][ny] == "F") {
    if ((dx == -1 && dy == 0)) {
      [newDx, newDy] = [0, 1];
    }
    if ((dx == 0 && dy == -1)) {
      [newDx, newDy] = [1, 0];
    }
  }
  
  return [nx + newDx, ny + newDy, newDx, newDy];
}
