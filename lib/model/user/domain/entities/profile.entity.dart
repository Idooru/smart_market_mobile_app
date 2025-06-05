class RequestUpdateProfile {
  final String nickName;
  final String phoneNumber;
  final String address;
  final String email;

  const RequestUpdateProfile({
    required this.nickName,
    required this.phoneNumber,
    required this.address,
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'nickName': nickName,
      'phoneNumber': phoneNumber,
      'address': address,
      'email': email,
    };
  }
}

class ResponseProfile {
  final String id;
  final String role;
  final String realName;
  final String birth;
  final String gender;
  final String phoneNumber;
  final String address;
  final String nickName;
  final String email;

  const ResponseProfile({
    required this.id,
    required this.role,
    required this.realName,
    required this.birth,
    required this.gender,
    required this.phoneNumber,
    required this.address,
    required this.nickName,
    required this.email,
  });

  factory ResponseProfile.fromJson(Map<String, dynamic> json) {
    return ResponseProfile(
      id: json['id'],
      role: json['role'],
      realName: json['realName'],
      birth: json["birth"],
      gender: json['gender'],
      phoneNumber: json['phoneNumber'],
      address: json['address'],
      nickName: json['nickName'],
      email: json['email'],
    );
  }
}
