// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $PatientProfilesTable extends PatientProfiles
    with TableInfo<$PatientProfilesTable, PatientProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PatientProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fullNameMeta =
      const VerificationMeta('fullName');
  @override
  late final GeneratedColumn<String> fullName = GeneratedColumn<String>(
      'full_name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _ageMeta = const VerificationMeta('age');
  @override
  late final GeneratedColumn<int> age = GeneratedColumn<int>(
      'age', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<String> gender = GeneratedColumn<String>(
      'gender', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _addressMeta =
      const VerificationMeta('address');
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
      'address', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _bloodGroupMeta =
      const VerificationMeta('bloodGroup');
  @override
  late final GeneratedColumn<String> bloodGroup = GeneratedColumn<String>(
      'blood_group', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _emergencyContactNameMeta =
      const VerificationMeta('emergencyContactName');
  @override
  late final GeneratedColumn<String> emergencyContactName =
      GeneratedColumn<String>('emergency_contact_name', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _emergencyContactPhoneMeta =
      const VerificationMeta('emergencyContactPhone');
  @override
  late final GeneratedColumn<String> emergencyContactPhone =
      GeneratedColumn<String>('emergency_contact_phone', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _heightMeta = const VerificationMeta('height');
  @override
  late final GeneratedColumn<double> height = GeneratedColumn<double>(
      'height', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _weightMeta = const VerificationMeta('weight');
  @override
  late final GeneratedColumn<double> weight = GeneratedColumn<double>(
      'weight', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _chronicConditionsMeta =
      const VerificationMeta('chronicConditions');
  @override
  late final GeneratedColumn<String> chronicConditions =
      GeneratedColumn<String>('chronic_conditions', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _allergiesMeta =
      const VerificationMeta('allergies');
  @override
  late final GeneratedColumn<String> allergies = GeneratedColumn<String>(
      'allergies', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _profileImagePathMeta =
      const VerificationMeta('profileImagePath');
  @override
  late final GeneratedColumn<String> profileImagePath = GeneratedColumn<String>(
      'profile_image_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isSyncedMeta =
      const VerificationMeta('isSynced');
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
      'is_synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        fullName,
        age,
        gender,
        phone,
        email,
        address,
        bloodGroup,
        emergencyContactName,
        emergencyContactPhone,
        height,
        weight,
        chronicConditions,
        allergies,
        profileImagePath,
        isSynced,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'patient_profiles';
  @override
  VerificationContext validateIntegrity(Insertable<PatientProfile> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('full_name')) {
      context.handle(_fullNameMeta,
          fullName.isAcceptableOrUnknown(data['full_name']!, _fullNameMeta));
    } else if (isInserting) {
      context.missing(_fullNameMeta);
    }
    if (data.containsKey('age')) {
      context.handle(
          _ageMeta, age.isAcceptableOrUnknown(data['age']!, _ageMeta));
    }
    if (data.containsKey('gender')) {
      context.handle(_genderMeta,
          gender.isAcceptableOrUnknown(data['gender']!, _genderMeta));
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    if (data.containsKey('address')) {
      context.handle(_addressMeta,
          address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    }
    if (data.containsKey('blood_group')) {
      context.handle(
          _bloodGroupMeta,
          bloodGroup.isAcceptableOrUnknown(
              data['blood_group']!, _bloodGroupMeta));
    }
    if (data.containsKey('emergency_contact_name')) {
      context.handle(
          _emergencyContactNameMeta,
          emergencyContactName.isAcceptableOrUnknown(
              data['emergency_contact_name']!, _emergencyContactNameMeta));
    }
    if (data.containsKey('emergency_contact_phone')) {
      context.handle(
          _emergencyContactPhoneMeta,
          emergencyContactPhone.isAcceptableOrUnknown(
              data['emergency_contact_phone']!, _emergencyContactPhoneMeta));
    }
    if (data.containsKey('height')) {
      context.handle(_heightMeta,
          height.isAcceptableOrUnknown(data['height']!, _heightMeta));
    }
    if (data.containsKey('weight')) {
      context.handle(_weightMeta,
          weight.isAcceptableOrUnknown(data['weight']!, _weightMeta));
    }
    if (data.containsKey('chronic_conditions')) {
      context.handle(
          _chronicConditionsMeta,
          chronicConditions.isAcceptableOrUnknown(
              data['chronic_conditions']!, _chronicConditionsMeta));
    }
    if (data.containsKey('allergies')) {
      context.handle(_allergiesMeta,
          allergies.isAcceptableOrUnknown(data['allergies']!, _allergiesMeta));
    }
    if (data.containsKey('profile_image_path')) {
      context.handle(
          _profileImagePathMeta,
          profileImagePath.isAcceptableOrUnknown(
              data['profile_image_path']!, _profileImagePathMeta));
    }
    if (data.containsKey('is_synced')) {
      context.handle(_isSyncedMeta,
          isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PatientProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PatientProfile(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      fullName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}full_name'])!,
      age: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}age']),
      gender: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}gender']),
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone']),
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email']),
      address: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address']),
      bloodGroup: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}blood_group']),
      emergencyContactName: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}emergency_contact_name']),
      emergencyContactPhone: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}emergency_contact_phone']),
      height: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}height']),
      weight: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}weight']),
      chronicConditions: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}chronic_conditions']),
      allergies: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}allergies']),
      profileImagePath: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}profile_image_path']),
      isSynced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_synced'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $PatientProfilesTable createAlias(String alias) {
    return $PatientProfilesTable(attachedDatabase, alias);
  }
}

class PatientProfile extends DataClass implements Insertable<PatientProfile> {
  final String id;
  final String userId;
  final String fullName;
  final int? age;
  final String? gender;
  final String? phone;
  final String? email;
  final String? address;
  final String? bloodGroup;
  final String? emergencyContactName;
  final String? emergencyContactPhone;
  final double? height;
  final double? weight;
  final String? chronicConditions;
  final String? allergies;
  final String? profileImagePath;
  final bool isSynced;
  final DateTime createdAt;
  final DateTime updatedAt;
  const PatientProfile(
      {required this.id,
      required this.userId,
      required this.fullName,
      this.age,
      this.gender,
      this.phone,
      this.email,
      this.address,
      this.bloodGroup,
      this.emergencyContactName,
      this.emergencyContactPhone,
      this.height,
      this.weight,
      this.chronicConditions,
      this.allergies,
      this.profileImagePath,
      required this.isSynced,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['full_name'] = Variable<String>(fullName);
    if (!nullToAbsent || age != null) {
      map['age'] = Variable<int>(age);
    }
    if (!nullToAbsent || gender != null) {
      map['gender'] = Variable<String>(gender);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || bloodGroup != null) {
      map['blood_group'] = Variable<String>(bloodGroup);
    }
    if (!nullToAbsent || emergencyContactName != null) {
      map['emergency_contact_name'] = Variable<String>(emergencyContactName);
    }
    if (!nullToAbsent || emergencyContactPhone != null) {
      map['emergency_contact_phone'] = Variable<String>(emergencyContactPhone);
    }
    if (!nullToAbsent || height != null) {
      map['height'] = Variable<double>(height);
    }
    if (!nullToAbsent || weight != null) {
      map['weight'] = Variable<double>(weight);
    }
    if (!nullToAbsent || chronicConditions != null) {
      map['chronic_conditions'] = Variable<String>(chronicConditions);
    }
    if (!nullToAbsent || allergies != null) {
      map['allergies'] = Variable<String>(allergies);
    }
    if (!nullToAbsent || profileImagePath != null) {
      map['profile_image_path'] = Variable<String>(profileImagePath);
    }
    map['is_synced'] = Variable<bool>(isSynced);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PatientProfilesCompanion toCompanion(bool nullToAbsent) {
    return PatientProfilesCompanion(
      id: Value(id),
      userId: Value(userId),
      fullName: Value(fullName),
      age: age == null && nullToAbsent ? const Value.absent() : Value(age),
      gender:
          gender == null && nullToAbsent ? const Value.absent() : Value(gender),
      phone:
          phone == null && nullToAbsent ? const Value.absent() : Value(phone),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      bloodGroup: bloodGroup == null && nullToAbsent
          ? const Value.absent()
          : Value(bloodGroup),
      emergencyContactName: emergencyContactName == null && nullToAbsent
          ? const Value.absent()
          : Value(emergencyContactName),
      emergencyContactPhone: emergencyContactPhone == null && nullToAbsent
          ? const Value.absent()
          : Value(emergencyContactPhone),
      height:
          height == null && nullToAbsent ? const Value.absent() : Value(height),
      weight:
          weight == null && nullToAbsent ? const Value.absent() : Value(weight),
      chronicConditions: chronicConditions == null && nullToAbsent
          ? const Value.absent()
          : Value(chronicConditions),
      allergies: allergies == null && nullToAbsent
          ? const Value.absent()
          : Value(allergies),
      profileImagePath: profileImagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(profileImagePath),
      isSynced: Value(isSynced),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory PatientProfile.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PatientProfile(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      fullName: serializer.fromJson<String>(json['fullName']),
      age: serializer.fromJson<int?>(json['age']),
      gender: serializer.fromJson<String?>(json['gender']),
      phone: serializer.fromJson<String?>(json['phone']),
      email: serializer.fromJson<String?>(json['email']),
      address: serializer.fromJson<String?>(json['address']),
      bloodGroup: serializer.fromJson<String?>(json['bloodGroup']),
      emergencyContactName:
          serializer.fromJson<String?>(json['emergencyContactName']),
      emergencyContactPhone:
          serializer.fromJson<String?>(json['emergencyContactPhone']),
      height: serializer.fromJson<double?>(json['height']),
      weight: serializer.fromJson<double?>(json['weight']),
      chronicConditions:
          serializer.fromJson<String?>(json['chronicConditions']),
      allergies: serializer.fromJson<String?>(json['allergies']),
      profileImagePath: serializer.fromJson<String?>(json['profileImagePath']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'fullName': serializer.toJson<String>(fullName),
      'age': serializer.toJson<int?>(age),
      'gender': serializer.toJson<String?>(gender),
      'phone': serializer.toJson<String?>(phone),
      'email': serializer.toJson<String?>(email),
      'address': serializer.toJson<String?>(address),
      'bloodGroup': serializer.toJson<String?>(bloodGroup),
      'emergencyContactName': serializer.toJson<String?>(emergencyContactName),
      'emergencyContactPhone':
          serializer.toJson<String?>(emergencyContactPhone),
      'height': serializer.toJson<double?>(height),
      'weight': serializer.toJson<double?>(weight),
      'chronicConditions': serializer.toJson<String?>(chronicConditions),
      'allergies': serializer.toJson<String?>(allergies),
      'profileImagePath': serializer.toJson<String?>(profileImagePath),
      'isSynced': serializer.toJson<bool>(isSynced),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  PatientProfile copyWith(
          {String? id,
          String? userId,
          String? fullName,
          Value<int?> age = const Value.absent(),
          Value<String?> gender = const Value.absent(),
          Value<String?> phone = const Value.absent(),
          Value<String?> email = const Value.absent(),
          Value<String?> address = const Value.absent(),
          Value<String?> bloodGroup = const Value.absent(),
          Value<String?> emergencyContactName = const Value.absent(),
          Value<String?> emergencyContactPhone = const Value.absent(),
          Value<double?> height = const Value.absent(),
          Value<double?> weight = const Value.absent(),
          Value<String?> chronicConditions = const Value.absent(),
          Value<String?> allergies = const Value.absent(),
          Value<String?> profileImagePath = const Value.absent(),
          bool? isSynced,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      PatientProfile(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        fullName: fullName ?? this.fullName,
        age: age.present ? age.value : this.age,
        gender: gender.present ? gender.value : this.gender,
        phone: phone.present ? phone.value : this.phone,
        email: email.present ? email.value : this.email,
        address: address.present ? address.value : this.address,
        bloodGroup: bloodGroup.present ? bloodGroup.value : this.bloodGroup,
        emergencyContactName: emergencyContactName.present
            ? emergencyContactName.value
            : this.emergencyContactName,
        emergencyContactPhone: emergencyContactPhone.present
            ? emergencyContactPhone.value
            : this.emergencyContactPhone,
        height: height.present ? height.value : this.height,
        weight: weight.present ? weight.value : this.weight,
        chronicConditions: chronicConditions.present
            ? chronicConditions.value
            : this.chronicConditions,
        allergies: allergies.present ? allergies.value : this.allergies,
        profileImagePath: profileImagePath.present
            ? profileImagePath.value
            : this.profileImagePath,
        isSynced: isSynced ?? this.isSynced,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  PatientProfile copyWithCompanion(PatientProfilesCompanion data) {
    return PatientProfile(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      fullName: data.fullName.present ? data.fullName.value : this.fullName,
      age: data.age.present ? data.age.value : this.age,
      gender: data.gender.present ? data.gender.value : this.gender,
      phone: data.phone.present ? data.phone.value : this.phone,
      email: data.email.present ? data.email.value : this.email,
      address: data.address.present ? data.address.value : this.address,
      bloodGroup:
          data.bloodGroup.present ? data.bloodGroup.value : this.bloodGroup,
      emergencyContactName: data.emergencyContactName.present
          ? data.emergencyContactName.value
          : this.emergencyContactName,
      emergencyContactPhone: data.emergencyContactPhone.present
          ? data.emergencyContactPhone.value
          : this.emergencyContactPhone,
      height: data.height.present ? data.height.value : this.height,
      weight: data.weight.present ? data.weight.value : this.weight,
      chronicConditions: data.chronicConditions.present
          ? data.chronicConditions.value
          : this.chronicConditions,
      allergies: data.allergies.present ? data.allergies.value : this.allergies,
      profileImagePath: data.profileImagePath.present
          ? data.profileImagePath.value
          : this.profileImagePath,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PatientProfile(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('fullName: $fullName, ')
          ..write('age: $age, ')
          ..write('gender: $gender, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('address: $address, ')
          ..write('bloodGroup: $bloodGroup, ')
          ..write('emergencyContactName: $emergencyContactName, ')
          ..write('emergencyContactPhone: $emergencyContactPhone, ')
          ..write('height: $height, ')
          ..write('weight: $weight, ')
          ..write('chronicConditions: $chronicConditions, ')
          ..write('allergies: $allergies, ')
          ..write('profileImagePath: $profileImagePath, ')
          ..write('isSynced: $isSynced, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      userId,
      fullName,
      age,
      gender,
      phone,
      email,
      address,
      bloodGroup,
      emergencyContactName,
      emergencyContactPhone,
      height,
      weight,
      chronicConditions,
      allergies,
      profileImagePath,
      isSynced,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PatientProfile &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.fullName == this.fullName &&
          other.age == this.age &&
          other.gender == this.gender &&
          other.phone == this.phone &&
          other.email == this.email &&
          other.address == this.address &&
          other.bloodGroup == this.bloodGroup &&
          other.emergencyContactName == this.emergencyContactName &&
          other.emergencyContactPhone == this.emergencyContactPhone &&
          other.height == this.height &&
          other.weight == this.weight &&
          other.chronicConditions == this.chronicConditions &&
          other.allergies == this.allergies &&
          other.profileImagePath == this.profileImagePath &&
          other.isSynced == this.isSynced &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PatientProfilesCompanion extends UpdateCompanion<PatientProfile> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> fullName;
  final Value<int?> age;
  final Value<String?> gender;
  final Value<String?> phone;
  final Value<String?> email;
  final Value<String?> address;
  final Value<String?> bloodGroup;
  final Value<String?> emergencyContactName;
  final Value<String?> emergencyContactPhone;
  final Value<double?> height;
  final Value<double?> weight;
  final Value<String?> chronicConditions;
  final Value<String?> allergies;
  final Value<String?> profileImagePath;
  final Value<bool> isSynced;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const PatientProfilesCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.fullName = const Value.absent(),
    this.age = const Value.absent(),
    this.gender = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.address = const Value.absent(),
    this.bloodGroup = const Value.absent(),
    this.emergencyContactName = const Value.absent(),
    this.emergencyContactPhone = const Value.absent(),
    this.height = const Value.absent(),
    this.weight = const Value.absent(),
    this.chronicConditions = const Value.absent(),
    this.allergies = const Value.absent(),
    this.profileImagePath = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PatientProfilesCompanion.insert({
    required String id,
    required String userId,
    required String fullName,
    this.age = const Value.absent(),
    this.gender = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.address = const Value.absent(),
    this.bloodGroup = const Value.absent(),
    this.emergencyContactName = const Value.absent(),
    this.emergencyContactPhone = const Value.absent(),
    this.height = const Value.absent(),
    this.weight = const Value.absent(),
    this.chronicConditions = const Value.absent(),
    this.allergies = const Value.absent(),
    this.profileImagePath = const Value.absent(),
    this.isSynced = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        userId = Value(userId),
        fullName = Value(fullName),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<PatientProfile> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? fullName,
    Expression<int>? age,
    Expression<String>? gender,
    Expression<String>? phone,
    Expression<String>? email,
    Expression<String>? address,
    Expression<String>? bloodGroup,
    Expression<String>? emergencyContactName,
    Expression<String>? emergencyContactPhone,
    Expression<double>? height,
    Expression<double>? weight,
    Expression<String>? chronicConditions,
    Expression<String>? allergies,
    Expression<String>? profileImagePath,
    Expression<bool>? isSynced,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (fullName != null) 'full_name': fullName,
      if (age != null) 'age': age,
      if (gender != null) 'gender': gender,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (address != null) 'address': address,
      if (bloodGroup != null) 'blood_group': bloodGroup,
      if (emergencyContactName != null)
        'emergency_contact_name': emergencyContactName,
      if (emergencyContactPhone != null)
        'emergency_contact_phone': emergencyContactPhone,
      if (height != null) 'height': height,
      if (weight != null) 'weight': weight,
      if (chronicConditions != null) 'chronic_conditions': chronicConditions,
      if (allergies != null) 'allergies': allergies,
      if (profileImagePath != null) 'profile_image_path': profileImagePath,
      if (isSynced != null) 'is_synced': isSynced,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PatientProfilesCompanion copyWith(
      {Value<String>? id,
      Value<String>? userId,
      Value<String>? fullName,
      Value<int?>? age,
      Value<String?>? gender,
      Value<String?>? phone,
      Value<String?>? email,
      Value<String?>? address,
      Value<String?>? bloodGroup,
      Value<String?>? emergencyContactName,
      Value<String?>? emergencyContactPhone,
      Value<double?>? height,
      Value<double?>? weight,
      Value<String?>? chronicConditions,
      Value<String?>? allergies,
      Value<String?>? profileImagePath,
      Value<bool>? isSynced,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return PatientProfilesCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      emergencyContactName: emergencyContactName ?? this.emergencyContactName,
      emergencyContactPhone:
          emergencyContactPhone ?? this.emergencyContactPhone,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      chronicConditions: chronicConditions ?? this.chronicConditions,
      allergies: allergies ?? this.allergies,
      profileImagePath: profileImagePath ?? this.profileImagePath,
      isSynced: isSynced ?? this.isSynced,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (fullName.present) {
      map['full_name'] = Variable<String>(fullName.value);
    }
    if (age.present) {
      map['age'] = Variable<int>(age.value);
    }
    if (gender.present) {
      map['gender'] = Variable<String>(gender.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (bloodGroup.present) {
      map['blood_group'] = Variable<String>(bloodGroup.value);
    }
    if (emergencyContactName.present) {
      map['emergency_contact_name'] =
          Variable<String>(emergencyContactName.value);
    }
    if (emergencyContactPhone.present) {
      map['emergency_contact_phone'] =
          Variable<String>(emergencyContactPhone.value);
    }
    if (height.present) {
      map['height'] = Variable<double>(height.value);
    }
    if (weight.present) {
      map['weight'] = Variable<double>(weight.value);
    }
    if (chronicConditions.present) {
      map['chronic_conditions'] = Variable<String>(chronicConditions.value);
    }
    if (allergies.present) {
      map['allergies'] = Variable<String>(allergies.value);
    }
    if (profileImagePath.present) {
      map['profile_image_path'] = Variable<String>(profileImagePath.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PatientProfilesCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('fullName: $fullName, ')
          ..write('age: $age, ')
          ..write('gender: $gender, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('address: $address, ')
          ..write('bloodGroup: $bloodGroup, ')
          ..write('emergencyContactName: $emergencyContactName, ')
          ..write('emergencyContactPhone: $emergencyContactPhone, ')
          ..write('height: $height, ')
          ..write('weight: $weight, ')
          ..write('chronicConditions: $chronicConditions, ')
          ..write('allergies: $allergies, ')
          ..write('profileImagePath: $profileImagePath, ')
          ..write('isSynced: $isSynced, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncQueueTable extends SyncQueue
    with TableInfo<$SyncQueueTable, SyncQueueData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncQueueTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entityTypeMeta =
      const VerificationMeta('entityType');
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
      'entity_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entityIdMeta =
      const VerificationMeta('entityId');
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
      'entity_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _operationMeta =
      const VerificationMeta('operation');
  @override
  late final GeneratedColumn<String> operation = GeneratedColumn<String>(
      'operation', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _payloadMeta =
      const VerificationMeta('payload');
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
      'payload', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  static const VerificationMeta _retryCountMeta =
      const VerificationMeta('retryCount');
  @override
  late final GeneratedColumn<int> retryCount = GeneratedColumn<int>(
      'retry_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _errorMessageMeta =
      const VerificationMeta('errorMessage');
  @override
  late final GeneratedColumn<String> errorMessage = GeneratedColumn<String>(
      'error_message', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        entityType,
        entityId,
        operation,
        payload,
        status,
        retryCount,
        errorMessage,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_queue';
  @override
  VerificationContext validateIntegrity(Insertable<SyncQueueData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
          _entityTypeMeta,
          entityType.isAcceptableOrUnknown(
              data['entity_type']!, _entityTypeMeta));
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(_entityIdMeta,
          entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta));
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('operation')) {
      context.handle(_operationMeta,
          operation.isAcceptableOrUnknown(data['operation']!, _operationMeta));
    } else if (isInserting) {
      context.missing(_operationMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(_payloadMeta,
          payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta));
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('retry_count')) {
      context.handle(
          _retryCountMeta,
          retryCount.isAcceptableOrUnknown(
              data['retry_count']!, _retryCountMeta));
    }
    if (data.containsKey('error_message')) {
      context.handle(
          _errorMessageMeta,
          errorMessage.isAcceptableOrUnknown(
              data['error_message']!, _errorMessageMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncQueueData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncQueueData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      entityType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_type'])!,
      entityId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_id'])!,
      operation: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}operation'])!,
      payload: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payload'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      retryCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}retry_count'])!,
      errorMessage: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}error_message']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $SyncQueueTable createAlias(String alias) {
    return $SyncQueueTable(attachedDatabase, alias);
  }
}

class SyncQueueData extends DataClass implements Insertable<SyncQueueData> {
  final String id;
  final String entityType;
  final String entityId;
  final String operation;
  final String payload;
  final String status;
  final int retryCount;
  final String? errorMessage;
  final DateTime createdAt;
  final DateTime updatedAt;
  const SyncQueueData(
      {required this.id,
      required this.entityType,
      required this.entityId,
      required this.operation,
      required this.payload,
      required this.status,
      required this.retryCount,
      this.errorMessage,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<String>(entityId);
    map['operation'] = Variable<String>(operation);
    map['payload'] = Variable<String>(payload);
    map['status'] = Variable<String>(status);
    map['retry_count'] = Variable<int>(retryCount);
    if (!nullToAbsent || errorMessage != null) {
      map['error_message'] = Variable<String>(errorMessage);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SyncQueueCompanion toCompanion(bool nullToAbsent) {
    return SyncQueueCompanion(
      id: Value(id),
      entityType: Value(entityType),
      entityId: Value(entityId),
      operation: Value(operation),
      payload: Value(payload),
      status: Value(status),
      retryCount: Value(retryCount),
      errorMessage: errorMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(errorMessage),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory SyncQueueData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncQueueData(
      id: serializer.fromJson<String>(json['id']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<String>(json['entityId']),
      operation: serializer.fromJson<String>(json['operation']),
      payload: serializer.fromJson<String>(json['payload']),
      status: serializer.fromJson<String>(json['status']),
      retryCount: serializer.fromJson<int>(json['retryCount']),
      errorMessage: serializer.fromJson<String?>(json['errorMessage']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<String>(entityId),
      'operation': serializer.toJson<String>(operation),
      'payload': serializer.toJson<String>(payload),
      'status': serializer.toJson<String>(status),
      'retryCount': serializer.toJson<int>(retryCount),
      'errorMessage': serializer.toJson<String?>(errorMessage),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SyncQueueData copyWith(
          {String? id,
          String? entityType,
          String? entityId,
          String? operation,
          String? payload,
          String? status,
          int? retryCount,
          Value<String?> errorMessage = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      SyncQueueData(
        id: id ?? this.id,
        entityType: entityType ?? this.entityType,
        entityId: entityId ?? this.entityId,
        operation: operation ?? this.operation,
        payload: payload ?? this.payload,
        status: status ?? this.status,
        retryCount: retryCount ?? this.retryCount,
        errorMessage:
            errorMessage.present ? errorMessage.value : this.errorMessage,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  SyncQueueData copyWithCompanion(SyncQueueCompanion data) {
    return SyncQueueData(
      id: data.id.present ? data.id.value : this.id,
      entityType:
          data.entityType.present ? data.entityType.value : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      operation: data.operation.present ? data.operation.value : this.operation,
      payload: data.payload.present ? data.payload.value : this.payload,
      status: data.status.present ? data.status.value : this.status,
      retryCount:
          data.retryCount.present ? data.retryCount.value : this.retryCount,
      errorMessage: data.errorMessage.present
          ? data.errorMessage.value
          : this.errorMessage,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueData(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('operation: $operation, ')
          ..write('payload: $payload, ')
          ..write('status: $status, ')
          ..write('retryCount: $retryCount, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, entityType, entityId, operation, payload,
      status, retryCount, errorMessage, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncQueueData &&
          other.id == this.id &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.operation == this.operation &&
          other.payload == this.payload &&
          other.status == this.status &&
          other.retryCount == this.retryCount &&
          other.errorMessage == this.errorMessage &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SyncQueueCompanion extends UpdateCompanion<SyncQueueData> {
  final Value<String> id;
  final Value<String> entityType;
  final Value<String> entityId;
  final Value<String> operation;
  final Value<String> payload;
  final Value<String> status;
  final Value<int> retryCount;
  final Value<String?> errorMessage;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SyncQueueCompanion({
    this.id = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.operation = const Value.absent(),
    this.payload = const Value.absent(),
    this.status = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.errorMessage = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncQueueCompanion.insert({
    required String id,
    required String entityType,
    required String entityId,
    required String operation,
    required String payload,
    this.status = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.errorMessage = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        entityType = Value(entityType),
        entityId = Value(entityId),
        operation = Value(operation),
        payload = Value(payload),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<SyncQueueData> custom({
    Expression<String>? id,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<String>? operation,
    Expression<String>? payload,
    Expression<String>? status,
    Expression<int>? retryCount,
    Expression<String>? errorMessage,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (operation != null) 'operation': operation,
      if (payload != null) 'payload': payload,
      if (status != null) 'status': status,
      if (retryCount != null) 'retry_count': retryCount,
      if (errorMessage != null) 'error_message': errorMessage,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncQueueCompanion copyWith(
      {Value<String>? id,
      Value<String>? entityType,
      Value<String>? entityId,
      Value<String>? operation,
      Value<String>? payload,
      Value<String>? status,
      Value<int>? retryCount,
      Value<String?>? errorMessage,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return SyncQueueCompanion(
      id: id ?? this.id,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      operation: operation ?? this.operation,
      payload: payload ?? this.payload,
      status: status ?? this.status,
      retryCount: retryCount ?? this.retryCount,
      errorMessage: errorMessage ?? this.errorMessage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (operation.present) {
      map['operation'] = Variable<String>(operation.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (retryCount.present) {
      map['retry_count'] = Variable<int>(retryCount.value);
    }
    if (errorMessage.present) {
      map['error_message'] = Variable<String>(errorMessage.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueCompanion(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('operation: $operation, ')
          ..write('payload: $payload, ')
          ..write('status: $status, ')
          ..write('retryCount: $retryCount, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PatientProfilesTable patientProfiles =
      $PatientProfilesTable(this);
  late final $SyncQueueTable syncQueue = $SyncQueueTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [patientProfiles, syncQueue];
}

typedef $$PatientProfilesTableCreateCompanionBuilder = PatientProfilesCompanion
    Function({
  required String id,
  required String userId,
  required String fullName,
  Value<int?> age,
  Value<String?> gender,
  Value<String?> phone,
  Value<String?> email,
  Value<String?> address,
  Value<String?> bloodGroup,
  Value<String?> emergencyContactName,
  Value<String?> emergencyContactPhone,
  Value<double?> height,
  Value<double?> weight,
  Value<String?> chronicConditions,
  Value<String?> allergies,
  Value<String?> profileImagePath,
  Value<bool> isSynced,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$PatientProfilesTableUpdateCompanionBuilder = PatientProfilesCompanion
    Function({
  Value<String> id,
  Value<String> userId,
  Value<String> fullName,
  Value<int?> age,
  Value<String?> gender,
  Value<String?> phone,
  Value<String?> email,
  Value<String?> address,
  Value<String?> bloodGroup,
  Value<String?> emergencyContactName,
  Value<String?> emergencyContactPhone,
  Value<double?> height,
  Value<double?> weight,
  Value<String?> chronicConditions,
  Value<String?> allergies,
  Value<String?> profileImagePath,
  Value<bool> isSynced,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$PatientProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $PatientProfilesTable> {
  $$PatientProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fullName => $composableBuilder(
      column: $table.fullName, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get age => $composableBuilder(
      column: $table.age, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get gender => $composableBuilder(
      column: $table.gender, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get bloodGroup => $composableBuilder(
      column: $table.bloodGroup, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get emergencyContactName => $composableBuilder(
      column: $table.emergencyContactName,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get emergencyContactPhone => $composableBuilder(
      column: $table.emergencyContactPhone,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get height => $composableBuilder(
      column: $table.height, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get weight => $composableBuilder(
      column: $table.weight, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get chronicConditions => $composableBuilder(
      column: $table.chronicConditions,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get allergies => $composableBuilder(
      column: $table.allergies, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get profileImagePath => $composableBuilder(
      column: $table.profileImagePath,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$PatientProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $PatientProfilesTable> {
  $$PatientProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fullName => $composableBuilder(
      column: $table.fullName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get age => $composableBuilder(
      column: $table.age, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get gender => $composableBuilder(
      column: $table.gender, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get bloodGroup => $composableBuilder(
      column: $table.bloodGroup, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get emergencyContactName => $composableBuilder(
      column: $table.emergencyContactName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get emergencyContactPhone => $composableBuilder(
      column: $table.emergencyContactPhone,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get height => $composableBuilder(
      column: $table.height, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get weight => $composableBuilder(
      column: $table.weight, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get chronicConditions => $composableBuilder(
      column: $table.chronicConditions,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get allergies => $composableBuilder(
      column: $table.allergies, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get profileImagePath => $composableBuilder(
      column: $table.profileImagePath,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$PatientProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PatientProfilesTable> {
  $$PatientProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get fullName =>
      $composableBuilder(column: $table.fullName, builder: (column) => column);

  GeneratedColumn<int> get age =>
      $composableBuilder(column: $table.age, builder: (column) => column);

  GeneratedColumn<String> get gender =>
      $composableBuilder(column: $table.gender, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get bloodGroup => $composableBuilder(
      column: $table.bloodGroup, builder: (column) => column);

  GeneratedColumn<String> get emergencyContactName => $composableBuilder(
      column: $table.emergencyContactName, builder: (column) => column);

  GeneratedColumn<String> get emergencyContactPhone => $composableBuilder(
      column: $table.emergencyContactPhone, builder: (column) => column);

  GeneratedColumn<double> get height =>
      $composableBuilder(column: $table.height, builder: (column) => column);

  GeneratedColumn<double> get weight =>
      $composableBuilder(column: $table.weight, builder: (column) => column);

  GeneratedColumn<String> get chronicConditions => $composableBuilder(
      column: $table.chronicConditions, builder: (column) => column);

  GeneratedColumn<String> get allergies =>
      $composableBuilder(column: $table.allergies, builder: (column) => column);

  GeneratedColumn<String> get profileImagePath => $composableBuilder(
      column: $table.profileImagePath, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$PatientProfilesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PatientProfilesTable,
    PatientProfile,
    $$PatientProfilesTableFilterComposer,
    $$PatientProfilesTableOrderingComposer,
    $$PatientProfilesTableAnnotationComposer,
    $$PatientProfilesTableCreateCompanionBuilder,
    $$PatientProfilesTableUpdateCompanionBuilder,
    (
      PatientProfile,
      BaseReferences<_$AppDatabase, $PatientProfilesTable, PatientProfile>
    ),
    PatientProfile,
    PrefetchHooks Function()> {
  $$PatientProfilesTableTableManager(
      _$AppDatabase db, $PatientProfilesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PatientProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PatientProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PatientProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<String> fullName = const Value.absent(),
            Value<int?> age = const Value.absent(),
            Value<String?> gender = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<String?> bloodGroup = const Value.absent(),
            Value<String?> emergencyContactName = const Value.absent(),
            Value<String?> emergencyContactPhone = const Value.absent(),
            Value<double?> height = const Value.absent(),
            Value<double?> weight = const Value.absent(),
            Value<String?> chronicConditions = const Value.absent(),
            Value<String?> allergies = const Value.absent(),
            Value<String?> profileImagePath = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PatientProfilesCompanion(
            id: id,
            userId: userId,
            fullName: fullName,
            age: age,
            gender: gender,
            phone: phone,
            email: email,
            address: address,
            bloodGroup: bloodGroup,
            emergencyContactName: emergencyContactName,
            emergencyContactPhone: emergencyContactPhone,
            height: height,
            weight: weight,
            chronicConditions: chronicConditions,
            allergies: allergies,
            profileImagePath: profileImagePath,
            isSynced: isSynced,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String userId,
            required String fullName,
            Value<int?> age = const Value.absent(),
            Value<String?> gender = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<String?> bloodGroup = const Value.absent(),
            Value<String?> emergencyContactName = const Value.absent(),
            Value<String?> emergencyContactPhone = const Value.absent(),
            Value<double?> height = const Value.absent(),
            Value<double?> weight = const Value.absent(),
            Value<String?> chronicConditions = const Value.absent(),
            Value<String?> allergies = const Value.absent(),
            Value<String?> profileImagePath = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              PatientProfilesCompanion.insert(
            id: id,
            userId: userId,
            fullName: fullName,
            age: age,
            gender: gender,
            phone: phone,
            email: email,
            address: address,
            bloodGroup: bloodGroup,
            emergencyContactName: emergencyContactName,
            emergencyContactPhone: emergencyContactPhone,
            height: height,
            weight: weight,
            chronicConditions: chronicConditions,
            allergies: allergies,
            profileImagePath: profileImagePath,
            isSynced: isSynced,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PatientProfilesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PatientProfilesTable,
    PatientProfile,
    $$PatientProfilesTableFilterComposer,
    $$PatientProfilesTableOrderingComposer,
    $$PatientProfilesTableAnnotationComposer,
    $$PatientProfilesTableCreateCompanionBuilder,
    $$PatientProfilesTableUpdateCompanionBuilder,
    (
      PatientProfile,
      BaseReferences<_$AppDatabase, $PatientProfilesTable, PatientProfile>
    ),
    PatientProfile,
    PrefetchHooks Function()>;
typedef $$SyncQueueTableCreateCompanionBuilder = SyncQueueCompanion Function({
  required String id,
  required String entityType,
  required String entityId,
  required String operation,
  required String payload,
  Value<String> status,
  Value<int> retryCount,
  Value<String?> errorMessage,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$SyncQueueTableUpdateCompanionBuilder = SyncQueueCompanion Function({
  Value<String> id,
  Value<String> entityType,
  Value<String> entityId,
  Value<String> operation,
  Value<String> payload,
  Value<String> status,
  Value<int> retryCount,
  Value<String?> errorMessage,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$SyncQueueTableFilterComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entityId => $composableBuilder(
      column: $table.entityId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get operation => $composableBuilder(
      column: $table.operation, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get payload => $composableBuilder(
      column: $table.payload, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get retryCount => $composableBuilder(
      column: $table.retryCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get errorMessage => $composableBuilder(
      column: $table.errorMessage, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$SyncQueueTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entityId => $composableBuilder(
      column: $table.entityId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get operation => $composableBuilder(
      column: $table.operation, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get payload => $composableBuilder(
      column: $table.payload, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get retryCount => $composableBuilder(
      column: $table.retryCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get errorMessage => $composableBuilder(
      column: $table.errorMessage,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$SyncQueueTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => column);

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get operation =>
      $composableBuilder(column: $table.operation, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get retryCount => $composableBuilder(
      column: $table.retryCount, builder: (column) => column);

  GeneratedColumn<String> get errorMessage => $composableBuilder(
      column: $table.errorMessage, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SyncQueueTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SyncQueueTable,
    SyncQueueData,
    $$SyncQueueTableFilterComposer,
    $$SyncQueueTableOrderingComposer,
    $$SyncQueueTableAnnotationComposer,
    $$SyncQueueTableCreateCompanionBuilder,
    $$SyncQueueTableUpdateCompanionBuilder,
    (
      SyncQueueData,
      BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueData>
    ),
    SyncQueueData,
    PrefetchHooks Function()> {
  $$SyncQueueTableTableManager(_$AppDatabase db, $SyncQueueTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncQueueTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncQueueTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncQueueTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> entityType = const Value.absent(),
            Value<String> entityId = const Value.absent(),
            Value<String> operation = const Value.absent(),
            Value<String> payload = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int> retryCount = const Value.absent(),
            Value<String?> errorMessage = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SyncQueueCompanion(
            id: id,
            entityType: entityType,
            entityId: entityId,
            operation: operation,
            payload: payload,
            status: status,
            retryCount: retryCount,
            errorMessage: errorMessage,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String entityType,
            required String entityId,
            required String operation,
            required String payload,
            Value<String> status = const Value.absent(),
            Value<int> retryCount = const Value.absent(),
            Value<String?> errorMessage = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              SyncQueueCompanion.insert(
            id: id,
            entityType: entityType,
            entityId: entityId,
            operation: operation,
            payload: payload,
            status: status,
            retryCount: retryCount,
            errorMessage: errorMessage,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SyncQueueTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SyncQueueTable,
    SyncQueueData,
    $$SyncQueueTableFilterComposer,
    $$SyncQueueTableOrderingComposer,
    $$SyncQueueTableAnnotationComposer,
    $$SyncQueueTableCreateCompanionBuilder,
    $$SyncQueueTableUpdateCompanionBuilder,
    (
      SyncQueueData,
      BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueData>
    ),
    SyncQueueData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PatientProfilesTableTableManager get patientProfiles =>
      $$PatientProfilesTableTableManager(_db, _db.patientProfiles);
  $$SyncQueueTableTableManager get syncQueue =>
      $$SyncQueueTableTableManager(_db, _db.syncQueue);
}
