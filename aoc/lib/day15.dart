import 'dart:io';

final labelRegex = RegExp(r'[a-zA-Z]+');

void solve(String fileName) {
  var lines = File(fileName).readAsLinesSync();
  easy(lines);
  hard(lines);
}

void easy(List<String> lines) {
  var total = lines[0].split(",").fold(0, (prev, x) => prev + hash(x));

  print(total);
}

int hash(String x) {
  var curr = 0;
  for (var ch in x.codeUnits) {
    curr += ch;
    curr *= 17;
    curr %= 256;
  }

  return curr;
}

void hard(List<String> lines) {
  var operations = lines[0].split(",");
  var hashmap = <int, List<Lens>>{};
  for (var op in operations) {
    var label = labelRegex.firstMatch(op)![0]!;
    var hashValue = hash(label);
    if (op.endsWith("-")) {
      removeLens(hashmap, hashValue, label);
    } else {
      var focalLength = int.parse(op.split("=")[1]);
      var lens = Lens(label, focalLength);
      updateLens(hashmap, hashValue, lens);
    }
  }

  print(getFocusingPower(hashmap));
}

void removeLens(Map<int, List<Lens>> hashmap, int hashValue, String label) {
  hashmap[hashValue]?.removeWhere((lens) => lens.label == label);
}

void updateLens(Map<int, List<Lens>> hashmap, int hashValue, Lens lens) {
  if (hashmap.containsKey(hashValue)) {
    var idx = hashmap[hashValue]!.indexWhere((x) => x.label == lens.label);
    if (idx != -1) {
      hashmap[hashValue]![idx] = lens;
    } else {
      hashmap[hashValue]!.add(lens);
    }
  } else {
    hashmap[hashValue] = [lens];
  }
}

int getFocusingPower(Map<int, List<Lens>> hashmap) {
  var focusingPower = 0;
  for (var i = 0; i < 256; i++) {
    if (hashmap.containsKey(i)) {
      for (var (j, lens) in hashmap[i]!.indexed) {
        focusingPower += (i + 1) * (j + 1) * lens.focalLength;
      }
    }
  }
  return focusingPower;
}

class Lens {
  Lens(this.label, this.focalLength);
  final String label;
  final int focalLength;

  @override
  String toString() {
    return "$label $focalLength";
  }
}
