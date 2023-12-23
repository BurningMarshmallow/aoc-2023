import 'dart:collection';
import 'dart:io';
import 'dart:math';
import 'package:aoc/utils.dart';

void solve(String fileName) {
  var lines = File(fileName).readAsLinesSync();

  var (n, m) = (lines.length, lines[0].length);
  var (sx, sy) = (0, 1);
  var (ex, ey) = (n - 1, m - 2);

  longestHike(n, m, lines, sx, sy, ex, ey, true);
  longestHike(n, m, lines, sx, sy, ex, ey, false);
}

void longestHike(
    int n, int m, List<String> lines, int sx, int sy, int ex, int ey, bool easy) {
  var crossroads = <V>[];
  var arrowsToDir = Map<String, (int, int)>.from(
      {">": (0, 1), "v": (1, 0), "<": (0, -1), "^": (-1, 0)});
  for (var i = 0; i < n; i++) {
    for (var j = 0; j < m; j++) {
      var neighbours = 0;
      for (var [nx, ny] in neighbours4([i, j], n, m)) {
        if (lines[nx][ny] != "#") {
          neighbours++;
        }
      }
      if (lines[i][j] == "." && neighbours > 2) {
        crossroads.add((i, j));
      }
    }
  }

  var adj = <V, Map<V, int>>{};
  var q = DoubleLinkedQueue<(int, int, int)>.from([]);
  var vis = <V>{};

  var vertices = [(sx, sy)] + crossroads + [(ex, ey)];
  for (var u in vertices) {
    q.add((u.$1, u.$2, 0));
    while (q.isNotEmpty) {
      var state = q.removeFirst();
      var (x, y, steps) = state;
      for (var [nx, ny, dx, dy] in neighbours4WithDiff([x, y], n, m)) {
        if (lines[nx][ny] == "#") {
          continue;
        }
        if (easy && arrowsToDir.containsKey(lines[nx][ny])) {
          var diff = arrowsToDir[lines[nx][ny]]!;
          if (dx != diff.$1 || dy != diff.$2) {
            continue;
          }
        }
        if (vertices.contains((nx, ny)) && u != (nx, ny)) {
          if (!adj.containsKey(u)) {
            adj[u] = <V, int>{};
          }
          adj[u]![(nx, ny)] = steps + 1;

          if (!easy) {
            var v = (nx, ny);
            if (!adj.containsKey(v)) {
              adj[v] = <V, int>{};
            }
            adj[v]![u] = steps + 1;
          }
        } else {
          var newState = (nx, ny, steps + 1);
          if (!vis.contains((nx, ny))) {
            vis.add((nx, ny));
            q.add(newState);
          }
        }
      }
    }
  }

  var currMax = -1;
  var maxDist = getMaxDist(currMax, 0, (sx, sy), adj, (ex, ey), []);
  print(maxDist);
}

int getMaxDist(int currMax, int currDist, V curr, Map<V, Map<V, int>> adj,
    (int, int) end, List<V> path) {
  if (curr == end) {
    return currDist;
  }
  for (var y in adj[curr]!.keys) {
    if (!path.contains(y)) {
      currMax = max(
          currMax,
          getMaxDist(
              currMax, currDist + adj[curr]![y]!, y, adj, end, path + [y]));
    }
  }

  return currMax;
}

typedef V = (int x, int y);
