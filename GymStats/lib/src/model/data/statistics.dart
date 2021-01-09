class Statistics {
  static num max(List<num> values) {
    num max = -9999999999;
    values.forEach((element) {
      if (element > max) max = element;
    });
    return max;
  }

  static num min(List<num> values) {
    num min = 9999999999;
    values.forEach((element) {
      if (element < min) min = element;
    });
    return min;
  }

  static sum(List<num> values) {
    num sum = 0;
    values.forEach((element) {
      sum += element;
    });
    return sum;
  }

  static num mean(List<num> values) {
    return Statistics.sum(values) / values.length;
  }

  static num moda(List<num> values) {
    final Map<num, int> count = {};
    values.forEach((element) {
      if (count.containsKey(element)) {
        count[element] = count[element] + 1;
      } else {
        count[element] = 1;
      }
    });
    var maxCount = 0;
    var moda = 0;
    for (var pair in count.entries) {
      if (pair.value > maxCount) {
        maxCount = pair.value;
        moda = pair.key;
      }
    }
    return moda;
  }

  List<num> multiplyLists(List<num> a, List<num> b) {
    if (a.length != b.length) {
      print("List must be the same lenght");
      return null;
    }
    List<num> prod = [];
    for (int i = 0; i < a.length; i++) {
      prod.add(a[i] * b[i]);
    }
    return prod;
  }
}
