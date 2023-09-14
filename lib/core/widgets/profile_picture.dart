import 'package:cached_network_image/cached_network_image.dart';
import 'package:eimunisasi/core/extension.dart';
import 'package:flutter/material.dart';

class ProfilePictureFromUrl extends StatelessWidget {
  final String? url;
  final VoidCallback? onPressedCamera;

  const ProfilePictureFromUrl({Key? key, this.url, this.onPressedCamera})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isUrlSafe = Uri.tryParse(url ?? emptyString)?.isAbsolute ?? false;
    const placeholder =
        'https://i.pinimg.com/originals/d2/4d/db/d24ddb8271b8ea9b4bbf4b67df8cbc01.gif';
    return CircleAvatar(
      radius: 50.0,
      backgroundColor: isUrlSafe ? Colors.transparent : Colors.white,
      backgroundImage: isUrlSafe
          ? CachedNetworkImageProvider(placeholder, scale: 0.1)
          : null,
      child: Stack(
        children: [
          if (isUrlSafe) ...[
            Align(
              alignment: Alignment.center,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.transparent,
                backgroundImage:
                    CachedNetworkImageProvider(url ?? emptyString, scale: 0.1),
              ),
            ),
          ],
          if (!isUrlSafe) ...[
            Align(
              alignment: Alignment.center,
              child: Icon(
                Icons.photo_outlined,
                size: 50,
                color: Colors.grey,
              ),
            ),
          ],
          Align(
            alignment: Alignment.bottomRight,
            child: CircleAvatar(
              radius: 15,
              child: IconButton(
                alignment: Alignment.center,
                icon: Icon(
                  Icons.photo_camera,
                  size: 15.0,
                ),
                onPressed: onPressedCamera,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
