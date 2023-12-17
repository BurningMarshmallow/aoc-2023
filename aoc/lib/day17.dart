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
  var initState = State(0, 0, 0, 0, 0);
  var heap =
      HeapPriorityQueue<DistAndState>((x, y) => x.dist.compareTo(y.dist));
  heap.add(DistAndState(0, initState));

  var n = grid.length;
  var m = grid[0].length;
  var vis = <State>{};
  vis.add(initState);

  while (true) {
    var curr = heap.removeFirst();
    var state = curr.state;
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
        next.add(State(nx, ny, dx, dy, 1));
      }
    } else {
      if (state.steps < minLength) {
        var (nx, ny) = (state.x + state.dx, state.y + state.dy);
        if (!inside(nx, ny, grid)) {
          continue;
        }
        next.add(State(nx, ny, state.dx, state.dy, state.steps + 1));
      } else {
        for (var [nx, ny, dx, dy]
            in neighbours4WithDiff([state.x, state.y], n, m)) {
          if (!inside(nx, ny, grid)) {
            continue;
          }
          if (isReverseDirection(dx, dy, state)) {
            continue;
          }
          if (isSameDirection(dx, dy, state)) {
            if (state.steps < maxLength) {
              next.add(State(nx, ny, dx, dy, state.steps + 1));
            }
          } else {
            next.add(State(nx, ny, dx, dy, 1));
          }
        }
      }
    }

    for (var state in next) {
      if (vis.contains(state)) {
        continue;
      }
      vis.add(state);
      heap.add(DistAndState(curr.dist + grid[state.x][state.y], state));
    }
  }
}

bool isSameDirection(int dx, int dy, State state) =>
    dx == state.dx && dy == state.dy;

bool isReverseDirection(int dx, int dy, State state) {
  return dx == -state.dx && dy == -state.dy;
}

bool inside(int x, int y, List<List<int>> grid) {
  return 0 <= x && x < grid.length && 0 <= y && y < grid[0].length;
}

class State {
  State(this.x, this.y, this.dx, this.dy, this.steps);
  final int x, y, dx, dy, steps;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is State &&
        other.x == x &&
        other.y == y &&
        other.dx == dx &&
        other.dy == dy &&
        other.steps == steps;
  }

  @override
  int get hashCode => hash5(x, y, dx, dy, steps);

  @override
  String toString() {
    return "$x $y $dx $dy $steps";
  }
}

/// Generates a hash code for five objects.
int hash5(a, b, c, d, e) => _finish(_combine(
    _combine(
        _combine(_combine(_combine(0, a.hashCode), b.hashCode), c.hashCode),
        d.hashCode),
    e.hashCode));

// Jenkins hash functions

int _combine(int hash, int value) {
  hash = 0x1fffffff & (hash + value);
  hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
  return hash ^ (hash >> 6);
}

int _finish(int hash) {
  hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
  hash = hash ^ (hash >> 11);
  return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
}

class DistAndState {
  DistAndState(this.dist, this.state);
  final int dist;
  final State state;
}
