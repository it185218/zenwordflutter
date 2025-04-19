// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'treasure_progress.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetTreasureProgressCollection on Isar {
  IsarCollection<TreasureProgress> get treasureProgress => this.collection();
}

const TreasureProgressSchema = CollectionSchema(
  name: r'TreasureProgress',
  id: 3416249212093332480,
  properties: {
    r'collectibleTileIndex': PropertySchema(
      id: 0,
      name: r'collectibleTileIndex',
      type: IsarType.long,
    ),
    r'currentLevelWithIcon': PropertySchema(
      id: 1,
      name: r'currentLevelWithIcon',
      type: IsarType.long,
    ),
    r'setsCompleted': PropertySchema(
      id: 2,
      name: r'setsCompleted',
      type: IsarType.long,
    ),
    r'totalCollected': PropertySchema(
      id: 3,
      name: r'totalCollected',
      type: IsarType.long,
    ),
    r'vaseIndices': PropertySchema(
      id: 4,
      name: r'vaseIndices',
      type: IsarType.longList,
    ),
    r'wordWithCollectible': PropertySchema(
      id: 5,
      name: r'wordWithCollectible',
      type: IsarType.string,
    )
  },
  estimateSize: _treasureProgressEstimateSize,
  serialize: _treasureProgressSerialize,
  deserialize: _treasureProgressDeserialize,
  deserializeProp: _treasureProgressDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _treasureProgressGetId,
  getLinks: _treasureProgressGetLinks,
  attach: _treasureProgressAttach,
  version: '3.1.0+1',
);

int _treasureProgressEstimateSize(
  TreasureProgress object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.vaseIndices.length * 8;
  {
    final value = object.wordWithCollectible;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _treasureProgressSerialize(
  TreasureProgress object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.collectibleTileIndex);
  writer.writeLong(offsets[1], object.currentLevelWithIcon);
  writer.writeLong(offsets[2], object.setsCompleted);
  writer.writeLong(offsets[3], object.totalCollected);
  writer.writeLongList(offsets[4], object.vaseIndices);
  writer.writeString(offsets[5], object.wordWithCollectible);
}

TreasureProgress _treasureProgressDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TreasureProgress();
  object.collectibleTileIndex = reader.readLongOrNull(offsets[0]);
  object.currentLevelWithIcon = reader.readLongOrNull(offsets[1]);
  object.id = id;
  object.setsCompleted = reader.readLong(offsets[2]);
  object.totalCollected = reader.readLong(offsets[3]);
  object.vaseIndices = reader.readLongList(offsets[4]) ?? [];
  object.wordWithCollectible = reader.readStringOrNull(offsets[5]);
  return object;
}

