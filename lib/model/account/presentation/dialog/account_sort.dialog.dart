import 'package:flutter/material.dart';
import 'package:smart_market/core/common/network_handler.mixin.dart';
import 'package:smart_market/core/widgets/common/radio.widget.dart';
import 'package:smart_market/model/account/domain/entities/account.entity.dart';

final Map<String, String> _filterMap = {};

class AccountSortDialog {
  static void show(BuildContext context, {required void Function(RequestAccounts args) updateCallback}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => Dialog(
        child: AccountSortDialogWidget(
          updateCallback: updateCallback,
        ),
      ),
    );
  }
}

class AccountSortDialogWidget extends StatefulWidget {
  final void Function(RequestAccounts args) updateCallback;

  const AccountSortDialogWidget({
    super.key,
    required this.updateCallback,
  });

  @override
  State<AccountSortDialogWidget> createState() => AccountSortDialogWidgetState();
}

class AccountSortDialogWidgetState extends State<AccountSortDialogWidget> with NetWorkHandler {
  String _selectedAlign = _filterMap["select-align"] ?? "DESC";
  String _selectedColumn = _filterMap["select-column"] ?? "createdAt";

  void initFilterMap() {
    setState(() {
      _selectedAlign = "DESC";
      _selectedColumn = "createdAt";
    });
  }

  void sortAccount() {
    RequestAccounts args = RequestAccounts(
      align: _selectedAlign,
      column: _selectedColumn,
    );

    widget.updateCallback(args);

    _filterMap["select-align"] = _selectedAlign;
    _filterMap["select-column"] = _selectedColumn;

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 240,
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
                  GestureDetector(
                    onTap: initFilterMap,
                    child: Container(
                      width: 200,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 180, 180, 180),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          "필터링 초기화",
                          style: TextStyle(
                            color: Color.fromARGB(255, 70, 70, 70),
                          ),
                        ),
                      ),
                    ),
                  ),
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
