import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangadex_app/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:mangadex_app/features/favorite/presentation/cubits/favorite_cubit.dart';
import 'package:mangadex_app/features/favorite/presentation/cubits/favorite_state.dart';
import 'package:mangadex_app/features/manga/presentation/widgets/manga_tile.dart';
import 'package:mangadex_app/features/svg_view/svg_view.dart';
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
        actions: [
          IconButton(
            onPressed: () {
              context.read<AuthCubit>().logout();
            },
            icon: const Icon(
              Icons.logout,
              color: AppColors.placeholder,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: BlocBuilder<FavoriteCubit, FavoriteState>(
          builder: (context, state) {
            // loading
            if (state is FavoriteLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            // loaded
            else if (state is FavoriteLoaded) {
              final mangas = state.mangas;

              if (mangas.isEmpty) {
                return const SvgView(
                  svgFileName: 'ufo',
                  message: 'No Favorite',
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
                    SvgView(
                      svgFileName: 'error',
                      message: state.message,
                    ),
                  ],
                ),
              );
            }

            // other
            return Container();
          },
        ),
      ),
    );
  }
}