P _treasureProgressDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readLongList(offset) ?? []) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _treasureProgressGetId(TreasureProgress object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _treasureProgressGetLinks(TreasureProgress object) {
  return [];
}

void _treasureProgressAttach(
    IsarCollection<dynamic> col, Id id, TreasureProgress object) {
  object.id = id;
}

extension TreasureProgressQueryWhereSort
    on QueryBuilder<TreasureProgress, TreasureProgress, QWhere> {
  QueryBuilder<TreasureProgress, TreasureProgress, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension TreasureProgressQueryWhere
    on QueryBuilder<TreasureProgress, TreasureProgress, QWhereClause> {
  QueryBuilder<TreasureProgress, TreasureProgress, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<TreasureProgress, TreasureProgress, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<TreasureProgress, TreasureProgress, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<TreasureProgress, TreasureProgress, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<TreasureProgress, TreasureProgress, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension TreasureProgressQueryFilter
    on QueryBuilder<TreasureProgress, TreasureProgress, QFilterCondition> {
  QueryBuilder<TreasureProgress, TreasureProgress, QAfterFilterCondition>
      collectibleTileIndexIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'collectibleTileIndex',
      ));
    });
  }

  QueryBuilder<TreasureProgress, TreasureProgress, QAfterFilterCondition>
      collectibleTileIndexIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'collectibleTileIndex',
      ));
    });
  }

  QueryBuilder<TreasureProgress, TreasureProgress, QAfterFilterCondition>
      collectibleTileIndexEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'collectibleTileIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<TreasureProgress, TreasureProgress, QAfterFilterCondition>
      collectibleTileIndexGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'collectibleTileIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<TreasureProgress, TreasureProgress, QAfterFilterCondition>
      collectibleTileIndexLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'collectibleTileIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<TreasureProgress, TreasureProgress, QAfterFilterCondition>
      collectibleTileIndexBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'collectibleTileIndex',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TreasureProgress, TreasureProgress, QAfterFilterCondition>
      currentLevelWithIconIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'currentLevelWithIcon',
      ));
    });
  }

  QueryBuilder<TreasureProgress, TreasureProgress, QAfterFilterCondition>
      currentLevelWithIconIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'currentLevelWithIcon',
      ));
    });
  }

  QueryBuilder<TreasureProgress, TreasureProgress, QAfterFilterCondition>
      currentLevelWithIconEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currentLevelWithIcon',
        value: value,
      ));
    });
  }

  QueryBuilder<TreasureProgress, TreasureProgress, QAfterFilterCondition>
      currentLevelWithIconGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'currentLevelWithIcon',
        value: value,
      ));
    });
  }

  QueryBuilder<TreasureProgress, TreasureProgress, QAfterFilterCondition>
      currentLevelWithIconLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'currentLevelWithIcon',
        value: value,
      ));
    });
  }

  QueryBuilder<TreasureProgress, TreasureProgress, QAfterFilterCondition>
      currentLevelWithIconBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'currentLevelWithIcon',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TreasureProgress, TreasureProgress, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TreasureProgress, TreasureProgress, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TreasureProgress, TreasureProgress, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TreasureProgress, TreasureProgress, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TreasureProgress, TreasureProgress, QAfterFilterCondition>
      setsCompletedEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'setsCompleted',
        value: value,
      ));
    });
  }

  QueryBuilder<TreasureProgress, TreasureProgress, QAfterFilterCondition>
      setsCompletedGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'setsCompleted',
        value: value,
      ));
    });
  }

  QueryBuilder<TreasureProgress, TreasureProgress, QAfterFilterCondition>
      setsCompletedLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'setsCompleted',
        value: value,
      ));
    });
  }

  QueryBuilder<TreasureProgress, TreasureProgress, QAfterFilterCondition>
      setsCompletedBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'setsCompleted',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TreasureProgress, TreasureProgress, QAfterFilterCondition>
      totalCollectedEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalCollected',
        value: value,
      ));
    });
  }

  QueryBuilder<TreasureProgress, TreasureProgress, QAfterFilterCondition>
      totalCollectedGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalCollected',
        value: value,
      ));
    });
  }

  QueryBuilder<TreasureProgress, TreasureProgress, QAfterFilterCondition>
      totalCollectedLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalCollected',
        value: value,
      ));
    });
  }

  QueryBuilder<TreasureProgress, TreasureProgress, QAfterFilterCondition>
      totalCollectedBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalCollected',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TreasureProgress, TreasureProgress, QAfterFilterCondition>
      vaseIndicesElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'vaseIndices',
        value: value,
      ));
    });
  }

  QueryBuilder<TreasureProgress, TreasureProgress, QAfterFilterCondition>
      vaseIndicesElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'vaseIndices',
        value: value,
      ));
    });
  }

  QueryBuilder<TreasureProgress, TreasureProgress, QAfterFilterCondition>
      vaseIndicesElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'vaseIndices',
        value: value,
      ));
    });
  }

  QueryBuilder<TreasureProgress, TreasureProgress, QAfterFilterCondition>
      vaseIndicesElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'vaseIndices',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TreasureProgress, TreasureProgress, QAfterFilterCondition>
      vaseIndicesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'vaseIndices',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<TreasureProgress, TreasureProgress, QAfterFilterCondition>
      vaseIndicesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'vaseIndices',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<TreasureProgress, TreasureProgress, QAfterFilterCondition>
      vaseIndicesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'vaseIndices',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<TreasureProgress, TreasureProgress, QAfterFilterCondition>
      vaseIndicesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'vaseIndices',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<TreasureProgress, TreasureProgress, QAfterFilterCondition>
      vaseIndicesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'vaseIndices',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<TreasureProgress, TreasureProgress, QAfterFilterCondition>
      vaseIndicesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'vaseIndices',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<TreasureProgress, TreasureProgress, QAfterFilterCondition>
      wordWithCollectibleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'wordWithCollectible',
      ));
    });
  }

  QueryBuilder<TreasureProgress, TreasureProgress, QAfterFilterCondition>
      wordWithCollectibleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'wordWithCollectible',
      ));
    });
  }

  QueryBuilder<TreasureProgress, TreasureProgress, QAfterFilterCondition>
      wordWithCollectibleEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'wordWithCollectible',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TreasureProgress, TreasureProgress, QAfterFilterCondition>
      wordWithCollectibleGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'wordWithCollectible',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TreasureProgress, TreasureProgress, QAfterFilterCondition>
      wordWithCollectibleLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'wordWithCollectible',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TreasureProgress, TreasureProgress, QAfterFilterCondition>
      wordWithCollectibleBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'wordWithCollectible',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TreasureProgress, TreasureProgress, QAfterFilterCondition>
      wordWithCollectibleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'wordWithCollectible',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TreasureProgress, TreasureProgress, QAfterFilterCondition>
      wordWithCollectibleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'wordWithCollectible',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TreasureProgress, TreasureProgress, QAfterFilterCondition>
      wordWithCollectibleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'wordWithCollectible',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TreasureProgress, TreasureProgress, QAfterFilterCondition>
      wordWithCollectibleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'wordWithCollectible',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TreasureProgress, TreasureProgress, QAfterFilterCondition>
      wordWithCollectibleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'wordWithCollectible',
        value: '',
      ));
    });
  }

  QueryBuilder<TreasureProgress, TreasureProgress, QAfterFilterCondition>
      wordWithCollectibleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'wordWithCollectible',
        value: '',
      ));
    });
  }
}

