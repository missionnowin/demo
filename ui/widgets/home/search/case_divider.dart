import 'package:auto_size_text/auto_size_text.dart';
import 'package:child_healthcare/ui/decorations/theme.dart';
import 'package:child_healthcare/utils/case_utils.dart';
import 'package:flutter/material.dart';

class CaseDivider extends StatelessWidget{
  final int age;
  final int cases;

  const CaseDivider({super.key, required this.age, required this.cases});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 40,
      decoration: const BoxDecoration(
        color: Color.fromRGBO(255, 230, 239, 1)
      ),
      padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 16),
      margin: const EdgeInsets.only(top: 28),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AutoSizeText('$age ${getAgeNoun(age)}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: getTextStyle(
              color: const Color.fromRGBO(253, 53, 126, 1),
              fontWeight: FontWeight.w500,
              fontSize: 18,
              height: 1.33
            ),
          ),
          AutoSizeText('$cases ${getCaseNoun(cases)}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: getTextStyle(
                color: const Color.fromRGBO(25, 0, 9, 1),
                fontWeight: FontWeight.w500,
                fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}