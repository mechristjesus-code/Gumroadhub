import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class LlamaManager {
  // TinyLlama is highly efficient for testing on phones
  final String _modelUrl = 'https://huggingface.co/TinyLlama/TinyLlama-1.1B-Chat-v1.0/resolve/main/TinyLlama-1.1B-Chat-v1.0.Q4_K_M.gguf';
  final Dio _dio = Dio();

  Future<String> get localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<String> get modelFilePath async {
    final path = await localPath;
    return '$path/tinyllama.gguf';
  }

  Future<bool> downloadModel() async {
    final filePath = await modelFilePath;
    if (await File(filePath).exists()) return true;

    try {
      await _dio.download(_modelUrl, filePath);
      return true;
    } catch (e) {
      print('Download failed: $e');
      return false;
    }
  }
}
