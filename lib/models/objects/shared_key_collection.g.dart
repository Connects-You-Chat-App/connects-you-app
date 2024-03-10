// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shared_key_collection.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSharedKeyCollectionCollection on Isar {
  IsarCollection<SharedKeyCollection> get sharedKeyCollections =>
      this.collection();
}

const SharedKeyCollectionSchema = CollectionSchema(
  name: r'SharedKeyCollection',
  id: 1517699118868791767,
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'forRoomId': PropertySchema(
      id: 1,
      name: r'forRoomId',
      type: IsarType.string,
    ),
    r'forUserId': PropertySchema(
      id: 2,
      name: r'forUserId',
      type: IsarType.string,
    ),
    r'sharedKey': PropertySchema(
      id: 3,
      name: r'sharedKey',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 4,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _sharedKeyCollectionEstimateSize,
  serialize: _sharedKeyCollectionSerialize,
  deserialize: _sharedKeyCollectionDeserialize,
  deserializeProp: _sharedKeyCollectionDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _sharedKeyCollectionGetId,
  getLinks: _sharedKeyCollectionGetLinks,
  attach: _sharedKeyCollectionAttach,
  version: '3.1.0+1',
);

int _sharedKeyCollectionEstimateSize(
  SharedKeyCollection object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.forRoomId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.forUserId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.sharedKey.length * 3;
  return bytesCount;
}

void _sharedKeyCollectionSerialize(
  SharedKeyCollection object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeString(offsets[1], object.forRoomId);
  writer.writeString(offsets[2], object.forUserId);
  writer.writeString(offsets[3], object.sharedKey);
  writer.writeDateTime(offsets[4], object.updatedAt);
}

SharedKeyCollection _sharedKeyCollectionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SharedKeyCollection(
    createdAt: reader.readDateTime(offsets[0]),
    forRoomId: reader.readStringOrNull(offsets[1]),
    forUserId: reader.readStringOrNull(offsets[2]),
    id: id,
    sharedKey: reader.readString(offsets[3]),
    updatedAt: reader.readDateTime(offsets[4]),
  );
  return object;
}

