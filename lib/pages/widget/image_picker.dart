import 'dart:async';
import 'dart:io';

import 'package:eimunisasi/pages/widget/snackbar_custom.dart';
import 'package:eimunisasi/services/user_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ModalPickerImage {
  uploadFirebase(context, File image,
          FutureOr<dynamic> Function(String) callback) async =>
      await UserService().uploadImage(image).then(callback).catchError(
          (onError) =>
              snackbarCustom('Terjadi kesalahan: $onError').show(context));

  _imgFromCamera(context) async {
    XFile image = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 50);
    if (image != null) {
      File imagePath = File(image.path);
      return imagePath;
    }
    return;
  }

  _imgFromGallery(context) async {
    XFile image = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (image != null) {
      File imagePath = File(image.path);
      return imagePath;
    }
    return;
  }

  void showPicker(context, FutureOr<dynamic> Function(String) callback) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery(context).then((value) {
                          if (value != null) {
                            uploadFirebase(context, value, callback);
                          }
                        });
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera(context).then((value) {
                        if (value != null) {
                          uploadFirebase(context, value, callback);
                        }
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}
