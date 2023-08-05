import 'semigroup.dart';

/// Function that returns an instance of type `A`.
typedef LazyArg<A> = A Function();

/// Wraps a function `func` of type `S Function(A)` so it can be called as an instance method.
class FunctionWrapper<S, A> {
  /// Function to be wrapped.
  final S Function(A) func;

  FunctionWrapper(this.func);

  /// Allows the wrapped function to be called as an instance method.
  S call(A a) => func(a);
}

/// Returns a semigroup for the `FunctionWrapper` type, using a provided semigroup for the `S` type.
BaseSemigroup<FunctionWrapper<S, A>> getSemigroup<S, A>(
    BaseSemigroup<S> semigroup) {
  return _FunctionSemigroup(semigroup);
}

/// Defines a semigroup for the `FunctionWrapper` type.
class _FunctionSemigroup<S, A> extends BaseSemigroup<FunctionWrapper<S, A>> {
  /// The semigroup used to combine the results of the wrapped functions.
  final BaseSemigroup<S> semigroup;

  _FunctionSemigroup(this.semigroup);

  @override

  /// Combines two wrapped functions into a single one that, when called, combines their results using the `semigroup`.
  FunctionWrapper<S, A> concat(
      FunctionWrapper<S, A> f, FunctionWrapper<S, A> g) {
    return FunctionWrapper((A a) => semigroup.concat(f(a), g(a)));
  }
}

/// Identity function.
A identity<A>(A a) => a;
