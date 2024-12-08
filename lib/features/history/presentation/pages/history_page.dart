import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangadex_app/features/history/presentation/cubits/history_cubit.dart';
import 'package:mangadex_app/features/history/presentation/cubits/history_state.dart';
import 'package:mangadex_app/features/manga/presentation/widgets/manga_tile.dart';
import 'package:mangadex_app/features/svg_view/svg_view.dart';
import 'package:mangadex_app/theme/app_colors.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Row(
          children: [
            Text(
              'History',
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
        child: BlocBuilder<HistoryCubit, HistoryState>(
          builder: (context, state) {
            // loading
            if (state is HistoryLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            // loaded
            else if (state is HistoryLoaded) {
              final mangas = state.mangas;
              return ListView.separated(
                itemCount: mangas.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 15),
                itemBuilder: (context, index) {
                  final manga = mangas[index];
                  return MangaTile(manga: manga);
                },
              );
            }

            // error
            else if (state is HistoryError) {
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
    );
  }
}
