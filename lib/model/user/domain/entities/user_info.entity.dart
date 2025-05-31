class UserInfo {
  final String userId;
  final String email;
  final String nickName;
  final String userRole;
  final int iat;
  final int exp;

  const UserInfo({
    required this.userId,
    required this.email,
    required this.nickName,
    required this.userRole,
    required this.iat,
    required this.exp,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      userId: json["userId"],
      email: json["email"],
      nickName: json["nickName"],
      userRole: json["userRole"],
      iat: json["iat"],
      exp: json["exp"],
    );
  }
}
