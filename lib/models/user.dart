class User {
  final int id;
  final String name;
  final String username;
  final String email;
  final String password;

  User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.password
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'],
    name: json['name'],
    email: json['email'],
    username: json['username'],
    password: json['password']
  );

  factory User.getJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      email: json['email'],
      password: '',
    );
  }

}