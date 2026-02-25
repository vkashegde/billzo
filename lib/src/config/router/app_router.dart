import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/clients/presentation/pages/clients_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/invoice/presentation/pages/invoice_list_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../shared/widgets/main_scaffold.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');

  static GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: DashboardPage.routePath,
    routes: <RouteBase>[
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainScaffold(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: GlobalKey<NavigatorState>(debugLabel: 'home'),
            routes: [
              GoRoute(
                path: DashboardPage.routePath,
                name: DashboardPage.routeName,
                builder: (context, state) => const DashboardPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: GlobalKey<NavigatorState>(debugLabel: 'invoices'),
            routes: [
              GoRoute(
                path: InvoiceListPage.routePath,
                name: InvoiceListPage.routeName,
                builder: (context, state) => const InvoiceListPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: GlobalKey<NavigatorState>(debugLabel: 'clients'),
            routes: [
              GoRoute(
                path: ClientsPage.routePath,
                name: ClientsPage.routeName,
                builder: (context, state) => const ClientsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: GlobalKey<NavigatorState>(debugLabel: 'profile'),
            routes: [
              GoRoute(
                path: ProfilePage.routePath,
                name: ProfilePage.routeName,
                builder: (context, state) => const ProfilePage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
