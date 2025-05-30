import 'package:flutter/material.dart';
import 'package:smart_market/core/errors/connection_error.dart';
import 'package:smart_market/core/errors/dio_fail.error.dart';
import 'package:smart_market/core/errors/refresh_token_expired.error.dart';
import 'package:smart_market/core/utils/check_jwt_duration.dart';
import 'package:smart_market/core/utils/get_it_initializer.dart';
import 'package:smart_market/core/utils/get_snackbar.dart';
import 'package:smart_market/core/widgets/handler/loading_handler.widget.dart';
import 'package:smart_market/model/main/presentation/pages/navigation.page.dart';
import 'package:smart_market/model/user/domain/service/user.service.dart';

import '../../../../core/widgets/dialog/handle_network_error_on_dialog.dialog.dart';
import '../../../../core/widgets/handler/internal_server_error_handler.widget.dart';
import '../../../../core/widgets/handler/network_error_handler.widget.dart';
import '../../../account/domain/entities/account.entity.dart';
import '../../../account/domain/service/account.service.dart';
import '../../../account/presentation/widgets/account_list.widget.dart';
import '../../domain/entities/profile.entity.dart';
import '../dialog/force_logout.dialog.dart';
import '../widgets/profile/basic_profile.widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
    await checkJwtDuration();

    ResponseProfile profile = await _userService.getProfile();
    List<ResponseAccount> accounts = await _accountService.getAccounts(defaultRequestAccountsArgs);

    return {"profile": profile, "accounts": accounts};
  }

  void handleLogoutError(Object err) {
    HandleNetworkErrorOnDialogDialog.show(context, err);
  }

  Future<void> pressLogout() async {
    ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      final state = context.findAncestorStateOfType<NavigationPageState>();
      await _userService.logout();
      scaffoldMessenger.showSnackBar(getSnackBar('로그아웃이 완료되었습니다.'));
      state?.tapBottomNavigator(0);
    } catch (err) {
      handleLogoutError(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: _profilePageFuture,
        builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingHandlerWidget(title: "프로필 페이지 불러오기..");
          } else if (snapshot.hasError) {
            final error = snapshot.error;
            if (error is ConnectionError) {
              return NetworkErrorHandlerWidget(reconnectCallback: () {
                setState(() {
                  _profilePageFuture = initProfilePageFuture();
                });
              });
            } else if (error is RefreshTokenExpiredError) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ForceLogoutDialog.show(context);
              });
              return const SizedBox.shrink();
            } else if (error is DioFailError) {
              return const InternalServerErrorHandlerWidget();
            } else {
              return Center(child: Text("$error"));
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
