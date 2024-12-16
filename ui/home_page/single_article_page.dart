import 'package:child_healthcare/blocs/main_blocs/home_page/single_article/single_article_bloc.dart';
import 'package:child_healthcare/blocs/user/user_bloc.dart';
import 'package:child_healthcare/ui/widgets/common_widgets/error_widget.dart';
import 'package:child_healthcare/ui/widgets/common_widgets/non_root_appbar.dart';
import 'package:child_healthcare/ui/widgets/home_page_widgets/article/article_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SingleArticlePage extends StatelessWidget{
  final String id;

  const SingleArticlePage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SingleArticleBloc()..add(LoadSingleArticle(id)),
      child: Scaffold(
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              nonRootAppBar(context),
            ],
            body: SingleChildScrollView(
              child: BlocConsumer<SingleArticleBloc, SingleArticleState>(
                listener: (context, state){
                  if(state is SingleArticleLoaded){
                    List<String>? completedCourses = context.read<UserBloc>().state.user?.completedCourses;
                    if(completedCourses?.contains(state.article.id) != true){
                      context.read<SingleArticleBloc>().add(MarkAsCompleted(id));
                      completedCourses?.add(id);
                    }
                  }
                },
                builder: (context, state){
                  if(state is SingleArticleLoaded){
                    return ArticleWidget(article: state.article);
                  }
                  if(state is SingleArticleError){
                    return LoadingErrorWidget(
                        onError: (){
                          context.read<SingleArticleBloc>().add(LoadSingleArticle(id));
                        }
                    );
                  }
                  return Column(
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height / 3,),
                      const Center(
                        child: CircularProgressIndicator(),
                      )
                    ],
                  );
                },
              ),
            )
          )
      )
    );
  }
}