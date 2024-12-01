import 'dart:convert';
import 'dart:io';

import 'package:mangadex_app/features/manga/domain/entities/chapter.dart';
import 'package:mangadex_app/features/manga/domain/entities/chapter_list.dart';
import 'package:mangadex_app/features/manga/domain/entities/manga.dart';
import 'package:mangadex_app/features/manga/domain/entities/manga_list.dart';
import 'package:mangadex_app/features/manga/domain/repos/manga_repo.dart';
import 'package:http/http.dart' as http;

class MangadexMangaRepo implements MangaRepo {
  final baseUrl = 'api.mangadex.org';

  @override
  Future<MangaList> searchByTitle(String title, int offset,
      {bool mostFollowed = false}) async {
    try {
      final uri = Uri.https(
        baseUrl,
        '/manga',
        mostFollowed
            ? {
                'offset': offset.toString(),
                'title': title,
                'includes[]': ['cover_art'],
                'availableTranslatedLanguage[]': ['en', 'id'],
                'order[followedCount]': 'desc',
              }
            : {
                'offset': offset.toString(),
                'title': title,
                'includes[]': ['cover_art'],
                'availableTranslatedLanguage[]': ['en', 'id'],
                'order[latestUploadedChapter]': 'desc',
              },
      );
      final response = await http.get(uri);

      // 200 ok response
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        final mangaJsons = json['data'] as List<dynamic>;
        final mangas = mangaJsons.map((json) => Manga.fromJson(json)).toList();

        final currIndex = ((json['offset'] as int) / 10).round();
        final totalPage = ((json['total'] as int) / 10).ceil();

        final mangaList = MangaList(
          mangas: mangas,
          currIndex: currIndex,
          totalPage: totalPage,
        );
        return mangaList;
      }

      // 503 server is down
      else if (response.statusCode == 503) {
        throw Exception('Server is currently down');
      }

      // something went wrong
      throw Exception('Error code ${response.statusCode}');
    } on SocketException {
      throw Exception('No internet connection');
    } catch (e) {
      throw Exception('Failed to search manga by title: $e');
    }
  }

  @override
  Future<List<Manga>> getMangas(List<String> mangaIds) async {
    try {
      final uri = Uri.https(
        baseUrl,
        '/manga',
        {
          'ids[]': mangaIds,
          'includes[]': ['cover_art'],
          'availableTranslatedLanguage[]': ['en', 'id'],
          'order[latestUploadedChapter]': 'desc',
        },
      );
      final response = await http.get(uri);

      // 200 ok response
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        final mangaJsons = json['data'] as List<dynamic>;
        final mangas = mangaJsons.map((json) => Manga.fromJson(json)).toList();

        return mangas;
      }

      // 503 server is down
      else if (response.statusCode == 503) {
        throw Exception('Server is currently down');
      }

      // something went wrong
      throw Exception('Error code ${response.statusCode}');
    } on SocketException {
      throw Exception('No internet connection');
    } catch (e) {
      throw Exception('Failed to get manga by ids: $e');
    }
  }

  @override
  Future<ChapterList> getMangaChapters(String mangaId, int offset) async {
    try {
      final uri = Uri.https(
        baseUrl,
        '/manga/$mangaId/feed',
        {
          'offset': offset.toString(),
          'translatedLanguage[]': ['en', 'id'],
          'order[volume]': 'asc',
          'order[chapter]': 'asc',
        },
      );
      final response = await http.get(uri);

      // 200 ok response
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        final chapterJsons = json['data'] as List<dynamic>;
        final chapters =
            chapterJsons.map((json) => Chapter.fromJson(json)).toList();

        final currIndex = ((json['offset'] as int) / 100).round();
        final totalPage = ((json['total'] as int) / 100).ceil();

        final chapterList = ChapterList(
          chapters: chapters,
          currIndex: currIndex,
          totalPage: totalPage,
        );
        return chapterList;
      }

      // 503 server is down
      else if (response.statusCode == 503) {
        throw Exception('Server is currently down');
      }

      // something went wrong
      throw Exception('Error code ${response.statusCode}');
    } on SocketException {
      throw Exception('No internet connection');
    } catch (e) {
      throw Exception('Failed to get manga chapters: $e');
    }
  }

  @override
  Future<List<String>> getChapterImageUrls(String chapterId) async {
    try {
      final uri = Uri.https(
        baseUrl,
        '/at-home/server/$chapterId',
        {
          'forcePort443': 'true',
        },
      );
      final response = await http.get(uri);

      // 200 ok response
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final base = json['baseUrl'];
        final hash = json['chapter']['hash'];
        final fileNames = json['chapter']['dataSaver'] as List<dynamic>;

        final imageUrls = fileNames
            .map((fileName) => '$base/data-saver/$hash/$fileName')
            .toList();
        return imageUrls;
      }

      // 503 server is down
      else if (response.statusCode == 503) {
        throw Exception('Server is currently down');
      }

      // something went wrong
      throw Exception('Error code ${response.statusCode}');
    } on SocketException {
      throw Exception('No internet connection');
    } catch (e) {
      throw Exception('Failed to get chapter images: $e');
    }
  }
}
