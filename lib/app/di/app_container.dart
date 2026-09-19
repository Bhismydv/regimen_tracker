import '../../data/database/app_database.dart';
import '../../data/repositories/habit_repository_impl.dart';
import '../../data/repositories/log_repository_impl.dart';

class AppContainer {
  late final AppDatabase database;

  late final HabitRepositoryImpl habitRepository;
  late final LogRepositoryImpl logRepository;

  AppContainer({AppDatabase? database}) {
    this.database = database ?? AppDatabase();

    habitRepository = HabitRepositoryImpl(this.database);
    logRepository = LogRepositoryImpl(this.database);
  }

  Future<void> dispose() => database.close();
}
