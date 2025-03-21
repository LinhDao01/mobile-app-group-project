class User {
  final String id;
  final String email;
  final String? password;
  final String? name;
  final String? address;
  final String? phone;
  
  User({
    required this.id,
    required this.password,
    required this.email,
    this.name = 'unknown',
    this.address = 'unknown',
    this.phone = '0123456789',
  });

  User copyWith({
    String? id,
    String? username,
    String? email,
    String? password,
    String? name,
    String? address,
    String? phone,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
      name: name ?? this.name,
      address: address ?? this.address,
      phone: phone ?? this.phone,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      name: json['name'] ?? 'unknown',
      address: json['address'] ?? 'unknown',
      phone: json['phone'] ?? 'unknown',
    );
  }

  // Add a convenient method to create a user with only email and password
  factory User.createNew(
      {required String email, required String password, String id = ''}) {
    return User(
      id: id,
      email: email,
      password: password,
    );
  }

  // Convert to JSON for sending to PocketBase
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'name': name,
      'address': address,
      'phone': phone,
    };
  }
}
