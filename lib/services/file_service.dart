import 'dart:io';
import 'dart:math';

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

  String? backgroundImagePath;

  String? backgroundImageName;

  Alignment boxArtAlignment = Alignment.center;

  final boxartList = [
    "abenteuer_v1",
    "alchemisten_v1",
    "basisspiel_v1",
    "basisspiel_v2",
    "bluetezeit_v1",
    "bluetezeit_v2",
    "dark_ages_v1",
    "empires_v2",
    "gilden_v1",
    "hinterland_v1",
    "hinterland_v2",
    "intrige_v1",
    "intrige_v2",
    "menagerie_v1",
    "nocturne_v1",
    "pluenderer_v1",
    "reiche_ernte_v1",
    "renaissance_v1",
    "seaside_v1",
    "seaside_v2",
    "verbuendete_v1",
  ];

  Map<String, Alignment> boxArtAlignmentMap = {
    "abenteuer_v1": Alignment.centerRight,
    "alchemisten_v1": Alignment.lerp(Alignment.centerLeft, Alignment.centerRight, 0.6) ?? Alignment.center,
    "basisspiel_v1": Alignment.centerRight,
    "basisspiel_v2": Alignment.centerLeft,
    "bluetezeit_v1": Alignment.center,
    "bluetezeit_v2": Alignment.lerp(Alignment.centerLeft, Alignment.centerRight, 0.2) ?? Alignment.center,
    "dark_ages_v1": Alignment.centerRight,
    "empires_v2": Alignment.center,
    "gilden_v1": Alignment.lerp(Alignment.centerLeft, Alignment.centerRight, 0.1) ?? Alignment.center,
    "hinterland_v1": Alignment.lerp(Alignment.centerLeft, Alignment.centerRight, 0.48) ?? Alignment.center,
    "hinterland_v2": Alignment.centerLeft,
    "intrige_v1": Alignment.lerp(Alignment.topLeft, Alignment.topRight, 0.8) ?? Alignment.center,
    "intrige_v2": Alignment.center,
    "menagerie_v1": Alignment.lerp(Alignment.centerLeft, Alignment.centerRight, 0.16) ?? Alignment.center,
    "nocturne_v1": Alignment.center,
    "pluenderer_v1": Alignment.lerp(Alignment.centerLeft, Alignment.centerRight, 0.4) ?? Alignment.center,
    "reiche_ernte_v1": Alignment.center,
    "renaissance_v1": Alignment.center,
    "seaside_v1": Alignment.center,
    "seaside_v2": Alignment.center,
    "verbuendete_v1": Alignment.lerp(Alignment.centerLeft, Alignment.centerRight, 0.75) ?? Alignment.center,
  };

  void initialize() {
    initializeBackgroundImagePath();
    initializeBoxArtAlignment();
  }

  void initializeBackgroundImagePath() {
    /*backgroundImageName = boxartList[Random().nextInt(boxartList.length)];*/
    backgroundImageName = "verbuendete_v1";
    backgroundImagePath = "assets/artwork/boxart/$backgroundImageName.jpg";
  }

  void initializeBoxArtAlignment() {
    if (boxArtAlignmentMap.containsKey(backgroundImageName!)) {
      boxArtAlignment = boxArtAlignmentMap[backgroundImageName]!;
    } else {
      boxArtAlignment = Alignment.center;
    }
  }

  Future<File> getTempFile(String assetPath, String tempPath) async {
    final tempDir = await getTemporaryDirectory();
    final tempFilePath = '${tempDir.path}/$tempPath';
    return File(tempFilePath);
  }

  void openFile(String assetPath, String tempPath) async {
    final ByteData assetData = await rootBundle.load(assetPath);
    final tempDir = await getTemporaryDirectory();
    final tempFilePath = '${tempDir.path}/$tempPath';
    final tempFile = File(tempFilePath);
    await tempFile.writeAsBytes(assetData.buffer
        .asUint8List(assetData.offsetInBytes, assetData.lengthInBytes));
    await OpenFilex.open(tempFilePath);
  }

  Future<bool> checkForExpansionsInstructions(String expansionId) async {
    final assetPath = 'assets/instructions/$expansionId.pdf';
    try {
      await rootBundle.load(assetPath);
      return true;
    } catch (_) {
      return false;
    }
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
    await file.writeAsString(content);
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
