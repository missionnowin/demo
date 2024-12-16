import 'package:child_healthcare/models/api_models/api_article.dart';
import 'package:child_healthcare/ui/widgets/home_page_widgets/article/custom_rich_text.dart';
import 'package:child_healthcare/utils/article_utils.dart';
import 'package:flutter/material.dart';

class RichTextParentWidget extends StatelessWidget{
  final List<RichTextElement> richText;
  final Color? color;

  const RichTextParentWidget({super.key, required this.richText, this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for(int i = 0; i < richText.length; i++)...[
          Container(
            margin: i > 0 ? const EdgeInsets.only(top: 25) : null,
            padding: getPadding(richText[i].type),
            child: Builder(
                builder: (context){
                  RichTextElement richTextElement = richText[i];
                  /*
                    if(richTextElement.type == 'blockquote'){
                      return Container(
                        margin: const EdgeInsets.only(top: 12),
                        padding: const EdgeInsets.only(left: 12),
                        decoration: const BoxDecoration(
                            border: BorderDirectional(start: BorderSide(color: Colors.black))
                        ),
                        child: RichTextWidget(
                          richText: richTextElement,
                          color: color,
                        ),
                      );
                    }

                     */
                  if(isList(richTextElement.type)){
                    return TextListWidget(
                        richText: richTextElement.children ?? [],
                        color: color,
                        iconType: richTextElement.type
                    );
                  }
                  return RichTextWidget(
                    richText: richTextElement,
                    color: color,
                  );
                }
            ),
          )
        ]
      ],
    );
  }
}


class TextListWidget extends StatelessWidget{
  final List<RichTextElement> richText;
  final String? iconType;
  final Color? color;
  const TextListWidget({super.key, required this.richText, required this.iconType, this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for(int i = 0; i < richText.length; i++)...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListIcon(type: iconType, index: i,),
              Expanded(
                child: RichTextWidget(
                  richText: richText[i],
                  color: color,
                ),
              )
            ],
          ),
          i < richText.length - 1 ? const SizedBox(height: 16,) : Container()
        ]
      ],
    );
  }
}