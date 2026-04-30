import '../../data/database/app_database.dart';
import '../../data/repositories/habit_repository_impl.dart';
import '../../data/repositories/log_repository_impl.dart';

class AppContainer {
  late final AppDatabase database;

  late final HabitRepositoryImpl habitRepository;
  late final LogRepositoryImpl logRepository;

  AppContainer() {
    database = AppDatabase();

    habitRepository = HabitRepositoryImpl(database);
    logRepository = LogRepositoryImpl(database);
  }

  void dispose() {
    database.close();
  }
}