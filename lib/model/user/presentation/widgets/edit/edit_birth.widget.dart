import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smart_market/core/common/input_widget.mixin.dart';
import 'package:smart_market/model/user/presentation/provider/edit_user_column.provider.dart';

class EditBirthWidget extends StatefulWidget {
  const EditBirthWidget({super.key});

  @override
  State<EditBirthWidget> createState() => EditBirthWidgetState();
}

class EditBirthWidgetState extends State<EditBirthWidget> with InputWidget {
  late EditUserColumnProvider _provider;
  late bool _isValid = false;

  String selectedDate = "";

  @override
  void initState() {
    super.initState();
    _provider = context.read<EditUserColumnProvider>();

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
        Titile("생년월일"),
        EditWidget(
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: 15),
              Icon(
                Icons.date_range,
                size: 19,
                color: _isValid ? Colors.green : Colors.red,
              ),
              const SizedBox(width: 15),
              Expanded(
                child: TextButton(
                  onPressed: pressSelectDate,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    alignment: Alignment.centerLeft,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    !_isValid ? "날짜 선택" : selectedDate.toString(),
                    style: const TextStyle(fontSize: 16, color: Color.fromARGB(255, 90, 90, 90)),
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
