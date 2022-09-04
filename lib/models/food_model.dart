class Food {
  Food({required this.name});

  final String name;

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(name: json['name']);
  }
}
