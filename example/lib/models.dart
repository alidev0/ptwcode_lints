// ignore_for_file: unused_local_variable
// ignore_for_file: prefer_moving_to_variable

class User {
  User(this.name);
  final dynamic name;
  final String surname = 'some-surname';
  final String address = 'some-address';
  final String location = 'some-location';

  static const String smth = 'smth';

  User copyWith(double value) => User(name);

  Model<String> get smth2 => Model<String>();
}

class Model<T> {
  Future<bool> set1(T value) async => true;
  Future<bool> set2(T value) async => false;
}

final user = User('John2');

final list = <User>[];

class User2 {
  User2(this.man);
  final Man man;
}

final user2 = User2(Man(name: 'name', age: '25'));

class Man {
  final String name;
  final String age;
  Man({required this.name, required this.age});
}

class Counter {
  Counter({required this.value});
  int value;
}

final counter = Counter(value: 0);

class Bear {
  String? age;
}

class Button {
  Button({required this.doSmth});
  void Function() doSmth;
}

class StreamProvider {
  static late Stream Function<T>(dynamic) autoDispose;
}
