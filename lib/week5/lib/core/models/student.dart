class Student {
  const Student({required this.name, required this.group, required this.email});

  final String name;
  final String group;
  final String email;

  Student copyWith({String? name, String? group, String? email}) => Student(
    name: name ?? this.name,
    group: group ?? this.group,
    email: email ?? this.email,
  );
}
