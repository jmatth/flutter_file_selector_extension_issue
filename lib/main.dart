import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';

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
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter file picker test'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? _path;
  final _extensionController = TextEditingController();

  @override
  dispose() {
    _extensionController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final extensions =
        _extensionController.text.split(',').map((s) => s.trim()).toList();
    debugPrint('Extensions: $extensions');
    final file = await openFile(
      acceptedTypeGroups: [
        XTypeGroup(extensions: extensions),
      ],
    );
    if (file == null) return;
    setState(() {
      _path = file.path;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: TextField(
                controller: _extensionController,
                maxLines: 1,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(_path ?? '<No file selected>'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickFile,
        tooltip: 'Select file',
        child: const Icon(Icons.folder_open),
      ),
    );
  }
}
