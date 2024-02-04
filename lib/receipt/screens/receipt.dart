import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:resid_saz/constants/utils/random.dart';

class ReceiptScreen extends StatelessWidget {
  const ReceiptScreen({super.key, required this.image});
  final Uint8List image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Builder(builder: (context) {
        return Column(
          children: [
            Image.memory(
              image,
              height: 400,
              width: double.infinity,
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () async {
                if (Platform.isAndroid || Platform.isIOS) {
                  await Permission.manageExternalStorage.request();
                  ImageGallerySaver.saveImage(
                    image,
                    name: '${createRandomID()}.png',
                  );
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('تصویر با موفقیت ذخیره شد.'),
                      ),
                    );
                  }
                } else {
                  final Directory? downloadsDir = await getDownloadsDirectory();
                  if (downloadsDir == null) return;
                  await downloadsDir.create();
                  var f = File('${downloadsDir.path}/${createRandomID()}.png');
                  await f.create();
                  await f.writeAsBytes(image);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('تصویر با موفقیت ذخیره شد.'),
                      ),
                    );
                  }
                }
              },
              icon: const Icon(Icons.image_outlined),
              label: const Text('ذخیره در گالری'),
            ),
          ],
        );
      }),
    );
  }
}
