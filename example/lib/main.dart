// ignore_for_file: unused_local_variable, unused_element

import 'package:example/models.dart';

class Dumb {
  void fun1() => print(user.name);
  void fun2() => print(user.name);

  void fun3() {
    final age = user2.man.age;
    final name = user2.man.name;
  }

  void fun4() {
    final user1 = user.copyWith(0.25);
    final user2 = user.copyWith(0.25);
  }

  void fun5() {
    final bear1 = Bear()..age = '5';
    final bear2 = Bear()..age = '5';
  }
}

void fun8() {
  void aa() => counter.value = 1;
  void bb() => counter.value = 1;
}

void fun7() {
  counter.value = 1;
  counter.value = 2;
  counter.value += 1;
  counter.value += 2;
  counter.value -= 1;
  counter.value -= 2;
}

void fun6() {
  final age = user2.man.age;
  final name = user2.man.name;
}

void fun5() {
  final time = DateTime.now();
  final items = [];

  final groupByTime1 = {time: items, time: items};
  final groupByTime2 = {time: items, time: items};

  final yeap = [
    ...groupByTime1.entries.map((el) => User(el.key)).toList(),
    ...groupByTime2.entries.map((el) => User(el.key)).toList(),
  ];
}

void fun4() {
  list.map((el) => el.name);
  list.map((el) => el.name);
}

void fun3() {
  list.map((el) => user.name); // warning
  list.map((el) => user.name); // warning
}

void fun2() {
  final name = user.name; // warning
  print(user.name); // warning
}

void fun1() {
  final name = user.name;
  print(name);
}
