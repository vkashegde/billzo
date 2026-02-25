import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../features/clients/data/datasources/client_local_data_source.dart';
import '../../features/clients/data/models/client_model.dart';
import '../../features/clients/data/repositories/client_repository_impl.dart';
import '../../features/clients/domain/repositories/client_repository.dart';
import '../../features/invoice/data/datasources/invoice_local_data_source.dart';
import '../../features/invoice/data/models/invoice_model.dart';
import '../../features/invoice/data/repositories/invoice_repository_impl.dart';
import '../../features/invoice/domain/repositories/invoice_repository.dart';
import '../../features/invoice/domain/usecases/delete_invoice.dart';
import '../../features/invoice/domain/usecases/get_invoices.dart';
import '../../features/invoice/domain/usecases/save_invoice.dart';
import '../network/connectivity_service.dart';
import '../sync/supabase_sync_service.dart';
import '../sync/sync_manager.dart';
import '../sync/sync_service.dart';

/// Global service locator for dependency injection.
final GetIt sl = GetIt.instance;

Future<void> initServiceLocator() async {
  // Hive boxes
  final invoiceBox = await Hive.openBox<InvoiceModel>(kInvoiceBoxName);
  final clientBox = await Hive.openBox<ClientModel>(kClientBoxName);
  final syncMetaBox = await Hive.openBox<dynamic>(kSyncMetaBoxName);

  // Core services
  sl.registerLazySingleton<ConnectivityService>(() => ConnectivityService());

  // Sync services
  sl.registerLazySingleton<SyncService>(() => SupabaseSyncService(syncMetaBox));
  sl.registerLazySingleton<SyncManager>(
    () => SyncManager(syncService: sl(), connectivityService: sl()),
  );

  // ==================== Invoice Feature ====================
  sl.registerLazySingleton<InvoiceLocalDataSource>(() => InvoiceLocalDataSourceImpl(invoiceBox));
  sl.registerLazySingleton<InvoiceRepository>(() => InvoiceRepositoryImpl(sl()));
  sl.registerLazySingleton<GetInvoices>(() => GetInvoices(sl()));
  sl.registerLazySingleton<SaveInvoice>(() => SaveInvoice(sl()));
  sl.registerLazySingleton<DeleteInvoice>(() => DeleteInvoice(sl()));

  // ==================== Client Feature ====================
  sl.registerLazySingleton<ClientLocalDataSource>(() => ClientLocalDataSourceImpl(clientBox));
  sl.registerLazySingleton<ClientRepository>(() => ClientRepositoryImpl(sl()));
}
