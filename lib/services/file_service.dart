import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

class FileService {
  static final FileService _fileService = FileService._internal();

  factory FileService() {
    return _fileService;
  }

  FileService._internal();

  ValueNotifier<bool> notifier = ValueNotifier(false);

  void openFile(String assetPath, String tempPath) async {
    final ByteData assetData = await rootBundle.load(assetPath);
    final tempDir = await getTemporaryDirectory();
    final tempFilePath = '${tempDir.path}/$tempPath';
    final tempFile = File(tempFilePath);
    await tempFile.writeAsBytes(assetData.buffer.asUint8List(assetData.offsetInBytes, assetData.lengthInBytes));
    await OpenFilex.open(tempFilePath);
  }

  void openExpansionInstructions(String expansionId) {
    final assetPath = 'assets/instructions/$expansionId.pdf';
    final tempPath = '$expansionId.pdf';
    openFile(assetPath, tempPath);
  }
}
