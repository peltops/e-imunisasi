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
    return CircleAvatar(
      radius: 50.0,
      backgroundColor: isUrlSafe ? Colors.transparent : Colors.white,
      child: Stack(
        children: [
          if (isUrlSafe) ...[
            Align(
              alignment: Alignment.center,
              child: CachedNetworkImage(
                imageUrl: url ?? emptyString,
                placeholder: (context, url) => CircularProgressIndicator.adaptive(),
                errorWidget: (context, url, error) => Icon(Icons.error),
                imageBuilder: (context, imageProvider) => CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.transparent,
                  backgroundImage: imageProvider,
                )
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
