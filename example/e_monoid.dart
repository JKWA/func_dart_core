import 'package:functional_dart/integer.dart';
import 'package:functional_dart/monoid.dart';
import 'package:functional_dart/string.dart';

// The Monoid is the same as a Semigroup, but it includes a concept of 'empty'
// This is useful when combining lists of things

// Like a Semigroup, Monoids are structures with an operation to combine two elements
// Unlike a Semigroup, Monoids include an 'empty' element, which doesn't change other elements when combined.
final add = monoidSum;
final multiply = monoidProduct;
final combineString = monoidConcat;
final addList = concatAll(add);
final multiplyList = concatAll(multiply);
final concatList = concatAll(combineString);

void main() {
  // Empty changes depending on how things are combined
  // 0 for addition, 1 for multiplication, and '' for concatenation
  print('empty for addition = ${monoidSum.empty}');
  print('empty for addition = ${monoidProduct.empty}');
  print('empty for concat = ${monoidConcat.empty}');

  print('add 1 and 2 = ${add.concat(1, 2)}');
  print('multiply 2 and 3 = ${multiply.concat(2, 3)}');
  print('concat a and b = ${combineString.concat('a', 'b')}');

  // Monoids, because they understand empty, can combine lists of things.
  // Combine numbers though addition
  print('1+2+3+4 = ${addList([1, 2, 3, 4])}');

  // Combine numbers though multiplication
  print('1*2*3*4 = ${multiplyList([1, 2, 3, 4])}');

  // Combine strings by concatenation
  print('a+b+c+d = ${concatList(['a', 'b', 'c', 'd'])}');
}
