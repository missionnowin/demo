import 'package:child_healthcare/models/api_models/api_article_reduced.dart';
import 'package:child_healthcare/network/network_service.dart';
import 'package:child_healthcare/ui/decorations/theme.dart';
import 'package:flutter/material.dart';

class CustomSearchField extends StatefulWidget{
  final String? initialValue;
  final void Function(String? value) onSearch;

  const CustomSearchField({super.key, this.initialValue, required this.onSearch});

  @override
  State<CustomSearchField> createState() => _CustomSearchFieldState();
}

class _CustomSearchFieldState extends State<CustomSearchField> {
  final SearchController searchController = SearchController();

  @override
  void initState() {
    super.initState();
    setState(() {
      searchController.text = widget.initialValue ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SearchAnchor(
          isFullScreen: false,
          searchController: searchController,
          viewBackgroundColor: const Color.fromRGBO(255, 255, 255, 1),
          viewSurfaceTintColor: const Color.fromRGBO(255, 255, 255, 1),
          viewHintText: 'Поиск по базе знаний',
          viewElevation: 5.0,
          headerTextStyle: getTextStyle(),
          headerHintStyle: getTextStyle(
              color: const Color.fromRGBO(136, 140, 146, 1)
          ),
          viewOnSubmitted: (filter){
            widget.onSearch(filter);
            setState(() {
              searchController.closeView(filter);
              FocusScope.of(context).requestFocus(FocusNode());
            });
          },
          builder: (context, controller){
            return TextField(
              controller: controller,
              onTap: () {
                controller.openView();
              },
              onChanged: (_){
                controller.openView();
              },
              onSubmitted: (filter){
                widget.onSearch(filter);
              },
              style: getTextStyle(),
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                fillColor: const Color.fromRGBO(255, 255, 255, 1),
                filled: true,
                constraints: const BoxConstraints(minHeight: 40, maxHeight: 40),
                contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                prefixIcon: const Icon(Icons.search, color: Color.fromRGBO(60, 60, 60, 1),),
                hintText: 'Поиск по базе знаний',
                hintStyle: getTextStyle(
                    color: const Color.fromRGBO(136, 140, 146, 1),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            );
          },
          suggestionsBuilder: (context, controller) async {
            final suggestions = await _getData(controller.value.text);
            return suggestions.map((e) =>
                ListTile(
                  title:
                  Text(e.title ?? '',
                    style: getTextStyle(),),
                  leading: const Icon(Icons.search,
                    color: Color.fromRGBO(68, 68, 79, 1), size: 20,),
                  onTap: (){
                    widget.onSearch(e.title);
                    setState(() {
                      controller.closeView(e.title);
                    });
                  }
                )
            ).toList();
          }
      ),
    );
  }
}

Future<List<ApiArticleReduced>> _getData(String? filter) async{
  return await NetworkService().searchArticles(name: filter, limit: 20, page: 1);
}