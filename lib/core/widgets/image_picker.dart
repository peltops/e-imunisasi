import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class ModalPickerImage {
  static ImagePicker _imagePicker = ImagePicker();

  static Future<File?> _imgFromCamera(context) async {
    XFile? image = await _imagePicker.pickImage(source: ImageSource.camera);
    if (image != null) {
      File imagePath = File(image.path);
      return imagePath;
    }
    return null;
  }

  static Future<File?> _imgFromGallery(context) async {
    XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    if (image != null) {
      File imagePath = File(image.path);
      return imagePath;
    }
    return null;
  }

  static void showPicker(BuildContext context, Function(File) callback) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: Icon(Icons.photo_library),
                    title: Text('Photo Library'),
                    onTap: () async {
                      final file = await _imgFromGallery(context);
                      if (file != null) {
                        callback(file);
                      }
                      context.pop();
                    }),
                ListTile(
                  leading: Icon(Icons.photo_camera),
                  title: Text('Camera'),
                  onTap: () async {
                    final file = await _imgFromCamera(context);
                    if (file != null) {
                      callback(file);
                    }
                    context.pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
