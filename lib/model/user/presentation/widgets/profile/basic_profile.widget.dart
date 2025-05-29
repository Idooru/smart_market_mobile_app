import 'package:flutter/material.dart';
import 'package:smart_market/core/errors/dio_fail.error.dart';
import 'package:smart_market/core/utils/get_it_initializer.dart';
import 'package:smart_market/core/utils/parse_date.dart';
import 'package:smart_market/core/widgets/handler/internal_server_error_handler.widget.dart';
import 'package:smart_market/core/widgets/handler/loading_handler.widget.dart';
import 'package:smart_market/core/widgets/handler/network_error_handler.widget.dart';
import 'package:smart_market/model/user/domain/entities/profile.entity.dart';
import 'package:smart_market/model/user/domain/service/user.service.dart';
import 'package:smart_market/model/user/presentation/pages/edit_profile.page.dart';

import '../../../../../core/errors/connection_error.dart';

class BasicProfileWidget extends StatefulWidget {
  final ResponseProfile profile;

  const BasicProfileWidget({
    super.key,
    required this.profile,
  });

  @override
  State<BasicProfileWidget> createState() => _BasicProfileWidgetState();
}

class _BasicProfileWidgetState extends State<BasicProfileWidget> {
  final UserService _userService = locator<UserService>();
  late Future<ResponseProfile> _getProfileFuture;
  bool _isFirstRendering = true;

  @override
  void initState() {
    super.initState();
    _getProfileFuture = _userService.getProfile();
  }

  void pressEditButton(ResponseProfile profile) async {
    final result = await Navigator.of(context).pushNamed(
      "/edit_profile",
      arguments: EditProfilePageArgs(profile: profile),
    );

    if (result == true) {
      setState(() {
        _getProfileFuture = _userService.getProfile();
      });
    }
  }

  Widget getEditProfileButton(ResponseProfile profile) {
    return GestureDetector(
      onTap: () => pressEditButton(profile),
      child: Container(
        width: 90,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color.fromARGB(255, 230, 230, 230),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(Icons.edit, size: 15),
            Text("프로필 수정"),
          ],
        ),
      ),
    );
  }

  Widget getPageElement(ResponseProfile profile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              "내 프로필",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            getEditProfileButton(profile),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color.fromARGB(255, 245, 245, 245),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    profile.realName,
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(width: 5),
                  Icon(
                    profile.role == "client" ? Icons.person : Icons.security,
                    size: 15,
                  ),
                  const Spacer(),
                  Text(
                    parseDate(profile.birth),
                    style: const TextStyle(
                      color: Color.fromARGB(255, 80, 80, 80),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(width: 3),
                  Icon(
                    profile.gender == "male" ? Icons.male : Icons.female,
                    color: profile.gender == "male" ? Colors.blue : Colors.pink,
                    size: 18,
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  const Icon(
                    Icons.email,
                    size: 15,
                    color: Color.fromARGB(255, 70, 70, 70),
                  ),
                  const SizedBox(width: 3),
                  Text(
                    profile.email,
                    style: const TextStyle(fontSize: 12, color: Color.fromARGB(255, 70, 70, 70)),
                  )
                ],
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  const Icon(
                    Icons.phone,
                    size: 15,
                    color: Color.fromARGB(255, 70, 70, 70),
                  ),
                  const SizedBox(width: 3),
                  Text(
                    profile.phoneNumber,
                    style: const TextStyle(fontSize: 12, color: Color.fromARGB(255, 70, 70, 70)),
                  )
                ],
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  const Icon(
                    Icons.tag,
                    size: 15,
                    color: Color.fromARGB(255, 70, 70, 70),
                  ),
                  const SizedBox(width: 3),
                  Text(
                    profile.nickName,
                    style: const TextStyle(fontSize: 12, color: Color.fromARGB(255, 70, 70, 70)),
                  )
                ],
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  const Icon(
                    Icons.home,
                    size: 15,
                    color: Color.fromARGB(255, 70, 70, 70),
                  ),
                  const SizedBox(width: 3),
                  Text(
                    profile.address,
                    style: const TextStyle(fontSize: 12, color: Color.fromARGB(255, 70, 70, 70)),
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _isFirstRendering
        ? Builder(builder: (context) {
            WidgetsBinding.instance.addPostFrameCallback((_) => _isFirstRendering = false);
            return getPageElement(widget.profile);
          })
        : FutureBuilder(
            future: _getProfileFuture,
            builder: (BuildContext context, AsyncSnapshot<ResponseProfile> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Column(
                  children: [
                    SizedBox(height: 30),
                    LoadingHandlerWidget(title: "기본 프로필 불러오기"),
                  ],
                );
              } else if (snapshot.hasError) {
                final error = snapshot.error;
                if (error is ConnectionError) {
                  return NetworkErrorHandlerWidget(reconnectCallback: () {
                    setState(() {
                      _getProfileFuture = _userService.getProfile();
                    });
                  });
                } else if (error is DioFailError) {
                  return const InternalServerErrorHandlerWidget();
                } else {
                  return Center(child: Text("$error"));
                }
              } else {
                return getPageElement(snapshot.data!);
              }
            },
          );
  }
}
