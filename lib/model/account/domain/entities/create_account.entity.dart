class RequestCreateAccount {
  final String bank;
  final String accountNumber;
  final int balance;
  final bool isMainAccount;

  const RequestCreateAccount({
    required this.bank,
    required this.accountNumber,
    required this.balance,
    required this.isMainAccount,
  });

  Map<String, dynamic> toJson() {
    return {
      "bank": bank,
      "accountNumber": accountNumber,
      "balance": balance,
      "isMainAccount": isMainAccount,
    };
  }
}
