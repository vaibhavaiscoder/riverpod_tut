import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_tut2/routes/app_routes.dart';
import 'package:riverpod_tut2/videoPlay/videoPlayer.dart';
import 'package:video_player/video_player.dart';
const String defaultVideoUrl = 'https://bharat-vanee-dev.s3.amazonaws.com/2f91cc4e-d707-4c9d-a90d-150f3ef7301a.trashed-1699966829-VID_20231015_141308.mp4';


class VideoDetailsPage extends StatefulWidget {
  const VideoDetailsPage({super.key});

  @override
  State<VideoDetailsPage> createState() => _VideoDetailsPageState();
}

class _VideoDetailsPageState extends State<VideoDetailsPage> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  bool isFullScreen = false;
  bool isMinimized = false;
  bool showControls = true;
  bool isPlaying = false;
  bool isMuted = false;
  double _currentSliderValue = 0.0;
  String _videoDuration = "00:00";
  String _currentPosition = "00:00";

  // For picture-in-picture mode
  Offset _pipPosition = const Offset(20, 100);
  final double _pipWidth = 150;
  final double _pipHeight = 100;


  // Sample video data
  List<Map<String, dynamic>> relatedVideos = [
    {
      'title': 'Physics Fundamentals',
      'url': defaultVideoUrl,
      'thumbnail': 'https://via.placeholder.com/300x200/4CAF50/FFFFFF?text=Physics',
      'duration': '15:30',
      'views': '2.1M',
      'uploadTime': '3 days ago'
    },
    {
      'title': 'Chemistry Basics',
      'url': defaultVideoUrl,
      'thumbnail': 'https://via.placeholder.com/300x200/FF5722/FFFFFF?text=Chemistry',
      'duration': '12:45',
      'views': '1.8M',
      'uploadTime': '1 week ago'
    },
    {
      'title': 'Mathematics Advanced',
      'url': defaultVideoUrl,
      'thumbnail': 'https://via.placeholder.com/300x200/2196F3/FFFFFF?text=Mathematics',
      'duration': '20:15',
      'views': '950K',
      'uploadTime': '2 days ago'
    },
    {
      'title': 'Biology Concepts',
      'url': defaultVideoUrl,
      'thumbnail': 'https://via.placeholder.com/300x200/9C27B0/FFFFFF?text=Biology',
      'duration': '18:22',
      'views': '1.5M',
      'uploadTime': '5 days ago'
    },
    {
      'title': 'History Lessons',
      'url': defaultVideoUrl,
      'thumbnail': 'https://via.placeholder.com/300x200/FF9800/FFFFFF?text=History',
      'duration': '25:10',
      'views': '800K',
      'uploadTime': '1 day ago'
    },
  ];
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(defaultVideoUrl));
    _initializeVideoPlayerFuture = _initializeVideoPlayer();

    // Add listener to the video player controller
    _controller.addListener(() {
      if (mounted) {
        setState(() {
          _currentSliderValue = _controller.value.position.inMilliseconds.toDouble();
          _currentPosition = _formatDuration(_controller.value.position);
          isPlaying = _controller.value.isPlaying;
        });
      }
    });

    // Hide controls after 3 seconds
    _hideControlsAfterDelay();
  }

  Future<void> _initializeVideoPlayer() async {
    try {
      await _controller.initialize();
      setState(() {
        _videoDuration = _formatDuration(_controller.value.duration);
      });
      _controller.pause();
    } catch (error) {
      print('Error initializing video player: $error');
      _controller.dispose();
      setState(() {
        _controller = VideoPlayerController.networkUrl(Uri.parse(''));
      });
    }
  }

  void _hideControlsAfterDelay() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && isPlaying) {
        setState(() {
          showControls = false;
        });
      }
    });
  }

  void _toggleControls() {
    setState(() {
      showControls = !showControls;
    });
    if (showControls) {
      _hideControlsAfterDelay();
    }
  }

  void _toggleFullScreen() {
    setState(() {
      isFullScreen = !isFullScreen;
    });

    if (isFullScreen) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    }
  }

  void _toggleMinimize() {
    setState(() {
      isMinimized = !isMinimized;
    });
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
    });
    _hideControlsAfterDelay();
  }

  void _toggleMute() {
    setState(() {
      isMuted = !isMuted;
      _controller.setVolume(isMuted ? 0.0 : 1.0);
    });
  }

  void _seekTo(double value) {
    _controller.seekTo(Duration(milliseconds: value.toInt()));
  }

  void _skipForward() {
    final currentPosition = _controller.value.position;
    final newPosition = currentPosition + const Duration(seconds: 10);
    _controller.seekTo(newPosition);
  }

  void _skipBackward() {
    final currentPosition = _controller.value.position;
    final newPosition = currentPosition - const Duration(seconds: 10);
    _controller.seekTo(newPosition);
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  Widget _buildVideoPlayer() {
    return Container(
      color: Colors.black,
      child: Stack(
        children: [
          // Video Player
          Center(
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
          ),

          // Loading indicator
          if (!_controller.value.isInitialized)
            const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),

          // Tap to show/hide controls
          GestureDetector(
            onTap: _toggleControls,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.transparent,
            ),
          ),

          // Video Controls Overlay
          if (showControls) _buildControlsOverlay(),
        ],
      ),
    );
  }

  Widget _buildControlsOverlay() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.7),
            Colors.transparent,
            Colors.transparent,
            Colors.black.withOpacity(0.7),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Top controls
          Positioned(
            top: 20,
            left: 10,
            right: 10,
            child: Row(
              children: [
                if (!isFullScreen)
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 24),
                  ),
                const Spacer(),
                if (!isFullScreen)
                  IconButton(
                    onPressed: _toggleMinimize,
                    icon: Icon(
                      isMinimized ? Icons.picture_in_picture_alt : Icons.picture_in_picture,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                IconButton(
                  onPressed: _toggleMute,
                  icon: Icon(
                    isMuted ? Icons.volume_off : Icons.volume_up,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                IconButton(
                  onPressed: _toggleFullScreen,
                  icon: Icon(
                    isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),

          // Center play/pause controls
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: _skipBackward,
                  icon: const Icon(Icons.replay_10, color: Colors.white, size: 36),
                ),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: _togglePlayPause,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                      size: 48,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                IconButton(
                  onPressed: _skipForward,
                  icon: const Icon(Icons.forward_10, color: Colors.white, size: 36),
                ),
              ],
            ),
          ),

          // Bottom controls
          Positioned(
            bottom: 20,
            left: 10,
            right: 10,
            child: Column(
              children: [
                // Progress bar
                Row(
                  children: [
                    Text(
                      _currentPosition,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    Expanded(
                      child: Slider(
                        value: _currentSliderValue,
                        min: 0.0,
                        max: _controller.value.duration.inMilliseconds.toDouble(),
                        onChanged: (value) {
                          setState(() {
                            _currentSliderValue = value;
                          });
                        },
                        onChangeEnd: _seekTo,
                        activeColor: Colors.red,
                        inactiveColor: Colors.white.withOpacity(0.3),
                      ),
                    ),
                    Text(
                      _videoDuration,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPictureInPicture() {
    return Positioned(
      left: _pipPosition.dx,
      top: _pipPosition.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            _pipPosition = Offset(
              _pipPosition.dx + details.delta.dx,
              _pipPosition.dy + details.delta.dy,
            );
          });
        },
        onTap: _toggleMinimize,
        child: Container(
          width: _pipWidth,
          height: _pipHeight,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              children: [
                AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
                Positioned(
                  top: 2,
                  right: 2,
                  child: GestureDetector(
                    onTap: () {
                      _controller.pause();
                      setState(() {
                        isMinimized = false;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isFullScreen) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: FutureBuilder(
          future: _initializeVideoPlayerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return _buildVideoPlayer();
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.blue.withOpacity(0.1),
      body: Stack(
        children: [
          ListView(
            children: [
              // Video Player Section
              SizedBox(
                width: double.infinity,
                height: isMinimized ? 0 : MediaQuery.of(context).size.height / 3,
                child: isMinimized
                    ? const SizedBox.shrink()
                    : FutureBuilder(
                  future: _initializeVideoPlayerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return _buildVideoPlayer();
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),

              // Video Information Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 4,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Video Title',
                      style: TextStyle(
                        color: Color(0xFF4F4F4F),
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.visibility, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          '1.2M views',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          '2 days ago',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(thickness: 1),
                    const SizedBox(height: 16),
                    const Text(
                      'Description',
                      style: TextStyle(
                        color: Color(0xFF4F4F4F),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'This is a sample video description. It contains information about the video content, what viewers can expect, and other relevant details.',
                      style: TextStyle(
                        color: Color(0xFF4F4F4F),
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Divider(thickness: 1),
                    const SizedBox(height: 16),

                    // Action buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildActionButton(Icons.thumb_up, 'Like', '1.2K'),
                        _buildActionButton(Icons.thumb_down, 'Dislike', '45'),
                        _buildActionButton(Icons.share, 'Share', ''),
                        _buildActionButton(Icons.download, 'Download', ''),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Related Videos Section
                    const Text(
                      'Related Videos',
                      style: TextStyle(
                        color: Color(0xFF4F4F4F),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Horizontal Video List
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: relatedVideos.length,
                        itemBuilder: (context, index) {
                          final video = relatedVideos[index];
                          return _buildVideoThumbnail(video, index);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Picture in Picture overlay
          if (isMinimized) _buildPictureInPicture(),
        ],
      ),
    );
  }

  Widget _buildVideoThumbnail(Map<String, dynamic> video, int index) {
    return GestureDetector(
      onTap: () => _playVideo(video['url']),
      child: Container(
        width: 180,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail with duration overlay
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 180,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: video['thumbnail'].startsWith('http')
                        ? Image.network(
                      video['thumbnail'],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.video_library,
                            size: 40,
                            color: Colors.grey,
                          ),
                        );
                      },
                    )
                        : Container(
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.video_library,
                        size: 40,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),

                // Play button overlay
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.black.withOpacity(0.3),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.play_circle_filled,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                ),

                // Duration badge
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      video['duration'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Video title
            Text(
              video['title'],
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4F4F4F),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 4),

            // Video info
            Row(
              children: [
                Icon(
                  Icons.visibility,
                  size: 12,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(
                  video['views'],
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '•',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    video['uploadTime'],
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  void _playVideo(String videoUrl) {
    _controller.pause();
    _controller.dispose();

    setState(() {
      _controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
      _initializeVideoPlayerFuture = _initializeVideoPlayer();
      _currentSliderValue = 0.0;
      _currentPosition = "00:00";
      isMinimized = false;
      showControls = true;
    });

    // Re-add listener for new controller
    _controller.addListener(() {
      if (mounted) {
        setState(() {
          _currentSliderValue = _controller.value.position.inMilliseconds.toDouble();
          _currentPosition = _formatDuration(_controller.value.position);
          isPlaying = _controller.value.isPlaying;
        });
      }
    });
  }
  Widget _buildActionButton(IconData icon, String label, String count) {
    return Column(
      children: [
        IconButton(
          onPressed: () {},
          icon: Icon(icon, color: Colors.grey[700]),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: 12,
          ),
        ),
        if (count.isNotEmpty)
          Text(
            count,
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 10,
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.pause();
    _controller.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }
}
