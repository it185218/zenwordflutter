// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_game.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSavedGameCollection on Isar {
  IsarCollection<SavedGame> get savedGames => this.collection();
}

const SavedGameSchema = CollectionSchema(
  name: r'SavedGame',
  id: -7719033278776789884,
  properties: {
    r'additionalWords': PropertySchema(
      id: 0,
      name: r'additionalWords',
      type: IsarType.stringList,
    ),
    r'baseWord': PropertySchema(
      id: 1,
      name: r'baseWord',
      type: IsarType.string,
    ),
    r'extraWordMilestone': PropertySchema(
      id: 2,
      name: r'extraWordMilestone',
      type: IsarType.long,
    ),
    r'foundExtras': PropertySchema(
      id: 3,
      name: r'foundExtras',
      type: IsarType.stringList,
    ),
    r'foundWords': PropertySchema(
      id: 4,
      name: r'foundWords',
      type: IsarType.stringList,
    ),
    r'hintRevealedLetters': PropertySchema(
      id: 5,
      name: r'hintRevealedLetters',
      type: IsarType.string,
    ),
    r'letterIds': PropertySchema(
      id: 6,
      name: r'letterIds',
      type: IsarType.longList,
    ),
    r'letters': PropertySchema(
      id: 7,
      name: r'letters',
      type: IsarType.stringList,
    ),
    r'level': PropertySchema(
      id: 8,
      name: r'level',
      type: IsarType.long,
    ),
    r'revealedLetters': PropertySchema(
      id: 9,
      name: r'revealedLetters',
      type: IsarType.string,
    ),
    r'validWords': PropertySchema(
      id: 10,
      name: r'validWords',
      type: IsarType.stringList,
    )
  },
  estimateSize: _savedGameEstimateSize,
  serialize: _savedGameSerialize,
  deserialize: _savedGameDeserialize,
  deserializeProp: _savedGameDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _savedGameGetId,
  getLinks: _savedGameGetLinks,
  attach: _savedGameAttach,
  version: '3.1.0+1',
);

