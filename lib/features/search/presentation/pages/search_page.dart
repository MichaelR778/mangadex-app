import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangadex_app/features/manga/presentation/widgets/manga_tile.dart';
import 'package:mangadex_app/features/search/presentation/cubits/search_cubit.dart';
import 'package:mangadex_app/features/search/presentation/cubits/search_state.dart';
import 'package:mangadex_app/features/svg_view/svg_view.dart';
import 'package:mangadex_app/theme/app_colors.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late final controller = TextEditingController(
    text: context.read<SearchCubit>().lastSearch,
  );
  late bool mostFollowed = context.read<SearchCubit>().orderByFollow;

  void search(int index) {
    final offset = index * 10;
    context.read<SearchCubit>().searchByTitle(
          controller.text,
          offset,
          mostFollowed: mostFollowed,
        );
  }

  Widget _orderOption(String text) {
    bool disabled = mostFollowed == (text == 'Most Followed');
    if (disabled) {
      return Text(
        text,
        style: const TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
        ),
      );
    } else {
      return GestureDetector(
        onTap: () {
          setState(() {
            mostFollowed = !mostFollowed;
          });
          search(0);
        },
        child: Text(
          text,
          style: const TextStyle(
            color: AppColors.placeholder,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
  }

  Widget _pageNav(int currIndex, int totalPage) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () => search((currIndex - 1) % totalPage),
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 10,
          ),
        ),
        Text('${currIndex + 1} / $totalPage'),
        IconButton(
          onPressed: () => search((currIndex + 1) % totalPage),
          icon: const Icon(
            Icons.arrow_forward_ios,
            size: 10,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Row(
          children: [
            Text(
              'Browse',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '.',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            // search text field
            Container(
              padding: const EdgeInsets.only(
                top: 8,
                left: 6,
                right: 6,
                bottom: 16,
              ),
              child: TextField(
                controller: controller,
                onSubmitted: (_) => search(0),
                cursorColor: const Color(0x33FFFFFF),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search',
                ),
              ),
            ),

            Row(
              children: [
                _orderOption('Most Followed'),
                const SizedBox(width: 10),
                _orderOption('Latest Updated'),
              ],
            ),

            const SizedBox(height: 5),

            // body
            Expanded(
              child: BlocBuilder<SearchCubit, SearchState>(
                builder: (context, state) {
                  // loading
                  if (state is SearchLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // loaded
                  else if (state is SearchLoaded) {
                    final mangas = state.mangaList.mangas;

                    if (mangas.isEmpty) {
                      return const SvgView(
                        svgFileName: 'empty',
                        message: 'Not Found',
                      );
                    }

                    final currIndex = state.mangaList.currIndex;
                    final totalPage = state.mangaList.totalPage;

                    return ListView(
                      children: [
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: mangas.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 15),
                          itemBuilder: (context, index) {
                            final manga = mangas[index];
                            return MangaTile(manga: manga);
                          },
                        ),
                        totalPage > 1
                            ? _pageNav(currIndex, totalPage)
                            : Container(),
                      ],
                    );
                  }

                  // error
                  else if (state is SearchError) {
                    return SvgView(
                      svgFileName: 'error',
                      message: state.message,
                    );
                  }

                  // other
                  return Container();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
