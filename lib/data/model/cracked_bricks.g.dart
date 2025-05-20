// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cracked_bricks.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCrackedBricksCollection on Isar {
  IsarCollection<CrackedBricks> get crackedBricks => this.collection();
}

const CrackedBricksSchema = CollectionSchema(
  name: r'CrackedBricks',
  id: -6431921270699403793,
  properties: {
    r'crackedStates': PropertySchema(
      id: 0,
      name: r'crackedStates',
      type: IsarType.boolList,
    ),
    r'pieceIndices': PropertySchema(
      id: 1,
      name: r'pieceIndices',
      type: IsarType.longList,
    ),
    r'setIndex': PropertySchema(
      id: 2,
      name: r'setIndex',
      type: IsarType.long,
    )
  },
  estimateSize: _crackedBricksEstimateSize,
  serialize: _crackedBricksSerialize,
  deserialize: _crackedBricksDeserialize,
  deserializeProp: _crackedBricksDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _crackedBricksGetId,
  getLinks: _crackedBricksGetLinks,
  attach: _crackedBricksAttach,
  version: '3.1.0+1',
);

int _crackedBricksEstimateSize(
  CrackedBricks object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.crackedStates.length;
  bytesCount += 3 + object.pieceIndices.length * 8;
  return bytesCount;
}

void _crackedBricksSerialize(
  CrackedBricks object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBoolList(offsets[0], object.crackedStates);
  writer.writeLongList(offsets[1], object.pieceIndices);
  writer.writeLong(offsets[2], object.setIndex);
}

CrackedBricks _crackedBricksDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CrackedBricks(
    setIndex: reader.readLong(offsets[2]),
  );
  object.crackedStates = reader.readBoolList(offsets[0]) ?? [];
  object.id = id;
  object.pieceIndices = reader.readLongList(offsets[1]) ?? [];
  return object;
}

P _crackedBricksDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBoolList(offset) ?? []) as P;
    case 1:
      return (reader.readLongList(offset) ?? []) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _crackedBricksGetId(CrackedBricks object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _crackedBricksGetLinks(CrackedBricks object) {
  return [];
}

void _crackedBricksAttach(
    IsarCollection<dynamic> col, Id id, CrackedBricks object) {
  object.id = id;
}

extension CrackedBricksQueryWhereSort
    on QueryBuilder<CrackedBricks, CrackedBricks, QWhere> {
  QueryBuilder<CrackedBricks, CrackedBricks, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension CrackedBricksQueryWhere
    on QueryBuilder<CrackedBricks, CrackedBricks, QWhereClause> {
  QueryBuilder<CrackedBricks, CrackedBricks, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<CrackedBricks, CrackedBricks, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<CrackedBricks, CrackedBricks, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<CrackedBricks, CrackedBricks, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<CrackedBricks, CrackedBricks, QAfterWhereClause> idBetween(
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

extension CrackedBricksQueryFilter
    on QueryBuilder<CrackedBricks, CrackedBricks, QFilterCondition> {
  QueryBuilder<CrackedBricks, CrackedBricks, QAfterFilterCondition>
      crackedStatesElementEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'crackedStates',
        value: value,
      ));
    });
  }

  QueryBuilder<CrackedBricks, CrackedBricks, QAfterFilterCondition>
      crackedStatesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'crackedStates',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<CrackedBricks, CrackedBricks, QAfterFilterCondition>
      crackedStatesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'crackedStates',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<CrackedBricks, CrackedBricks, QAfterFilterCondition>
      crackedStatesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'crackedStates',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<CrackedBricks, CrackedBricks, QAfterFilterCondition>
      crackedStatesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'crackedStates',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<CrackedBricks, CrackedBricks, QAfterFilterCondition>
      crackedStatesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'crackedStates',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<CrackedBricks, CrackedBricks, QAfterFilterCondition>
      crackedStatesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'crackedStates',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<CrackedBricks, CrackedBricks, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CrackedBricks, CrackedBricks, QAfterFilterCondition>
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

  QueryBuilder<CrackedBricks, CrackedBricks, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<CrackedBricks, CrackedBricks, QAfterFilterCondition> idBetween(
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

  QueryBuilder<CrackedBricks, CrackedBricks, QAfterFilterCondition>
      pieceIndicesElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pieceIndices',
        value: value,
      ));
    });
  }

  QueryBuilder<CrackedBricks, CrackedBricks, QAfterFilterCondition>
      pieceIndicesElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pieceIndices',
        value: value,
      ));
    });
  }

  QueryBuilder<CrackedBricks, CrackedBricks, QAfterFilterCondition>
      pieceIndicesElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pieceIndices',
        value: value,
      ));
    });
  }

  QueryBuilder<CrackedBricks, CrackedBricks, QAfterFilterCondition>
      pieceIndicesElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pieceIndices',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CrackedBricks, CrackedBricks, QAfterFilterCondition>
      pieceIndicesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'pieceIndices',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<CrackedBricks, CrackedBricks, QAfterFilterCondition>
      pieceIndicesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'pieceIndices',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<CrackedBricks, CrackedBricks, QAfterFilterCondition>
      pieceIndicesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'pieceIndices',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<CrackedBricks, CrackedBricks, QAfterFilterCondition>
      pieceIndicesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'pieceIndices',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<CrackedBricks, CrackedBricks, QAfterFilterCondition>
      pieceIndicesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'pieceIndices',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<CrackedBricks, CrackedBricks, QAfterFilterCondition>
      pieceIndicesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'pieceIndices',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<CrackedBricks, CrackedBricks, QAfterFilterCondition>
      setIndexEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'setIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<CrackedBricks, CrackedBricks, QAfterFilterCondition>
      setIndexGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'setIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<CrackedBricks, CrackedBricks, QAfterFilterCondition>
      setIndexLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'setIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<CrackedBricks, CrackedBricks, QAfterFilterCondition>
      setIndexBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'setIndex',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension CrackedBricksQueryObject
    on QueryBuilder<CrackedBricks, CrackedBricks, QFilterCondition> {}

