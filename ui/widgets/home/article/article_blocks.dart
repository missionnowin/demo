import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:child_healthcare/models/api_models/api_article.dart';
import 'package:child_healthcare/ui/decorations/theme.dart';
import 'package:child_healthcare/ui/widgets/home_page_widgets/article/custom_text_widgets.dart';
import 'package:child_healthcare/ui/widgets/home_page_widgets/article/image_view_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:child_healthcare/utils/article_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

class ArticleBlock extends StatelessWidget{
  final dynamic articleBlock;

  const ArticleBlock({super.key, required this.articleBlock});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 25),
      child: Builder(
        builder: (context){
          switch (articleBlock['blockType']){
            case 'information':
              return InformationBlock(
                  informationBlock: InformationElement.fromJson(articleBlock)
              );
            case 'content':
              return ContentBlock(
                  contentBlock: ContentColumns.fromJson(articleBlock)
              );
            case 'mediaBlock':
              return MediaBlock(
                  mediaBlock: MediaContent.fromJson(articleBlock['media'])
              );
            case 'link':
              return LinkWidget(
                linkBlock: LinkBlock.fromJson(articleBlock),
              );
            default:
              return Container();
          }
        },
      ),
    );
  }
}

class LinkWidget extends StatelessWidget{
  final LinkBlock linkBlock;

  const LinkWidget({super.key, required this.linkBlock});

  @override
  Widget build(BuildContext context) {
    return AutoSizeText.rich(
      TextSpan(
        children: [
          TextSpan(text: 'Источник: ',
            style: getTextStyle()
          ),
          TextSpan(text: linkBlock.link,
            style: getTextStyle(
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()..onTap = () async {
              await launchUrl(
                  Uri.parse(linkBlock.link ?? '')
              );
            }
          )
        ]
      )
    );
  }
}


class InformationBlock extends StatelessWidget{
  final InformationElement informationBlock;

  const InformationBlock({super.key, required this.informationBlock});

  @override
  Widget build(BuildContext context) {
    if(informationBlock.blockColor != null){
      return Container(
        padding: const EdgeInsets.only(
            right: 11,
            left: 15,
            top: 10,
            bottom: 13
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: getBlockColor(informationBlock.blockColor),
        ),
        child: RichTextParentWidget(
          richText: informationBlock.richText,
          color: informationBlock.blockColor == 'pinky' ? Colors.white : null,
        ),
      );
    }
    return RichTextParentWidget(richText: informationBlock.richText);
  }
}


class ContentBlock extends StatelessWidget{
  final ContentColumns contentBlock;

  const ContentBlock({super.key, required this.contentBlock});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for(int i = 0; i < contentBlock.columns.length; i += 2)...[
          if(contentBlock.columns[i].size == 'half')
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    margin: i > 0 ? const EdgeInsets.only(right: 16, top: 25) : const EdgeInsets.only(right: 16),
                    width: (MediaQuery.of(context).size.width - 32 - 16) / 2,
                    child: RichTextParentWidget(richText: contentBlock.columns[i].richText,)
                ),
                i + 1 < contentBlock.columns.length && contentBlock.columns[i + 1].size == 'half' ? SizedBox(
                    width: (MediaQuery.of(context).size.width - 32 - 16) / 2,
                    child: RichTextParentWidget(richText: contentBlock.columns[i + 1].richText,)
                ) : Container(),
              ],
            ),
          if(contentBlock.columns[i].size != 'half')
            Container(
              margin: i > 0 ? const EdgeInsets.only(top: 25) : null,
              child: RichTextParentWidget(richText: contentBlock.columns[i].richText),
            ),

          if(i + 1 < contentBlock.columns.length)...[
            if(contentBlock.columns[i + 1].size != 'half')
              Container(
                margin: const EdgeInsets.only(top: 25),
                child:RichTextParentWidget(richText: contentBlock.columns[i + 1].richText),
              ),
            if(contentBlock.columns[i].size != 'half' && contentBlock.columns[i + 1].size == 'half')
              Container(
                  margin: const EdgeInsets.only(top: 25),
                  width: (MediaQuery.of(context).size.width - 32 - 16) / 2,
                  child: RichTextParentWidget(richText: contentBlock.columns[i + 1].richText,)
              ),
          ]
        ]
      ],
    );
  }
}


class MediaBlock extends StatelessWidget{
  final MediaContent mediaBlock;

  const MediaBlock({super.key, required this.mediaBlock});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context){
        if(mediaBlock.mimeType == null || mediaBlock.mimeType!.contains('image')){
          return ImageBlock(
            url: mediaBlock.url ?? '',
            width: MediaQuery.of(context).size.width - 32,
          );
        } else{
          return Container();
        }
      },
    );
  }
}

class ImageBlock extends StatelessWidget{
  final String url;
  final double? height;
  final double? width;

  const ImageBlock({super.key, required this.url, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return ImageViewWidget(
      width: width,
      height: height,
      tag: const Uuid().v1(),
      url: url,
      child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(
            width: width,
            height: height,
            child: CachedNetworkImage(
                memCacheWidth: width != null ? ((width! * 2).toInt()) : null,
                memCacheHeight: height != null ? ((height! * 2).toInt()) : null,
                fit: BoxFit.contain,
                imageUrl: url,
                placeholder: (context, message) =>
                    Container(
                      width: width,
                      height: height ?? (width ?? 0) / 2,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      )
                    )
            ),
          )
      ),
    );
  }
}

