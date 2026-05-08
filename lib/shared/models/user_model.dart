class UserModel {
  final String id;
  final String name;
  final String phone;

  UserModel({required this.id, required this.name, required this.phone});

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'phone': phone};

  static UserModel fromJson(Map<String, dynamic> json) =>
      UserModel(id: json['id'], name: json['name'], phone: json['phone']);
}
