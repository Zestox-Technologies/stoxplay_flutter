import 'package:flutter/material.dart';

import 'app_component_base.dart';

/// A custom page route builder that adds a fade transition between pages.
class FadePageRouteBuilder<T> extends PageRouteBuilder<T> {
  /// The widget builder for the page to be displayed.
  final WidgetBuilder builder;

  /// The settings for this route.
  @override
  final RouteSettings settings;

  /// The duration of the fade transition.
  @override
  final Duration transitionDuration;

  /// The curve of the fade transition.
  final Curve transitionCurve;

  FadePageRouteBuilder({
    required this.builder,
    required this.settings,
    this.transitionDuration = const Duration(seconds: 1),
    this.transitionCurve = Curves.ease,
  }) : super(
         pageBuilder:
             (context, animation, secondaryAnimation) => builder(context),
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           // Define the tween for fade transition with the provided curve.
           final tween = Tween<double>(
             begin: 0.0,
             end: 1.0,
           ).chain(CurveTween(curve: transitionCurve));

           final fadeAnimation = animation.drive(tween);

           return FadeTransition(
             opacity: fadeAnimation,
             child: FutureBuilder<bool>(
               future: AppComponentBase().isConnected(),
               builder: (context, snapshot) {
                 return PopScope(
                   canPop: !(snapshot.data ?? false),
                   child: child,
                 );
               },
             ),
           );
         },
         transitionDuration: transitionDuration,
         settings: settings,
       );
}
