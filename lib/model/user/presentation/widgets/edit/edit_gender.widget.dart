import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_market/core/common/input_widget.mixin.dart';
import 'package:smart_market/core/widgets/common/radio.widget.dart';
import 'package:smart_market/model/user/presentation/provider/edit_user_column.provider.dart';

class EditGenderWidget extends StatefulWidget {
  const EditGenderWidget({super.key});

  @override
  State<EditGenderWidget> createState() => EditGenderWidgetState();
}

class EditGenderWidgetState extends State<EditGenderWidget> with InputWidget {
  late EditUserColumnProvider provider;

  String selectedGender = "male";

  @override
  void initState() {
    super.initState();
    provider = context.read<EditUserColumnProvider>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.setIsGenderValid(true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getTitle("성별"),
        getEditWidget(
          Row(
            children: [
              const SizedBox(width: 15),
              Icon(
                selectedGender == "male" ? Icons.male : Icons.female,
                size: 19,
                color: selectedGender == "male" ? Colors.blue : Colors.pink,
              ),
              Expanded(
                child: RadioGeneratorWidget(
                  args: RadioGenerateArgs(
                    title: "",
                    radioWidgets: [
                      RadioItemWidget(
                        optionTitle: "남성",
                        value: "male",
                        groupValue: selectedGender,
                        selectRadioCallback: (value) {
                          setState(() {
                            selectedGender = value!;
                          });
                        },
                      ),
                      RadioItemWidget(
                        optionTitle: "여성",
                        value: "female",
                        groupValue: selectedGender,
                        selectRadioCallback: (value) {
                          setState(() {
                            selectedGender = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
