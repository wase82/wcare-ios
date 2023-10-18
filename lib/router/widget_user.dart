import 'package:flutter/material.dart';
import 'package:wtoncare/shared/util/color.dart';
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

class BG extends StatelessWidget {
  const BG({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: const AssetImage('assets/images/bg.jpg'),
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.08), BlendMode.dstATop),
            fit: BoxFit.fitHeight),
      ),
    );
  }
}

class CardField extends StatelessWidget {
  final IconData iconData;
  final String title;
  final Widget textField;
  final Widget? validator;
  final TextStyle? titleStyle;

  const CardField(
      {Key? key,
      required this.iconData,
      required this.title,
      required this.textField,
      required this.validator,
      this.titleStyle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle finStyle = titleStyle ??
        const TextStyle(fontWeight: FontWeight.bold, color: cMain);
    return Column(
      children: [
        CardContainer(
          child: Row(
            children: [
              Expanded(
                  flex: 1,
                  child: Center(
                    child: Icon(
                      iconData,
                      color: Colors.black,
                    ),
                  )),
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                        flex: 4,
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          heightFactor: 1,
                          child: Text(
                            title,
                            style: finStyle,
                            textAlign: TextAlign.start,
                          ),
                        )),
                    Expanded(
                      flex: 10,
                      child: Align(
                        child: textField,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        validator ?? const SizedBox(),
      ],
    );
  }
}

class CardContainer extends StatelessWidget {
  final Widget child;

  const CardContainer({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double cardHeight = 70;
    return Card(
      elevation: 8,
      child: SizedBox(height: cardHeight, child: child),
    );
  }
}
