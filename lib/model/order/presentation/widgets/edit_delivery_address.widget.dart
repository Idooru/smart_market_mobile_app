// import 'package:flutter/cupertino.dart';
// import 'package:provider/provider.dart';
// import 'package:smart_market/model/order/presentation/provider/create_order.provider.dart';
// import 'package:smart_market/model/user/domain/service/user_validate.service.dart';
//
// import '../../../../core/utils/get_it_initializer.dart';
// import '../../../../core/widgets/common/focus_edit.widget.dart';
//
// class EditDeliveryAddressWidget extends StatefulWidget {
//   const EditDeliveryAddressWidget({super.key});
//
//   @override
//   State<EditDeliveryAddressWidget> createState() => EditDeliveryAddressWidgetState();
// }
//
// class EditDeliveryAddressWidgetState extends EditWidgetState<EditDeliveryAddressWidget> {
//   final FocusNode _focusNode = FocusNode();
//   final TextEditingController addressController = TextEditingController();
//   final UserValidateService _userValidateService = locator<UserValidateService>();
//   late CreateOrderProvider _provider;
//   late bool _isValid;
//
//   String _errorMessage = "";
//
//   @override
//   FocusNode get focusNode => _focusNode;
//
//   @override
//   void initState() {
//     super.initState();
//     _provider = context.read<CreateOrderProvider>();
//     _isValid
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }
