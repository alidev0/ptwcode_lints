class Dumb {
  void fun1() => print(_user.name); // no warning
  void fun2() => print(_user.name); // no warning
}

void fun5() {
  final time = DateTime.now();
  final items = [];

  final groupByTime1 = {time: items, time: items};
  final groupByTime2 = {time: items, time: items};

  // ignore: unused_local_variable
  final yeap = [
    ...groupByTime1.entries.map((el) => _User(el.key)).toList(), // no warning
    ...groupByTime2.entries.map((el) => _User(el.key)).toList(), // no warning
  ];
}

void fun4() {
  list.map((el) => el.name); // no warning
  list.map((el) => el.name); // no warning
}

void fun3() {
  list.map((el) => _user.name); // warning
  list.map((el) => _user.name); // warning
}

void fun2() {
  // ignore: unused_local_variable
  final name = _user.name; // warning
  print(_user.name);
}

void fun1() {
  final name = _user.name; // no warning
  print(name);
}

class _User {
  _User(this.name);
  final dynamic name;
}

final _user = _User('John2');

final list = <_User>[];
