import 'dart:math';

String createRandomID() {
  var rng = Random();
  String n = (rng.nextInt(8) + 1).toString();
  for (var i = 0; i <= 11; i++) {
    n += (rng.nextInt(10)).toString();
  }
  return n;
}
