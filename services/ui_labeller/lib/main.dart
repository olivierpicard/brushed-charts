import 'package:flutter/material.dart';
// import 'package:graph_kernel/main.dart';

abstract class A {
  static final id = "a";
  String getID();
}

class B extends A {
  static final id = "b";

  @override
  String getID() => B.id;
}

class C extends A {
  static final id = "c";

  @override
  String getID() => C.id;
}

main(List<String> args) async {
  // runApp(App());
  final A a = B();
  final A a1 = C();
  print(a.getID());
  print(a1.getID());
}

// class App extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         theme: getThemeData(),
//         home: Scaffold(body: GraphWidget(child: Container())));
//   }

//   ThemeData getThemeData() {
//     return ThemeData(
//       brightness: Brightness.dark,
//       primaryColor: Colors.blueGrey,
//     );
//   }
// }
