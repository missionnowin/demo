import 'package:child_healthcare/models/view_models/image_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class ImageViewWidget extends StatelessWidget {
  const ImageViewWidget({
        super.key,
        required this.child,
        required this.tag,
        required this.width,
        required this.height, required this.url
  });

  final Widget child;
  final double? width;
  final double? height;
  final String url;
  final String tag;

  @override
  Widget build(BuildContext context) {
    return ImageHero(
      width: width,
      height: height,
      tag: tag,
      onTap: (){
        context.push('/image_view', extra: ImageViewModel(tag, url));
      },
      child: child,
    );
  }
}

class ImageHero extends StatelessWidget{
  final String tag;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final Widget child;

  const ImageHero({super.key, required this.tag, this.onTap, required this.width, required this.height, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Hero(
        tag: tag,
        child: Material(
          color: Colors.transparent,
          child: GestureDetector(
              onTap: onTap,
              behavior: HitTestBehavior.opaque,
              child: child
          ),
        ),
      ),
    );
  }
}
