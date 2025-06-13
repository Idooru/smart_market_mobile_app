import 'package:flutter/material.dart';
import 'package:smart_market/core/themes/theme_data.dart';
import 'package:smart_market/core/utils/format_number.dart';

import '../../../product/presentation/pages/detail_product.page.dart';
import '../../../review/presentation/pages/create_review.page.dart';
import '../../domain/entities/order.entity.dart';

class PaymentItemWidget extends StatelessWidget {
  final Payment payment;
  final bool hasPlusIcon;

  const PaymentItemWidget({
    super.key,
    required this.payment,
    required this.hasPlusIcon,
  });

  void pressTrailingIcon(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color.fromARGB(255, 245, 245, 245),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed(
                    "/detail_product",
                    arguments: DetailProductPageArgs(productId: payment.product.id),
                  );
                },
                child: const ListTile(
                  leading: Icon(Icons.open_in_new),
                  title: Text("상품 상세 보기"),
                ),
              ),
              GestureDetector(
                onTap: () {
                  List<ProductIdentify> products = [
                    ProductIdentify(
                      id: payment.product.id,
                      name: payment.product.name,
                    )
                  ];

                  Navigator.of(context).pushNamed(
                    "/create_review",
                    arguments: CreateReviewPageArgs(
                      isCreateCart: false,
                      updateCallback: () {},
                      products: products,
                      backRoute: "/display_payment",
                    ),
                  );
                },
                child: const ListTile(
                  leading: Icon(Icons.reviews),
                  title: Text("리뷰 작성 하기"),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => pressTrailingIcon(context),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: commonContainerDecoration,
            child: Stack(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  margin: const EdgeInsets.all(10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      payment.product.imageUrls[0],
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 100,
                  child: SizedBox(
                    height: 80,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: SizedBox(
                            width: 160,
                            child: Text(
                              payment.product.name,
                              style: const TextStyle(
                                fontSize: 22,
                                color: Color.fromARGB(255, 50, 50, 50),
                                overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 140,
                          child: Text(
                            "합계: ${formatNumber(payment.totalPrice)}원",
                            style: const TextStyle(
                              fontSize: 17,
                              color: Colors.black,
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 188,
                          child: Row(
                            children: [
                              SizedBox(
                                child: Text(
                                  "${formatNumber(payment.product.price)}원",
                                  style: const TextStyle(
                                    // fontSize: 16,
                                    color: Color.fromARGB(255, 100, 100, 100),
                                    overflow: TextOverflow.ellipsis,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 2),
                                child: Icon(
                                  Icons.close,
                                  size: 15,
                                  color: Color.fromARGB(255, 100, 100, 100),
                                ),
                              ),
                              Text(
                                "수량: ${payment.quantity}",
                                style: const TextStyle(
                                  // fontSize: 14,
                                  color: Color.fromARGB(255, 100, 100, 100),
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: -5,
                  right: -5,
                  child: IconButton(
                    constraints: const BoxConstraints(), // 크기 최소화
                    icon: const Icon(Icons.more_vert, size: 18),
                    onPressed: () => pressTrailingIcon(context),
                  ),
                ),
              ],
            ),
          ),
          hasPlusIcon
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: Icon(Icons.add_circle),
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
