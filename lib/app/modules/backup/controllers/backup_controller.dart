import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';

import '../../../../generated/locales.g.dart';
import '../../../../main.dart';
import '../../../core/constants/api_url.dart';
import '../../../data/repository/restore_repository.dart';

class BackupController extends GetxController {
  final LocalStorageService _localStorageService =
      Get.find<LocalStorageService>();

  final RestoreRepository _restoreRepository = RestoreRepository();

  String get totalBackupURL => _localStorageService.baseURL + backupURL;

  void restoreBackup() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowedExtensions: ["proto.gz"]);
    if (result != null && result.files.single.path!.endsWith("proto.gz")) {
      File file = File(result.files.single.path!);
      Get.rawSnackbar(
        title: LocaleKeys.backupSettings_restoring_title.tr,
        message: LocaleKeys.backupSettings_restoring_subtitle.tr,
      );

      Response res = await _restoreRepository.postRestore(file);
      if (res.statusCode == null || res.statusCode == 200) {
        Get.rawSnackbar(
          title: LocaleKeys.backupSettings_restored_title.tr,
          message: LocaleKeys.backupSettings_restored_subtitle.tr,
        );
      } else {
        Get.rawSnackbar(
          title: LocaleKeys.error_restoreBackup_title.tr,
          message: LocaleKeys.error_restoreBackup_message.tr,
        );
      }
    } else {
      if (result != null && !result.files.single.path!.endsWith("proto.gz")) {
        Get.rawSnackbar(
          title: LocaleKeys.error_filePickUnknownExtension_title.tr,
          message: LocaleKeys.error_filePickUnknownExtension_message.tr,
        );
      } else {
        Get.rawSnackbar(
          title: LocaleKeys.error_filePick_title.tr,
          message: LocaleKeys.error_filePick_message.tr,
        );
      }
    }
  }
}
