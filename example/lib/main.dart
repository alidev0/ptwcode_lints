// ignore_for_file: unused_local_variable, unused_element

import 'package:example/models.dart';

class Dumb {
  Dumb.v1({
    this.smth = User.smth,
  });

  Dumb.v2({
    this.smth = User.smth,
  });

  final smth;

  void fun1() => print(user.name);
  void fun2() => print(user.name);

  void fun3() {
    final name = user2.man.name;

    final age1 = user2.man.age; // warning
    final age2 = user2.man.age; // warning
  }
}

final stream1 = StreamProvider.autoDispose<void>((_) => Stream.empty());
final stream2 = StreamProvider.autoDispose<void>((_) => Stream.empty());

void fun11() {
  final user1 = user.copyWith(0.25);
  final user2 = user.copyWith(0.25);
}

void fun10() {
  final bear1 = Bear()..age = '5';
  final bear2 = Bear()..age = '5';
}

void fun9() {
  final btn1 = Button(
    doSmth: () {
      final list = [0];
      print(list.length);
    },
  );

  final btn3 = Button(
    doSmth: () {
      final list = [1];
      print(list.length);
    },
  );
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
  list.map((el) => user.surname); // warning
  list.map((el) => user.surname); // warning
}

void fun2() {
  final address = user.address; // warning
  print(user.address); // warning
}

void fun1() {
  final location = user.location;
  print(location);
}