extension TreasureProgressQueryObject
    on QueryBuilder<TreasureProgress, TreasureProgress, QFilterCondition> {}

extension TreasureProgressQueryLinks
    on QueryBuilder<TreasureProgress, TreasureProgress, QFilterCondition> {}

extension TreasureProgressQuerySortBy
    on QueryBuilder<TreasureProgress, TreasureProgress, QSortBy> {
  QueryBuilder<TreasureProgress, TreasureProgress, QAfterSortBy>
      sortByCollectibleTileIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'collectibleTileIndex', Sort.asc);
    });
  }

  QueryBuilder<TreasureProgress, TreasureProgress, QAfterSortBy>
      sortByCollectibleTileIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'collectibleTileIndex', Sort.desc);
    });
  }

  QueryBuilder<TreasureProgress, TreasureProgress, QAfterSortBy>
      sortByCurrentLevelWithIcon() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentLevelWithIcon', Sort.asc);
    });
  }

  QueryBuilder<TreasureProgress, TreasureProgress, QAfterSortBy>
      sortByCurrentLevelWithIconDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentLevelWithIcon', Sort.desc);
    });
  }

  QueryBuilder<TreasureProgress, TreasureProgress, QAfterSortBy>
      sortBySetsCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'setsCompleted', Sort.asc);
    });
  }

  QueryBuilder<TreasureProgress, TreasureProgress, QAfterSortBy>
      sortBySetsCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'setsCompleted', Sort.desc);
    });
  }

  QueryBuilder<TreasureProgress, TreasureProgress, QAfterSortBy>
      sortByTotalCollected() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCollected', Sort.asc);
    });
  }

  QueryBuilder<TreasureProgress, TreasureProgress, QAfterSortBy>
      sortByTotalCollectedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCollected', Sort.desc);
    });
  }

  QueryBuilder<TreasureProgress, TreasureProgress, QAfterSortBy>
      sortByWordWithCollectible() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wordWithCollectible', Sort.asc);
    });
  }

  QueryBuilder<TreasureProgress, TreasureProgress, QAfterSortBy>
      sortByWordWithCollectibleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wordWithCollectible', Sort.desc);
    });
  }
}

