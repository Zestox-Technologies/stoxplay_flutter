class ProfileModel {
  final String id;
  final String firstName;
  final String lastName;
  final String? email;
  final String username;
  final String phoneNumber;
  final String roleName;
  final bool active;
  final int walletBalance;
  final String? state;
  final String? area;

  ProfileModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.username,
    required this.phoneNumber,
    required this.roleName,
    required this.active,
    required this.walletBalance,
    required this.state,
    required this.area,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      username: json['username'],
      phoneNumber: json['phoneNumber'],
      roleName: json['roleName'],
      active: json['active'],
      walletBalance: json['walletBalance'],
      state: json['state'],
      area: json['area'],
    );
  }
} 