import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_market/core/utils/parse_date.dart';
import 'package:smart_market/model/account/domain/entities/account.entity.dart';

class AccountItemWidget extends StatelessWidget {
  final ResponseAccount account;

  const AccountItemWidget({
    super.key,
    required this.account,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 95,
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromARGB(255, 245, 245, 245),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 10,
            left: 10,
            child: Text(
              "${account.bank} ${account.accountNumber}",
              style: const TextStyle(
                fontSize: 14,
                color: Color.fromARGB(255, 80, 80, 80),
              ),
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: Icon(
              account.isMainAccount ? Icons.check_circle_outline : Icons.circle_outlined,
              color: account.isMainAccount ? Colors.red : Colors.black,
            ),
          ),
          Positioned(
            top: 35,
            left: 10,
            child: Text(
              "${NumberFormat('#,###').format(account.balance)} 원",
              style: const TextStyle(fontSize: 22),
            ),
          ),
          Positioned(
            top: 70,
            left: 10,
            child: Text(
              "${parseDate(account.createdAt)}에 계좌 생성됨",
              style: const TextStyle(
                fontSize: 12,
                color: Color.fromARGB(255, 120, 120, 120),
              ),
            ),
          ),
          Positioned(
            right: -2,
            bottom: -2,
            child: IconButton(
              constraints: const BoxConstraints(), // 크기 최소화
              icon: const Icon(Icons.more_vert, size: 15),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
