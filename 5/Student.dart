class Student {
  String name;
  int age;

  Student({required this.name, required this.age});

  Student.fromMap(Map<String, dynamic> map)
      : this(
          name: map['name'] as String,
          age: map['age'] as int,
        );

  Map<String, dynamic> toMap() => {
        'name': name,
        'age': age,
      };
}
