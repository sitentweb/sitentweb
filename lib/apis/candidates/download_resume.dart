import 'dart:io';

import 'package:dio/dio.dart';
import 'package:open_file_safe/open_file_safe.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:remark_app/config/constants.dart';

class DownloadResume {
  downloadCandidateResume(resumePath, String resumeName) async {
    var dio = Dio();

    final isPermission = await Permission.storage.request();

    try {
      if (isPermission.isGranted) {
        var saveFile = await getFilePath(resumeName);

        Response response = await dio
            .download("${base_url + resumePath}", saveFile,
                onReceiveProgress: (rcv, total) {
          print(
              'recieived: ${rcv.toStringAsFixed(0)} out of total: ${total.toStringAsFixed(0)}');
          if (rcv == total) {
            print("Download Finished");
          }
        });

        String filePath = saveFile;

        OpenFile.open(filePath);

        print(base_url + resumePath);
        return {"status": true, "message": "Resume Downloaded"};
      } else {
        return {"status": false, "message": "Permission denied"};
      }
    } catch (e) {
      print(e);
      return {"status": false, "message": "Something went wrong"};
    }
  }

  Future<String> getFilePath(uniqueFileName) async {
    String path = '';

    final storagePermission = await Permission.storage.request();

    if (storagePermission.isGranted) {
      Directory dir = await getExternalStorageDirectory();

      // Get Download Path
      var downloadPath = "storage/emulated/0/Remark/resumes";

      path = '/$downloadPath/$uniqueFileName.pdf';
    } else {
      path = "";
    }

    return path;
  }
}
