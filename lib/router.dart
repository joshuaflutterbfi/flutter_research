import 'package:flutter/material.dart';
import 'package:flutter_research/core/resources/router_string.dart';
import 'package:flutter_research/feature/chat_on_apps/chat_on_apps_screen.dart';
import 'package:flutter_research/feature/crash_analytics/crash_analytics.dart';
import 'package:flutter_research/feature/flutter_chart/flutter_chart_screen.dart';
import 'package:flutter_research/feature/liquid_animation/liquid_animation_screen.dart';
import 'package:flutter_research/feature/local_auth/local_auth_screen.dart';
import 'package:flutter_research/feature/pull_refresh/presentation/screen/pull_refresh_screen.dart';
import 'package:flutter_research/feature/slider/slider_screen.dart';
import 'package:flutter_research/feature/voice_to_text/vlice_to_text_screen.dart';
import 'package:flutter_research/home/screen/home_screen.dart';

class Routers {
  static Route<dynamic> generateRouter(RouteSettings settings) {
    switch (settings.name) {
      case '/local_auth_route':
        return PageRouteBuilder<dynamic>(
            pageBuilder: (_, __, ___) => LocalAuthScreen(),
            settings: RouteSettings(name: settings.name),
            transitionsBuilder: (_, Animation<double> a, __, Widget c) =>
                FadeTransition(
                  opacity: a,
                  child: c,
                ));

      case '/fl_route':
        return PageRouteBuilder<dynamic>(
            pageBuilder: (_, __, ___) => FlutterChartScreen(),
            settings: RouteSettings(name: settings.name),
            transitionsBuilder: (_, Animation<double> a, __, Widget c) =>
                FadeTransition(
                  opacity: a,
                  child: c,
                ));

      case '/animation_route':
        return PageRouteBuilder<dynamic>(
            pageBuilder: (_, __, ___) => LiquidAnimationScreen(),
            settings: RouteSettings(name: settings.name),
            transitionsBuilder: (_, Animation<double> a, __, Widget c) =>
                FadeTransition(
                  opacity: a,
                  child: c,
                ));

      case '/refresh_route':
        return PageRouteBuilder<dynamic>(
            pageBuilder: (_, __, ___) => PullRefrsehScreen(),
            settings: RouteSettings(name: settings.name),
            transitionsBuilder: (_, Animation<double> a, __, Widget c) =>
                FadeTransition(
                  opacity: a,
                  child: c,
                ));

      case '/slider_route':
        return PageRouteBuilder<dynamic>(
            pageBuilder: (_, __, ___) => SliderScreen(),
            settings: RouteSettings(name: settings.name),
            transitionsBuilder: (_, Animation<double> a, __, Widget c) =>
                FadeTransition(
                  opacity: a,
                  child: c,
                ));

      case '/voice_to_text':
        return PageRouteBuilder<dynamic>(
            pageBuilder: (_, __, ___) => VoiceToTextScreen(),
            settings: RouteSettings(name: settings.name),
            transitionsBuilder: (_, Animation<double> a, __, Widget c) =>
                FadeTransition(
                  opacity: a,
                  child: c,
                ));

      case '/chat_on_apps':
        return PageRouteBuilder<dynamic>(
            pageBuilder: (_, __, ___) => ChatOnAppsScreen(),
            settings: RouteSettings(name: settings.name),
            transitionsBuilder: (_, Animation<double> a, __, Widget c) =>
                FadeTransition(
                  opacity: a,
                  child: c,
                ));

      case '/home_route':
        return PageRouteBuilder<dynamic>(
            pageBuilder: (_, __, ___) => HomeScreen(),
            settings: RouteSettings(name: settings.name),
            transitionsBuilder: (_, Animation<double> a, __, Widget c) =>
                FadeTransition(
                  opacity: a,
                  child: c,
                ));

      case '/crashlytics_route':
        return PageRouteBuilder<dynamic>(
            pageBuilder: (_, __, ___) => CrashLyticsScreen(),
            settings: RouteSettings(name: settings.name),
            transitionsBuilder: (_, Animation<double> a, __, Widget c) =>
                FadeTransition(
                  opacity: a,
                  child: c,
                ));

      default:
        return MaterialPageRoute<dynamic>(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
