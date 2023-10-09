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
  final String name;
}

final _user = _User('John2');

final list = <_User>[];
