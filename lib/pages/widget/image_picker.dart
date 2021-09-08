import 'dart:io';

import 'package:eimunisasi/pages/widget/snackbar_custom.dart';
import 'package:eimunisasi/services/user_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ModalPickerImage {
  uploadFirebase(context, File image) async => await UserService()
      .uploadImage(image)
      .then((value) => UserService().updateUserAvatar(value))
      .catchError((onError) =>
          snackbarCustom('Terjadi kesalahan: $onError').show(context));

  _imgFromCamera(context) async {
    XFile image = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 50);
    File imagePath = File(image.path);
    return uploadFirebase(context, imagePath);
  }

  _imgFromGallery(context) async {
    XFile image = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 50);
    File imagePath = File(image.path);
    return uploadFirebase(context, imagePath);
  }

  void showPicker(context) {
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
                        _imgFromGallery(context);
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera(context);
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
