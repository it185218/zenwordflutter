// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'global_stats.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetGlobalStatsCollection on Isar {
  IsarCollection<GlobalStats> get globalStats => this.collection();
}

const GlobalStatsSchema = CollectionSchema(
  name: r'GlobalStats',
  id: -2327367842578455289,
  properties: {
    r'extraWordMilestone': PropertySchema(
      id: 0,
      name: r'extraWordMilestone',
      type: IsarType.long,
    ),
    r'totalFoundExtras': PropertySchema(
      id: 1,
      name: r'totalFoundExtras',
      type: IsarType.long,
    )
  },
  estimateSize: _globalStatsEstimateSize,
  serialize: _globalStatsSerialize,
  deserialize: _globalStatsDeserialize,
  deserializeProp: _globalStatsDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _globalStatsGetId,
  getLinks: _globalStatsGetLinks,
  attach: _globalStatsAttach,
  version: '3.1.0+1',
);

int _globalStatsEstimateSize(
  GlobalStats object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _globalStatsSerialize(
  GlobalStats object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.extraWordMilestone);
  writer.writeLong(offsets[1], object.totalFoundExtras);
}

GlobalStats _globalStatsDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = GlobalStats();
  object.extraWordMilestone = reader.readLong(offsets[0]);
  object.id = id;
  object.totalFoundExtras = reader.readLong(offsets[1]);
  return object;
}

P _globalStatsDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _globalStatsGetId(GlobalStats object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _globalStatsGetLinks(GlobalStats object) {
  return [];
}

void _globalStatsAttach(
    IsarCollection<dynamic> col, Id id, GlobalStats object) {
  object.id = id;
}

extension GlobalStatsQueryWhereSort
    on QueryBuilder<GlobalStats, GlobalStats, QWhere> {
  QueryBuilder<GlobalStats, GlobalStats, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension GlobalStatsQueryWhere
    on QueryBuilder<GlobalStats, GlobalStats, QWhereClause> {
  QueryBuilder<GlobalStats, GlobalStats, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<GlobalStats, GlobalStats, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<GlobalStats, GlobalStats, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<GlobalStats, GlobalStats, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<GlobalStats, GlobalStats, QAfterWhereClause> idBetween(
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

extension GlobalStatsQueryFilter
    on QueryBuilder<GlobalStats, GlobalStats, QFilterCondition> {
  QueryBuilder<GlobalStats, GlobalStats, QAfterFilterCondition>
      extraWordMilestoneEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'extraWordMilestone',
        value: value,
      ));
    });
  }

  QueryBuilder<GlobalStats, GlobalStats, QAfterFilterCondition>
      extraWordMilestoneGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'extraWordMilestone',
        value: value,
      ));
    });
  }

  QueryBuilder<GlobalStats, GlobalStats, QAfterFilterCondition>
      extraWordMilestoneLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'extraWordMilestone',
        value: value,
      ));
    });
  }

  QueryBuilder<GlobalStats, GlobalStats, QAfterFilterCondition>
      extraWordMilestoneBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'extraWordMilestone',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<GlobalStats, GlobalStats, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<GlobalStats, GlobalStats, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<GlobalStats, GlobalStats, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<GlobalStats, GlobalStats, QAfterFilterCondition> idBetween(
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

  QueryBuilder<GlobalStats, GlobalStats, QAfterFilterCondition>
      totalFoundExtrasEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalFoundExtras',
        value: value,
      ));
    });
  }

  QueryBuilder<GlobalStats, GlobalStats, QAfterFilterCondition>
      totalFoundExtrasGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalFoundExtras',
        value: value,
      ));
    });
  }

  QueryBuilder<GlobalStats, GlobalStats, QAfterFilterCondition>
      totalFoundExtrasLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalFoundExtras',
        value: value,
      ));
    });
  }

  QueryBuilder<GlobalStats, GlobalStats, QAfterFilterCondition>
      totalFoundExtrasBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalFoundExtras',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension GlobalStatsQueryObject
    on QueryBuilder<GlobalStats, GlobalStats, QFilterCondition> {}

extension GlobalStatsQueryLinks
    on QueryBuilder<GlobalStats, GlobalStats, QFilterCondition> {}

extension GlobalStatsQuerySortBy
    on QueryBuilder<GlobalStats, GlobalStats, QSortBy> {
  QueryBuilder<GlobalStats, GlobalStats, QAfterSortBy>
      sortByExtraWordMilestone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'extraWordMilestone', Sort.asc);
    });
  }

  QueryBuilder<GlobalStats, GlobalStats, QAfterSortBy>
      sortByExtraWordMilestoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'extraWordMilestone', Sort.desc);
    });
  }

  QueryBuilder<GlobalStats, GlobalStats, QAfterSortBy>
      sortByTotalFoundExtras() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalFoundExtras', Sort.asc);
    });
  }

  QueryBuilder<GlobalStats, GlobalStats, QAfterSortBy>
      sortByTotalFoundExtrasDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalFoundExtras', Sort.desc);
    });
  }
}

extension GlobalStatsQuerySortThenBy
    on QueryBuilder<GlobalStats, GlobalStats, QSortThenBy> {
  QueryBuilder<GlobalStats, GlobalStats, QAfterSortBy>
      thenByExtraWordMilestone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'extraWordMilestone', Sort.asc);
    });
  }

  QueryBuilder<GlobalStats, GlobalStats, QAfterSortBy>
      thenByExtraWordMilestoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'extraWordMilestone', Sort.desc);
    });
  }

  QueryBuilder<GlobalStats, GlobalStats, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<GlobalStats, GlobalStats, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<GlobalStats, GlobalStats, QAfterSortBy>
      thenByTotalFoundExtras() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalFoundExtras', Sort.asc);
    });
  }

  QueryBuilder<GlobalStats, GlobalStats, QAfterSortBy>
      thenByTotalFoundExtrasDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalFoundExtras', Sort.desc);
    });
  }
}

extension GlobalStatsQueryWhereDistinct
    on QueryBuilder<GlobalStats, GlobalStats, QDistinct> {
  QueryBuilder<GlobalStats, GlobalStats, QDistinct>
      distinctByExtraWordMilestone() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'extraWordMilestone');
    });
  }

  QueryBuilder<GlobalStats, GlobalStats, QDistinct>
      distinctByTotalFoundExtras() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalFoundExtras');
    });
  }
}

extension GlobalStatsQueryProperty
    on QueryBuilder<GlobalStats, GlobalStats, QQueryProperty> {
  QueryBuilder<GlobalStats, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<GlobalStats, int, QQueryOperations>
      extraWordMilestoneProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'extraWordMilestone');
    });
  }

  QueryBuilder<GlobalStats, int, QQueryOperations> totalFoundExtrasProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalFoundExtras');
    });
  }
}
