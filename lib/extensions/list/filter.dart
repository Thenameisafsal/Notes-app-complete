
extension Filter<T> on Stream<List<T>>{ // add an extension for the Stream<List<T>> objects
  Stream<List<T>> filter(bool Function(T) lookupFunction) =>  // the lookupFunction is a condition that the results have to satisfy to be included - filtering
    map((items) => items.where(lookupFunction).toList());

}