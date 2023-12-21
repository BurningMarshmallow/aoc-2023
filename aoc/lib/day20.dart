import 'dart:collection';
import 'dart:io';
import 'package:dart_numerics/dart_numerics.dart';

void solve(String fileName) {
  var lines = File(fileName).readAsLinesSync();
  var moduleTypes = <String, int>{};
  var moduleAdj = <String, List<String>>{};
  var broadcastAdj = <String>[];

  for (var line in lines) {
    var [name, adj] = line.split(" -> ");
    if (line.contains("broad")) {
      broadcastAdj = adj.split(", ");
    } else {
      var realName = name.substring(1);
      if (name[0] == "%") {
        moduleTypes[realName] = 1;
      } else {
        moduleTypes[realName] = 2;
      }
      moduleAdj[realName] = adj.split(", ");
    }
  }

  var from = <String, Map<String, String>>{};
  var inv = <String, List<String>>{};
  for (var x in moduleAdj.keys) {
    for (var y in moduleAdj[x]!) {
      if (!from.containsKey(y)) {
        from[y] = {};
      }
      from[y]![x] = "low";
      if (!inv.containsKey(y)) {
        inv[y] = [];
      }
      inv[y]!.add(x);
    }
  }

  var finalInputs = inv.containsKey("rx") ? inv[inv["rx"]![0]]! : [];

  var toLcm = <int>[];
  var prev = <String, int>{};
  var count = <String, int>{};

  var (lo, hi) = (0, 0);
  var on = <String>{};
  var q = DoubleLinkedQueue<(String, String, String)>.from([]);

  for (var t = 1; t <= 10000000; t++) {
    q.add(("broadcaster", "button", "low"));
    while (q.isNotEmpty) {
      var (x, from_, type) = q.removeFirst();
      if (type == "low") {
        // Part 2
        if (prev.containsKey(x) && count[x]! == 2 && finalInputs.contains(x)) {
          toLcm.add(t - prev[x]!);
        }
        prev[x] = t;
        count[x] = (count[x] ?? 0) + 1;
      }
      if (t >= 1000 && toLcm.length == finalInputs.length) {
        if (toLcm.isNotEmpty) {
          print(toLcm);
          print(toLcm.reduce(leastCommonMultiple));
        } else {
          print("Undefined");
        }
        return;
      }

      if (type == "low") {
        lo++;
      } else {
        hi++;
      }

      var nextType = "";
      if (!moduleAdj.containsKey(x) && x != "broadcaster") {
        continue;
      }
      if (x == "broadcaster") {
        for (var y in broadcastAdj) {
          q.add((y, x, type));
        }
      } else {
        if (moduleTypes[x]! == 1) {
          if (type == "high") {
            continue;
          } else {
            if (!on.contains(x)) {
              on.add(x);
              nextType = "high";
            } else {
              on.remove(x);
              nextType = "low";
            }
            for (var y in moduleAdj[x]!) {
              q.add((y, x, nextType));
            }
          }
        } else {
          from[x]![from_] = type;
          if (from[x]!.values.every((y) => y == "high")) {
            nextType = "low";
          } else {
            nextType = "high";
          }
          for (var y in moduleAdj[x]!) {
            q.add((y, x, nextType));
          }
        }
      }
    }
    if (t == 1000) {
      print(lo * hi);
    }
  }
}
