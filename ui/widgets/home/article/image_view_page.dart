import 'package:cached_network_image/cached_network_image.dart';
import 'package:child_healthcare/ui/widgets/auth_page_widgets/auth_pages_appbar.dart';
import 'package:child_healthcare/ui/widgets/home_page_widgets/article/image_view_widget.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewPage extends StatelessWidget{
  final String url;
  final String tag;
  const ImageViewPage({super.key, required this.url, required this.tag});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: nonRootAppBar(context, backgroundColor: Colors.transparent.withOpacity(0.2)),
        body: ImageHero(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            tag: tag,
            child: PhotoView(
              backgroundDecoration: const BoxDecoration(
                  color: Colors.white
              ),
              imageProvider: CachedNetworkImageProvider(url),
              minScale: 0.05,
              maxScale: 10.0,
            )
        )
    );
  }
}