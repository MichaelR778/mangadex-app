import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangadex_app/features/manga/domain/entities/chapter.dart';
import 'package:mangadex_app/features/manga/presentation/cubits/chapterpage_cubit.dart';
import 'package:mangadex_app/features/manga/presentation/cubits/chapterpage_state.dart';
import 'package:mangadex_app/theme/app_colors.dart';

class ChapterPage extends StatefulWidget {
  final Chapter chapter;

  const ChapterPage({super.key, required this.chapter});

  @override
  State<ChapterPage> createState() => _ChapterPageState();
}

class _ChapterPageState extends State<ChapterPage> {
  @override
  void initState() {
    super.initState();
    context.read<ChapterpageCubit>().getChapterImageUrls(widget.chapter.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'Chapter ${widget.chapter.chapterNumber}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              '.',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: BlocBuilder<ChapterpageCubit, ChapterpageState>(
        builder: (context, state) {
          // loading
          if (state is ChapterpageLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // loaded
          else if (state is ChapterpageLoaded) {
            final imageUrls = state.imageUrls;
            return ListView.builder(
              itemCount: imageUrls.length,
              itemBuilder: (context, index) {
                return Image.network(
                  imageUrls[index],
                  width: double.infinity,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Align(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(),
                    );
                  },
                );
              },
            );
          }

          // error
          else if (state is ChapterpageError) {
            return Center(child: Text(state.message));
          }

          // other
          return Container();
        },
      ),
    );
  }
}
