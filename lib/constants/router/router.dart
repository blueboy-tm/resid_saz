import 'dart:typed_data';

import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:resid_saz/home/screens/home.dart';
import 'package:resid_saz/receipt/screens/receipt.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen();
      },
    ),
    GoRoute(
      path: '/receipt',
      builder: (BuildContext context, GoRouterState state) {
        return ReceiptScreen(
          image: state.extra as Uint8List,
        );
      },
    ),
  ],
);
