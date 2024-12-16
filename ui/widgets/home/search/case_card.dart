import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:child_healthcare/blocs/main_blocs/home_page/search_page/case_card_image/case_card_image_bloc.dart';
import 'package:child_healthcare/ui/decorations/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CaseCard extends StatelessWidget{
  final String? title;
  final String id;
  final String? mediaId;
  final bool isCompleted;
  final bool isSorted;
  final int? ageOfChild;
  const CaseCard({super.key,required this.title, required this.id, this.mediaId, this.isCompleted = false, this.isSorted = true, this.ageOfChild});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CaseCardImageBloc()..add(LoadCaseCardImage(mediaId)),
      child: GestureDetector(
        onTap: (){
          context.go('/home/search/:/single_article_page/$id');
        },
        child: Stack(
          children: [
            Container(
              width: (MediaQuery.of(context).size.width - 32 - 8) / 2,
              height: 190,
              margin: const EdgeInsets.only(top: 16),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16)
              ),
              padding: const EdgeInsets.only(right: 8, left: 8, top: 8, bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlocBuilder<CaseCardImageBloc, CaseCardImageState>(
                    builder: (context, state){
                      if(state is CaseCardImageLoaded){
                        return Container(
                          height: 108,
                          width: (MediaQuery.of(context).size.width - 32 - 8 - 16) / 2,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              image: DecorationImage(
                                  image: CachedNetworkImageProvider(state.mediaContent.url ?? '',),
                                  fit: BoxFit.cover
                              )
                          ),
                        );
                      }
                      if(state is CaseCardNoImage){
                        return Container(
                          height: 108,
                          width: (MediaQuery.of(context).size.width - 32 - 8 - 16) / 2,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              image: const DecorationImage(
                                  image: AssetImage('assets/images/rectangle.png'),
                                  fit: BoxFit.cover
                              )
                          ),
                        );
                      }
                      return Container(
                          height: 108,
                          alignment: Alignment.center,
                          width: (MediaQuery.of(context).size.width - 32 - 8 - 16) / 2,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.transparent.withOpacity(0.5)
                          ),
                          child: const SizedBox(
                            height: 40,
                            width:  40,
                            child: CircularProgressIndicator(),
                          )
                      );
                    },
                  ),
                  const SizedBox(height: 16,),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: AutoSizeText(title ?? '',
                      style: getTextStyle(
                          height: 1.42
                      ),
                      textAlign: TextAlign.left,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 16,)
                ],
              ),
            ),
            if (isCompleted) Container(
              width: (MediaQuery.of(context).size.width - 32 - 8) / 2,
              height: isSorted ? 190 : 224,
              margin: const EdgeInsets.only(top: 16),
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(16)
              ),
            ) else const SizedBox()
          ],
        )
      ),
    );
  }
}