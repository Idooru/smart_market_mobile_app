import 'package:flutter/material.dart';
import 'package:smart_market/core/errors/dio_fail.error.dart';
import 'package:smart_market/core/utils/get_it_initializer.dart';
import 'package:smart_market/model/main/presentation/pages/navigation.page.dart';
import 'package:smart_market/model/user/domain/entities/profile.entity.dart';
import 'package:smart_market/model/user/domain/service/user.service.dart';

class ClientProfilePage extends StatefulWidget {
  const ClientProfilePage({super.key});

  @override
  State<ClientProfilePage> createState() => _ClientProfilePageState();
}

class _ClientProfilePageState extends State<ClientProfilePage> {
  final UserService _userService = locator<UserService>();

  Future<void> pressLogout() async {
    try {
      final state = context.findAncestorStateOfType<NavigationPageState>();
      await _userService.logout();
      state?.tapBottomNavigator(0);
    } on DioFailError catch (err) {
      debugPrint("err: $err");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile",
        ),
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
      body: FutureBuilder(
        future: _userService.getProfile(),
        builder: (BuildContext context, AsyncSnapshot<ResponseProfile> snapshot) {
          if (snapshot.hasData) {
            ResponseProfile profile = snapshot.data!;
            return Center(
              child: Text("안녕하세요, ${profile.nickName}님!"),
            );
          }
          return Container();
        },
      ),
    );
  }
}
