
import '../../domain/enums/habit_category.dart';
import '../../domain/enums/measurement_type.dart';
import '../../domain/enums/skin_condition_tag.dart';

class EnumMappers {
  // HabitCategory
  static String habitCategoryToString(HabitCategory category) =>
      category.name;

  static HabitCategory stringToHabitCategory(String value) =>
      HabitCategory.values.firstWhere((e) => e.name == value);

  // MeasurementType
  static String measurementTypeToString(MeasurementType type) =>
      type.name;

  static MeasurementType stringToMeasurementType(String value) =>
      MeasurementType.values.firstWhere((e) => e.name == value);

  // SkinConditionTag
  static String? skinTagToString(SkinConditionTag? tag) =>
      tag?.name;

  static SkinConditionTag? stringToSkinTag(String? value) =>
      value == null
          ? null
          : SkinConditionTag.values.firstWhere((e) => e.name == value);
}