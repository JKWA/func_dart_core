import 'semigroup.dart';

// need base because of lack of HKT

abstract class BaseMonoid<T> extends BaseSemigroup<T> {
  T get empty;
}
