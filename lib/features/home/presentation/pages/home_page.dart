import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mangadex_app/features/history/presentation/cubits/history_cubit.dart';
import 'package:mangadex_app/features/history/presentation/cubits/history_state.dart';
import 'package:mangadex_app/features/history/presentation/pages/history_page.dart';
import 'package:mangadex_app/features/home/presentation/cubits/home_cubit.dart';
import 'package:mangadex_app/features/home/presentation/cubits/home_state.dart';
import 'package:mangadex_app/features/manga/domain/entities/manga.dart';
import 'package:mangadex_app/features/manga/presentation/pages/manga_page.dart';
import 'package:mangadex_app/features/manga/presentation/widgets/manga_tile.dart';
import 'package:mangadex_app/theme/app_colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void getLatest(int index) {
    final offset = index * 10;
    context.read<HomeCubit>().fetchLatest(offset);
  }

  Widget _pageNav(int currIndex, int totalPage) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () => getLatest((currIndex - 1) % totalPage),
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 10,
          ),
        ),
        Text('${currIndex + 1} / $totalPage'),
        IconButton(
          onPressed: () => getLatest((currIndex + 1) % totalPage),
          icon: const Icon(
            Icons.arrow_forward_ios,
            size: 10,
          ),
        ),
      ],
    );
  }

  Future<void> reload() async {
    await context.read<HistoryCubit>().loadHistory();
    await context.read<HomeCubit>().fetchLatest(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Text(
              'Home',
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
      body: RefreshIndicator(
        onRefresh: reload,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          children: [
            // history
            BlocBuilder<HistoryCubit, HistoryState>(
              builder: (context, state) {
                if (state is HistoryError) {
                  return Text(state.message);
                }
                if (state is HistoryLoaded) {
                  List<Manga> mangas = state.mangas;
                  if (mangas.isEmpty) return Container();
                  if (mangas.length > 10) mangas = mangas.sublist(0, 10);
                  return Column(
                    children: [
                      Row(
                        children: [
                          const Text(
                            'History',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(child: Container()),
                          IconButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HistoryPage(),
                              ),
                            ),
                            icon: const Icon(Icons.arrow_forward_ios),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width / 2.5,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: mangas.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(width: 10),
                          itemBuilder: (context, index) {
                            final manga = mangas[index];
                            return Column(
                              children: [
                                // cover
                                GestureDetector(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          MangaPage(manga: manga),
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      manga.coverUrl,
                                      width:
                                          MediaQuery.of(context).size.width / 4,
                                      height:
                                          MediaQuery.of(context).size.width / 3,
                                      fit: BoxFit.cover,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              4,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              3,
                                          decoration: BoxDecoration(
                                            color: AppColors.placeholder,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        );
                                      },
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              4,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              3,
                                          decoration: BoxDecoration(
                                            color: AppColors.placeholder,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                // title
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 4,
                                  child: Text(
                                    manga.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }
                return Container();
              },
            ),

            // latest update section
            const Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                'Latest',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                // loading
                if (state is HomeLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                // loaded
                else if (state is HomeLoaded) {
                  final mangas = state.mangaList.mangas;
                  final currIndex = state.mangaList.currIndex;
                  final totalPage = state.mangaList.totalPage;
                  return Column(
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
                      _pageNav(currIndex, totalPage),
                    ],
                  );
                }

                // error
                else if (state is HomeError) {
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
          ],
        ),
      ),
    );
  }
}