extension TreasureProgressQuerySortThenBy
    on QueryBuilder<TreasureProgress, TreasureProgress, QSortThenBy> {
  QueryBuilder<TreasureProgress, TreasureProgress, QAfterSortBy>
      thenByCollectibleTileIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'collectibleTileIndex', Sort.asc);
    });
  }

  QueryBuilder<TreasureProgress, TreasureProgress, QAfterSortBy>
      thenByCollectibleTileIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'collectibleTileIndex', Sort.desc);
    });
  }

  QueryBuilder<TreasureProgress, TreasureProgress, QAfterSortBy>
      thenByCurrentLevelWithIcon() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentLevelWithIcon', Sort.asc);
    });
  }

  QueryBuilder<TreasureProgress, TreasureProgress, QAfterSortBy>
      thenByCurrentLevelWithIconDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentLevelWithIcon', Sort.desc);
    });
  }

  QueryBuilder<TreasureProgress, TreasureProgress, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<TreasureProgress, TreasureProgress, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<TreasureProgress, TreasureProgress, QAfterSortBy>
      thenBySetsCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'setsCompleted', Sort.asc);
    });
  }

  QueryBuilder<TreasureProgress, TreasureProgress, QAfterSortBy>
      thenBySetsCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'setsCompleted', Sort.desc);
    });
  }

  QueryBuilder<TreasureProgress, TreasureProgress, QAfterSortBy>
      thenByTotalCollected() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCollected', Sort.asc);
    });
  }

  QueryBuilder<TreasureProgress, TreasureProgress, QAfterSortBy>
      thenByTotalCollectedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCollected', Sort.desc);
    });
  }

  QueryBuilder<TreasureProgress, TreasureProgress, QAfterSortBy>
      thenByWordWithCollectible() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wordWithCollectible', Sort.asc);
    });
  }

  QueryBuilder<TreasureProgress, TreasureProgress, QAfterSortBy>
      thenByWordWithCollectibleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wordWithCollectible', Sort.desc);
    });
  }
}

extension TreasureProgressQueryWhereDistinct
    on QueryBuilder<TreasureProgress, TreasureProgress, QDistinct> {
  QueryBuilder<TreasureProgress, TreasureProgress, QDistinct>
      distinctByCollectibleTileIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'collectibleTileIndex');
    });
  }

  QueryBuilder<TreasureProgress, TreasureProgress, QDistinct>
      distinctByCurrentLevelWithIcon() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currentLevelWithIcon');
    });
  }

  QueryBuilder<TreasureProgress, TreasureProgress, QDistinct>
      distinctBySetsCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'setsCompleted');
    });
  }

  QueryBuilder<TreasureProgress, TreasureProgress, QDistinct>
      distinctByTotalCollected() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalCollected');
    });
  }

  QueryBuilder<TreasureProgress, TreasureProgress, QDistinct>
      distinctByVaseIndices() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'vaseIndices');
    });
  }

  QueryBuilder<TreasureProgress, TreasureProgress, QDistinct>
      distinctByWordWithCollectible({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'wordWithCollectible',
          caseSensitive: caseSensitive);
    });
  }
}

extension TreasureProgressQueryProperty
    on QueryBuilder<TreasureProgress, TreasureProgress, QQueryProperty> {
  QueryBuilder<TreasureProgress, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<TreasureProgress, int?, QQueryOperations>
      collectibleTileIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'collectibleTileIndex');
    });
  }

  QueryBuilder<TreasureProgress, int?, QQueryOperations>
      currentLevelWithIconProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currentLevelWithIcon');
    });
  }

  QueryBuilder<TreasureProgress, int, QQueryOperations>
      setsCompletedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'setsCompleted');
    });
  }

  QueryBuilder<TreasureProgress, int, QQueryOperations>
      totalCollectedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalCollected');
    });
  }

  QueryBuilder<TreasureProgress, List<int>, QQueryOperations>
      vaseIndicesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'vaseIndices');
    });
  }

  QueryBuilder<TreasureProgress, String?, QQueryOperations>
      wordWithCollectibleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'wordWithCollectible');
    });
  }
}
