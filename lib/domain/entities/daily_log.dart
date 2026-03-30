import '../enums/skin_condition_tag.dart';

class DailyLog {
  final DateTime date;
  final String imagePath;
  final String? thumbnailPath;
  final String? notes;
  late SkinConditionTag? conditionTag;
  final double? irritationScore;
  final double? oilinessScore;

  DailyLog({
    required this.date,
    required this.imagePath,
    this.thumbnailPath,
    this.notes,
    this.conditionTag,
    this.irritationScore,
    this.oilinessScore,
  });
}