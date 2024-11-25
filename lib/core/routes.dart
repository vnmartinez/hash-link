import 'package:flutter/material.dart';
import 'package:hash_link/views/decrypt/decrypt_view.dart';
import 'package:hash_link/views/initial/initial_view.dart';
import 'package:page_transition/page_transition.dart';

import '../views/encrypt/generate_key_view.dart';

class Routes {
  static const initialRoute = InitialView.route;

  static Map<String, WidgetBuilder> getRoutes({
    required RouteSettings settings,
  }) {
    final arguments = settings.arguments as RouteArguments?;
    assert((arguments == null) ^ (arguments is RouteArguments));

    return {
      InitialView.route: (context) => const InitialView(),
      GenerateKeyView.route: (context) => const GenerateKeyView(),
      DecryptView.route: (context) => const DecryptView(),
    };
  }

  static List<Route<dynamic>> onGenerateInitialRoutes(String routeName) {
    final settings = RouteSettings(name: routeName);
    final routes = getRoutes(settings: settings);
    return [
      MaterialPageRoute(
        settings: settings,
        builder: routes[routeName]!,
      )
    ];
  }

  static Route<dynamic>? onGenerateRoute(RouteSettings routeSettings) {
    final routes = getRoutes(settings: routeSettings);
    for (final entry in routes.entries) {
      if (entry.key == routeSettings.name) {
        final transitionType =
            routeSettings.routeArguments?.transitionType?.pageTransitionType;

        if (transitionType != null) {
          return PageTransition(
            child: Builder(builder: entry.value),
            type: transitionType,
            settings: routeSettings,
          );
        } else {
          return MaterialPageRoute(
            builder: entry.value,
            settings: routeSettings,
          );
        }
      }
    }

    return MaterialPageRoute(
      settings: routeSettings,
      builder: (context) => const Center(
        child: Text('Rota não encontrada.'),
      ),
    );
  }
}

enum RouteTransitionType {
  fade,
  leftToRight,
  rightToLeft,
  topToBottom,
  bottomToTop,
  scale,
  size,
  rotate,
  rightToLeftWithFade,
  leftToRightWithFade,
  leftToRightJoined,
  rightToLeftJoined,
  topToBottomJoined,
  bottomToTopJoined,
  leftToRightPop,
  rightToLeftPop,
  topToBottomPop,
  bottomToTopPop;
}

extension on RouteSettings {
  RouteArguments? get routeArguments {
    if (arguments is! RouteArguments) return null;
    return arguments as RouteArguments;
  }
}

extension on RouteTransitionType {
  PageTransitionType get pageTransitionType =>
      PageTransitionType.values.firstWhere((v) => v.name == name);
}

class RouteArguments<T extends Object> {
  final RouteTransitionType? transitionType;
  final T? data;

  const RouteArguments({this.transitionType, this.data});
}
