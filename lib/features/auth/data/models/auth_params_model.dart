class AuthParamsModel {
  String? phoneNumber;
  String? otp;
  String? referralCode;
  String? username;
  String? email;
  String? firstName;
  String? lastName;
  bool? isUserExists;

  AuthParamsModel({
    this.phoneNumber,
    this.otp,
    this.referralCode,
    this.username,
    this.isUserExists = false,
    this.email,
    this.firstName,
    this.lastName,
  });

  Map<String, dynamic> toJson() {
    return {
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
      if (otp != null) 'otp': otp,
      if (referralCode != null) 'referralCode': referralCode,
      if (username != null) 'username': username,
      if (email != null) 'email': email,
      if (firstName != null) 'firstName': firstName,
      if (lastName != null) 'lastName': lastName,
    };
  }

  factory AuthParamsModel.fromJson(Map<String, dynamic> json) {
    return AuthParamsModel(
      phoneNumber: json['phoneNumber'],
      otp: json['otp'],
      referralCode: json['referralCode'],
      username: json['username'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
    );
  }
}
