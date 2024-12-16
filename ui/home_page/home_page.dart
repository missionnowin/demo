import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:child_healthcare/blocs/main_blocs/home_page/home_page/home_page_bloc.dart';
import 'package:child_healthcare/blocs/user/user_bloc.dart';
import 'package:child_healthcare/models/api_models/api_child.dart';
import 'package:child_healthcare/ui/decorations/theme.dart';
import 'package:child_healthcare/ui/widgets/common_widgets/error_widget.dart';
import 'package:child_healthcare/ui/widgets/common_widgets/root_appbar.dart';
import 'package:child_healthcare/ui/widgets/home_page_widgets/article/article_widgets.dart';
import 'package:child_healthcare/ui/widgets/home_page_widgets/search/search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatelessWidget{
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomePageBloc()..add(
          LoadHomePage(context.read<UserBloc>().state.selectedChild)
      ),
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
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
          ],
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: CustomSearchField(
                    onSearch: (String? value) {
                      context.go('/home/search/${value != null && value.isNotEmpty ? value : ' '}');
                    },
                  ),
                ),
                const SizedBox(height: 10,),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ElevatedButton(
                      onPressed: (){
                        context.go('/home/search/${' '}');
                      },
                      child: AutoSizeText(
                        'Перейти ко всем статьям',
                        style: GoogleFonts.notoSans(
                          height: 1.5,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromRGBO(255, 255, 255, 1),
                          letterSpacing: -0.01,
                        ),
                      )
                  ),
                ),
                const SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: BlocConsumer<UserBloc, UserState>(
                    listener: (context, state){
                      if(state is UserLoggedIn){
                        context.read<HomePageBloc>().add(LoadHomePage(context.read<UserBloc>().state.selectedChild));
                      }
                    },
                    builder: (context, state){
                      return BlocConsumer<HomePageBloc, HomePageState>(
                        listener: (context, state){
                          if(state is HomePageLoaded){
                            if(context.read<UserBloc>().state.selectedChild?.recommendation == null && state.article != null){
                              ApiChild? selectedChild = context.read<UserBloc>().state.selectedChild;
                              selectedChild?.recommendation = state.article;
                              context.read<UserBloc>().add(UpdateUserChild(selectedChild));
                            }
                          }
                        },
                        builder: (context, state){
                          if(state is HomePageLoaded){
                            if(state.article != null){
                              return ArticleWidget(article: state.article!);
                            }
                            if(context.read<UserBloc>().state.selectedChild != null){
                              return Column(
                                children: [
                                  SizedBox(height: MediaQuery.of(context).size.height / 4,),
                                  AutoSizeText('Для выбранного ребенка нет рекомендаций.',
                                      style: getTextStyle()
                                  )
                                ],
                              );
                            }
                            return Column(
                              children: [
                                SizedBox(height: MediaQuery.of(context).size.height / 4,),
                                AutoSizeText('Для получение рекомендаций выберите ребенка.',
                                    style: getTextStyle()
                                )
                              ],
                            );
                          }
                          if(state is HomePageError){
                            return LoadingErrorWidget(
                                onError: (){
                                  context.read<HomePageBloc>().add(LoadHomePage(context.read<UserBloc>().state.selectedChild));
                                }
                            );
                          }
                          return Center(
                            child: Column(
                              children: [
                                SizedBox(height: MediaQuery.of(context).size.height / 4,),
                                const CircularProgressIndicator()
                              ],
                            ),
                          );
                        },
                      );
                    },
                  )
                )
              ],
            ),
          ),
        )
      ),
    );
  }
}