P _sharedKeyCollectionDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _sharedKeyCollectionGetId(SharedKeyCollection object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _sharedKeyCollectionGetLinks(
    SharedKeyCollection object) {
  return [];
}

void _sharedKeyCollectionAttach(
    IsarCollection<dynamic> col, Id id, SharedKeyCollection object) {
  object.id = id;
}

extension SharedKeyCollectionQueryWhereSort
    on QueryBuilder<SharedKeyCollection, SharedKeyCollection, QWhere> {
  QueryBuilder<SharedKeyCollection, SharedKeyCollection, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SharedKeyCollectionQueryWhere
    on QueryBuilder<SharedKeyCollection, SharedKeyCollection, QWhereClause> {
  QueryBuilder<SharedKeyCollection, SharedKeyCollection, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<SharedKeyCollection, SharedKeyCollection, QAfterWhereClause>
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

  QueryBuilder<SharedKeyCollection, SharedKeyCollection, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SharedKeyCollection, SharedKeyCollection, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SharedKeyCollection, SharedKeyCollection, QAfterWhereClause>
      idBetween(
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

extension SharedKeyCollectionQueryFilter on QueryBuilder<SharedKeyCollection,
    SharedKeyCollection, QFilterCondition> {
  QueryBuilder<SharedKeyCollection, SharedKeyCollection, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SharedKeyCollection, SharedKeyCollection, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SharedKeyCollection, SharedKeyCollection, QAfterFilterCondition>
      createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SharedKeyCollection, SharedKeyCollection, QAfterFilterCondition>
      createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SharedKeyCollection, SharedKeyCollection, QAfterFilterCondition>
      forRoomIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'forRoomId',
      ));
    });
  }

  QueryBuilder<SharedKeyCollection, SharedKeyCollection, QAfterFilterCondition>
      forRoomIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'forRoomId',
      ));
    });
  }

  QueryBuilder<SharedKeyCollection, SharedKeyCollection, QAfterFilterCondition>
      forRoomIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'forRoomId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SharedKeyCollection, SharedKeyCollection, QAfterFilterCondition>
      forRoomIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'forRoomId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SharedKeyCollection, SharedKeyCollection, QAfterFilterCondition>
      forRoomIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'forRoomId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SharedKeyCollection, SharedKeyCollection, QAfterFilterCondition>
      forRoomIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'forRoomId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SharedKeyCollection, SharedKeyCollection, QAfterFilterCondition>
      forRoomIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'forRoomId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SharedKeyCollection, SharedKeyCollection, QAfterFilterCondition>
      forRoomIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'forRoomId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SharedKeyCollection, SharedKeyCollection, QAfterFilterCondition>
      forRoomIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'forRoomId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SharedKeyCollection, SharedKeyCollection, QAfterFilterCondition>
      forRoomIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'forRoomId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SharedKeyCollection, SharedKeyCollection, QAfterFilterCondition>
      forRoomIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'forRoomId',
        value: '',
      ));
    });
  }

  QueryBuilder<SharedKeyCollection, SharedKeyCollection, QAfterFilterCondition>
      forRoomIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'forRoomId',
        value: '',
      ));
    });
  }

  QueryBuilder<SharedKeyCollection, SharedKeyCollection, QAfterFilterCondition>
      forUserIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'forUserId',
      ));
    });
  }

  QueryBuilder<SharedKeyCollection, SharedKeyCollection, QAfterFilterCondition>
      forUserIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'forUserId',
      ));
    });
  }

  QueryBuilder<SharedKeyCollection, SharedKeyCollection, QAfterFilterCondition>
      forUserIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'forUserId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SharedKeyCollection, SharedKeyCollection, QAfterFilterCondition>
      forUserIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'forUserId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SharedKeyCollection, SharedKeyCollection, QAfterFilterCondition>
      forUserIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'forUserId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SharedKeyCollection, SharedKeyCollection, QAfterFilterCondition>
      forUserIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'forUserId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SharedKeyCollection, SharedKeyCollection, QAfterFilterCondition>
      forUserIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'forUserId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SharedKeyCollection, SharedKeyCollection, QAfterFilterCondition>
      forUserIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'forUserId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SharedKeyCollection, SharedKeyCollection, QAfterFilterCondition>
      forUserIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'forUserId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SharedKeyCollection, SharedKeyCollection, QAfterFilterCondition>
      forUserIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'forUserId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SharedKeyCollection, SharedKeyCollection, QAfterFilterCondition>
      forUserIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'forUserId',
        value: '',
      ));
    });
  }

  QueryBuilder<SharedKeyCollection, SharedKeyCollection, QAfterFilterCondition>
      forUserIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'forUserId',
        value: '',
      ));
    });
  }

  QueryBuilder<SharedKeyCollection, SharedKeyCollection, QAfterFilterCondition>
      idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<SharedKeyCollection, SharedKeyCollection, QAfterFilterCondition>
      idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<SharedKeyCollection, SharedKeyCollection, QAfterFilterCondition>
      idEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SharedKeyCollection, SharedKeyCollection, QAfterFilterCondition>
      idGreaterThan(
    Id? value, {
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

  QueryBuilder<SharedKeyCollection, SharedKeyCollection, QAfterFilterCondition>
      idLessThan(
    Id? value, {
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

  QueryBuilder<SharedKeyCollection, SharedKeyCollection, QAfterFilterCondition>
      idBetween(
    Id? lower,
    Id? upper, {
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

  QueryBuilder<SharedKeyCollection, SharedKeyCollection, QAfterFilterCondition>
      sharedKeyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sharedKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SharedKeyCollection, SharedKeyCollection, QAfterFilterCondition>
      sharedKeyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sharedKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SharedKeyCollection, SharedKeyCollection, QAfterFilterCondition>
      sharedKeyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sharedKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SharedKeyCollection, SharedKeyCollection, QAfterFilterCondition>
      sharedKeyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sharedKey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SharedKeyCollection, SharedKeyCollection, QAfterFilterCondition>
      sharedKeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'sharedKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SharedKeyCollection, SharedKeyCollection, QAfterFilterCondition>
      sharedKeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'sharedKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SharedKeyCollection, SharedKeyCollection, QAfterFilterCondition>
      sharedKeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'sharedKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SharedKeyCollection, SharedKeyCollection, QAfterFilterCondition>
      sharedKeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'sharedKey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SharedKeyCollection, SharedKeyCollection, QAfterFilterCondition>
      sharedKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sharedKey',
        value: '',
      ));
    });
  }

  QueryBuilder<SharedKeyCollection, SharedKeyCollection, QAfterFilterCondition>
      sharedKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'sharedKey',
        value: '',
      ));
    });
  }

  QueryBuilder<SharedKeyCollection, SharedKeyCollection, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SharedKeyCollection, SharedKeyCollection, QAfterFilterCondition>
      updatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SharedKeyCollection, SharedKeyCollection, QAfterFilterCondition>
      updatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SharedKeyCollection, SharedKeyCollection, QAfterFilterCondition>
      updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension SharedKeyCollectionQueryObject on QueryBuilder<SharedKeyCollection,
    SharedKeyCollection, QFilterCondition> {}

