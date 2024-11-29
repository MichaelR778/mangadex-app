import 'package:flutter/material.dart';
import 'package:mangadex_app/features/manga/domain/entities/manga.dart';
import 'package:mangadex_app/features/manga/presentation/pages/manga_page.dart';
import 'package:mangadex_app/features/manga/presentation/widgets/manga_tags.dart';
import 'package:mangadex_app/theme/app_colors.dart';

class MangaTile extends StatefulWidget {
  final Manga manga;

  const MangaTile({super.key, required this.manga});

  @override
  State<MangaTile> createState() => _MangaTileState();
}

class _MangaTileState extends State<MangaTile> {
  bool fullTags = false;

  Widget _tags() {
    if (widget.manga.tags.length > 3 && !fullTags) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // tags
          Expanded(
            child: MangaTags(
              tags: widget.manga.tags.sublist(0, 3),
            ),
          ),

          // more button
          GestureDetector(
            onTap: () {
              setState(() {
                fullTags = true;
              });
            },
            child: const Text(
              'MORE',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
    }

    return MangaTags(tags: widget.manga.tags);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MangaPage(manga: widget.manga),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // cover art
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                widget.manga.coverUrl,
                width: MediaQuery.of(context).size.width / 4,
                height: MediaQuery.of(context).size.width / 3,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
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
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // title
                  Text(
                    widget.manga.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // tags
                  _tags(),

                  // desc
                  Text(
                    widget.manga.description,
                    maxLines: 4,
                    overflow: TextOverflow.fade,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
