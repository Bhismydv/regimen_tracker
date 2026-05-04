// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $HabitsTable extends Habits with TableInfo<$HabitsTable, Habit> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HabitsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _measurementTypeMeta = const VerificationMeta(
    'measurementType',
  );
  @override
  late final GeneratedColumn<String> measurementType = GeneratedColumn<String>(
    'measurement_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _intensityScaleMaxMeta = const VerificationMeta(
    'intensityScaleMax',
  );
  @override
  late final GeneratedColumn<int> intensityScaleMax = GeneratedColumn<int>(
    'intensity_scale_max',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _colorValueMeta = const VerificationMeta(
    'colorValue',
  );
  @override
  late final GeneratedColumn<int> colorValue = GeneratedColumn<int>(
    'color_value',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    category,
    measurementType,
    intensityScaleMax,
    isActive,
    colorValue,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'habits';
  @override
  VerificationContext validateIntegrity(
    Insertable<Habit> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('measurement_type')) {
      context.handle(
        _measurementTypeMeta,
        measurementType.isAcceptableOrUnknown(
          data['measurement_type']!,
          _measurementTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_measurementTypeMeta);
    }
    if (data.containsKey('intensity_scale_max')) {
      context.handle(
        _intensityScaleMaxMeta,
        intensityScaleMax.isAcceptableOrUnknown(
          data['intensity_scale_max']!,
          _intensityScaleMaxMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_intensityScaleMaxMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('color_value')) {
      context.handle(
        _colorValueMeta,
        colorValue.isAcceptableOrUnknown(data['color_value']!, _colorValueMeta),
      );
    } else if (isInserting) {
      context.missing(_colorValueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Habit map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Habit(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      measurementType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}measurement_type'],
      )!,
      intensityScaleMax: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}intensity_scale_max'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      colorValue: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color_value'],
      )!,
    );
  }

  @override
  $HabitsTable createAlias(String alias) {
    return $HabitsTable(attachedDatabase, alias);
  }
}

