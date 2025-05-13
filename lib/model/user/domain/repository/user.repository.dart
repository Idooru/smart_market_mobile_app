import 'package:smart_market/core/common/data_state.dart';
import 'package:smart_market/model/user/domain/entities/login.entity.dart';

abstract interface class UserRepository {
  Future<DataState<String>> login(RequestLogin args);
  Future<DataState<void>> logout(String accessToken);
}
