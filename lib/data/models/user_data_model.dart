class UserModel {
  final int id;
  final String username;
  final String phoneNumber;
  final String firstName;
  final String lastName;
  final String cashbackBalance;

  UserModel({
    required this.id,
    required this.username,
    required this.phoneNumber,
    required this.firstName,
    required this.lastName,
    required this.cashbackBalance,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      username: json['username'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      cashbackBalance: json['cashback_balance'] ?? '0.00',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'phone_number': phoneNumber,
      'first_name': firstName,
      'last_name': lastName,
      'cashback_balance': cashbackBalance,
    };
  }
}
