import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mangadex_app/features/home/presentation/cubits/home_cubit.dart';
import 'package:mangadex_app/features/home/presentation/cubits/home_state.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Text(
              'Latest',
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
      body: BlocBuilder<HomeCubit, HomeState>(
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
            return RefreshIndicator(
              onRefresh: () => context.read<HomeCubit>().fetchLatest(0),
              child: ListView(
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
                  _pageNav(currIndex, totalPage)
                ],
              ),
            );
          }

          // error
          else if (state is HomeError) {
            return RefreshIndicator(
              onRefresh: () => context.read<HomeCubit>().fetchLatest(0),
              child: ListView(
                children: [
                  Column(
                    children: [
                      // vertical offset
                      SizedBox(height: MediaQuery.of(context).size.height / 5),

                      SvgPicture.asset(
                        'assets/vectors/ufo.svg',
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
                  ),
                ],
              ),
            );
          }

          // other
          return Container();
        },
      ),
    );
  }
}
