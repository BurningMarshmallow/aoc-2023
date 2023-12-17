import 'dart:io';
import 'package:aoc/utils.dart';
import 'package:collection/collection.dart';

void solve(String fileName) {
  var lines = File(fileName).readAsLinesSync();
  var grid = lines.map((x) => x.split("").map(int.parse).toList()).toList();

  easy(grid);
  hard(grid);
}

void easy(List<List<int>> grid) {
  print(getMinHeatLoss(grid, 1, 3));
}

void hard(List<List<int>> grid) {
  print(getMinHeatLoss(grid, 4, 10));
}

int getMinHeatLoss(List<List<int>> grid, int minLength, int maxLength) {
  var initState = (0, 0, 0, 0, 0);
  var heap =
      HeapPriorityQueue<DistAndState>((x, y) => x.dist.compareTo(y.dist));
  heap.add(DistAndState(0, initState));

  var n = grid.length;
  var m = grid[0].length;
  var vis = <State>{};
  vis.add(initState);

  while (true) {
    var curr = heap.removeFirst();

    var state = (
      x: curr.state.$1,
      y: curr.state.$2,
      dx: curr.state.$3,
      dy: curr.state.$4,
      steps: curr.state.$5
    );
    if (state.x == n - 1 && state.y == m - 1) {
      return curr.dist;
    }

    var next = <State>[];
    if (state.steps == 0) {
      for (var [nx, ny, dx, dy]
          in neighbours4WithDiff([state.x, state.y], n, m)) {
        if (!inside(nx, ny, grid)) {
          continue;
        }
        next.add((nx, ny, dx, dy, 1));
      }
    } else {
      if (state.steps < minLength) {
        var (nx, ny) = (state.x + state.dx, state.y + state.dy);
        if (!inside(nx, ny, grid)) {
          continue;
        }
        next.add((nx, ny, state.dx, state.dy, state.steps + 1));
      } else {
        for (var [nx, ny, dx, dy]
            in neighbours4WithDiff([state.x, state.y], n, m)) {
          if (!inside(nx, ny, grid)) {
            continue;
          }
          if (isReverseDirection(dx, dy, state.dx, state.dy)) {
            continue;
          }
          if (isSameDirection(dx, dy, state.dx, state.dy)) {
            if (state.steps < maxLength) {
              next.add((nx, ny, dx, dy, state.steps + 1));
            }
          } else {
            next.add((nx, ny, dx, dy, 1));
          }
        }
      }
    }

    for (var state in next) {
      if (vis.contains(state)) {
        continue;
      }
      vis.add(state);
      var (nx, ny, _, _, _) = state;
      heap.add(DistAndState(curr.dist + grid[nx][ny], state));
    }
  }
}

bool isSameDirection(int dx, int dy, int stateDx, int stateDy) {
  return dx == stateDx && dy == stateDy;
}

bool isReverseDirection(int dx, int dy, int stateDx, int stateDy) {
  return dx == -stateDx && dy == -stateDy;
}

bool inside(int x, int y, List<List<int>> grid) {
  return 0 <= x && x < grid.length && 0 <= y && y < grid[0].length;
}

typedef State = (int x, int y, int dx, int dy, int steps);

class DistAndState {
  DistAndState(this.dist, this.state);
  final int dist;
  final State state;
}
