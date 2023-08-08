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

/// Returns the input [a] without making any transformations.
///
/// Dart doesn't support function overloading, so different function names are
/// used for a different number of function arguments.
A pipe<A>(A a) {
  return a;
}

/// Transforms the input [a] by applying the function [ab].
B pipe2<A, B>(A a, B Function(A) ab) {
  return ab(a);
}

/// Transforms the input [a] by applying the function [ab] and then [bc].
C pipe3<A, B, C>(A a, B Function(A) ab, C Function(B) bc) {
  return bc(ab(a));
}

/// Transforms the input [a] by applying the function [ab], then [bc] and then [cd].
D pipe4<A, B, C, D>(A a, B Function(A) ab, C Function(B) bc, D Function(C) cd) {
  return cd(bc(ab(a)));
}

/// Transforms the input [a] by applying the function [ab], then [bc], then [cd] and then [de].
E pipe5<A, B, C, D, E>(A a, B Function(A) ab, C Function(B) bc,
    D Function(C) cd, E Function(D) de) {
  return de(cd(bc(ab(a))));
}

/// Transforms the input [a] by applying the function [ab], then [bc], then [cd], then [de] and then [ef].
F pipe6<A, B, C, D, E, F>(A a, B Function(A) ab, C Function(B) bc,
    D Function(C) cd, E Function(D) de, F Function(E) ef) {
  return ef(de(cd(bc(ab(a)))));
}

/// Transforms the input [a] by applying the function [ab], then [bc], then [cd], then [de], then [ef] and then [fg].
G pipe7<A, B, C, D, E, F, G>(A a, B Function(A) ab, C Function(B) bc,
    D Function(C) cd, E Function(D) de, F Function(E) ef, G Function(F) fg) {
  return fg(ef(de(cd(bc(ab(a))))));
}

/// Transforms the input [a] by applying the function [ab], then [bc], then [cd], then [de], then [ef], then [fg] and then [gh].
H pipe8<A, B, C, D, E, F, G, H>(
    A a,
    B Function(A) ab,
    C Function(B) bc,
    D Function(C) cd,
    E Function(D) de,
    F Function(E) ef,
    G Function(F) fg,
    H Function(G) gh) {
  return gh(fg(ef(de(cd(bc(ab(a)))))));
}

/// Transforms the input [a] by applying the function [ab], then [bc], then [cd], then [de], then [ef], then [fg], then [gh] and then [hi].
I pipe9<A, B, C, D, E, F, G, H, I>(
    A a,
    B Function(A) ab,
    C Function(B) bc,
    D Function(C) cd,
    E Function(D) de,
    F Function(E) ef,
    G Function(F) fg,
    H Function(G) gh,
    I Function(H) hi) {
  return hi(gh(fg(ef(de(cd(bc(ab(a))))))));
}

/// Transforms the input [a] by applying the function [ab], then [bc], then [cd], then [de], then [ef], then [fg], then [gh], then [hi] and then [ij].
J pipe10<A, B, C, D, E, F, G, H, I, J>(
    A a,
    B Function(A) ab,
    C Function(B) bc,
    D Function(C) cd,
    E Function(D) de,
    F Function(E) ef,
    G Function(F) fg,
    H Function(G) gh,
    I Function(H) hi,
    J Function(I) ij) {
  return ij(hi(gh(fg(ef(de(cd(bc(ab(a)))))))));
}

/// Returns a function that applies [ab] to its argument.
///
/// This function is similar to `pipe2`, but it curries the first argument.
/// Instead of taking two arguments, it takes one argument and returns a function
/// that takes the second argument and applies [ab] to it.
///
/// Dart doesn't support function overloading, so different function names are
/// used for a different number of function arguments.
B Function(A) flow<A, B>(B Function(A) ab) => (A a) => pipe2(a, ab);

C Function(A) flow2<A, B, C>(B Function(A) ab, C Function(B) bc) =>
    (A a) => pipe3(a, ab, bc);

D Function(A) flow3<A, B, C, D>(
        B Function(A) ab, C Function(B) bc, D Function(C) cd) =>
    (A a) => pipe4(a, ab, bc, cd);

E Function(A) flow4<A, B, C, D, E>(B Function(A) ab, C Function(B) bc,
        D Function(C) cd, E Function(D) de) =>
    (A a) => pipe5(a, ab, bc, cd, de);

F Function(A) flow5<A, B, C, D, E, F>(B Function(A) ab, C Function(B) bc,
        D Function(C) cd, E Function(D) de, F Function(E) ef) =>
    (A a) => pipe6(a, ab, bc, cd, de, ef);

G Function(A) flow6<A, B, C, D, E, F, G>(
        B Function(A) ab,
        C Function(B) bc,
        D Function(C) cd,
        E Function(D) de,
        F Function(E) ef,
        G Function(F) fg) =>
    (A a) => pipe7(a, ab, bc, cd, de, ef, fg);

H Function(A) flow7<A, B, C, D, E, F, G, H>(
        B Function(A) ab,
        C Function(B) bc,
        D Function(C) cd,
        E Function(D) de,
        F Function(E) ef,
        G Function(F) fg,
        H Function(G) gh) =>
    (A a) => pipe8(a, ab, bc, cd, de, ef, fg, gh);

I Function(A) flow8<A, B, C, D, E, F, G, H, I>(
        B Function(A) ab,
        C Function(B) bc,
        D Function(C) cd,
        E Function(D) de,
        F Function(E) ef,
        G Function(F) fg,
        H Function(G) gh,
        I Function(H) ih) =>
    (A a) => pipe9(a, ab, bc, cd, de, ef, fg, gh, ih);

J Function(A) flow9<A, B, C, D, E, F, G, H, I, J>(
        B Function(A) ab,
        C Function(B) bc,
        D Function(C) cd,
        E Function(D) de,
        F Function(E) ef,
        G Function(F) fg,
        H Function(G) gh,
        I Function(H) ih,
        J Function(I) ji) =>
    (A a) => pipe10(a, ab, bc, cd, de, ef, fg, gh, ih, ji);

/// Flips the order of arguments for a curried function.
///
/// Example:
///
/// ```dart
/// String concatenate(String a) => (String b) => a + b;
/// final flippedConcatenate = flip(concatenate);
///
/// print(concatenate('Hello, ')('World!'));  // Outputs: 'Hello, World!'
/// print(flippedConcatenate('World!')('Hello, '));  // Outputs: 'Hello, World!'
/// ```
C Function(A) Function(B) flip<A, B, C>(C Function(B) Function(A) fn) {
  return (B b) => (A a) {
        return fn(a)(b);
      };
}
