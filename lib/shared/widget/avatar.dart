import 'package:flutter/material.dart';
import 'package:wtoncare/router/page_foto_detail.dart';

class AvatarUser extends StatelessWidget {
  final double avatarRadius;
  final String avatarUri;

  const AvatarUser({Key? key, this.avatarRadius = 18, required this.avatarUri})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: avatarRadius,
      child: AspectRatio(
        aspectRatio: 1,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(avatarRadius * 2),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HeroPhotoViewRouteWrapper(
                          imageProvider: NetworkImage(avatarUri))));
            },
            child: Image.network(
              avatarUri,
              fit: BoxFit.fitWidth,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.supervised_user_circle);
              },
            ),
          ),
        ),
      ),
    );
  }
}
