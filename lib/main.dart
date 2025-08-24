import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'NZ_viewer'),
    );
  }
}

Future<void> savePhotoToFolder(BuildContext context, String folderName) async {
  // ここで写真を選択して保存する処理を実装
  // 例: 画像ピッカーを使って写真を選択し、保存先フォルダ名を使って保存
  // 実際の保存処理はプラグインやストレージAPIに応じて実装してください
  ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text('「$folderName」に写真を保存しました（ダミー処理）')));
}

Future<String?> showFolderNameDialog(BuildContext context) async {
  String? folderName;
  return showDialog<String>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('フォルダ名を入力'),
        content: TextField(
          autofocus: true,
          onChanged: (value) {
            folderName = value;
          },
          decoration: const InputDecoration(hintText: 'フォルダ名'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(folderName),
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}

// フォルダ名編集用のダイアログ
Future<String?> showEditFolderNameDialog(
  BuildContext context,
  String currentName,
) async {
  String? folderName = currentName;
  return showDialog<String>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('フォルダ名を編集'),
        content: TextField(
          autofocus: true,
          controller: TextEditingController(text: currentName),
          onChanged: (value) {
            folderName = value;
          },
          decoration: const InputDecoration(hintText: 'フォルダ名'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(folderName),
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}

// フォルダ詳細ページ
class FolderPage extends StatelessWidget {
  final String folderName;
  const FolderPage({super.key, required this.folderName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(folderName)),
      body: Center(child: Text('「$folderName」のページ')),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? folderName;
  List<String?> folderNames = List.filled(9, null);

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(6.0),
        child: GridView.count(
          crossAxisCount: 3,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,

          children: List.generate(9, (index) {
            return Column(
              mainAxisSize: MainAxisSize.min,

              children: [
                GestureDetector(
                  onTap: () async {
                    if (folderNames[index] != null) {
                      // フォルダ名がある場合は詳細ページへ遷移
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  FolderPage(folderName: folderNames[index]!),
                        ),
                      );
                    } else {
                      // フォルダ名がない場合は名前入力ダイアログを表示
                      final name = await showFolderNameDialog(context);
                      if (name != null && name.isNotEmpty) {
                        setState(() {
                          folderNames[index] = name;
                        });
                      }
                    }
                  },
                  onLongPress: () async {
                    // 既存のフォルダがある場合のみ長押しで編集可能
                    if (folderNames[index] != null) {
                      final newName = await showEditFolderNameDialog(
                        context,
                        folderNames[index]!,
                      );
                      if (newName != null && newName.isNotEmpty) {
                        setState(() {
                          folderNames[index] = newName;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('フォルダ名を「$newName」に変更しました')),
                        );
                      }
                    }
                  },
                  child: IconButton(
                    icon: Icon(
                      folderNames[index] != null
                          ? Icons.photo_album
                          : Icons.add,
                    ),
                    color:
                        folderNames[index] != null ? Colors.blue : Colors.black,
                    iconSize: 80,
                    onPressed: null, // GestureDetectorで処理するため無効化
                  ),
                ),
                SizedBox(height: 4),
                Text(folderNames[index] ?? '空'),
              ],
            );
          }),
        ),
      ),

      /*floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final name = await showFolderNameDialog(context);
          if (name != null && name.isNotEmpty) {
            setState(() {
              folderName = name;
              folder_num++;
            });
          }
        },
        tooltip: 'create foleder',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
      */
    );
  }
}
