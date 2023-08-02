import 'semigroup.dart';

// need base because of lack of HKT

abstract class BaseMonoid<T> extends BaseSemigroup<T> {
  T get empty;
}

Function(List<T>) concatAll<T>(BaseMonoid<T> monoid) {
  return (List<T> as) =>
      as.fold(monoid.empty, (acc, a) => monoid.concat(acc, a));
}
