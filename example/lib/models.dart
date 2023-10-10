class User {
  User(this.name);
  final dynamic name;

  User copyWith(double value) => User(name);
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
