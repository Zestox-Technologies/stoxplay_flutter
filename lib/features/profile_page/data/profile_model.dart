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
  final String? gender;
  final DateTime? dob;
  final String? profilePictureUrl;

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
    this.dob,
    this.gender,
    this.profilePictureUrl,
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
      profilePictureUrl: json['profilePictureUrl'] ?? '',
      dob: json['dateOfBirth'] != null ? DateTime.tryParse(json['dateOfBirth']) : null,
      gender: json['gender'] ?? 'SELECT',
    );
  }

  ProfileModel copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? username,
    String? phoneNumber,
    String? roleName,
    bool? active,
    int? walletBalance,
    String? state,
    String? area,
    DateTime? dob,
    String? profilePictureUrl,
    String? gender,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      username: username ?? this.username,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      roleName: roleName ?? this.roleName,
      active: active ?? this.active,
      walletBalance: walletBalance ?? this.walletBalance,
      state: state ?? this.state,
      area: area ?? this.area,
      dob: dob ?? this.dob,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      gender: gender ?? this.gender,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'username': username,
      'phoneNumber': phoneNumber,
      'roleName': roleName,
      'active': active,
      'walletBalance': walletBalance,
      'state': state,
      'area': area,
      'dateOfBirth': dob?.toIso8601String(),
      'profilePictureUrl': profilePictureUrl,
      'gender': gender,
    };
  }
}
