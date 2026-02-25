import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'src/app.dart';
import 'src/config/router/app_router.dart';
import 'src/core/di/service_locator.dart';
import 'src/core/sync/sync_manager.dart';
import 'src/features/clients/data/models/client_model.dart';
import 'src/features/invoice/data/models/invoice_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(InvoiceModelAdapter());
  Hive.registerAdapter(ClientModelAdapter());

  await initServiceLocator();

  // Initialize sync manager (listens for connectivity, schedules daily sync)
  sl<SyncManager>().init();

  runApp(BillzoApp(router: AppRouter.router));
}
