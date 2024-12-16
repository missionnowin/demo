import 'package:auto_size_text/auto_size_text.dart';
import 'package:child_healthcare/blocs/user/user_bloc.dart';
import 'package:child_healthcare/models/api_models/api_child.dart';
import 'package:child_healthcare/ui/decorations/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'child_avatar.dart';

SliverAppBar rootAppBar(BuildContext context, Widget title,{Widget? leading, Widget? actions}) =>
    SliverAppBar(
      centerTitle: true,
      title: title,
      backgroundColor: const Color.fromRGBO(240, 240, 240, 1),
      elevation: 0.0,
      leadingWidth: 76,
      bottom: PreferredSize(preferredSize: const Size.fromHeight(10), child: Container()),
      leading: leading,
      actions: [
        actions ?? Container(),
      ],
    );

class AppbarTitle extends StatelessWidget{
  const AppbarTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state){
        if(state is UserLoggedIn){
          return AutoSizeText(state.selectedChild?.name ?? '',
            style: getTextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600
            ),
          );
        }
        return Container();
      }
    );
  }
}

class AppbarText extends StatelessWidget{
  final String text;

  const AppbarText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(text,
      style: getTextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600
      ),
    );
  }
}


class TitleWithAction extends StatelessWidget{
  final void Function() onTap;
  final String text;

  const TitleWithAction({super.key, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AppbarText(text: text,),
    );
  }
}

class ChildSwitch extends StatelessWidget{

  const ChildSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state){
        return Container(
          margin: const EdgeInsets.only(right: 15),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(248, 247, 247, 1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: IconButton(
              onPressed: () async {
                await modalChildSwitch(context: context, children: state.user?.children ?? []);
              },
              icon: const Icon(Icons.keyboard_arrow_down, color: Color.fromRGBO(60, 60, 60, 1), size: 26)),
        );
      },
    );
  }
}

Future<void> modalChildSwitch({required BuildContext context, required List<ApiChild> children}) async{
  return showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      context: context,
      builder: (context){
        return SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(top: 20, bottom: 50, left: 16, right: 16),
            decoration: const BoxDecoration(
              color: Color.fromRGBO(250, 250, 250, 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoSizeText('Дети',
                  style: getTextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500
                  ),
                ),
                for(int i = 0; i < children.length; i++)...[
                  SingleChildModalCard(
                      name: children[i].name ?? '',
                      birthDate: children[i].dateBirth ?? DateTime.now(),
                      child: children[i],
                  )
                ]
              ],
            ),
          ),
        );
      }
  );
}


class SingleChildModalCard extends StatelessWidget{
  final String name;
  final ApiChild child;
  final DateTime birthDate;

  const SingleChildModalCard({super.key, required this.name, required this.birthDate, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: (){
        context.read<UserBloc>().add(SelectChild(child));
        context.pop();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        width: MediaQuery.of(context).size.width - 32,
        margin: const EdgeInsets.only(top: 16),
        decoration: BoxDecoration(
            color: const Color.fromRGBO(255, 255, 255, 1),
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.05),
                  blurRadius: 6,
                  spreadRadius: 0,
                  offset: Offset(0, 3)
              )
            ]
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<UserBloc, UserState>(
              builder: (context, state){
                return ChildAvatar(avatarUrl: child.avatar?.url,);
              },
            ),
            const SizedBox(width: 16,),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoSizeText(name,
                  style: getTextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4,),
                AutoSizeText('Возраст: ${(DateTime.now().difference(birthDate).inDays / 365).floor()}',
                  style: getTextStyle(
                      fontSize: 14,
                      color: const Color.fromRGBO(136, 140, 146, 1)
                  ),
                )
              ],
            ),
            const Spacer(),
            AutoSizeText('Выбрать',
              style: getTextStyle(
                fontSize: 13,
                color: const Color.fromRGBO(0, 212, 98, 1),
              ),
            )
          ],
        ),
      ),
    );
  }
}

