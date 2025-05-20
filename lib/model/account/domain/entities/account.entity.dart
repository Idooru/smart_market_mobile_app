class RequestAccounts {
  final String align;
  final String column;

  const RequestAccounts({
    required this.align,
    required this.column,
  });
}

class ResponseAccount {
  final String id;
  final String bank;
  final String accountNumber;
  final int balance;
  final bool isMainAccount;
  final DateTime createdAt;

  const ResponseAccount({
    required this.id,
    required this.bank,
    required this.accountNumber,
    required this.balance,
    required this.isMainAccount,
    required this.createdAt,
  });

  factory ResponseAccount.fromJson(Map<String, dynamic> json) {
    return ResponseAccount(
      id: json["id"],
      bank: json["bank"],
      accountNumber: json["accountNumber"],
      balance: json["balance"],
      isMainAccount: json["isMainAccount"],
      createdAt: DateTime.parse(json["createdAt"]),
    );
  }
}
