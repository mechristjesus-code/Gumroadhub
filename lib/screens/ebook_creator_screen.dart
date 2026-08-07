import 'package:flutter/material.dart';
import '../services/word_genie_service.dart';

class EbookCreatorScreen extends StatefulWidget {
  const EbookCreatorScreen({super.key});

  @override
  State<EbookCreatorScreen> createState() => _EbookCreatorScreenState();
}

class _EbookCreatorScreenState extends State<EbookCreatorScreen> {
  final _contentController = TextEditingController();
  final _wordGenie = WordGenie();
  String _aiSuggestion = '';
  String _selectedFormat = 'Standard';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('E-book Creator (Powered by WordGenie)')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<String>(
              value: _selectedFormat,
              items: ['Standard', 'Kindle'].map((f) => DropdownMenuItem(value: f, child: Text(f))).toList(),
              onChanged: (val) => setState(() => _selectedFormat = val!),
            ),
            Expanded(
              child: TextField(
                controller: _contentController,
                maxLines: null,
                decoration: const InputDecoration(hintText: 'Start writing...'),
              ),
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final enhanced = await _wordGenie.enhanceText(_contentController.text);
                    _contentController.text = enhanced;
                  },
                  child: const Text('WordGenie Enhance'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () async {
                    final suggestion = await _wordGenie.getWritingSuggestion(_contentController.text);
                    setState(() => _aiSuggestion = suggestion);
                  },
                  child: const Text('WordGenie Suggest'),
                ),
              ],
            ),
            if (_aiSuggestion.isNotEmpty) Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(_aiSuggestion, style: const TextStyle(fontStyle: FontStyle.italic)),
            ),
          ],
        ),
      ),
    );
  }
}
