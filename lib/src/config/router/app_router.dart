import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/clients/presentation/pages/clients_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/invoice/domain/entities/invoice.dart';
import '../../features/invoice/presentation/cubit/invoice_cubit.dart';
import '../../features/invoice/presentation/cubit/invoice_state.dart';
import '../../features/invoice/presentation/pages/create_invoice_page.dart';
import '../../features/invoice/presentation/pages/invoice_list_page.dart';
import '../../features/invoice/presentation/pages/invoice_preview_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../shared/widgets/main_scaffold.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');

  static GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: DashboardPage.routePath,
    routes: <RouteBase>[
      // Create Invoice (full-screen, outside shell)
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: CreateInvoicePage.routePath,
        name: CreateInvoicePage.routeName,
        builder: (context, state) => const CreateInvoicePage(),
      ),

      // Invoice Preview (full-screen, outside shell)
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/invoices/preview/:id',
        name: InvoicePreviewPage.routeName,
        builder: (context, state) {
          // Check if invoice passed via extra
          final extraInvoice = state.extra as Invoice?;
          if (extraInvoice != null) {
            return InvoicePreviewPage(invoice: extraInvoice);
          }

          // Otherwise, find by ID from cubit state
          final invoiceId = state.pathParameters['id']!;
          final cubitState = context.read<InvoiceCubit>().state;
          if (cubitState is InvoiceLoaded) {
            final invoice = cubitState.invoices.firstWhere(
              (i) => i.id == invoiceId,
              orElse: () => throw Exception('Invoice not found'),
            );
            return InvoicePreviewPage(invoice: invoice);
          }

          // Fallback - should not happen in normal flow
          return Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: const Center(child: Text('Invoice not found')),
          );
        },
      ),

      // Main shell with bottom nav
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
