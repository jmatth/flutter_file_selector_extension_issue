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
  final List<String> _extensions = [];

  @override
  dispose() {
    _extensionController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final file = await openFile(
      acceptedTypeGroups: [
        XTypeGroup(
          extensions: _extensions,
          // uniformTypeIdentifiers: extensions,
        ),
      ],
    );
    if (file == null) return;
    setState(() {
      _path = file.path;
    });
  }

  final _splitPattern = RegExp(r'(\s|,)');
  void _addExtensions(String extensionsStr) {
    _extensionController.value = TextEditingValue.empty;
    final extensions = extensionsStr
        .split(_splitPattern)
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .where((s) => !_extensions.contains(s))
        .toList();
    if (extensions.isEmpty) return;
    setState(() {
      _extensions.addAll(extensions);
    });
  }

  void _removeExtension(String extension) {
    setState(() {
      _extensions.remove(extension);
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
          Wrap(
            direction: Axis.horizontal,
            runSpacing: 10,
            spacing: 5,
            children: _extensionChips(context),
          ),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: TextField(
                controller: _extensionController,
                maxLines: 1,
                onSubmitted: _addExtensions,
                textInputAction: TextInputAction.none,
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

  List<Widget> _extensionChips(BuildContext context) => _extensions
      .map((e) => InputChip(
            key: ValueKey(e),
            label: Text(e),
            onDeleted: () => _removeExtension(e),
          ))
      .toList();
}
