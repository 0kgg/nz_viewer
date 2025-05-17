import 'package:flutter/material.dart';

Future<String?> showFolderNameDialog(BuildContext context) async {
  String folderName = '';

  return showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('フォルダ名を入力'),
        content: TextField(
          autofocus: true,
          decoration: const InputDecoration(hintText: '例：カラオケ'),
          onChanged: (value) {
            folderName = value;
          },
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('キャンセル'),
            onPressed: () {
              Navigator.of(context).pop(); // nullを返す
            },
          ),
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop(folderName); // 入力値を返す
            },
          ),
        ],
      );
    },
  );
}
