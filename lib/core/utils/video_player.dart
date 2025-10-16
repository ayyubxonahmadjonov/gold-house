import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoWidget extends StatefulWidget {
  final String url;

  const VideoWidget({
    super.key,
    required this.url,
  });

  @override
  State<VideoWidget> createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  VideoPlayerController? _controller;
  bool _isPlaying = false;
  bool _isInitialized = false;
  bool _isError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  Future<void> _initializeVideoPlayer() async {
    try {
      if (widget.url.isEmpty || !Uri.parse(widget.url).isAbsolute) {
        throw Exception('Invalid video URL: ${widget.url}');
      }

      _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.url),
        videoPlayerOptions: VideoPlayerOptions(
          mixWithOthers: true,
          allowBackgroundPlayback: false,
        ),
      );

      await _controller!.initialize();
      if (mounted) {
        setState(() {
          _isInitialized = true;
          _isError = false;
        });
        _controller!.addListener(_videoListener);
      }
    } catch (e, stackTrace) {
      if (mounted) {
        setState(() {
          _isError = true;
          _errorMessage = 'Error: $e';
          _isInitialized = false;
        });
        print('Video Player Error for URL ${widget.url}: $e\n$stackTrace');
      }
    }
  }

  void _videoListener() {
    if (mounted) {
      setState(() {
        _isPlaying = _controller?.value.isPlaying ?? false;
      });
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_videoListener);
    _controller?.pause();
    _controller?.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (!_isInitialized || _controller == null) return;

    setState(() {
      if (_controller!.value.isPlaying) {
        _controller!.pause();
      } else {
        _controller!.play();
      }
      _isPlaying = _controller!.value.isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final videoWidth = screenWidth * 0.9; // 90% of screen width

    if (_isError) {
      return Container(
        width: videoWidth,
        height: 300,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10), // Rounded corners for error
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 32),
            const SizedBox(height: 8),
            Text(
              _errorMessage,
              style: const TextStyle(color: Colors.red, fontSize: 12),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _initializeVideoPlayer,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (!_isInitialized || _controller == null) {
      return Container(
        width: videoWidth,
        height: 300,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10), // Rounded corners for loading
        ),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    return Container(
      width: videoWidth,
      height: 300,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10), // Outer container radius
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10), // Rounded corners for video
        child: AspectRatio(
          aspectRatio: _controller!.value.aspectRatio,
          child: Stack(
            alignment: Alignment.center,
            children: [
              VideoPlayer(_controller!),
              GestureDetector(
                onTap: _togglePlayPause,
                child: AnimatedOpacity(
                  opacity: _isPlaying ? 0.0 : 0.7,
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Icon(
                      _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: VideoProgressIndicator(
                    _controller!,
                    allowScrubbing: true,
                    colors: const VideoProgressColors(
                      playedColor: Colors.blue,
                      bufferedColor: Colors.grey,
                      backgroundColor: Colors.white30,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 4,
                right: 8,
                child: ValueListenableBuilder(
                  valueListenable: _controller!,
                  builder: (context, VideoPlayerValue value, child) {
                    return Text(
                      '${_formatDuration(value.position)} / ${_formatDuration(value.duration)}',
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return [
      if (hours > 0) twoDigits(hours),
      twoDigits(minutes),
      twoDigits(seconds),
    ].join(':');
  }
}