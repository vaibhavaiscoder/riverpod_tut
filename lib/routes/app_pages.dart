import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_tut2/favoriteTasks.dart';
import 'package:riverpod_tut2/home_page.dart';
import 'package:riverpod_tut2/videoPlay/videoDetails.dart';
import 'package:riverpod_tut2/videoPlay/videoPlayer.dart';

import 'app_routes.dart';


final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: Routes.HOME,
    routes: [
      customPageRoute(Routes.HOME, HomePage()),
      customPageRoute(Routes.FAVORITES, FavoriteTasks()),
      customPageRoute(Routes.VIDEODETAILS, VideoDetailsPage()),
      customPageRouteWithExtra(Routes.VIDEOPLAYER, (state) {
        final videoUrl = state.extra as String;
        return VideoPlayPage(videoUrl: videoUrl);
      }),
    ],
  );
});

GoRoute customPageRoute(String path, Widget page) {
  return GoRoute(
    path: path,
    pageBuilder: (context, state) => CustomTransitionPage(
      key: state.pageKey,
      child: page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Fade Animation
        var fadeTween = Tween(begin: 0.0, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut));

        return FadeTransition(
          opacity: animation.drive(fadeTween),
          child: child,
        );
      },
    ),
  );
}

GoRoute customPageRouteWithExtra(String path, Widget Function(GoRouterState) builder) {
  return GoRoute(
    path: path,
    pageBuilder: (context, state) => CustomTransitionPage(
      key: state.pageKey,
      child: builder(state),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var fadeTween = Tween(begin: 0.0, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut));
        return FadeTransition(
          opacity: animation.drive(fadeTween),
          child: child,
        );
      },
    ),
  );
}