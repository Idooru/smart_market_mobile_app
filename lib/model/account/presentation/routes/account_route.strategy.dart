import 'package:flutter/material.dart';
import 'package:smart_market/core/common/route.strategy.dart';
import 'package:smart_market/model/account/presentation/pages/accounts.page.dart';
import 'package:smart_market/model/account/presentation/pages/create_account.page.dart';

final Map<String, RouteStrategy> accountRouteStrategies = {
  "/accounts": AccountsStrategy(),
  '/create_account': CreateAccountStrategy(),
};

class AccountsStrategy implements RouteStrategy {
  @override
  MaterialPageRoute route(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) => const AccountsPage(),
      settings: settings,
    );
  }
}

class CreateAccountStrategy implements RouteStrategy {
  @override
  MaterialPageRoute route(RouteSettings settings) {
    final args = settings.arguments as CreateAccountPageArgs;
    return MaterialPageRoute(
      builder: (context) => CreateAccountPage(
        isAccountsEmpty: args.isAccountsEmpty,
      ),
      settings: settings,
    );
  }
}