int _savedGameEstimateSize(
  SavedGame object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.additionalWords.length * 3;
  {
    for (var i = 0; i < object.additionalWords.length; i++) {
      final value = object.additionalWords[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.baseWord.length * 3;
  bytesCount += 3 + object.foundExtras.length * 3;
  {
    for (var i = 0; i < object.foundExtras.length; i++) {
      final value = object.foundExtras[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.foundWords.length * 3;
  {
    for (var i = 0; i < object.foundWords.length; i++) {
      final value = object.foundWords[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.hintRevealedLetters.length * 3;
  bytesCount += 3 + object.letterIds.length * 8;
  bytesCount += 3 + object.letters.length * 3;
  {
    for (var i = 0; i < object.letters.length; i++) {
      final value = object.letters[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.revealedLetters.length * 3;
  bytesCount += 3 + object.validWords.length * 3;
  {
    for (var i = 0; i < object.validWords.length; i++) {
      final value = object.validWords[i];
      bytesCount += value.length * 3;
    }
  }
  return bytesCount;
}

void _savedGameSerialize(
  SavedGame object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeStringList(offsets[0], object.additionalWords);
  writer.writeString(offsets[1], object.baseWord);
  writer.writeLong(offsets[2], object.extraWordMilestone);
  writer.writeStringList(offsets[3], object.foundExtras);
  writer.writeStringList(offsets[4], object.foundWords);
  writer.writeString(offsets[5], object.hintRevealedLetters);
  writer.writeLongList(offsets[6], object.letterIds);
  writer.writeStringList(offsets[7], object.letters);
  writer.writeLong(offsets[8], object.level);
  writer.writeString(offsets[9], object.revealedLetters);
  writer.writeStringList(offsets[10], object.validWords);
}

SavedGame _savedGameDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SavedGame();
  object.additionalWords = reader.readStringList(offsets[0]) ?? [];
  object.baseWord = reader.readString(offsets[1]);
  object.extraWordMilestone = reader.readLong(offsets[2]);
  object.foundExtras = reader.readStringList(offsets[3]) ?? [];
  object.foundWords = reader.readStringList(offsets[4]) ?? [];
  object.hintRevealedLetters = reader.readString(offsets[5]);
  object.id = id;
  object.letterIds = reader.readLongList(offsets[6]) ?? [];
  object.letters = reader.readStringList(offsets[7]) ?? [];
  object.level = reader.readLong(offsets[8]);
  object.revealedLetters = reader.readString(offsets[9]);
  object.validWords = reader.readStringList(offsets[10]) ?? [];
  return object;
}

P _savedGameDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringList(offset) ?? []) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readStringList(offset) ?? []) as P;
    case 4:
      return (reader.readStringList(offset) ?? []) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readLongList(offset) ?? []) as P;
    case 7:
      return (reader.readStringList(offset) ?? []) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readStringList(offset) ?? []) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _savedGameGetId(SavedGame object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _savedGameGetLinks(SavedGame object) {
  return [];
}

void _savedGameAttach(IsarCollection<dynamic> col, Id id, SavedGame object) {
  object.id = id;
}

extension SavedGameQueryWhereSort
    on QueryBuilder<SavedGame, SavedGame, QWhere> {
  QueryBuilder<SavedGame, SavedGame, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SavedGameQueryWhere
    on QueryBuilder<SavedGame, SavedGame, QWhereClause> {
  QueryBuilder<SavedGame, SavedGame, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<SavedGame, SavedGame, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterWhereClause> idBetween(
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

extension SavedGameQueryFilter
    on QueryBuilder<SavedGame, SavedGame, QFilterCondition> {
  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      additionalWordsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'additionalWords',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      additionalWordsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'additionalWords',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      additionalWordsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'additionalWords',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      additionalWordsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'additionalWords',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      additionalWordsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'additionalWords',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      additionalWordsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'additionalWords',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      additionalWordsElementContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'additionalWords',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      additionalWordsElementMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'additionalWords',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      additionalWordsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'additionalWords',
        value: '',
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      additionalWordsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'additionalWords',
        value: '',
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      additionalWordsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'additionalWords',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      additionalWordsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'additionalWords',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      additionalWordsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'additionalWords',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      additionalWordsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'additionalWords',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      additionalWordsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'additionalWords',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      additionalWordsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'additionalWords',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> baseWordEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'baseWord',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> baseWordGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'baseWord',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> baseWordLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'baseWord',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> baseWordBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'baseWord',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> baseWordStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'baseWord',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> baseWordEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'baseWord',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> baseWordContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'baseWord',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> baseWordMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'baseWord',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> baseWordIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'baseWord',
        value: '',
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      baseWordIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'baseWord',
        value: '',
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      extraWordMilestoneEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'extraWordMilestone',
        value: value,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
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

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
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

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
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

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      foundExtrasElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'foundExtras',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      foundExtrasElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'foundExtras',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      foundExtrasElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'foundExtras',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      foundExtrasElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'foundExtras',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      foundExtrasElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'foundExtras',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      foundExtrasElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'foundExtras',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      foundExtrasElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'foundExtras',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      foundExtrasElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'foundExtras',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      foundExtrasElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'foundExtras',
        value: '',
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      foundExtrasElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'foundExtras',
        value: '',
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      foundExtrasLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'foundExtras',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      foundExtrasIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'foundExtras',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      foundExtrasIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'foundExtras',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      foundExtrasLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'foundExtras',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      foundExtrasLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'foundExtras',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      foundExtrasLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'foundExtras',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      foundWordsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'foundWords',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      foundWordsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'foundWords',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      foundWordsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'foundWords',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      foundWordsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'foundWords',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      foundWordsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'foundWords',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      foundWordsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'foundWords',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      foundWordsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'foundWords',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      foundWordsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'foundWords',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      foundWordsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'foundWords',
        value: '',
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      foundWordsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'foundWords',
        value: '',
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      foundWordsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'foundWords',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      foundWordsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'foundWords',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      foundWordsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'foundWords',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      foundWordsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'foundWords',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      foundWordsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'foundWords',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      foundWordsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'foundWords',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      hintRevealedLettersEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hintRevealedLetters',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      hintRevealedLettersGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'hintRevealedLetters',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      hintRevealedLettersLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'hintRevealedLetters',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      hintRevealedLettersBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'hintRevealedLetters',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      hintRevealedLettersStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'hintRevealedLetters',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      hintRevealedLettersEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'hintRevealedLetters',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      hintRevealedLettersContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'hintRevealedLetters',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      hintRevealedLettersMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'hintRevealedLetters',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      hintRevealedLettersIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hintRevealedLetters',
        value: '',
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      hintRevealedLettersIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'hintRevealedLetters',
        value: '',
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> idBetween(
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

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      letterIdsElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'letterIds',
        value: value,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      letterIdsElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'letterIds',
        value: value,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      letterIdsElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'letterIds',
        value: value,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      letterIdsElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'letterIds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      letterIdsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'letterIds',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> letterIdsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'letterIds',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      letterIdsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'letterIds',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      letterIdsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'letterIds',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      letterIdsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'letterIds',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      letterIdsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'letterIds',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      lettersElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'letters',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      lettersElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'letters',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      lettersElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'letters',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      lettersElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'letters',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      lettersElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'letters',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      lettersElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'letters',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      lettersElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'letters',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      lettersElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'letters',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      lettersElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'letters',
        value: '',
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      lettersElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'letters',
        value: '',
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      lettersLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'letters',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> lettersIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'letters',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      lettersIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'letters',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      lettersLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'letters',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      lettersLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'letters',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      lettersLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'letters',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> levelEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'level',
        value: value,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> levelGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'level',
        value: value,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> levelLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'level',
        value: value,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition> levelBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'level',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      revealedLettersEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'revealedLetters',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      revealedLettersGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'revealedLetters',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      revealedLettersLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'revealedLetters',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      revealedLettersBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'revealedLetters',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      revealedLettersStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'revealedLetters',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      revealedLettersEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'revealedLetters',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      revealedLettersContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'revealedLetters',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      revealedLettersMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'revealedLetters',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      revealedLettersIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'revealedLetters',
        value: '',
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      revealedLettersIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'revealedLetters',
        value: '',
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      validWordsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'validWords',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      validWordsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'validWords',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      validWordsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'validWords',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      validWordsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'validWords',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      validWordsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'validWords',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      validWordsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'validWords',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      validWordsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'validWords',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      validWordsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'validWords',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      validWordsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'validWords',
        value: '',
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      validWordsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'validWords',
        value: '',
      ));
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      validWordsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'validWords',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      validWordsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'validWords',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      validWordsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'validWords',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      validWordsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'validWords',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      validWordsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'validWords',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterFilterCondition>
      validWordsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'validWords',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension SavedGameQueryObject
    on QueryBuilder<SavedGame, SavedGame, QFilterCondition> {}

extension SavedGameQueryLinks
    on QueryBuilder<SavedGame, SavedGame, QFilterCondition> {}

extension SavedGameQuerySortBy on QueryBuilder<SavedGame, SavedGame, QSortBy> {
  QueryBuilder<SavedGame, SavedGame, QAfterSortBy> sortByBaseWord() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'baseWord', Sort.asc);
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterSortBy> sortByBaseWordDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'baseWord', Sort.desc);
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterSortBy> sortByExtraWordMilestone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'extraWordMilestone', Sort.asc);
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterSortBy>
      sortByExtraWordMilestoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'extraWordMilestone', Sort.desc);
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterSortBy> sortByHintRevealedLetters() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hintRevealedLetters', Sort.asc);
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterSortBy>
      sortByHintRevealedLettersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hintRevealedLetters', Sort.desc);
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterSortBy> sortByLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'level', Sort.asc);
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterSortBy> sortByLevelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'level', Sort.desc);
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterSortBy> sortByRevealedLetters() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'revealedLetters', Sort.asc);
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterSortBy> sortByRevealedLettersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'revealedLetters', Sort.desc);
    });
  }
}

