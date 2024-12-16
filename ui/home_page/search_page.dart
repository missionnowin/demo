import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:child_healthcare/blocs/main_blocs/home_page/search_page/search_page_bloc.dart';
import 'package:child_healthcare/blocs/user/user_bloc.dart';
import 'package:child_healthcare/ui/widgets/common_widgets/error_widget.dart';
import 'package:child_healthcare/ui/widgets/home_page_widgets/search/case_card.dart';
import 'package:child_healthcare/ui/widgets/common_widgets/root_appbar.dart';
import 'package:child_healthcare/ui/widgets/home_page_widgets/search/search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchPage extends StatelessWidget{
  final String? initialSearch;
  final ScrollController _scrollController = ScrollController();

  SearchPage({super.key, this.initialSearch});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: (){
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: BlocProvider(create: (_) => SearchPageBloc(initialSearch)..add(SearchArticles(initialSearch)),
          child: BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              return NotificationListener<ScrollEndNotification>(
                onNotification: (event){
                  if(_scrollController.position.pixels > 0.8 * _scrollController.position.maxScrollExtent && context.read<SearchPageBloc>().state is! SearchPageLoadingNext){
                    context.read<SearchPageBloc>().add(NextPage());
                  }
                  return true;
                },
                child: CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    rootAppBar(context, const AppbarTitle(),
                      actions: const ChildSwitch(),
                      leading: BlocBuilder<UserBloc, UserState>(
                        builder: (context, state){
                          return GestureDetector(
                            onTap: () async {
                              await modalChildSwitch(context: context, children: state.user?.children ?? []);
                            },
                            child: Container(
                              width: 50,
                              height: 50,
                              margin: const EdgeInsets.only(left: 16),
                              child: context.read<UserBloc>().state.selectedChild?.avatar?.url != null ? CircleAvatar(
                                radius: 25,
                                backgroundImage: CachedNetworkImageProvider(
                                  context.read<UserBloc>().state.selectedChild?.avatar?.url ?? '',
                                ),
                                backgroundColor: Colors.transparent.withOpacity(0),)
                                  : CircleAvatar(
                                radius: 25,
                                backgroundImage: const AssetImage(
                                    'assets/images/profile_placeholder.png'),
                                backgroundColor: Colors.transparent.withOpacity(0),),
                            ),
                          );
                        },
                      )
                    ),
                    SliverList.list(
                      children: [
                        const SizedBox(height: 24,),
                        BlocBuilder<SearchPageBloc, SearchPageState>(
                          builder: (context, state){
                            return CustomSearchField(
                              initialValue: state.initialSearch,
                              onSearch: (String? value) {
                                context.read<SearchPageBloc>().add(SearchArticles(value));
                              },
                            );
                          }
                        ),
                        const SizedBox(height: 16,),
                        BlocBuilder<SearchPageBloc, SearchPageState>(
                          builder: (context, state){
                            if(state is SearchPageLoaded){
                              if(state.articles == null && state.articles?.isEmpty == true && state.articlesUnsorted == null && state.articlesUnsorted?.isEmpty == true) {
                                return const SizedBox(
                                  height: 250,
                                  child: Center(
                                      child: AutoSizeText('Ничего не найдено')
                                  ),
                                );
                              }
                              if(state.articlesUnsorted != null){
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 16.0),
                                      child: Wrap(
                                        children: [
                                          for(int i = 0; i < ((state.articlesUnsorted?.length) ?? 0); i++)...[
                                            CaseCard(
                                              title: state.articlesUnsorted?[i].title,
                                              isCompleted: context.read<UserBloc>().state.user?.completedCourses?.contains(state.articlesUnsorted?[i].id) == true,
                                              id:  state.articlesUnsorted?[i].id ?? '',
                                              isSorted: false,
                                              ageOfChild: state.articlesUnsorted?[i].ageOfChild ?? 0,
                                              mediaId: state.articlesUnsorted?[i].hero.media,
                                            ),
                                            const SizedBox(width: 8,)
                                          ]
                                        ],
                                      ),
                                    ),
                                    if(state is SearchPageLoadingNext)
                                      const Column(
                                          children:[
                                            SizedBox(height: 50,),
                                            Center(
                                              child: CircularProgressIndicator(),
                                            )
                                          ]
                                      )
                                  ],
                                );
                              }
                            }
                            if(state is SearchPageError){
                              return LoadingErrorWidget(
                                onError: () {
                                  context.read<SearchPageBloc>().add(SearchArticles(state.initialSearch));
                                },
                              );
                            }
                            if(state is SearchPageLoading){
                              return Center(
                                  child: Column(
                                    children: [
                                      SizedBox(height: MediaQuery.of(context).size.height / 3,),
                                      const CircularProgressIndicator(),
                                    ],
                                  )
                              );
                            }
                            return Container();
                          },
                        ),
                        const SizedBox(height: 24,),
                      ],
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}