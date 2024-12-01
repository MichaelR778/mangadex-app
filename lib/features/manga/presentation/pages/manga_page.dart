import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangadex_app/features/favorite/presentation/cubits/favorite_cubit.dart';
import 'package:mangadex_app/features/favorite/presentation/cubits/favorite_state.dart';
import 'package:mangadex_app/features/history/presentation/cubits/history_cubit.dart';
import 'package:mangadex_app/features/manga/domain/entities/manga.dart';
import 'package:mangadex_app/features/manga/presentation/cubits/chapter_cubit.dart';
import 'package:mangadex_app/features/manga/presentation/cubits/chapter_state.dart';
import 'package:mangadex_app/features/manga/presentation/pages/chapter_page.dart';
import 'package:mangadex_app/features/manga/presentation/widgets/manga_tags.dart';
import 'package:mangadex_app/theme/app_colors.dart';

class MangaPage extends StatefulWidget {
  final Manga manga;

  const MangaPage({super.key, required this.manga});

  @override
  State<MangaPage> createState() => _MangaPageState();
}

class _MangaPageState extends State<MangaPage> {
  bool fullDesc = false;

  Widget _desc() {
    return Column(
      children: [
        // desc
        SizedBox(
          height: fullDesc ? null : 60,
          child: Text(
            widget.manga.description,
            overflow: TextOverflow.fade,
          ),
        ),

        // show more/less
        GestureDetector(
          onTap: () {
            setState(() {
              fullDesc = !fullDesc;
            });
          },
          child: Text(
            fullDesc ? 'Show less' : 'Show more',
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _chapterNav(int currIndex, int totalPage) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () => getChapters((currIndex - 1) % totalPage),
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 10,
          ),
        ),
        Text('${currIndex + 1} / $totalPage'),
        IconButton(
          onPressed: () => getChapters((currIndex + 1) % totalPage),
          icon: const Icon(
            Icons.arrow_forward_ios,
            size: 10,
          ),
        ),
      ],
    );
  }

  void getChapters(int index) {
    final offset = index * 100;
    context.read<ChapterCubit>().getMangaChapters(widget.manga.id, offset);
  }

  @override
  void initState() {
    super.initState();
    getChapters(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        actions: [
          BlocConsumer<FavoriteCubit, FavoriteState>(
            builder: (context, state) {
              final mangaId = widget.manga.id;
              if (state is FavoriteLoaded) {
                return IconButton(
                  onPressed: () =>
                      context.read<FavoriteCubit>().toggleFavorite(mangaId),
                  icon: Icon(
                    state.mangaIds.contains(mangaId)
                        ? Icons.favorite
                        : Icons.favorite_outline,
                    color: AppColors.primary,
                  ),
                );
              }
              return Container();
            },
            listener: (context, state) {
              if (state is FavoriteError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // background image
          Image.network(
            widget.manga.coverUrl,
            width: double.infinity,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  color: AppColors.placeholder,
                  borderRadius: BorderRadius.circular(10),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  color: AppColors.placeholder,
                  borderRadius: BorderRadius.circular(10),
                ),
              );
            },
          ),

          SingleChildScrollView(
            child: Stack(
              children: [
                // fade
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(150, 11, 11, 11),
                        AppColors.background,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.0, 0.4],
                    ),
                  ),
                ),

                // actual body
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // vertical offset
                    SizedBox(height: MediaQuery.of(context).size.height / 3.5),

                    // cover and title
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          // cover image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              widget.manga.coverUrl,
                              width: MediaQuery.of(context).size.width / 4,
                              height: MediaQuery.of(context).size.width / 3,
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  width: MediaQuery.of(context).size.width / 4,
                                  height: MediaQuery.of(context).size.width / 3,
                                  decoration: BoxDecoration(
                                    color: AppColors.placeholder,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: MediaQuery.of(context).size.width / 4,
                                  height: MediaQuery.of(context).size.width / 3,
                                  decoration: BoxDecoration(
                                    color: AppColors.placeholder,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                );
                              },
                            ),
                          ),

                          const SizedBox(width: 10),

                          // title
                          Expanded(
                            child: Text(
                              widget.manga.title,
                              style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    // tags, desc and chapter list
                    // container to cover fade
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      color: AppColors.background,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // tags
                          MangaTags(tags: widget.manga.tags),

                          const SizedBox(height: 10),

                          // desc
                          _desc(),

                          const SizedBox(height: 20),

                          // chapters
                          BlocBuilder<ChapterCubit, ChapterState>(
                            builder: (context, state) {
                              // loading
                              if (state is ChapterLoading) {
                                return const Align(
                                  alignment: Alignment.center,
                                  child: CircularProgressIndicator(),
                                );
                              }

                              // loaded
                              else if (state is ChapterLoaded) {
                                final chapters = state.chapterList.chapters;

                                if (chapters.isEmpty) {
                                  return const Center(
                                    child: Text('No chapter found'),
                                  );
                                }

                                final currIndex = state.chapterList.currIndex;
                                final totalPage = state.chapterList.totalPage;
                                return Column(
                                  children: [
                                    // _chapterNav(currIndex, totalPage),
                                    ListView.builder(
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: chapters.length,
                                      itemBuilder: (context, index) {
                                        final chapter = chapters[index];
                                        return ListTile(
                                          onTap: () {
                                            context
                                                .read<HistoryCubit>()
                                                .addHistory(widget.manga.id);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ChapterPage(
                                                  chapter: chapter,
                                                ),
                                              ),
                                            );
                                          },
                                          leading: const Icon(
                                            Icons.arrow_right,
                                            color: AppColors.primary,
                                          ),
                                          title: Text(
                                            'Chapter ${chapter.chapterNumber} (${chapter.language})',
                                          ),
                                        );
                                      },
                                    ),
                                    totalPage > 1
                                        ? _chapterNav(currIndex, totalPage)
                                        : Container(),
                                  ],
                                );
                              }

                              // error
                              else if (state is ChapterError) {
                                return Align(
                                  alignment: Alignment.center,
                                  child: Text(state.message),
                                );
                              }

                              // other
                              return Container();
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
