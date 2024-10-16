// enum UserRole {
//   admin , dataProvider , dataApprover , dataReviewer
// }

class User {
  // Missing the profile picture as the type is according to the implementation
  String id;
  String name;
  String email;
  String password;
  String role;

  User(
      {required this.id,
      required this.name,
      required this.email,
      required this.password,
      required this.role,

      });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'role': role
    };
  }

  factory User.fromMap(Map<String, dynamic> map, String id) {
    return User(
      id: id,
      name: map['name'],
      email: map['email'],
      password: map['password'],
      role: map['role'],
      
    );
  }
}