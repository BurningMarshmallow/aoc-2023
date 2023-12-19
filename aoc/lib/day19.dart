import 'dart:io';
import 'dart:math';
import 'package:collection/collection.dart';

void solve(String fileName) {
  var input = File(fileName).readAsStringSync();
  var [workflows, parts] =
      input.split("\n\n").map((x) => x.split("\n")).toList();
  var workflowsMap = <String, Workflow>{};

  for (var workflow in workflows) {
    var [name, rest] = workflow.split("{");
    var rules = rest.substring(0, rest.length - 1).split(",").toList();
    workflowsMap[name] = Workflow(rules);
  }

  easy(parts, workflowsMap);
  hard(workflowsMap);
}

void easy(List<String> parts, Map<String, Workflow> workflowsMap) {
  print(parts.where((x) => check(workflowsMap, x)).map(rating).sum);
}

bool check(Map<String, Workflow> workflows, String part) {
  var curr = "in";
  while (true) {
    for (var rule in workflows[curr]!.rules) {
      var next = "";
      if (rule.contains(":")) {
        if (canApply(rule, part)) {
          next = rule.split(":")[1];
        }
      } else {
        next = rule;
      }
      if (next == "A") {
        return true;
      }
      if (next == "R") {
        return false;
      }
      if (next != "") {
        curr = next;
        break;
      }
    }
  }
}

bool canApply(String rule, String part) {
  var cond = rule.split(":")[0];
  var partMap = partToMap(part);
  if (cond.contains("<")) {
    return partMap[cond.split("<")[0]]! < int.parse(cond.split("<")[1]);
  }

  if (cond.contains(">")) {
    return partMap[cond.split(">")[0]]! > int.parse(cond.split(">")[1]);
  }

  return false;
}

Map<String, int> partToMap(String part) {
  var entries =
      part.substring(1, part.length - 1).split(",").map((e) => e.split("="));
  var map = <String, int>{};
  for (var [name, valueStr] in entries) {
    map[name] = int.parse(valueStr);
  }
  return map;
}

int rating(String part) {
  Map<String, int> map = partToMap(part);
  return map.values.sum;
}

void hard(Map<String, Workflow> workflowsMap) {
  var ranges = <String, List<int>>{};
  for (var ch in "xmas".split("")) {
    ranges[ch] = [1, 4000];
  }

  print(numOfAccepted(ranges, "in", workflowsMap));
}

int numOfAccepted(Map<String, List<int>> ranges, String curr,
    Map<String, Workflow> workflowsMap) {
  var accepted = 0;
  for (var rule in workflowsMap[curr]!.rules) {
    if (rule.contains(":")) {
      var [cond, act] = rule.split(":");
      if (cond.contains(">")) {
        var [a, b] = cond.split(">");
        var newRanges = deepcopy(ranges);
        if (newRanges[a]![1] > int.parse(b)) {
          newRanges[a]![0] = max(newRanges[a]![0], int.parse(b) + 1);
          if (act == "A") {
            accepted += size(newRanges);
          } else {
            if (act != "R") {
              accepted += numOfAccepted(newRanges, act, workflowsMap);
            }
          }

          ranges[a]![1] = min(ranges[a]![1], int.parse(b));
        }
      }

      if (cond.contains("<")) {
        var [a, b] = cond.split("<");
        var newRanges = deepcopy(ranges);
        if (newRanges[a]![0] < int.parse(b)) {
          newRanges[a]![1] = min(newRanges[a]![1], int.parse(b) - 1);
          if (act == "A") {
            accepted += size(newRanges);
          } else {
            if (act != "R") {
              accepted += numOfAccepted(newRanges, act, workflowsMap);
            }
          }

          ranges[a]![0] = max(ranges[a]![0], int.parse(b));
        }
      }
    } else {
      if (rule == "A") {
        accepted += size(ranges);
      } else {
        if (rule != "R") {
          accepted += numOfAccepted(ranges, rule, workflowsMap);
        }
      }
    }
  }

  return accepted;
}

Map<String, List<int>> deepcopy(Map<String, List<int>> oldMap) {
  var newMap = <String, List<int>>{};
  for (var entry in oldMap.entries) {
    newMap[entry.key] = List.from(entry.value);
  }
  return newMap;
}

int size(Map<String, List<int>> ranges) {
  var size = 1;
  for (var x in ranges.values) {
    size *= x[1] - x[0] + 1;
  }

  return size;
}

class Workflow {
  Workflow(this.rules);
  final List<String> rules;
}