extension SavedGameQuerySortThenBy
    on QueryBuilder<SavedGame, SavedGame, QSortThenBy> {
  QueryBuilder<SavedGame, SavedGame, QAfterSortBy> thenByBaseWord() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'baseWord', Sort.asc);
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterSortBy> thenByBaseWordDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'baseWord', Sort.desc);
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterSortBy> thenByExtraWordMilestone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'extraWordMilestone', Sort.asc);
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterSortBy>
      thenByExtraWordMilestoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'extraWordMilestone', Sort.desc);
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterSortBy> thenByHintRevealedLetters() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hintRevealedLetters', Sort.asc);
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterSortBy>
      thenByHintRevealedLettersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hintRevealedLetters', Sort.desc);
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterSortBy> thenByLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'level', Sort.asc);
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterSortBy> thenByLevelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'level', Sort.desc);
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterSortBy> thenByRevealedLetters() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'revealedLetters', Sort.asc);
    });
  }

  QueryBuilder<SavedGame, SavedGame, QAfterSortBy> thenByRevealedLettersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'revealedLetters', Sort.desc);
    });
  }
}

extension SavedGameQueryWhereDistinct
    on QueryBuilder<SavedGame, SavedGame, QDistinct> {
  QueryBuilder<SavedGame, SavedGame, QDistinct> distinctByAdditionalWords() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'additionalWords');
    });
  }

  QueryBuilder<SavedGame, SavedGame, QDistinct> distinctByBaseWord(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'baseWord', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SavedGame, SavedGame, QDistinct> distinctByExtraWordMilestone() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'extraWordMilestone');
    });
  }

  QueryBuilder<SavedGame, SavedGame, QDistinct> distinctByFoundExtras() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'foundExtras');
    });
  }

  QueryBuilder<SavedGame, SavedGame, QDistinct> distinctByFoundWords() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'foundWords');
    });
  }

  QueryBuilder<SavedGame, SavedGame, QDistinct> distinctByHintRevealedLetters(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hintRevealedLetters',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SavedGame, SavedGame, QDistinct> distinctByLetterIds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'letterIds');
    });
  }

  QueryBuilder<SavedGame, SavedGame, QDistinct> distinctByLetters() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'letters');
    });
  }

  QueryBuilder<SavedGame, SavedGame, QDistinct> distinctByLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'level');
    });
  }

  QueryBuilder<SavedGame, SavedGame, QDistinct> distinctByRevealedLetters(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'revealedLetters',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SavedGame, SavedGame, QDistinct> distinctByValidWords() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'validWords');
    });
  }
}

