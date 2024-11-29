import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangadex_app/features/favorite/data/firebase_favorite_repo.dart';
import 'package:mangadex_app/features/favorite/presentation/cubits/favorite_cubit.dart';
import 'package:mangadex_app/features/home/presentation/cubits/home_cubit.dart';
import 'package:mangadex_app/features/manga/data/mangadex_manga_repo.dart';
import 'package:mangadex_app/features/manga/presentation/cubits/chapter_cubit.dart';
import 'package:mangadex_app/features/manga/presentation/cubits/chapterpage_cubit.dart';
import 'package:mangadex_app/features/search/presentation/cubits/search_cubit.dart';
import 'package:mangadex_app/firebase_options.dart';
import 'package:mangadex_app/root.dart';
import 'package:mangadex_app/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final mangaRepo = MangadexMangaRepo();
    final favoriteRepo = FirebaseFavoriteRepo();

    return MultiBlocProvider(
      providers: [
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
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.appTheme,
        home: const Root(),
      ),
    );
  }
}
