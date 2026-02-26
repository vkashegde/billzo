import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'config/theme/app_theme.dart';
import 'core/di/service_locator.dart';
import 'features/clients/domain/repositories/client_repository.dart';
import 'features/clients/presentation/cubit/client_cubit.dart';
import 'features/invoice/domain/usecases/delete_invoice.dart';
import 'features/invoice/domain/usecases/get_invoices.dart';
import 'features/invoice/domain/usecases/save_invoice.dart';
import 'features/invoice/presentation/cubit/invoice_cubit.dart';

class BillzoApp extends StatelessWidget {
  final GoRouter _router;

  const BillzoApp({super.key, required GoRouter router}) : _router = router;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<InvoiceCubit>(
          create: (_) => InvoiceCubit(
            getInvoices: sl<GetInvoices>(),
            saveInvoice: sl<SaveInvoice>(),
            deleteInvoice: sl<DeleteInvoice>(),
          ),
        ),
        BlocProvider<ClientCubit>(create: (_) => ClientCubit(sl<ClientRepository>())),
      ],
      child: MaterialApp.router(
        title: 'Billzo',
        theme: AppTheme.light,
        routerConfig: _router,
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          return Container(
            color: Colors.grey.shade200,
            child: Center(
              child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 400), child: child),
            ),
          );
        },
      ),
    );
  }
}