extension SharedKeyCollectionQueryLinks on QueryBuilder<SharedKeyCollection,
    SharedKeyCollection, QFilterCondition> {}

extension SharedKeyCollectionQuerySortBy
    on QueryBuilder<SharedKeyCollection, SharedKeyCollection, QSortBy> {
  QueryBuilder<SharedKeyCollection, SharedKeyCollection, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<SharedKeyCollection, SharedKeyCollection, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<SharedKeyCollection, SharedKeyCollection, QAfterSortBy>
      sortByForRoomId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'forRoomId', Sort.asc);
    });
  }

  QueryBuilder<SharedKeyCollection, SharedKeyCollection, QAfterSortBy>
      sortByForRoomIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'forRoomId', Sort.desc);
    });
  }

  QueryBuilder<SharedKeyCollection, SharedKeyCollection, QAfterSortBy>
      sortByForUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'forUserId', Sort.asc);
    });
  }

  QueryBuilder<SharedKeyCollection, SharedKeyCollection, QAfterSortBy>
      sortByForUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'forUserId', Sort.desc);
    });
  }

  QueryBuilder<SharedKeyCollection, SharedKeyCollection, QAfterSortBy>
      sortBySharedKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sharedKey', Sort.asc);
    });
  }

  QueryBuilder<SharedKeyCollection, SharedKeyCollection, QAfterSortBy>
      sortBySharedKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sharedKey', Sort.desc);
    });
  }

  QueryBuilder<SharedKeyCollection, SharedKeyCollection, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<SharedKeyCollection, SharedKeyCollection, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension SharedKeyCollectionQuerySortThenBy
    on QueryBuilder<SharedKeyCollection, SharedKeyCollection, QSortThenBy> {
  QueryBuilder<SharedKeyCollection, SharedKeyCollection, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<SharedKeyCollection, SharedKeyCollection, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<SharedKeyCollection, SharedKeyCollection, QAfterSortBy>
      thenByForRoomId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'forRoomId', Sort.asc);
    });
  }

  QueryBuilder<SharedKeyCollection, SharedKeyCollection, QAfterSortBy>
      thenByForRoomIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'forRoomId', Sort.desc);
    });
  }

  QueryBuilder<SharedKeyCollection, SharedKeyCollection, QAfterSortBy>
      thenByForUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'forUserId', Sort.asc);
    });
  }

  QueryBuilder<SharedKeyCollection, SharedKeyCollection, QAfterSortBy>
      thenByForUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'forUserId', Sort.desc);
    });
  }

  QueryBuilder<SharedKeyCollection, SharedKeyCollection, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SharedKeyCollection, SharedKeyCollection, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SharedKeyCollection, SharedKeyCollection, QAfterSortBy>
      thenBySharedKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sharedKey', Sort.asc);
    });
  }

  QueryBuilder<SharedKeyCollection, SharedKeyCollection, QAfterSortBy>
      thenBySharedKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sharedKey', Sort.desc);
    });
  }

  QueryBuilder<SharedKeyCollection, SharedKeyCollection, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<SharedKeyCollection, SharedKeyCollection, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension SharedKeyCollectionQueryWhereDistinct
    on QueryBuilder<SharedKeyCollection, SharedKeyCollection, QDistinct> {
  QueryBuilder<SharedKeyCollection, SharedKeyCollection, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<SharedKeyCollection, SharedKeyCollection, QDistinct>
      distinctByForRoomId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'forRoomId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SharedKeyCollection, SharedKeyCollection, QDistinct>
      distinctByForUserId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'forUserId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SharedKeyCollection, SharedKeyCollection, QDistinct>
      distinctBySharedKey({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sharedKey', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SharedKeyCollection, SharedKeyCollection, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension SharedKeyCollectionQueryProperty
    on QueryBuilder<SharedKeyCollection, SharedKeyCollection, QQueryProperty> {
  QueryBuilder<SharedKeyCollection, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SharedKeyCollection, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<SharedKeyCollection, String?, QQueryOperations>
      forRoomIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'forRoomId');
    });
  }

  QueryBuilder<SharedKeyCollection, String?, QQueryOperations>
      forUserIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'forUserId');
    });
  }

  QueryBuilder<SharedKeyCollection, String, QQueryOperations>
      sharedKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sharedKey');
    });
  }

  QueryBuilder<SharedKeyCollection, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
