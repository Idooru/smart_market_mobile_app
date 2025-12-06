import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:smart_market/model/account/presentation/provider/create_account.provider.dart';
import 'package:smart_market/model/media/presentation/provider/review_image.provider.dart';
import 'package:smart_market/model/media/presentation/provider/review_video.provider.dart';
import 'package:smart_market/model/order/presentation/provider/after_create_order.provider.dart';
import 'package:smart_market/model/order/presentation/provider/create_order.provider.dart';
import 'package:smart_market/model/product/presentation/provider/product_filtered.provider.dart';
import 'package:smart_market/model/product/presentation/provider/product_search.provider.dart';
import 'package:smart_market/model/review/presentation/provider/edit_review.provider.dart';
import 'package:smart_market/model/user/presentation/provider/edit_user_column.provider.dart';

List<SingleChildWidget> initProvider() {
  return [
    ChangeNotifierProvider(create: (context) => ProductFilteredProvider()),
    ChangeNotifierProvider(create: (context) => ProductSearchProvider()),
    ChangeNotifierProvider(create: (context) => EditUserColumnProvider()),
    ChangeNotifierProvider(create: (context) => CreateAccountProvider()),
    ChangeNotifierProvider(create: (context) => CreateOrderProvider()),
    ChangeNotifierProvider(create: (context) => CompleteCreateOrderProvider()),
    ChangeNotifierProvider(create: (context) => EditReviewProvider()),
    ChangeNotifierProvider(create: (context) => ReviewImageProvider()),
    ChangeNotifierProvider(create: (context) => ReviewVideoProvider()),
  ];
}
