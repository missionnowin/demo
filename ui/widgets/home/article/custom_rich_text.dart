import 'package:auto_size_text/auto_size_text.dart';
import 'package:child_healthcare/models/api_models/api_article.dart';
import 'package:child_healthcare/ui/decorations/theme.dart';
import 'package:child_healthcare/utils/article_utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class RichTextWidget extends StatelessWidget{
  final RichTextElement richText;
  final Color? color;

  const RichTextWidget({super.key, required this.richText, this.color});
  @override
  Widget build(BuildContext context) {
    return AutoSizeText.rich(
      TextSpan(
          children: [
            for(int i = 0; i < (richText.children?.length ?? 0); i++)...[
              RichTextCustomElement(
                color: color,
                richText: richText.children?[i],
                fontSize: getFontSize(richText.type) ??  getFontSize(richText.children?[i].type),
                letterSpacing: getLetterSpacing(richText.type) ?? getLetterSpacing(richText.children?[i].type),
              )
            ]
          ]
      ),
      softWrap: true,
      locale: const Locale('ru'),
    );
  }
}


class RichTextCustomElement extends TextSpan{
  final RichTextElement? richText;
  final double? fontSize;
  final Color? color;
  final double? letterSpacing;
  final String? parentUrl;

  RichTextCustomElement( {this.color, required this.richText, this.fontSize, this.letterSpacing, this.parentUrl,})
      : super(
    children: richText?.children != null ? List<RichTextCustomElement>.generate(richText!.children!.length, (index) =>
        RichTextCustomElement(
            richText: richText.children![index],
            color: color,
            fontSize: fontSize ?? getFontSize(richText.children![index].type),
            letterSpacing: letterSpacing ?? getLetterSpacing(richText.children![index].type),
            parentUrl: richText.url
        )
    ) : null,
    text: richText?.text,
    style: getTextStyle(
        letterSpacing: letterSpacing,
        fontWeight: richText?.bold == true ? FontWeight.bold : FontWeight.w500,
        fontStyle: richText?.italic == true ? FontStyle.italic : null,
        decoration: richText?.underline == true || richText?.type == 'link' ? TextDecoration.underline : null,
        fontSize: fontSize ?? 14,
        color: richText?.type == 'link' ? Colors.blue : color ?? (richText?.red == true ? const Color.fromRGBO(254, 148, 187, 1.0) : null)
    ),
    recognizer: parentUrl != null ? (TapGestureRecognizer()..onTap = (){
      launchUrl(Uri.https(parentUrl));
    }) : null,
  );
}