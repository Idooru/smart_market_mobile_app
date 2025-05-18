import 'package:flutter/material.dart';
import 'package:smart_market/core/errors/dio_fail.error.dart';
import 'package:smart_market/core/utils/get_it_initializer.dart';
import 'package:smart_market/model/main/presentation/pages/navigation.page.dart';
import 'package:smart_market/model/user/domain/service/user.service.dart';
import 'package:smart_market/model/user/presentation/widgets/profile/basic_profile.widget.dart';

class ClientProfilePage extends StatefulWidget {
  const ClientProfilePage({super.key});

  @override
  State<ClientProfilePage> createState() => _ClientProfilePageState();
}

class _ClientProfilePageState extends State<ClientProfilePage> {
  final UserService _userService = locator<UserService>();

  Future<void> pressLogout() async {
    ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      final state = context.findAncestorStateOfType<NavigationPageState>();
      await _userService.logout();
      scaffoldMessenger.showSnackBar(const SnackBar(content: Text('로그아웃이 완료되었습니다.')));
      state?.tapBottomNavigator(0);
    } on DioFailError catch (err) {
      debugPrint("err: $err");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: false,
        flexibleSpace: Container(
          color: Colors.blueGrey[300], // 스크롤 될 시 색상 변경 방지
        ),
        actions: [
          IconButton(
            onPressed: pressLogout,
            icon: const Icon(
              Icons.logout,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Column(
            children: [
              BasicProfileWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
