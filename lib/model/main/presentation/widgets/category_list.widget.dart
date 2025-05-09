import 'package:flutter/material.dart';
import 'package:smart_market/model/main/presentation/widgets/category_item.widget.dart';

class CategoryListWidget extends StatelessWidget {
  const CategoryListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: double.infinity,
      height: 120,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "상품 카테고리",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                CategoryItemWidget(
                  title: "가전제품",
                  margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                  icon: Icon(Icons.tv),
                ),
                CategoryItemWidget(
                  title: "애완동물",
                  margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                  icon: Icon(Icons.pets),
                ),
                CategoryItemWidget(
                  title: "음식",
                  margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                  icon: Icon(Icons.food_bank),
                ),
                CategoryItemWidget(
                  title: "의류",
                  margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                  icon: Icon(Icons.checkroom),
                ),
                CategoryItemWidget(
                  title: "건강",
                  margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                  icon: Icon(Icons.sports_cricket),
                ),
                CategoryItemWidget(
                  title: "생활용품",
                  margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                  icon: Icon(Icons.cleaning_services),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
