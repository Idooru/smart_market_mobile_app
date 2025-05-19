import 'package:flutter/material.dart';

class InvitationLoginDialog {
  static void show(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: InvitationLoginDialogWidget(index: index),
      ),
    );
  }
}

class InvitationLoginDialogWidget extends StatefulWidget {
  final int index;

  const InvitationLoginDialogWidget({
    super.key,
    required this.index,
  });

  @override
  State<InvitationLoginDialogWidget> createState() => _InvitationLoginDialogWidgetState();
}

class _InvitationLoginDialogWidgetState extends State<InvitationLoginDialogWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 150,
      decoration: BoxDecoration(
        color: Colors.grey[200], // 연한 회색 배경
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const Icon(Icons.warning, size: 30),
            const SizedBox(height: 5),
            const Text(
              "로그인이 필요한 서비스입니다.",
              style: TextStyle(fontSize: 17),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed("/login");
              },
              child: Container(
                margin: const EdgeInsets.all(10),
                height: 50,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 200, 200, 200),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.login,
                      size: 19,
                      color: Color.fromARGB(255, 70, 70, 70),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "로그인 하기",
                      style: TextStyle(
                        color: Color.fromARGB(255, 70, 70, 70),
                        fontSize: 17,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
