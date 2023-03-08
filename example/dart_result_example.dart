import 'package:dart_result_option/dart_result_option.dart';

void main() {
  // Match is the same as using a pattern match on an enum, it'll expose the Ok
  // and Err values so that you can correctly treat if an operation was successful
  // or not.
  sumPositive(5, 5).match(
      (ok) => print("Successfully returned, the sum is $ok"),
      (err) => print(err));

  // Now if you need to return a single type from a Result, for example, you just
  // want to print the http code of some network request you can use narrowMatch
  // and provide the type you'll be returning for both Ok and Err.
  final networkCode =
      exceptionExample().narrowMatch<String>((ok) => '200', (err) => '404');
  print(networkCode);
}

// A lot of operations work under a success-failure pattern. Result makes it easy
// to encapsulate and return two different values from the same function.
Result<int, String> sumPositive(int n1, int n2) {
  if (n1 + n2 < 0) {
    // If the sum is not positive, we return a String wrapped on an Err
    // that will be treated as an error.
    return Err("The sum between $n1 + $n2 is not bigger than 0");
  }

  // If everything goes well we wrap the sum with an Ok.
  return Ok(n1 + n2);
}

// Simple example returning a Result with a try-catch block.
Result<int, String> exceptionExample() {
  try {
    return Ok(5);
  } catch (e) {
    return Err(e.toString());
  }
}
