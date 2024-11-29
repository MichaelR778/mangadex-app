import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mangadex_app/features/favorite/presentation/cubits/favorite_cubit.dart';
import 'package:mangadex_app/features/favorite/presentation/cubits/favorite_state.dart';
import 'package:mangadex_app/features/manga/presentation/widgets/manga_tile.dart';
import 'package:mangadex_app/theme/app_colors.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Text(
              'Favorites',
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
      body: BlocBuilder<FavoriteCubit, FavoriteState>(
        builder: (context, state) {
          // loading
          if (state is FavoriteLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // loaded
          else if (state is FavoriteLoaded) {
            final mangas = state.mangas;

            if (mangas.isEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/vectors/ufo.svg',
                    width: MediaQuery.of(context).size.width / 1.7,
                    height: MediaQuery.of(context).size.width / 1.7,
                  ),
                  const SizedBox(height: 5),
                  Align(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 1.7,
                      child: const Text(
                        'No favorite',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              );
            }

            return RefreshIndicator(
              onRefresh: () => context.read<FavoriteCubit>().loadFavorites(),
              child: ListView.separated(
                itemCount: mangas.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 15),
                itemBuilder: (context, index) {
                  final manga = mangas[index];
                  return MangaTile(manga: manga);
                },
              ),
            );
          }

          // error
          else if (state is FavoriteError) {
            return RefreshIndicator(
              onRefresh: () => context.read<FavoriteCubit>().loadFavorites(),
              child: ListView(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: Column(
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
                    ),
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