class Habit extends DataClass implements Insertable<Habit> {
  final String id;
  final String name;
  final String category;
  final String measurementType;
  final int intensityScaleMax;
  final bool isActive;
  final int colorValue;
  const Habit({
    required this.id,
    required this.name,
    required this.category,
    required this.measurementType,
    required this.intensityScaleMax,
    required this.isActive,
    required this.colorValue,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['category'] = Variable<String>(category);
    map['measurement_type'] = Variable<String>(measurementType);
    map['intensity_scale_max'] = Variable<int>(intensityScaleMax);
    map['is_active'] = Variable<bool>(isActive);
    map['color_value'] = Variable<int>(colorValue);
    return map;
  }

  HabitsCompanion toCompanion(bool nullToAbsent) {
    return HabitsCompanion(
      id: Value(id),
      name: Value(name),
      category: Value(category),
      measurementType: Value(measurementType),
      intensityScaleMax: Value(intensityScaleMax),
      isActive: Value(isActive),
      colorValue: Value(colorValue),
    );
  }

  factory Habit.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Habit(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      category: serializer.fromJson<String>(json['category']),
      measurementType: serializer.fromJson<String>(json['measurementType']),
      intensityScaleMax: serializer.fromJson<int>(json['intensityScaleMax']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      colorValue: serializer.fromJson<int>(json['colorValue']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'category': serializer.toJson<String>(category),
      'measurementType': serializer.toJson<String>(measurementType),
      'intensityScaleMax': serializer.toJson<int>(intensityScaleMax),
      'isActive': serializer.toJson<bool>(isActive),
      'colorValue': serializer.toJson<int>(colorValue),
    };
  }

  Habit copyWith({
    String? id,
    String? name,
    String? category,
    String? measurementType,
    int? intensityScaleMax,
    bool? isActive,
    int? colorValue,
  }) => Habit(
    id: id ?? this.id,
    name: name ?? this.name,
    category: category ?? this.category,
    measurementType: measurementType ?? this.measurementType,
    intensityScaleMax: intensityScaleMax ?? this.intensityScaleMax,
    isActive: isActive ?? this.isActive,
    colorValue: colorValue ?? this.colorValue,
  );
  Habit copyWithCompanion(HabitsCompanion data) {
    return Habit(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      category: data.category.present ? data.category.value : this.category,
      measurementType: data.measurementType.present
          ? data.measurementType.value
          : this.measurementType,
      intensityScaleMax: data.intensityScaleMax.present
          ? data.intensityScaleMax.value
          : this.intensityScaleMax,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      colorValue: data.colorValue.present
          ? data.colorValue.value
          : this.colorValue,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Habit(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('measurementType: $measurementType, ')
          ..write('intensityScaleMax: $intensityScaleMax, ')
          ..write('isActive: $isActive, ')
          ..write('colorValue: $colorValue')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    category,
    measurementType,
    intensityScaleMax,
    isActive,
    colorValue,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Habit &&
          other.id == this.id &&
          other.name == this.name &&
          other.category == this.category &&
          other.measurementType == this.measurementType &&
          other.intensityScaleMax == this.intensityScaleMax &&
          other.isActive == this.isActive &&
          other.colorValue == this.colorValue);
}

class HabitsCompanion extends UpdateCompanion<Habit> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> category;
  final Value<String> measurementType;
  final Value<int> intensityScaleMax;
  final Value<bool> isActive;
  final Value<int> colorValue;
  final Value<int> rowid;
  const HabitsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.category = const Value.absent(),
    this.measurementType = const Value.absent(),
    this.intensityScaleMax = const Value.absent(),
    this.isActive = const Value.absent(),
    this.colorValue = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HabitsCompanion.insert({
    required String id,
    required String name,
    required String category,
    required String measurementType,
    required int intensityScaleMax,
    this.isActive = const Value.absent(),
    required int colorValue,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       category = Value(category),
       measurementType = Value(measurementType),
       intensityScaleMax = Value(intensityScaleMax),
       colorValue = Value(colorValue);
  static Insertable<Habit> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? category,
    Expression<String>? measurementType,
    Expression<int>? intensityScaleMax,
    Expression<bool>? isActive,
    Expression<int>? colorValue,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (category != null) 'category': category,
      if (measurementType != null) 'measurement_type': measurementType,
      if (intensityScaleMax != null) 'intensity_scale_max': intensityScaleMax,
      if (isActive != null) 'is_active': isActive,
      if (colorValue != null) 'color_value': colorValue,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HabitsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? category,
    Value<String>? measurementType,
    Value<int>? intensityScaleMax,
    Value<bool>? isActive,
    Value<int>? colorValue,
    Value<int>? rowid,
  }) {
    return HabitsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      measurementType: measurementType ?? this.measurementType,
      intensityScaleMax: intensityScaleMax ?? this.intensityScaleMax,
      isActive: isActive ?? this.isActive,
      colorValue: colorValue ?? this.colorValue,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (measurementType.present) {
      map['measurement_type'] = Variable<String>(measurementType.value);
    }
    if (intensityScaleMax.present) {
      map['intensity_scale_max'] = Variable<int>(intensityScaleMax.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (colorValue.present) {
      map['color_value'] = Variable<int>(colorValue.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HabitsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('measurementType: $measurementType, ')
          ..write('intensityScaleMax: $intensityScaleMax, ')
          ..write('isActive: $isActive, ')
          ..write('colorValue: $colorValue, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DailyLogsTable extends DailyLogs
    with TableInfo<$DailyLogsTable, DailyLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imagePathMeta = const VerificationMeta(
    'imagePath',
  );
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
    'image_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _thumbnailPathMeta = const VerificationMeta(
    'thumbnailPath',
  );
  @override
  late final GeneratedColumn<String> thumbnailPath = GeneratedColumn<String>(
    'thumbnail_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _conditionTagMeta = const VerificationMeta(
    'conditionTag',
  );
  @override
  late final GeneratedColumn<String> conditionTag = GeneratedColumn<String>(
    'condition_tag',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _irritationScoreMeta = const VerificationMeta(
    'irritationScore',
  );
  @override
  late final GeneratedColumn<double> irritationScore = GeneratedColumn<double>(
    'irritation_score',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _oilinessScoreMeta = const VerificationMeta(
    'oilinessScore',
  );
  @override
  late final GeneratedColumn<double> oilinessScore = GeneratedColumn<double>(
    'oiliness_score',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    date,
    imagePath,
    thumbnailPath,
    notes,
    conditionTag,
    irritationScore,
    oilinessScore,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailyLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('image_path')) {
      context.handle(
        _imagePathMeta,
        imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta),
      );
    } else if (isInserting) {
      context.missing(_imagePathMeta);
    }
    if (data.containsKey('thumbnail_path')) {
      context.handle(
        _thumbnailPathMeta,
        thumbnailPath.isAcceptableOrUnknown(
          data['thumbnail_path']!,
          _thumbnailPathMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('condition_tag')) {
      context.handle(
        _conditionTagMeta,
        conditionTag.isAcceptableOrUnknown(
          data['condition_tag']!,
          _conditionTagMeta,
        ),
      );
    }
    if (data.containsKey('irritation_score')) {
      context.handle(
        _irritationScoreMeta,
        irritationScore.isAcceptableOrUnknown(
          data['irritation_score']!,
          _irritationScoreMeta,
        ),
      );
    }
    if (data.containsKey('oiliness_score')) {
      context.handle(
        _oilinessScoreMeta,
        oilinessScore.isAcceptableOrUnknown(
          data['oiliness_score']!,
          _oilinessScoreMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {date};
  @override
  DailyLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyLog(
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      imagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_path'],
      )!,
      thumbnailPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}thumbnail_path'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      conditionTag: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}condition_tag'],
      ),
      irritationScore: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}irritation_score'],
      ),
      oilinessScore: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}oiliness_score'],
      ),
    );
  }

  @override
  $DailyLogsTable createAlias(String alias) {
    return $DailyLogsTable(attachedDatabase, alias);
  }
}

class DailyLog extends DataClass implements Insertable<DailyLog> {
  final DateTime date;
  final String imagePath;
  final String? thumbnailPath;
  final String? notes;
  final String? conditionTag;
  final double? irritationScore;
  final double? oilinessScore;
  const DailyLog({
    required this.date,
    required this.imagePath,
    this.thumbnailPath,
    this.notes,
    this.conditionTag,
    this.irritationScore,
    this.oilinessScore,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['date'] = Variable<DateTime>(date);
    map['image_path'] = Variable<String>(imagePath);
    if (!nullToAbsent || thumbnailPath != null) {
      map['thumbnail_path'] = Variable<String>(thumbnailPath);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || conditionTag != null) {
      map['condition_tag'] = Variable<String>(conditionTag);
    }
    if (!nullToAbsent || irritationScore != null) {
      map['irritation_score'] = Variable<double>(irritationScore);
    }
    if (!nullToAbsent || oilinessScore != null) {
      map['oiliness_score'] = Variable<double>(oilinessScore);
    }
    return map;
  }

  DailyLogsCompanion toCompanion(bool nullToAbsent) {
    return DailyLogsCompanion(
      date: Value(date),
      imagePath: Value(imagePath),
      thumbnailPath: thumbnailPath == null && nullToAbsent
          ? const Value.absent()
          : Value(thumbnailPath),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      conditionTag: conditionTag == null && nullToAbsent
          ? const Value.absent()
          : Value(conditionTag),
      irritationScore: irritationScore == null && nullToAbsent
          ? const Value.absent()
          : Value(irritationScore),
      oilinessScore: oilinessScore == null && nullToAbsent
          ? const Value.absent()
          : Value(oilinessScore),
    );
  }

  factory DailyLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyLog(
      date: serializer.fromJson<DateTime>(json['date']),
      imagePath: serializer.fromJson<String>(json['imagePath']),
      thumbnailPath: serializer.fromJson<String?>(json['thumbnailPath']),
      notes: serializer.fromJson<String?>(json['notes']),
      conditionTag: serializer.fromJson<String?>(json['conditionTag']),
      irritationScore: serializer.fromJson<double?>(json['irritationScore']),
      oilinessScore: serializer.fromJson<double?>(json['oilinessScore']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'date': serializer.toJson<DateTime>(date),
      'imagePath': serializer.toJson<String>(imagePath),
      'thumbnailPath': serializer.toJson<String?>(thumbnailPath),
      'notes': serializer.toJson<String?>(notes),
      'conditionTag': serializer.toJson<String?>(conditionTag),
      'irritationScore': serializer.toJson<double?>(irritationScore),
      'oilinessScore': serializer.toJson<double?>(oilinessScore),
    };
  }

  DailyLog copyWith({
    DateTime? date,
    String? imagePath,
    Value<String?> thumbnailPath = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    Value<String?> conditionTag = const Value.absent(),
    Value<double?> irritationScore = const Value.absent(),
    Value<double?> oilinessScore = const Value.absent(),
  }) => DailyLog(
    date: date ?? this.date,
    imagePath: imagePath ?? this.imagePath,
    thumbnailPath: thumbnailPath.present
        ? thumbnailPath.value
        : this.thumbnailPath,
    notes: notes.present ? notes.value : this.notes,
    conditionTag: conditionTag.present ? conditionTag.value : this.conditionTag,
    irritationScore: irritationScore.present
        ? irritationScore.value
        : this.irritationScore,
    oilinessScore: oilinessScore.present
        ? oilinessScore.value
        : this.oilinessScore,
  );
  DailyLog copyWithCompanion(DailyLogsCompanion data) {
    return DailyLog(
      date: data.date.present ? data.date.value : this.date,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      thumbnailPath: data.thumbnailPath.present
          ? data.thumbnailPath.value
          : this.thumbnailPath,
      notes: data.notes.present ? data.notes.value : this.notes,
      conditionTag: data.conditionTag.present
          ? data.conditionTag.value
          : this.conditionTag,
      irritationScore: data.irritationScore.present
          ? data.irritationScore.value
          : this.irritationScore,
      oilinessScore: data.oilinessScore.present
          ? data.oilinessScore.value
          : this.oilinessScore,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyLog(')
          ..write('date: $date, ')
          ..write('imagePath: $imagePath, ')
          ..write('thumbnailPath: $thumbnailPath, ')
          ..write('notes: $notes, ')
          ..write('conditionTag: $conditionTag, ')
          ..write('irritationScore: $irritationScore, ')
          ..write('oilinessScore: $oilinessScore')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    date,
    imagePath,
    thumbnailPath,
    notes,
    conditionTag,
    irritationScore,
    oilinessScore,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyLog &&
          other.date == this.date &&
          other.imagePath == this.imagePath &&
          other.thumbnailPath == this.thumbnailPath &&
          other.notes == this.notes &&
          other.conditionTag == this.conditionTag &&
          other.irritationScore == this.irritationScore &&
          other.oilinessScore == this.oilinessScore);
}

class DailyLogsCompanion extends UpdateCompanion<DailyLog> {
  final Value<DateTime> date;
  final Value<String> imagePath;
  final Value<String?> thumbnailPath;
  final Value<String?> notes;
  final Value<String?> conditionTag;
  final Value<double?> irritationScore;
  final Value<double?> oilinessScore;
  final Value<int> rowid;
  const DailyLogsCompanion({
    this.date = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.thumbnailPath = const Value.absent(),
    this.notes = const Value.absent(),
    this.conditionTag = const Value.absent(),
    this.irritationScore = const Value.absent(),
    this.oilinessScore = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DailyLogsCompanion.insert({
    required DateTime date,
    required String imagePath,
    this.thumbnailPath = const Value.absent(),
    this.notes = const Value.absent(),
    this.conditionTag = const Value.absent(),
    this.irritationScore = const Value.absent(),
    this.oilinessScore = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : date = Value(date),
       imagePath = Value(imagePath);
  static Insertable<DailyLog> custom({
    Expression<DateTime>? date,
    Expression<String>? imagePath,
    Expression<String>? thumbnailPath,
    Expression<String>? notes,
    Expression<String>? conditionTag,
    Expression<double>? irritationScore,
    Expression<double>? oilinessScore,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (date != null) 'date': date,
      if (imagePath != null) 'image_path': imagePath,
      if (thumbnailPath != null) 'thumbnail_path': thumbnailPath,
      if (notes != null) 'notes': notes,
      if (conditionTag != null) 'condition_tag': conditionTag,
      if (irritationScore != null) 'irritation_score': irritationScore,
      if (oilinessScore != null) 'oiliness_score': oilinessScore,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DailyLogsCompanion copyWith({
    Value<DateTime>? date,
    Value<String>? imagePath,
    Value<String?>? thumbnailPath,
    Value<String?>? notes,
    Value<String?>? conditionTag,
    Value<double?>? irritationScore,
    Value<double?>? oilinessScore,
    Value<int>? rowid,
  }) {
    return DailyLogsCompanion(
      date: date ?? this.date,
      imagePath: imagePath ?? this.imagePath,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      notes: notes ?? this.notes,
      conditionTag: conditionTag ?? this.conditionTag,
      irritationScore: irritationScore ?? this.irritationScore,
      oilinessScore: oilinessScore ?? this.oilinessScore,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (thumbnailPath.present) {
      map['thumbnail_path'] = Variable<String>(thumbnailPath.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (conditionTag.present) {
      map['condition_tag'] = Variable<String>(conditionTag.value);
    }
    if (irritationScore.present) {
      map['irritation_score'] = Variable<double>(irritationScore.value);
    }
    if (oilinessScore.present) {
      map['oiliness_score'] = Variable<double>(oilinessScore.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyLogsCompanion(')
          ..write('date: $date, ')
          ..write('imagePath: $imagePath, ')
          ..write('thumbnailPath: $thumbnailPath, ')
          ..write('notes: $notes, ')
          ..write('conditionTag: $conditionTag, ')
          ..write('irritationScore: $irritationScore, ')
          ..write('oilinessScore: $oilinessScore, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HabitLogEntriesTable extends HabitLogEntries
    with TableInfo<$HabitLogEntriesTable, HabitLogEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HabitLogEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _habitIdMeta = const VerificationMeta(
    'habitId',
  );
  @override
  late final GeneratedColumn<String> habitId = GeneratedColumn<String>(
    'habit_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES habits (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _logDateMeta = const VerificationMeta(
    'logDate',
  );
  @override
  late final GeneratedColumn<DateTime> logDate = GeneratedColumn<DateTime>(
    'log_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES daily_logs (date) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<double> value = GeneratedColumn<double>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, habitId, logDate, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'habit_log_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<HabitLogEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('habit_id')) {
      context.handle(
        _habitIdMeta,
        habitId.isAcceptableOrUnknown(data['habit_id']!, _habitIdMeta),
      );
    } else if (isInserting) {
      context.missing(_habitIdMeta);
    }
    if (data.containsKey('log_date')) {
      context.handle(
        _logDateMeta,
        logDate.isAcceptableOrUnknown(data['log_date']!, _logDateMeta),
      );
    } else if (isInserting) {
      context.missing(_logDateMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HabitLogEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HabitLogEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      habitId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}habit_id'],
      )!,
      logDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}log_date'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $HabitLogEntriesTable createAlias(String alias) {
    return $HabitLogEntriesTable(attachedDatabase, alias);
  }
}

class HabitLogEntry extends DataClass implements Insertable<HabitLogEntry> {
  final String id;
  final String habitId;
  final DateTime logDate;
  final double value;
  const HabitLogEntry({
    required this.id,
    required this.habitId,
    required this.logDate,
    required this.value,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['habit_id'] = Variable<String>(habitId);
    map['log_date'] = Variable<DateTime>(logDate);
    map['value'] = Variable<double>(value);
    return map;
  }

  HabitLogEntriesCompanion toCompanion(bool nullToAbsent) {
    return HabitLogEntriesCompanion(
      id: Value(id),
      habitId: Value(habitId),
      logDate: Value(logDate),
      value: Value(value),
    );
  }

  factory HabitLogEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HabitLogEntry(
      id: serializer.fromJson<String>(json['id']),
      habitId: serializer.fromJson<String>(json['habitId']),
      logDate: serializer.fromJson<DateTime>(json['logDate']),
      value: serializer.fromJson<double>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'habitId': serializer.toJson<String>(habitId),
      'logDate': serializer.toJson<DateTime>(logDate),
      'value': serializer.toJson<double>(value),
    };
  }

  HabitLogEntry copyWith({
    String? id,
    String? habitId,
    DateTime? logDate,
    double? value,
  }) => HabitLogEntry(
    id: id ?? this.id,
    habitId: habitId ?? this.habitId,
    logDate: logDate ?? this.logDate,
    value: value ?? this.value,
  );
  HabitLogEntry copyWithCompanion(HabitLogEntriesCompanion data) {
    return HabitLogEntry(
      id: data.id.present ? data.id.value : this.id,
      habitId: data.habitId.present ? data.habitId.value : this.habitId,
      logDate: data.logDate.present ? data.logDate.value : this.logDate,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HabitLogEntry(')
          ..write('id: $id, ')
          ..write('habitId: $habitId, ')
          ..write('logDate: $logDate, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, habitId, logDate, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HabitLogEntry &&
          other.id == this.id &&
          other.habitId == this.habitId &&
          other.logDate == this.logDate &&
          other.value == this.value);
}

class HabitLogEntriesCompanion extends UpdateCompanion<HabitLogEntry> {
  final Value<String> id;
  final Value<String> habitId;
  final Value<DateTime> logDate;
  final Value<double> value;
  final Value<int> rowid;
  const HabitLogEntriesCompanion({
    this.id = const Value.absent(),
    this.habitId = const Value.absent(),
    this.logDate = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HabitLogEntriesCompanion.insert({
    required String id,
    required String habitId,
    required DateTime logDate,
    required double value,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       habitId = Value(habitId),
       logDate = Value(logDate),
       value = Value(value);
  static Insertable<HabitLogEntry> custom({
    Expression<String>? id,
    Expression<String>? habitId,
    Expression<DateTime>? logDate,
    Expression<double>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (habitId != null) 'habit_id': habitId,
      if (logDate != null) 'log_date': logDate,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HabitLogEntriesCompanion copyWith({
    Value<String>? id,
    Value<String>? habitId,
    Value<DateTime>? logDate,
    Value<double>? value,
    Value<int>? rowid,
  }) {
    return HabitLogEntriesCompanion(
      id: id ?? this.id,
      habitId: habitId ?? this.habitId,
      logDate: logDate ?? this.logDate,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (habitId.present) {
      map['habit_id'] = Variable<String>(habitId.value);
    }
    if (logDate.present) {
      map['log_date'] = Variable<DateTime>(logDate.value);
    }
    if (value.present) {
      map['value'] = Variable<double>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HabitLogEntriesCompanion(')
          ..write('id: $id, ')
          ..write('habitId: $habitId, ')
          ..write('logDate: $logDate, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $HabitsTable habits = $HabitsTable(this);
  late final $DailyLogsTable dailyLogs = $DailyLogsTable(this);
  late final $HabitLogEntriesTable habitLogEntries = $HabitLogEntriesTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    habits,
    dailyLogs,
    habitLogEntries,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'habits',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('habit_log_entries', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'daily_logs',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('habit_log_entries', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$HabitsTableCreateCompanionBuilder =
    HabitsCompanion Function({
      required String id,
      required String name,
      required String category,
      required String measurementType,
      required int intensityScaleMax,
      Value<bool> isActive,
      required int colorValue,
      Value<int> rowid,
    });
typedef $$HabitsTableUpdateCompanionBuilder =
    HabitsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> category,
      Value<String> measurementType,
      Value<int> intensityScaleMax,
      Value<bool> isActive,
      Value<int> colorValue,
      Value<int> rowid,
    });

final class $$HabitsTableReferences
    extends BaseReferences<_$AppDatabase, $HabitsTable, Habit> {
  $$HabitsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$HabitLogEntriesTable, List<HabitLogEntry>>
  _habitLogEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.habitLogEntries,
    aliasName: $_aliasNameGenerator(db.habits.id, db.habitLogEntries.habitId),
  );

  $$HabitLogEntriesTableProcessedTableManager get habitLogEntriesRefs {
    final manager = $$HabitLogEntriesTableTableManager(
      $_db,
      $_db.habitLogEntries,
    ).filter((f) => f.habitId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _habitLogEntriesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$HabitsTableFilterComposer
    extends Composer<_$AppDatabase, $HabitsTable> {
  $$HabitsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get measurementType => $composableBuilder(
    column: $table.measurementType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get intensityScaleMax => $composableBuilder(
    column: $table.intensityScaleMax,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> habitLogEntriesRefs(
    Expression<bool> Function($$HabitLogEntriesTableFilterComposer f) f,
  ) {
    final $$HabitLogEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.habitLogEntries,
      getReferencedColumn: (t) => t.habitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitLogEntriesTableFilterComposer(
            $db: $db,
            $table: $db.habitLogEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$HabitsTableOrderingComposer
    extends Composer<_$AppDatabase, $HabitsTable> {
  $$HabitsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get measurementType => $composableBuilder(
    column: $table.measurementType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get intensityScaleMax => $composableBuilder(
    column: $table.intensityScaleMax,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HabitsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HabitsTable> {
  $$HabitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get measurementType => $composableBuilder(
    column: $table.measurementType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get intensityScaleMax => $composableBuilder(
    column: $table.intensityScaleMax,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => column,
  );

  Expression<T> habitLogEntriesRefs<T extends Object>(
    Expression<T> Function($$HabitLogEntriesTableAnnotationComposer a) f,
  ) {
    final $$HabitLogEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.habitLogEntries,
      getReferencedColumn: (t) => t.habitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitLogEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.habitLogEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$HabitsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HabitsTable,
          Habit,
          $$HabitsTableFilterComposer,
          $$HabitsTableOrderingComposer,
          $$HabitsTableAnnotationComposer,
          $$HabitsTableCreateCompanionBuilder,
          $$HabitsTableUpdateCompanionBuilder,
          (Habit, $$HabitsTableReferences),
          Habit,
          PrefetchHooks Function({bool habitLogEntriesRefs})
        > {
  $$HabitsTableTableManager(_$AppDatabase db, $HabitsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HabitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HabitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HabitsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> measurementType = const Value.absent(),
                Value<int> intensityScaleMax = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> colorValue = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HabitsCompanion(
                id: id,
                name: name,
                category: category,
                measurementType: measurementType,
                intensityScaleMax: intensityScaleMax,
                isActive: isActive,
                colorValue: colorValue,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String category,
                required String measurementType,
                required int intensityScaleMax,
                Value<bool> isActive = const Value.absent(),
                required int colorValue,
                Value<int> rowid = const Value.absent(),
              }) => HabitsCompanion.insert(
                id: id,
                name: name,
                category: category,
                measurementType: measurementType,
                intensityScaleMax: intensityScaleMax,
                isActive: isActive,
                colorValue: colorValue,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$HabitsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({habitLogEntriesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (habitLogEntriesRefs) db.habitLogEntries,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (habitLogEntriesRefs)
                    await $_getPrefetchedData<
                      Habit,
                      $HabitsTable,
                      HabitLogEntry
                    >(
                      currentTable: table,
                      referencedTable: $$HabitsTableReferences
                          ._habitLogEntriesRefsTable(db),
                      managerFromTypedResult: (p0) => $$HabitsTableReferences(
                        db,
                        table,
                        p0,
                      ).habitLogEntriesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.habitId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$HabitsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HabitsTable,
      Habit,
      $$HabitsTableFilterComposer,
      $$HabitsTableOrderingComposer,
      $$HabitsTableAnnotationComposer,
      $$HabitsTableCreateCompanionBuilder,
      $$HabitsTableUpdateCompanionBuilder,
      (Habit, $$HabitsTableReferences),
      Habit,
      PrefetchHooks Function({bool habitLogEntriesRefs})
    >;
typedef $$DailyLogsTableCreateCompanionBuilder =
    DailyLogsCompanion Function({
      required DateTime date,
      required String imagePath,
      Value<String?> thumbnailPath,
      Value<String?> notes,
      Value<String?> conditionTag,
      Value<double?> irritationScore,
      Value<double?> oilinessScore,
      Value<int> rowid,
    });
typedef $$DailyLogsTableUpdateCompanionBuilder =
    DailyLogsCompanion Function({
      Value<DateTime> date,
      Value<String> imagePath,
      Value<String?> thumbnailPath,
      Value<String?> notes,
      Value<String?> conditionTag,
      Value<double?> irritationScore,
      Value<double?> oilinessScore,
      Value<int> rowid,
    });

final class $$DailyLogsTableReferences
    extends BaseReferences<_$AppDatabase, $DailyLogsTable, DailyLog> {
  $$DailyLogsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$HabitLogEntriesTable, List<HabitLogEntry>>
  _habitLogEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.habitLogEntries,
    aliasName: $_aliasNameGenerator(
      db.dailyLogs.date,
      db.habitLogEntries.logDate,
    ),
  );

  $$HabitLogEntriesTableProcessedTableManager get habitLogEntriesRefs {
    final manager = $$HabitLogEntriesTableTableManager(
      $_db,
      $_db.habitLogEntries,
    ).filter((f) => f.logDate.date.sqlEquals($_itemColumn<DateTime>('date')!));

    final cache = $_typedResult.readTableOrNull(
      _habitLogEntriesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$DailyLogsTableFilterComposer
    extends Composer<_$AppDatabase, $DailyLogsTable> {
  $$DailyLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get thumbnailPath => $composableBuilder(
    column: $table.thumbnailPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get conditionTag => $composableBuilder(
    column: $table.conditionTag,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get irritationScore => $composableBuilder(
    column: $table.irritationScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get oilinessScore => $composableBuilder(
    column: $table.oilinessScore,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> habitLogEntriesRefs(
    Expression<bool> Function($$HabitLogEntriesTableFilterComposer f) f,
  ) {
    final $$HabitLogEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.date,
      referencedTable: $db.habitLogEntries,
      getReferencedColumn: (t) => t.logDate,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitLogEntriesTableFilterComposer(
            $db: $db,
            $table: $db.habitLogEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DailyLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyLogsTable> {
  $$DailyLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get thumbnailPath => $composableBuilder(
    column: $table.thumbnailPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get conditionTag => $composableBuilder(
    column: $table.conditionTag,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get irritationScore => $composableBuilder(
    column: $table.irritationScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get oilinessScore => $composableBuilder(
    column: $table.oilinessScore,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DailyLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyLogsTable> {
  $$DailyLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  GeneratedColumn<String> get thumbnailPath => $composableBuilder(
    column: $table.thumbnailPath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get conditionTag => $composableBuilder(
    column: $table.conditionTag,
    builder: (column) => column,
  );

  GeneratedColumn<double> get irritationScore => $composableBuilder(
    column: $table.irritationScore,
    builder: (column) => column,
  );

  GeneratedColumn<double> get oilinessScore => $composableBuilder(
    column: $table.oilinessScore,
    builder: (column) => column,
  );

  Expression<T> habitLogEntriesRefs<T extends Object>(
    Expression<T> Function($$HabitLogEntriesTableAnnotationComposer a) f,
  ) {
    final $$HabitLogEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.date,
      referencedTable: $db.habitLogEntries,
      getReferencedColumn: (t) => t.logDate,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitLogEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.habitLogEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DailyLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DailyLogsTable,
          DailyLog,
          $$DailyLogsTableFilterComposer,
          $$DailyLogsTableOrderingComposer,
          $$DailyLogsTableAnnotationComposer,
          $$DailyLogsTableCreateCompanionBuilder,
          $$DailyLogsTableUpdateCompanionBuilder,
          (DailyLog, $$DailyLogsTableReferences),
          DailyLog,
          PrefetchHooks Function({bool habitLogEntriesRefs})
        > {
  $$DailyLogsTableTableManager(_$AppDatabase db, $DailyLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<DateTime> date = const Value.absent(),
                Value<String> imagePath = const Value.absent(),
                Value<String?> thumbnailPath = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> conditionTag = const Value.absent(),
                Value<double?> irritationScore = const Value.absent(),
                Value<double?> oilinessScore = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailyLogsCompanion(
                date: date,
                imagePath: imagePath,
                thumbnailPath: thumbnailPath,
                notes: notes,
                conditionTag: conditionTag,
                irritationScore: irritationScore,
                oilinessScore: oilinessScore,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required DateTime date,
                required String imagePath,
                Value<String?> thumbnailPath = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> conditionTag = const Value.absent(),
                Value<double?> irritationScore = const Value.absent(),
                Value<double?> oilinessScore = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailyLogsCompanion.insert(
                date: date,
                imagePath: imagePath,
                thumbnailPath: thumbnailPath,
                notes: notes,
                conditionTag: conditionTag,
                irritationScore: irritationScore,
                oilinessScore: oilinessScore,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DailyLogsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({habitLogEntriesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (habitLogEntriesRefs) db.habitLogEntries,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (habitLogEntriesRefs)
                    await $_getPrefetchedData<
                      DailyLog,
                      $DailyLogsTable,
                      HabitLogEntry
                    >(
                      currentTable: table,
                      referencedTable: $$DailyLogsTableReferences
                          ._habitLogEntriesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$DailyLogsTableReferences(
                            db,
                            table,
                            p0,
                          ).habitLogEntriesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.logDate == item.date),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$DailyLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DailyLogsTable,
      DailyLog,
      $$DailyLogsTableFilterComposer,
      $$DailyLogsTableOrderingComposer,
      $$DailyLogsTableAnnotationComposer,
      $$DailyLogsTableCreateCompanionBuilder,
      $$DailyLogsTableUpdateCompanionBuilder,
      (DailyLog, $$DailyLogsTableReferences),
      DailyLog,
      PrefetchHooks Function({bool habitLogEntriesRefs})
    >;
typedef $$HabitLogEntriesTableCreateCompanionBuilder =
    HabitLogEntriesCompanion Function({
      required String id,
      required String habitId,
      required DateTime logDate,
      required double value,
      Value<int> rowid,
    });
typedef $$HabitLogEntriesTableUpdateCompanionBuilder =
    HabitLogEntriesCompanion Function({
      Value<String> id,
      Value<String> habitId,
      Value<DateTime> logDate,
      Value<double> value,
      Value<int> rowid,
    });

final class $$HabitLogEntriesTableReferences
    extends
        BaseReferences<_$AppDatabase, $HabitLogEntriesTable, HabitLogEntry> {
  $$HabitLogEntriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $HabitsTable _habitIdTable(_$AppDatabase db) => db.habits.createAlias(
    $_aliasNameGenerator(db.habitLogEntries.habitId, db.habits.id),
  );

  $$HabitsTableProcessedTableManager get habitId {
    final $_column = $_itemColumn<String>('habit_id')!;

    final manager = $$HabitsTableTableManager(
      $_db,
      $_db.habits,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_habitIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $DailyLogsTable _logDateTable(_$AppDatabase db) =>
      db.dailyLogs.createAlias(
        $_aliasNameGenerator(db.habitLogEntries.logDate, db.dailyLogs.date),
      );

  $$DailyLogsTableProcessedTableManager get logDate {
    final $_column = $_itemColumn<DateTime>('log_date')!;

    final manager = $$DailyLogsTableTableManager(
      $_db,
      $_db.dailyLogs,
    ).filter((f) => f.date.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_logDateTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$HabitLogEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $HabitLogEntriesTable> {
  $$HabitLogEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  $$HabitsTableFilterComposer get habitId {
    final $$HabitsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.habitId,
      referencedTable: $db.habits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitsTableFilterComposer(
            $db: $db,
            $table: $db.habits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DailyLogsTableFilterComposer get logDate {
    final $$DailyLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.logDate,
      referencedTable: $db.dailyLogs,
      getReferencedColumn: (t) => t.date,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DailyLogsTableFilterComposer(
            $db: $db,
            $table: $db.dailyLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HabitLogEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $HabitLogEntriesTable> {
  $$HabitLogEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  $$HabitsTableOrderingComposer get habitId {
    final $$HabitsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.habitId,
      referencedTable: $db.habits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitsTableOrderingComposer(
            $db: $db,
            $table: $db.habits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DailyLogsTableOrderingComposer get logDate {
    final $$DailyLogsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.logDate,
      referencedTable: $db.dailyLogs,
      getReferencedColumn: (t) => t.date,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DailyLogsTableOrderingComposer(
            $db: $db,
            $table: $db.dailyLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HabitLogEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $HabitLogEntriesTable> {
  $$HabitLogEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  $$HabitsTableAnnotationComposer get habitId {
    final $$HabitsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.habitId,
      referencedTable: $db.habits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitsTableAnnotationComposer(
            $db: $db,
            $table: $db.habits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DailyLogsTableAnnotationComposer get logDate {
    final $$DailyLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.logDate,
      referencedTable: $db.dailyLogs,
      getReferencedColumn: (t) => t.date,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DailyLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.dailyLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HabitLogEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HabitLogEntriesTable,
          HabitLogEntry,
          $$HabitLogEntriesTableFilterComposer,
          $$HabitLogEntriesTableOrderingComposer,
          $$HabitLogEntriesTableAnnotationComposer,
          $$HabitLogEntriesTableCreateCompanionBuilder,
          $$HabitLogEntriesTableUpdateCompanionBuilder,
          (HabitLogEntry, $$HabitLogEntriesTableReferences),
          HabitLogEntry,
          PrefetchHooks Function({bool habitId, bool logDate})
        > {
  $$HabitLogEntriesTableTableManager(
    _$AppDatabase db,
    $HabitLogEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HabitLogEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HabitLogEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HabitLogEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> habitId = const Value.absent(),
                Value<DateTime> logDate = const Value.absent(),
                Value<double> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HabitLogEntriesCompanion(
                id: id,
                habitId: habitId,
                logDate: logDate,
                value: value,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String habitId,
                required DateTime logDate,
                required double value,
                Value<int> rowid = const Value.absent(),
              }) => HabitLogEntriesCompanion.insert(
                id: id,
                habitId: habitId,
                logDate: logDate,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$HabitLogEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({habitId = false, logDate = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (habitId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.habitId,
                                referencedTable:
                                    $$HabitLogEntriesTableReferences
                                        ._habitIdTable(db),
                                referencedColumn:
                                    $$HabitLogEntriesTableReferences
                                        ._habitIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (logDate) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.logDate,
                                referencedTable:
                                    $$HabitLogEntriesTableReferences
                                        ._logDateTable(db),
                                referencedColumn:
                                    $$HabitLogEntriesTableReferences
                                        ._logDateTable(db)
                                        .date,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$HabitLogEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HabitLogEntriesTable,
      HabitLogEntry,
      $$HabitLogEntriesTableFilterComposer,
      $$HabitLogEntriesTableOrderingComposer,
      $$HabitLogEntriesTableAnnotationComposer,
      $$HabitLogEntriesTableCreateCompanionBuilder,
      $$HabitLogEntriesTableUpdateCompanionBuilder,
      (HabitLogEntry, $$HabitLogEntriesTableReferences),
      HabitLogEntry,
      PrefetchHooks Function({bool habitId, bool logDate})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$HabitsTableTableManager get habits =>
      $$HabitsTableTableManager(_db, _db.habits);
  $$DailyLogsTableTableManager get dailyLogs =>
      $$DailyLogsTableTableManager(_db, _db.dailyLogs);
  $$HabitLogEntriesTableTableManager get habitLogEntries =>
      $$HabitLogEntriesTableTableManager(_db, _db.habitLogEntries);
}
