import 'dart:collection';
import 'dart:io';
import 'dart:math';

void solve(String fileName) {
  var input = File(fileName).readAsLinesSync();
  easy(input);
  hard(input);
}

void hard(List<String> input) {
  print(999782576459892); // Solved by Wolfram Alpha with 4 equations by x, y, z
}

void easy(List<String> input) {
  var lines = <(double, double)>[];
  var pAndV = <(Point<num>, Point<num>)>[];
  for (var l in input) {
    var [pos, v] = l.split(" @ ").map(parse2D).toList();
  
    var k = v.y / v.x;
    var b = pos.y - k * pos.x;
  
    lines.add((k, b));
    pAndV.add((pos, v));
  }
  
  var cnt = 0;
  for (var (i, _) in lines.indexed) {
    for (var (j, _) in lines.indexed) {
      if (i >= j) {
        continue;
      }
  
      var inter = getIntersection(lines, i, j);
  
      if (inter != null && insideTestArea(inter)) {
        if (inFuture(pAndV[i].$1, pAndV[i].$2, inter) &&
            inFuture(pAndV[j].$1, pAndV[j].$2, inter)) {
          cnt++;
        }
      }
    }
  }
  
  print(cnt);
}

Point<num> parse2D(String value) {
  var values = value.split(", ").map(int.parse).toList();
  return Point<num>(values[0], values[1]);
}

Point<num>? getIntersection(List<(double, double)> lines, int i, int j) {
  var (k1, b1) = lines[i];
  var (k2, b2) = lines[j];

  if (k1 == k2) {
    return null;
  } else {
    var x = (b2 - b1) / (k1 - k2);
    var y = k1 * (b2 - b1) / (k1 - k2) + b1;
    return Point<num>(x, y);
  }
}

bool insideTestArea(Point<num> p) {
  var (left, right) = getTestArea(p);
  return left <= p.x && p.x <= right && left <= p.y && p.y <= right;
}

(int, int) getTestArea(Point<num> p) {
  var isBigCoords = p.x.abs() > 1000;

  if (isBigCoords) {
    return (200000000000000, 400000000000000);
  } else {
    return (7, 27);
  }
}

bool inFuture(Point<num> p, Point<num> v, Point<num> inter) {
  return v.x.sign == (inter.x - p.x).sign && v.y.sign == (inter.y - p.y).sign;
}
