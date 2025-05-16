import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smart_market/model/user/common/mixin/edit_widget.mixin.dart';
import 'package:smart_market/model/user/presentation/state/edit_profile.provider.dart';

class EditBirthWidget extends StatefulWidget {
  const EditBirthWidget({super.key});

  @override
  State<EditBirthWidget> createState() => EditBirthWidgetState();
}

class EditBirthWidgetState extends State<EditBirthWidget> with EditWidget {
  late EditProfileProvider _provider;
  late bool _isValid = false;

  String selectedDate = "";

  @override
  void initState() {
    super.initState();
    _provider = context.read<EditProfileProvider>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _provider.setIsBirthValid(_isValid);
    });
  }

  Future<void> pressSelectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1960),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        selectedDate = DateFormat('yyyy-MM-dd').format(picked);
        _isValid = true;
      });

      _provider.setIsBirthValid(_isValid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getTitle("생년월일"),
        getEditWidget(
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: 15),
              Icon(
                Icons.date_range,
                size: 19,
                color: _isValid ? Colors.green : Colors.red,
              ),
              Expanded(
                child: TextButton(
                  onPressed: pressSelectDate,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    !_isValid ? "날짜 선택" : selectedDate.toString(),
                    style: const TextStyle(color: Colors.black),
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
