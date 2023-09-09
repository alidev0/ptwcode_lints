/// this will show warning
void fun1() {
  final name = _user.name;
  print(name);

  print(_user.name);
  print(_user.name);
}

/// this will not show warning
void fun2() {
  print(_user.name);
}

class _User {
  _User(this.name);
  final String name;
}

final _user = _User('John2');
