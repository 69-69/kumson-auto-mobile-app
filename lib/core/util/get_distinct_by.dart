/// Remove Duplication of data: maintaining Distinct/Unique Data/Value[getDistinctBy]
extension IterableExtension<T> on Iterable<T> {
  Iterable<T> getDistinctBy(Object Function(T e) getCompareValue) {
    var result = <T>[];

    forEach((element) {
      if (!result.any((x) => getCompareValue(x) == getCompareValue(element))) {
        result.add(element);
      }
    });

    return result;
  }
}