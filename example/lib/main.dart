/// this fun has warnings
void fun1() {
  final name = _user.name; // warning
  print(name);

  print(_user.name); // warning
  print(_user.name); // warning
}

/// this fun has no warnings
void fun2() {
  print(_user.name);
}

class _User {
  _User(this.name);
  final String name;
}

final _user = _User('John2');
