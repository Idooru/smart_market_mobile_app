import 'package:smart_market/model/user/domain/entities/login.entity.dart';

class RequestResetPassword extends RequestLogin {
  const RequestResetPassword({required super.email, required super.password});
}
