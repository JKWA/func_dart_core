// need base because of lack of HKT

abstract class BaseSemigroup<T> {
  T concat(T first, T second);
}
