import 'package:auto_size_text/auto_size_text.dart';
import 'package:child_healthcare/models/api_models/api_article.dart';
import 'package:child_healthcare/ui/decorations/theme.dart';
import 'package:child_healthcare/ui/widgets/home_page_widgets/article/article_blocks.dart';
import 'package:flutter/material.dart';

class ArticleWidget extends StatelessWidget{
  final ApiArticle article;

  const ArticleWidget({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          const SizedBox(height: 10,),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16)
                ),
                color: Colors.white
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ArticleHeaderWidget(articleHeader: article.hero, title: article.title ?? ''),
                for(int i = 0; i < article.layout.length; i++)...[
                  ArticleBlock(
                      articleBlock: article.layout[i]
                  )
                ],
                const SizedBox(height: 16,),
              ],
            ),
          )
        ],
      );
  }
}

class ArticleHeaderWidget extends StatelessWidget{
  final ArticleHeader articleHeader;
  final String title;

  const ArticleHeaderWidget({super.key, required this.articleHeader, required this.title});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AutoSizeText(title,
          maxLines: null,
          style: getTextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16,),
        MediaBlock(mediaBlock: articleHeader.media),
        //const SizedBox(height: 16,),
        //RichTextParentWidget(richText: articleHeader.richText, fontSize: 14,)
      ],
    );
  }
}
