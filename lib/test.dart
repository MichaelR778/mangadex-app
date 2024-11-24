import 'package:flutter/material.dart';

class ManhwaChapterReader extends StatefulWidget {
  final List<String> imageUrls;

  const ManhwaChapterReader({
    super.key,
    required this.imageUrls,
  });

  @override
  State<ManhwaChapterReader> createState() => _ManhwaChapterReaderState();
}

class _ManhwaChapterReaderState extends State<ManhwaChapterReader> {
  // Keep track of loaded images
  final Map<int, bool> _loadedImages = {};
  // Viewport tracker
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_loadImagesInViewport);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadImagesInViewport() {
    // Pre-load images that are about to come into view
    final offset = _scrollController.offset;
    final viewportHeight = _scrollController.position.viewportDimension;

    // Calculate which images should be loaded based on scroll position
    final firstVisible =
        (offset / 500).floor().clamp(0, widget.imageUrls.length - 1);
    final lastVisible = ((offset + viewportHeight) / 500)
        .ceil()
        .clamp(0, widget.imageUrls.length - 1);

    // Mark nearby images for loading
    for (var i = firstVisible - 2; i <= lastVisible + 2; i++) {
      if (i >= 0 && i < widget.imageUrls.length) {
        _loadedImages[i] = true;
      }
    }

    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: widget.imageUrls.length,
      // Disable default ListView padding
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        return _ChapterImage(
          imageUrl: widget.imageUrls[index],
          // Only load image if it's marked for loading
          shouldLoad: _loadedImages[index] ?? false,
        );
      },
    );
  }
}

class _ChapterImage extends StatelessWidget {
  final String imageUrl;
  final bool shouldLoad;

  const _ChapterImage({
    super.key,
    required this.imageUrl,
    required this.shouldLoad,
  });

  @override
  Widget build(BuildContext context) {
    if (!shouldLoad) {
      // Return placeholder with estimated height
      return Container(
        width: double.infinity,
        height: 500, // Estimated average height
        color: Colors.grey[200],
      );
    }

    return Image.network(
      imageUrl,
      width: double.infinity,
      fit: BoxFit.fitWidth,
      // Enable gapless playback to prevent flicker
      gaplessPlayback: true,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (frame == null) {
          // Show shimmer loading effect
          return Container(
            width: double.infinity,
            height: 500,
            color: Colors.grey[200],
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        return child;
      },
      // Use error builder for failed loads
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: double.infinity,
          height: 500,
          color: Colors.grey[200],
          child: const Icon(Icons.error_outline, size: 32),
        );
      },
    );
  }
}
