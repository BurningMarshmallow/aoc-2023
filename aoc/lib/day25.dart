import 'dart:collection';
import 'dart:io';
import 'dart:math';
import 'package:collection/collection.dart';

void solve(String fileName) {
  var input = File(fileName).readAsLinesSync();
  easy(input);
}

void easy(List<String> input) {
  var edges = <(String, String)>{};
  var adj = <String, Set<String>>{};
  for (var line in input) {
    var [u, neighbours] = line.split(": ");

    if (!adj.containsKey(u)) {
      adj[u] = {};
    }
    for (var v in neighbours.split(" ")) {
      adj[u]!.add(v);

      if (!adj.containsKey(v)) {
        adj[v] = {};
      }
      adj[v]!.add(u);

      if (!edges.contains((u, v)) && !edges.contains((v, u))) {
        edges.add((u, v));
      }
    }
  }

  var n = adj.keys.length;
  var nodes = adj.keys.toList();
  var stats = <(String, String), int>{};

  for (var i = 0; i < 10000; i++) {
    var n1 = nodes[Random.secure().nextInt(n)];
    var n2 = nodes[Random.secure().nextInt(n)];
    var path = bfs(n1, n2, adj);
    for (var x in path) {
      x.sort();
      var edge = (x[0], x[1]);
      stats[edge] = (stats[edge] ?? 0) + 1;
    }
  }

  var maxStats = stats.entries.sorted((a, b) => -a.value.compareTo(b.value));
  for (var entry in maxStats.take(3)) {
    removeEdge(adj, entry.key);
  }

  var sizes = getComponentSizes(adj);

  if (sizes.length == 2) {
    print(sizes[0] * sizes[1]);
  } else {
    print("Did not separate graph!");
  }
}

List<List<String>> bfs(String start, String end, Map<String, Set<String>> adj) {
  var q = DoubleLinkedQueue<(String, List<List<String>>)>.from([]);
  var vis = <String>{};

  q.add((start, []));
  while (q.isNotEmpty) {
    var (v, edgePath) = q.removeFirst();
    if (v == end) {
      return edgePath;
    }
    for (var nextState in adj[v]!) {
      if (!vis.contains(nextState)) {
        var newState = (
          nextState,
          edgePath +
              [
                [v, nextState]
              ]
        );
        q.add(newState);
        vis.add(nextState);
      }
    }
  }

  return [];
}

void removeEdge(Map<String, Set<String>> adj, (String, String) edge) {
  adj[edge.$1]!.remove(edge.$2);
  adj[edge.$2]!.remove(edge.$1);
}

List<int> getComponentSizes(Map<String, Set<String>> adj) {
  var sizes = <int>[];
  var vis = <String>{};

  for (var x in adj.keys) {
    if (vis.contains(x)) {
      continue;
    } else {
      var component = <String>{};
      traverse(adj, vis, x, component);
      sizes.add(component.length);
    }
  }

  return sizes;
}

void traverse(Map<String, Set<String>> adj, Set<String> vis, String from,
    Set<String> component) {
  if (component.contains(from)) {
    return;
  } else {
    vis.add(from);
    component.add(from);
  }

  for (var to in adj[from]!) {
    traverse(adj, vis, to, component);
  }
}
