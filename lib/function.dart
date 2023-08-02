import 'semigroup.dart';

class FunctionWrapper<S, A> {
  final S Function(A) func;

  FunctionWrapper(this.func);

  S call(A a) => func(a);
}

BaseSemigroup<FunctionWrapper<S, A>> getSemigroup<S, A>(
    BaseSemigroup<S> semigroup) {
  return _FunctionSemigroup(semigroup);
}

class _FunctionSemigroup<S, A> extends BaseSemigroup<FunctionWrapper<S, A>> {
  final BaseSemigroup<S> semigroup;

  _FunctionSemigroup(this.semigroup);

  @override
  FunctionWrapper<S, A> concat(
      FunctionWrapper<S, A> f, FunctionWrapper<S, A> g) {
    return FunctionWrapper((A a) => semigroup.concat(f(a), g(a)));
  }
}
