import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:dominion_comanion/database/model/deck/deck_db_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

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
    await tempFile.writeAsBytes(assetData.buffer
        .asUint8List(assetData.offsetInBytes, assetData.lengthInBytes));
    await OpenFilex.open(tempFilePath);
  }

  void openExpansionInstructions(String expansionId) {
    final assetPath = 'assets/instructions/$expansionId.pdf';
    final tempPath = '$expansionId.pdf';
    openFile(assetPath, tempPath);
  }

  void shareTemporaryJSONFile(String name, String content) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/$name.json';
    final file = File(path);
    file.writeAsString(content);
    Share.shareXFiles([XFile(path)], text: 'Meine Dominion Decks');
  }

  Future<File?> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );
    File? file;
    if (result != null && result.files.isNotEmpty) {
      var pickedFile = result.files.single;
      var extension = pickedFile.name.split('.').last.toLowerCase();
      if (extension == 'json' && pickedFile.path != null) {
        file = File(pickedFile.path!);
      }
    }
    return file;
  }
}