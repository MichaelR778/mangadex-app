import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mangadex_app/features/manga/presentation/widgets/manga_tile.dart';
import 'package:mangadex_app/features/search/presentation/cubits/search_cubit.dart';
import 'package:mangadex_app/features/search/presentation/cubits/search_state.dart';
import 'package:mangadex_app/features/search/presentation/widgets/search_field.dart';
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
              child: SearchField(
                controller: controller,
                onSubmitted: (_) => search(0),
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
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/vectors/empty.svg',
                            width: MediaQuery.of(context).size.width / 1.7,
                            height: MediaQuery.of(context).size.width / 1.7,
                          ),
                          const SizedBox(height: 5),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 1.7,
                            child: const Text(
                              'Not found',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
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
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/vectors/error.svg',
                          width: MediaQuery.of(context).size.width / 1.7,
                          height: MediaQuery.of(context).size.width / 1.7,
                        ),
                        const SizedBox(height: 5),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.7,
                          child: Text(
                            state.message,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
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
