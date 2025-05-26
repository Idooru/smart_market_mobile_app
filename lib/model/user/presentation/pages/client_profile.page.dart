import 'package:flutter/material.dart';
import 'package:smart_market/core/errors/dio_fail.error.dart';
import 'package:smart_market/core/errors/refresh_token_expired.error.dart';
import 'package:smart_market/core/utils/get_it_initializer.dart';
import 'package:smart_market/core/utils/get_snackbar.dart';
import 'package:smart_market/core/widgets/handler/loading_handler.widget.dart';
import 'package:smart_market/model/main/presentation/pages/navigation.page.dart';
import 'package:smart_market/model/user/domain/service/user.service.dart';

import '../../../../core/widgets/handler/internal_server_error_handler.widget.dart';
import '../../../../core/widgets/handler/network_error_handler.widget.dart';
import '../../../account/domain/entities/account.entity.dart';
import '../../../account/domain/service/account.service.dart';
import '../../../account/presentation/widgets/account_list.widget.dart';
import '../../domain/entities/profile.entity.dart';
import '../dialog/force_logout.dialog.dart';
import '../widgets/profile/basic_profile.widget.dart';

class ClientProfilePage extends StatefulWidget {
  const ClientProfilePage({super.key});

  @override
  State<ClientProfilePage> createState() => _ClientProfilePageState();
}

class _ClientProfilePageState extends State<ClientProfilePage> {
  final UserService _userService = locator<UserService>();
  final AccountService _accountService = locator<AccountService>();
  final RequestAccounts defaultRequestAccountsArgs = const RequestAccounts(align: "DESC", column: "createdAt");
  late Future<Map<String, dynamic>> _profilePageFuture;

  @override
  void initState() {
    super.initState();

    _profilePageFuture = initProfilePageFuture();
  }

  Future<Map<String, dynamic>> initProfilePageFuture() async {
    await Future.delayed(const Duration(milliseconds: 500));

    bool result = await _userService.checkJwtTokenDuration();
    if (!result) throw RefreshTokenExpiredError();

    ResponseProfile profile = await _userService.getProfile();
    List<ResponseAccount> accounts = await _accountService.getAccounts(defaultRequestAccountsArgs);

    return {"profile": profile, "accounts": accounts};
  }

  Future<void> pressLogout() async {
    ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      final state = context.findAncestorStateOfType<NavigationPageState>();
      await _userService.logout();
      scaffoldMessenger.showSnackBar(getSnackBar('로그아웃이 완료되었습니다.'));
      state?.tapBottomNavigator(0);
    } on DioFailError catch (err) {
      debugPrint("err: $err");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: _profilePageFuture,
        builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: LoadingHandlerWidget(title: "프로필 페이지 불러오기.."),
            );
          } else if (snapshot.hasError) {
            final error = snapshot.error;
            if (error is RefreshTokenExpiredError) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ForceLogoutDialog.show(context);
              });
              return const SizedBox.shrink();
            } else if (error is DioFailError) {
              if (error.message == "none connection") {
                return Center(
                  child: NetworkErrorHandlerWidget(reconnectCallback: () {
                    setState(() {
                      _profilePageFuture = initProfilePageFuture();
                    });
                  }),
                );
              } else {
                return const Center(child: InternalServerErrorHandlerWidget());
              }
            } else {
              return const SizedBox.shrink();
            }
          } else {
            return Scaffold(
              appBar: AppBar(
                title: const Text("Profile"),
                centerTitle: false,
                flexibleSpace: Container(
                  color: Colors.blueGrey[300],
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
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: Column(
                    children: [
                      BasicProfileWidget(profile: snapshot.data!["profile"]),
                      AccountListWidget(accounts: snapshot.data!["accounts"]),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
