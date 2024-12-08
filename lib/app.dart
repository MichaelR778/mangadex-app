import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangadex_app/features/auth/data/firebase_auth_repo.dart';
import 'package:mangadex_app/features/auth/presentation/cubits/auth_button_cubit.dart';
import 'package:mangadex_app/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:mangadex_app/features/auth/presentation/cubits/auth_state.dart';
import 'package:mangadex_app/features/auth/presentation/pages/auth_page.dart';
import 'package:mangadex_app/features/favorite/data/firebase_favorite_repo.dart';
import 'package:mangadex_app/features/favorite/presentation/cubits/favorite_cubit.dart';
import 'package:mangadex_app/features/history/data/firebase_history_repo.dart';
import 'package:mangadex_app/features/history/presentation/cubits/history_cubit.dart';
import 'package:mangadex_app/features/home/presentation/cubits/home_cubit.dart';
import 'package:mangadex_app/features/manga/data/mangadex_manga_repo.dart';
import 'package:mangadex_app/features/manga/presentation/cubits/chapter_cubit.dart';
import 'package:mangadex_app/features/manga/presentation/cubits/chapterpage_cubit.dart';
import 'package:mangadex_app/features/search/presentation/cubits/search_cubit.dart';
import 'package:mangadex_app/root.dart';
import 'package:mangadex_app/theme/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepo = FirebaseAuthRepo();
    final mangaRepo = MangadexMangaRepo();
    final favoriteRepo = FirebaseFavoriteRepo();
    final historyRepo = FirebaseHistoryRepo();

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(authRepo: authRepo),
        ),
        BlocProvider<AuthButtonCubit>(
          create: (context) => AuthButtonCubit(authRepo: authRepo),
        ),
        BlocProvider<HomeCubit>(
          create: (context) => HomeCubit(mangaRepo: mangaRepo),
        ),
        BlocProvider<SearchCubit>(
          create: (context) => SearchCubit(mangaRepo: mangaRepo),
        ),
        BlocProvider<ChapterCubit>(
          create: (context) => ChapterCubit(mangaRepo: mangaRepo),
        ),
        BlocProvider<ChapterpageCubit>(
          create: (context) => ChapterpageCubit(mangaRepo: mangaRepo),
        ),
        BlocProvider<FavoriteCubit>(
          create: (context) => FavoriteCubit(
            favoriteRepo: favoriteRepo,
            mangaRepo: mangaRepo,
          ),
        ),
        BlocProvider<HistoryCubit>(
          create: (context) => HistoryCubit(
            historyRepo: historyRepo,
            mangaRepo: mangaRepo,
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.appTheme,
        home: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state is Unauthenticated) {
              return const AuthPage();
            }

            context.read<HomeCubit>().init();
            context.read<SearchCubit>().init();
            context.read<FavoriteCubit>().init();
            context.read<HistoryCubit>().init();
            return const Root();
          },
        ),
      ),
    );
  }
}
