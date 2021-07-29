import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:remark_app/config/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class DownloadResume {

  downloadCandidateResume(resume) async {

    var dio = Dio();

    try{


          var saveFile = await  getFilePath("hello");

          Response response = await dio.download("${base_url+resume}", saveFile , onReceiveProgress: (rcv , total) {
            print('recieived: ${rcv.toStringAsFixed(0)} out of total: ${total
                .toStringAsFixed(0)}');
            if (rcv == total) {
              print("Download Finished");
            }
          });

            final filepath = "/storage/emulated/0/Downloads/hello.pdf";
            await canLaunch(filepath) ? launch(filepath) : print(
                "$filepath not launched");

            print(response.headers);

    }catch(e){
      print(e);
    }

  }

  Future<String> getFilePath(uniqueFileName) async {
    String path = '';

    Directory dir = await getExternalStorageDirectory();

    // Get Download Path
    var downloadPath = "storage/emulated/0/Remark/resumes";

    path = '/$downloadPath/$uniqueFileName.pdf';

    return path;
  }

}