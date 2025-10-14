import 'package:flutter/material.dart';
import 'package:smart_market/core/common/network_handler.mixin.dart';
import 'package:smart_market/core/widgets/common/radio.widget.dart';
import 'package:smart_market/model/account/domain/entities/account.entity.dart';

import '../../../../core/widgets/common/init_filter_button_bar.widget.dart';
import '../../common/const/request_accounts.args.dart';

final Map<String, String> _filterMap = {};

class SortAccountsDialog {
  static void show(BuildContext context, {required void Function(RequestAccounts args) updateCallback}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => Dialog(
        child: SortAccountsDialogWidget(
          updateCallback: updateCallback,
        ),
      ),
    );
  }
}

class SortAccountsDialogWidget extends StatefulWidget {
  final void Function(RequestAccounts args) updateCallback;

  const SortAccountsDialogWidget({
    super.key,
    required this.updateCallback,
  });

  @override
  State<SortAccountsDialogWidget> createState() => SortAccountsDialogWidgetState();
}

class SortAccountsDialogWidgetState extends State<SortAccountsDialogWidget> with NetWorkHandler {
  String _selectedAlign = _filterMap["select-align"] ?? "DESC";
  String _selectedColumn = _filterMap["select-column"] ?? "createdAt";

  void initFilterMap() {
    setState(() {
      _selectedAlign = "DESC";
      _selectedColumn = "createdAt";
    });

    RequestAccounts args = RequestAccounts(
      align: _selectedAlign,
      column: _selectedColumn,
    );

    RequestAccountsArgs.setArgs(args);
  }

  void sortAccount() {
    RequestAccounts args = RequestAccounts(
      align: _selectedAlign,
      column: _selectedColumn,
    );

    RequestAccountsArgs.setArgs(args);
    widget.updateCallback(args);

    _filterMap["select-align"] = _selectedAlign;
    _filterMap["select-column"] = _selectedColumn;

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 250,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          const SizedBox(
            height: 50,
            child: Center(
              child: Text(
                "계좌 정렬",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
              child: Column(
                children: [
                  RadioGeneratorWidget(
                    args: RadioGenerateArgs(
                      title: "순서",
                      radioWidgets: [
                        RadioItemWidget(
                          optionTitle: "낮은순",
                          value: "ASC",
                          groupValue: _selectedAlign,
                          selectRadioCallback: (value) {
                            setState(() {
                              _selectedAlign = value!;
                            });
                          },
                        ),
                        RadioItemWidget(
                          optionTitle: "높은순",
                          value: "DESC",
                          groupValue: _selectedAlign,
                          selectRadioCallback: (value) {
                            setState(() {
                              _selectedAlign = value!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  RadioGeneratorWidget(
                    args: RadioGenerateArgs(
                      title: "기준",
                      radioWidgets: [
                        RadioItemWidget(
                          optionTitle: "생성일",
                          value: "createdAt",
                          groupValue: _selectedColumn,
                          selectRadioCallback: (value) {
                            setState(() {
                              _selectedColumn = value!;
                            });
                          },
                        ),
                        RadioItemWidget(
                          optionTitle: "잔액",
                          value: "balance",
                          groupValue: _selectedColumn,
                          selectRadioCallback: (value) {
                            setState(() {
                              _selectedColumn = value!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  InitFilterButtonBarWidget(pressInitFilter: initFilterMap),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  child: const Text(
                    '취소',
                    style: TextStyle(
                      color: Color.fromARGB(255, 70, 70, 70),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                TextButton(
                  onPressed: sortAccount,
                  child: const Text(
                    '찾기',
                    style: TextStyle(
                      color: Color.fromARGB(255, 70, 70, 70),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
