import 'package:flutter/material.dart';
import 'package:smart_market/core/errors/connection_error.dart';
import 'package:smart_market/core/errors/dio_fail.error.dart';
import 'package:smart_market/core/errors/refresh_token_expired.error.dart';
import 'package:smart_market/core/utils/check_jwt_duration.dart';
import 'package:smart_market/core/utils/get_it_initializer.dart';
import 'package:smart_market/core/utils/get_snackbar.dart';
import 'package:smart_market/core/widgets/handler/loading_handler.widget.dart';
import 'package:smart_market/model/account/presentation/widgets/navigate_accounts.widget.dart';
import 'package:smart_market/model/main/presentation/pages/navigation.page.dart';
import 'package:smart_market/model/order/presentation/widgets/navigate_orders.widget.dart';
import 'package:smart_market/model/review/presentation/widgets/navigate_all_reviews.widget.dart';
import 'package:smart_market/model/user/domain/service/user.service.dart';

import '../../../../core/widgets/dialog/handle_network_error.dialog.dart';
import '../../../../core/widgets/handler/internal_server_error_handler.widget.dart';
import '../../../../core/widgets/handler/network_error_handler.widget.dart';
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

    return {"profile": profile};
  }

  Future<void> pressLogout() async {
    ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);
    NavigatorState navigator = Navigator.of(context);

    try {
      await _userService.logout();
      scaffoldMessenger.showSnackBar(getSnackBar('로그아웃이 완료되었습니다.'));
      navigator.pushNamedAndRemoveUntil(
        "/home",
        (route) => false,
        arguments: const NavigationPageArgs(selectedIndex: 0),
      );
    } catch (err) {
      HandleNetworkErrorDialog.show(context, err);
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
                  color: const Color.fromARGB(255, 240, 240, 240),
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
                      const NavigateAccountsWidget(),
                      const NavigateOrdersWidget(),
                      const NavigateAllReviewsWidget(),
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
