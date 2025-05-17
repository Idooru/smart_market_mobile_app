class RequestRegister {
  final String realName;
  final String gender;
  final String birth;
  final String nickName;
  final String email;
  final String password;
  final String phoneNumber;
  final String address;
  final String role;

  const RequestRegister({
    required this.realName,
    required this.gender,
    required this.birth,
    required this.nickName,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.address,
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      "realName": realName,
      "gender": gender,
      "birth": birth,
      "nickName": nickName,
      "email": email,
      "password": password,
      "phoneNumber": phoneNumber,
      "address": address,
      "role": role,
    };
  }
}
