import 'dart:io';

void solve(String fileName) {
  var lines = File(fileName).readAsLinesSync();
  var (sumEasy, sumHard) = (0, 0);

  for (var line in lines) {
    var values = line.split(" ").map(int.parse).toList();
    var predictedValues = predict(values);
    sumEasy += predictedValues.last;
    sumHard += predictedValues.first;
  }

  print(sumEasy);
  print(sumHard);
}

List<int> predict(List<int> values) {
  if (values.every((x) => x == 0)) {
    return values;
  }

  var diffs = <int>[];
  for (var i = 0; i < values.length - 1; i++) {
    diffs.add(values[i+1] - values[i]);
  }
  diffs = predict(diffs);

  values.insert(0, values.first - diffs.first);
  values.add(diffs.last + values.last);
  return values;
}