extension CrackedBricksQueryLinks
    on QueryBuilder<CrackedBricks, CrackedBricks, QFilterCondition> {}

extension CrackedBricksQuerySortBy
    on QueryBuilder<CrackedBricks, CrackedBricks, QSortBy> {
  QueryBuilder<CrackedBricks, CrackedBricks, QAfterSortBy> sortBySetIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'setIndex', Sort.asc);
    });
  }

  QueryBuilder<CrackedBricks, CrackedBricks, QAfterSortBy>
      sortBySetIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'setIndex', Sort.desc);
    });
  }
}

extension CrackedBricksQuerySortThenBy
    on QueryBuilder<CrackedBricks, CrackedBricks, QSortThenBy> {
  QueryBuilder<CrackedBricks, CrackedBricks, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<CrackedBricks, CrackedBricks, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<CrackedBricks, CrackedBricks, QAfterSortBy> thenBySetIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'setIndex', Sort.asc);
    });
  }

  QueryBuilder<CrackedBricks, CrackedBricks, QAfterSortBy>
      thenBySetIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'setIndex', Sort.desc);
    });
  }
}

extension CrackedBricksQueryWhereDistinct
    on QueryBuilder<CrackedBricks, CrackedBricks, QDistinct> {
  QueryBuilder<CrackedBricks, CrackedBricks, QDistinct>
      distinctByCrackedStates() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'crackedStates');
    });
  }

  QueryBuilder<CrackedBricks, CrackedBricks, QDistinct>
      distinctByPieceIndices() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pieceIndices');
    });
  }

  QueryBuilder<CrackedBricks, CrackedBricks, QDistinct> distinctBySetIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'setIndex');
    });
  }
}

extension CrackedBricksQueryProperty
    on QueryBuilder<CrackedBricks, CrackedBricks, QQueryProperty> {
  QueryBuilder<CrackedBricks, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<CrackedBricks, List<bool>, QQueryOperations>
      crackedStatesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'crackedStates');
    });
  }

  QueryBuilder<CrackedBricks, List<int>, QQueryOperations>
      pieceIndicesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pieceIndices');
    });
  }

  QueryBuilder<CrackedBricks, int, QQueryOperations> setIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'setIndex');
    });
  }
}
