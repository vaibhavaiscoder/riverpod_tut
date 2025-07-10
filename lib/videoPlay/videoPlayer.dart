// import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/services.dart';
// import 'package:go_router/go_router.dart';
// import 'package:video_player/video_player.dart';
//
//
// class VideoPlayPage extends StatefulWidget {
//   final String videoUrl;
//   const VideoPlayPage({Key? key, required this.videoUrl,}) : super(key: key);
//
//   @override
//   _VideoPlayPageState createState() => _VideoPlayPageState();
// }
//
// class _VideoPlayPageState extends State<VideoPlayPage> {
//   late VideoPlayerController _controller;
//   late Future<void> _initializeVideoPlayerFuture;
//   bool _showControls = true; // Variable to track the visibility of controls
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.network(widget.videoUrl);
//     _initializeVideoPlayerFuture = _initializeVideoPlayer();
//   }
//
//   Future<void> _initializeVideoPlayer() async {
//     try {
//       await _controller.initialize();
//       _controller.pause();
//     } catch (error) {
//       print('Error initializing video player: $error');
//       // Handle error
//     }
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     // Lock orientation to landscape
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.landscapeRight,
//       DeviceOrientation.landscapeLeft,
//     ]);
//
//     return Scaffold(
//       body: Stack(
//         children: [
//           Center(
//             child: AspectRatio(
//               aspectRatio: _controller.value.aspectRatio,
//               child: GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       _showControls = !_showControls; // Toggle control visibility
//                     });
//                     if (_showControls) {
//                       SystemChrome.setEnabledSystemUIMode(
//                         SystemUiMode.manual,
//                         overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
//                       );
//                     } else {
//                       SystemChrome.setEnabledSystemUIMode(
//                         SystemUiMode.manual,
//                         overlays: [],
//                       );
//                     }
//                   },
//                   child: VideoPlayer(_controller)),
//             ),
//           ),
//           if (_showControls) // Show controls based on visibility flag
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: Container(
//                 height: 240,
//                 color: Colors.black.withOpacity(0.5),
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     Row(
//                       children: [
//                         ValueListenableBuilder(
//                           valueListenable: _controller,
//                           builder: (context, VideoPlayerValue value, child) {
//                             return Text(
//                               "${formatDuration(value.position)} / ${formatDuration(value.duration)}",
//                               style: TextStyle(color: Colors.white),
//                             );
//                           },
//                         ),
//                         SizedBox(width: 10,),
//                         Expanded(
//                           child: GestureDetector(
//                             onTapDown: (details) {
//                               final RenderBox box = context.findRenderObject() as RenderBox;
//                               final Offset tapPos = box.globalToLocal(details.globalPosition);
//                               final double relativePos = tapPos.dx / box.size.width;
//                               final Duration position = _controller.value.duration * relativePos;
//                               _controller.seekTo(position);
//                             },
//                             child: VideoProgressIndicator(
//                               _controller,
//                               allowScrubbing: true,
//                               padding: EdgeInsets.zero,
//                               colors: VideoProgressColors(
//                                 backgroundColor: Color(0xFF243771),
//                                 playedColor: Colors.blue,
//                                 bufferedColor: Colors.blueGrey,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         IconButton(
//                           onPressed: () {
//                             context.pop();
//                           },
//                           icon: Icon(
//                             Icons.arrow_back,
//                             color: Colors.white,
//                             size: 18,
//                           ),
//                         ),
//                         IconButton(
//                           onPressed: () {
//                             _controller.seekTo(Duration(
//                                 seconds:
//                                 _controller.value.position.inSeconds -
//                                     10));
//                           },
//                           icon: Icon(
//                             Icons.fast_rewind,
//                             color: Colors.white,
//                             size: 18,
//                           ),
//                         ),
//                         IconButton(
//                           onPressed: () {
//                             setState(() {
//                               if (_controller.value.isPlaying) {
//                                 _controller.pause();
//                               } else {
//                                 _controller.play();
//                               }
//                             });
//                           },
//                           icon: Icon(
//                             _controller.value.isPlaying
//                                 ? Icons.pause
//                                 : Icons.play_arrow,
//                             color: Colors.white,
//                             size: 18,
//                           ),
//                         ),
//                         IconButton(
//                           onPressed: () {
//                             _controller.seekTo(Duration(
//                                 seconds:
//                                 _controller.value.position.inSeconds +
//                                     10));
//                           },
//                           icon: Icon(
//                             Icons.fast_forward,
//                             color: Colors.white,
//                             size: 18,
//                           ),
//                         ),
//                         IconButton(
//                           onPressed: () {
//                             context.pop();
//                           },
//                           icon: Icon(
//                             Icons.fullscreen_exit,
//                             color: Colors.white,
//                             size: 18,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
//
//   String formatDuration(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, '0');
//     final hours = twoDigits(duration.inHours);
//     final minutes = twoDigits(duration.inMinutes.remainder(60));
//     final seconds = twoDigits(duration.inSeconds.remainder(60));
//     return "$hours:$minutes:$seconds";
//   }
//
//   @override
//   void dispose() {
//     // Unlock orientation when disposing the widget
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.portraitUp,
//       DeviceOrientation.portraitDown,
//     ]);
//
//     // SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
//
//     _controller.pause(); // Pause the video when disposing the widget
//     _controller.dispose();
//     super.dispose();
//   }
// }
