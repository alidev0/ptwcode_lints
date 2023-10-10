// ignore_for_file: unused_local_variable

import 'package:example/models.dart';

class Dumb {
  void fun1() => print(user.name); // no warning
  void fun2() => print(user.name); // no warning

  void fun3() {
    final age = user2.man.age; // no warning
    final name = user2.man.name; // no warning
  }

  void fun4() {
    final user1 = user.copyWith(0.25); // no warning
    final user2 = user.copyWith(0.25); // no warning
  }
}

void fun6() {
  final age = user2.man.age; // no warning
  final name = user2.man.name; // no warning
}

void fun5() {
  final time = DateTime.now();
  final items = [];

  final groupByTime1 = {time: items, time: items};
  final groupByTime2 = {time: items, time: items};

  final yeap = [
    ...groupByTime1.entries.map((el) => User(el.key)).toList(), // no warning
    ...groupByTime2.entries.map((el) => User(el.key)).toList(), // no warning
  ];
}

void fun4() {
  list.map((el) => el.name); // no warning
  list.map((el) => el.name); // no warning
}

void fun3() {
  list.map((el) => user.name); // warning
  list.map((el) => user.name); // warning
}

void fun2() {
  final name = user.name; // warning
  print(user.name);
}

void fun1() {
  final name = user.name; // no warning
  print(name);
}