extension SavedGameQueryProperty
    on QueryBuilder<SavedGame, SavedGame, QQueryProperty> {
  QueryBuilder<SavedGame, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SavedGame, List<String>, QQueryOperations>
      additionalWordsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'additionalWords');
    });
  }

  QueryBuilder<SavedGame, String, QQueryOperations> baseWordProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'baseWord');
    });
  }

  QueryBuilder<SavedGame, int, QQueryOperations> extraWordMilestoneProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'extraWordMilestone');
    });
  }

  QueryBuilder<SavedGame, List<String>, QQueryOperations>
      foundExtrasProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'foundExtras');
    });
  }

  QueryBuilder<SavedGame, List<String>, QQueryOperations> foundWordsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'foundWords');
    });
  }

  QueryBuilder<SavedGame, String, QQueryOperations>
      hintRevealedLettersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hintRevealedLetters');
    });
  }

  QueryBuilder<SavedGame, List<int>, QQueryOperations> letterIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'letterIds');
    });
  }

  QueryBuilder<SavedGame, List<String>, QQueryOperations> lettersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'letters');
    });
  }

  QueryBuilder<SavedGame, int, QQueryOperations> levelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'level');
    });
  }

  QueryBuilder<SavedGame, String, QQueryOperations> revealedLettersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'revealedLetters');
    });
  }

  QueryBuilder<SavedGame, List<String>, QQueryOperations> validWordsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'validWords');
    });
  }
}
