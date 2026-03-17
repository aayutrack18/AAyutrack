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

class $MedicinesTable extends Medicines
    with TableInfo<$MedicinesTable, Medicine> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MedicinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _patientIdMeta =
      const VerificationMeta('patientId');
  @override
  late final GeneratedColumn<String> patientId = GeneratedColumn<String>(
      'patient_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 120),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _dosageMeta = const VerificationMeta('dosage');
  @override
  late final GeneratedColumn<String> dosage = GeneratedColumn<String>(
      'dosage', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _frequencyMeta =
      const VerificationMeta('frequency');
  @override
  late final GeneratedColumn<String> frequency = GeneratedColumn<String>(
      'frequency', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _scheduledTimesMeta =
      const VerificationMeta('scheduledTimes');
  @override
  late final GeneratedColumn<String> scheduledTimes = GeneratedColumn<String>(
      'scheduled_times', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
      'color', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
      'unit', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _formMeta = const VerificationMeta('form');
  @override
  late final GeneratedColumn<String> form = GeneratedColumn<String>(
      'form', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _instructionsMeta =
      const VerificationMeta('instructions');
  @override
  late final GeneratedColumn<String> instructions = GeneratedColumn<String>(
      'instructions', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _stockCountMeta =
      const VerificationMeta('stockCount');
  @override
  late final GeneratedColumn<int> stockCount = GeneratedColumn<int>(
      'stock_count', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
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
  static const VerificationMeta _startDateMeta =
      const VerificationMeta('startDate');
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
      'start_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _endDateMeta =
      const VerificationMeta('endDate');
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
      'end_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
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
        patientId,
        name,
        dosage,
        frequency,
        scheduledTimes,
        color,
        unit,
        form,
        instructions,
        stockCount,
        isActive,
        isDeleted,
        isSynced,
        startDate,
        endDate,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'medicines';
  @override
  VerificationContext validateIntegrity(Insertable<Medicine> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('patient_id')) {
      context.handle(_patientIdMeta,
          patientId.isAcceptableOrUnknown(data['patient_id']!, _patientIdMeta));
    } else if (isInserting) {
      context.missing(_patientIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('dosage')) {
      context.handle(_dosageMeta,
          dosage.isAcceptableOrUnknown(data['dosage']!, _dosageMeta));
    }
    if (data.containsKey('frequency')) {
      context.handle(_frequencyMeta,
          frequency.isAcceptableOrUnknown(data['frequency']!, _frequencyMeta));
    }
    if (data.containsKey('scheduled_times')) {
      context.handle(
          _scheduledTimesMeta,
          scheduledTimes.isAcceptableOrUnknown(
              data['scheduled_times']!, _scheduledTimesMeta));
    }
    if (data.containsKey('color')) {
      context.handle(
          _colorMeta, color.isAcceptableOrUnknown(data['color']!, _colorMeta));
    }
    if (data.containsKey('unit')) {
      context.handle(
          _unitMeta, unit.isAcceptableOrUnknown(data['unit']!, _unitMeta));
    }
    if (data.containsKey('form')) {
      context.handle(
          _formMeta, form.isAcceptableOrUnknown(data['form']!, _formMeta));
    }
    if (data.containsKey('instructions')) {
      context.handle(
          _instructionsMeta,
          instructions.isAcceptableOrUnknown(
              data['instructions']!, _instructionsMeta));
    }
    if (data.containsKey('stock_count')) {
      context.handle(
          _stockCountMeta,
          stockCount.isAcceptableOrUnknown(
              data['stock_count']!, _stockCountMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    if (data.containsKey('is_synced')) {
      context.handle(_isSyncedMeta,
          isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta));
    }
    if (data.containsKey('start_date')) {
      context.handle(_startDateMeta,
          startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta));
    }
    if (data.containsKey('end_date')) {
      context.handle(_endDateMeta,
          endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta));
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
  Medicine map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Medicine(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      patientId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}patient_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      dosage: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}dosage']),
      frequency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}frequency']),
      scheduledTimes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}scheduled_times']),
      color: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}color']),
      unit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit']),
      form: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}form']),
      instructions: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}instructions']),
      stockCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}stock_count']),
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
      isSynced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_synced'])!,
      startDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_date']),
      endDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}end_date']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $MedicinesTable createAlias(String alias) {
    return $MedicinesTable(attachedDatabase, alias);
  }
}

class Medicine extends DataClass implements Insertable<Medicine> {
  final String id;
  final String patientId;
  final String name;
  final String? dosage;
  final String? frequency;
  final String? scheduledTimes;
  final String? color;
  final String? unit;
  final String? form;
  final String? instructions;
  final int? stockCount;
  final bool isActive;
  final bool isDeleted;
  final bool isSynced;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Medicine(
      {required this.id,
      required this.patientId,
      required this.name,
      this.dosage,
      this.frequency,
      this.scheduledTimes,
      this.color,
      this.unit,
      this.form,
      this.instructions,
      this.stockCount,
      required this.isActive,
      required this.isDeleted,
      required this.isSynced,
      this.startDate,
      this.endDate,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['patient_id'] = Variable<String>(patientId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || dosage != null) {
      map['dosage'] = Variable<String>(dosage);
    }
    if (!nullToAbsent || frequency != null) {
      map['frequency'] = Variable<String>(frequency);
    }
    if (!nullToAbsent || scheduledTimes != null) {
      map['scheduled_times'] = Variable<String>(scheduledTimes);
    }
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<String>(color);
    }
    if (!nullToAbsent || unit != null) {
      map['unit'] = Variable<String>(unit);
    }
    if (!nullToAbsent || form != null) {
      map['form'] = Variable<String>(form);
    }
    if (!nullToAbsent || instructions != null) {
      map['instructions'] = Variable<String>(instructions);
    }
    if (!nullToAbsent || stockCount != null) {
      map['stock_count'] = Variable<int>(stockCount);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['is_synced'] = Variable<bool>(isSynced);
    if (!nullToAbsent || startDate != null) {
      map['start_date'] = Variable<DateTime>(startDate);
    }
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<DateTime>(endDate);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  MedicinesCompanion toCompanion(bool nullToAbsent) {
    return MedicinesCompanion(
      id: Value(id),
      patientId: Value(patientId),
      name: Value(name),
      dosage:
          dosage == null && nullToAbsent ? const Value.absent() : Value(dosage),
      frequency: frequency == null && nullToAbsent
          ? const Value.absent()
          : Value(frequency),
      scheduledTimes: scheduledTimes == null && nullToAbsent
          ? const Value.absent()
          : Value(scheduledTimes),
      color:
          color == null && nullToAbsent ? const Value.absent() : Value(color),
      unit: unit == null && nullToAbsent ? const Value.absent() : Value(unit),
      form: form == null && nullToAbsent ? const Value.absent() : Value(form),
      instructions: instructions == null && nullToAbsent
          ? const Value.absent()
          : Value(instructions),
      stockCount: stockCount == null && nullToAbsent
          ? const Value.absent()
          : Value(stockCount),
      isActive: Value(isActive),
      isDeleted: Value(isDeleted),
      isSynced: Value(isSynced),
      startDate: startDate == null && nullToAbsent
          ? const Value.absent()
          : Value(startDate),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Medicine.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Medicine(
      id: serializer.fromJson<String>(json['id']),
      patientId: serializer.fromJson<String>(json['patientId']),
      name: serializer.fromJson<String>(json['name']),
      dosage: serializer.fromJson<String?>(json['dosage']),
      frequency: serializer.fromJson<String?>(json['frequency']),
      scheduledTimes: serializer.fromJson<String?>(json['scheduledTimes']),
      color: serializer.fromJson<String?>(json['color']),
      unit: serializer.fromJson<String?>(json['unit']),
      form: serializer.fromJson<String?>(json['form']),
      instructions: serializer.fromJson<String?>(json['instructions']),
      stockCount: serializer.fromJson<int?>(json['stockCount']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      startDate: serializer.fromJson<DateTime?>(json['startDate']),
      endDate: serializer.fromJson<DateTime?>(json['endDate']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'patientId': serializer.toJson<String>(patientId),
      'name': serializer.toJson<String>(name),
      'dosage': serializer.toJson<String?>(dosage),
      'frequency': serializer.toJson<String?>(frequency),
      'scheduledTimes': serializer.toJson<String?>(scheduledTimes),
      'color': serializer.toJson<String?>(color),
      'unit': serializer.toJson<String?>(unit),
      'form': serializer.toJson<String?>(form),
      'instructions': serializer.toJson<String?>(instructions),
      'stockCount': serializer.toJson<int?>(stockCount),
      'isActive': serializer.toJson<bool>(isActive),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'isSynced': serializer.toJson<bool>(isSynced),
      'startDate': serializer.toJson<DateTime?>(startDate),
      'endDate': serializer.toJson<DateTime?>(endDate),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Medicine copyWith(
          {String? id,
          String? patientId,
          String? name,
          Value<String?> dosage = const Value.absent(),
          Value<String?> frequency = const Value.absent(),
          Value<String?> scheduledTimes = const Value.absent(),
          Value<String?> color = const Value.absent(),
          Value<String?> unit = const Value.absent(),
          Value<String?> form = const Value.absent(),
          Value<String?> instructions = const Value.absent(),
          Value<int?> stockCount = const Value.absent(),
          bool? isActive,
          bool? isDeleted,
          bool? isSynced,
          Value<DateTime?> startDate = const Value.absent(),
          Value<DateTime?> endDate = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Medicine(
        id: id ?? this.id,
        patientId: patientId ?? this.patientId,
        name: name ?? this.name,
        dosage: dosage.present ? dosage.value : this.dosage,
        frequency: frequency.present ? frequency.value : this.frequency,
        scheduledTimes:
            scheduledTimes.present ? scheduledTimes.value : this.scheduledTimes,
        color: color.present ? color.value : this.color,
        unit: unit.present ? unit.value : this.unit,
        form: form.present ? form.value : this.form,
        instructions:
            instructions.present ? instructions.value : this.instructions,
        stockCount: stockCount.present ? stockCount.value : this.stockCount,
        isActive: isActive ?? this.isActive,
        isDeleted: isDeleted ?? this.isDeleted,
        isSynced: isSynced ?? this.isSynced,
        startDate: startDate.present ? startDate.value : this.startDate,
        endDate: endDate.present ? endDate.value : this.endDate,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Medicine copyWithCompanion(MedicinesCompanion data) {
    return Medicine(
      id: data.id.present ? data.id.value : this.id,
      patientId: data.patientId.present ? data.patientId.value : this.patientId,
      name: data.name.present ? data.name.value : this.name,
      dosage: data.dosage.present ? data.dosage.value : this.dosage,
      frequency: data.frequency.present ? data.frequency.value : this.frequency,
      scheduledTimes: data.scheduledTimes.present
          ? data.scheduledTimes.value
          : this.scheduledTimes,
      color: data.color.present ? data.color.value : this.color,
      unit: data.unit.present ? data.unit.value : this.unit,
      form: data.form.present ? data.form.value : this.form,
      instructions: data.instructions.present
          ? data.instructions.value
          : this.instructions,
      stockCount:
          data.stockCount.present ? data.stockCount.value : this.stockCount,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Medicine(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('name: $name, ')
          ..write('dosage: $dosage, ')
          ..write('frequency: $frequency, ')
          ..write('scheduledTimes: $scheduledTimes, ')
          ..write('color: $color, ')
          ..write('unit: $unit, ')
          ..write('form: $form, ')
          ..write('instructions: $instructions, ')
          ..write('stockCount: $stockCount, ')
          ..write('isActive: $isActive, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('isSynced: $isSynced, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      patientId,
      name,
      dosage,
      frequency,
      scheduledTimes,
      color,
      unit,
      form,
      instructions,
      stockCount,
      isActive,
      isDeleted,
      isSynced,
      startDate,
      endDate,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Medicine &&
          other.id == this.id &&
          other.patientId == this.patientId &&
          other.name == this.name &&
          other.dosage == this.dosage &&
          other.frequency == this.frequency &&
          other.scheduledTimes == this.scheduledTimes &&
          other.color == this.color &&
          other.unit == this.unit &&
          other.form == this.form &&
          other.instructions == this.instructions &&
          other.stockCount == this.stockCount &&
          other.isActive == this.isActive &&
          other.isDeleted == this.isDeleted &&
          other.isSynced == this.isSynced &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class MedicinesCompanion extends UpdateCompanion<Medicine> {
  final Value<String> id;
  final Value<String> patientId;
  final Value<String> name;
  final Value<String?> dosage;
  final Value<String?> frequency;
  final Value<String?> scheduledTimes;
  final Value<String?> color;
  final Value<String?> unit;
  final Value<String?> form;
  final Value<String?> instructions;
  final Value<int?> stockCount;
  final Value<bool> isActive;
  final Value<bool> isDeleted;
  final Value<bool> isSynced;
  final Value<DateTime?> startDate;
  final Value<DateTime?> endDate;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const MedicinesCompanion({
    this.id = const Value.absent(),
    this.patientId = const Value.absent(),
    this.name = const Value.absent(),
    this.dosage = const Value.absent(),
    this.frequency = const Value.absent(),
    this.scheduledTimes = const Value.absent(),
    this.color = const Value.absent(),
    this.unit = const Value.absent(),
    this.form = const Value.absent(),
    this.instructions = const Value.absent(),
    this.stockCount = const Value.absent(),
    this.isActive = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MedicinesCompanion.insert({
    required String id,
    required String patientId,
    required String name,
    this.dosage = const Value.absent(),
    this.frequency = const Value.absent(),
    this.scheduledTimes = const Value.absent(),
    this.color = const Value.absent(),
    this.unit = const Value.absent(),
    this.form = const Value.absent(),
    this.instructions = const Value.absent(),
    this.stockCount = const Value.absent(),
    this.isActive = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        patientId = Value(patientId),
        name = Value(name),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Medicine> custom({
    Expression<String>? id,
    Expression<String>? patientId,
    Expression<String>? name,
    Expression<String>? dosage,
    Expression<String>? frequency,
    Expression<String>? scheduledTimes,
    Expression<String>? color,
    Expression<String>? unit,
    Expression<String>? form,
    Expression<String>? instructions,
    Expression<int>? stockCount,
    Expression<bool>? isActive,
    Expression<bool>? isDeleted,
    Expression<bool>? isSynced,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (patientId != null) 'patient_id': patientId,
      if (name != null) 'name': name,
      if (dosage != null) 'dosage': dosage,
      if (frequency != null) 'frequency': frequency,
      if (scheduledTimes != null) 'scheduled_times': scheduledTimes,
      if (color != null) 'color': color,
      if (unit != null) 'unit': unit,
      if (form != null) 'form': form,
      if (instructions != null) 'instructions': instructions,
      if (stockCount != null) 'stock_count': stockCount,
      if (isActive != null) 'is_active': isActive,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (isSynced != null) 'is_synced': isSynced,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MedicinesCompanion copyWith(
      {Value<String>? id,
      Value<String>? patientId,
      Value<String>? name,
      Value<String?>? dosage,
      Value<String?>? frequency,
      Value<String?>? scheduledTimes,
      Value<String?>? color,
      Value<String?>? unit,
      Value<String?>? form,
      Value<String?>? instructions,
      Value<int?>? stockCount,
      Value<bool>? isActive,
      Value<bool>? isDeleted,
      Value<bool>? isSynced,
      Value<DateTime?>? startDate,
      Value<DateTime?>? endDate,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return MedicinesCompanion(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      name: name ?? this.name,
      dosage: dosage ?? this.dosage,
      frequency: frequency ?? this.frequency,
      scheduledTimes: scheduledTimes ?? this.scheduledTimes,
      color: color ?? this.color,
      unit: unit ?? this.unit,
      form: form ?? this.form,
      instructions: instructions ?? this.instructions,
      stockCount: stockCount ?? this.stockCount,
      isActive: isActive ?? this.isActive,
      isDeleted: isDeleted ?? this.isDeleted,
      isSynced: isSynced ?? this.isSynced,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
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
    if (patientId.present) {
      map['patient_id'] = Variable<String>(patientId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (dosage.present) {
      map['dosage'] = Variable<String>(dosage.value);
    }
    if (frequency.present) {
      map['frequency'] = Variable<String>(frequency.value);
    }
    if (scheduledTimes.present) {
      map['scheduled_times'] = Variable<String>(scheduledTimes.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (form.present) {
      map['form'] = Variable<String>(form.value);
    }
    if (instructions.present) {
      map['instructions'] = Variable<String>(instructions.value);
    }
    if (stockCount.present) {
      map['stock_count'] = Variable<int>(stockCount.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
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
    return (StringBuffer('MedicinesCompanion(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('name: $name, ')
          ..write('dosage: $dosage, ')
          ..write('frequency: $frequency, ')
          ..write('scheduledTimes: $scheduledTimes, ')
          ..write('color: $color, ')
          ..write('unit: $unit, ')
          ..write('form: $form, ')
          ..write('instructions: $instructions, ')
          ..write('stockCount: $stockCount, ')
          ..write('isActive: $isActive, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('isSynced: $isSynced, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RemindersTable extends Reminders
    with TableInfo<$RemindersTable, Reminder> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RemindersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _patientIdMeta =
      const VerificationMeta('patientId');
  @override
  late final GeneratedColumn<String> patientId = GeneratedColumn<String>(
      'patient_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _medicineIdMeta =
      const VerificationMeta('medicineId');
  @override
  late final GeneratedColumn<String> medicineId = GeneratedColumn<String>(
      'medicine_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 150),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _reminderTypeMeta =
      const VerificationMeta('reminderType');
  @override
  late final GeneratedColumn<String> reminderType = GeneratedColumn<String>(
      'reminder_type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('custom'));
  static const VerificationMeta _hourMeta = const VerificationMeta('hour');
  @override
  late final GeneratedColumn<int> hour = GeneratedColumn<int>(
      'hour', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _minuteMeta = const VerificationMeta('minute');
  @override
  late final GeneratedColumn<int> minute = GeneratedColumn<int>(
      'minute', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _frequencyMeta =
      const VerificationMeta('frequency');
  @override
  late final GeneratedColumn<String> frequency = GeneratedColumn<String>(
      'frequency', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('custom'));
  static const VerificationMeta _daysOfWeekMeta =
      const VerificationMeta('daysOfWeek');
  @override
  late final GeneratedColumn<String> daysOfWeek = GeneratedColumn<String>(
      'days_of_week', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _intervalDaysMeta =
      const VerificationMeta('intervalDays');
  @override
  late final GeneratedColumn<int> intervalDays = GeneratedColumn<int>(
      'interval_days', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
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
  static const VerificationMeta _startDateMeta =
      const VerificationMeta('startDate');
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
      'start_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _endDateMeta =
      const VerificationMeta('endDate');
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
      'end_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _lastTriggeredAtMeta =
      const VerificationMeta('lastTriggeredAt');
  @override
  late final GeneratedColumn<DateTime> lastTriggeredAt =
      GeneratedColumn<DateTime>('last_triggered_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
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
        patientId,
        medicineId,
        title,
        notes,
        reminderType,
        hour,
        minute,
        frequency,
        daysOfWeek,
        intervalDays,
        isActive,
        isDeleted,
        isSynced,
        startDate,
        endDate,
        lastTriggeredAt,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reminders';
  @override
  VerificationContext validateIntegrity(Insertable<Reminder> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('patient_id')) {
      context.handle(_patientIdMeta,
          patientId.isAcceptableOrUnknown(data['patient_id']!, _patientIdMeta));
    } else if (isInserting) {
      context.missing(_patientIdMeta);
    }
    if (data.containsKey('medicine_id')) {
      context.handle(
          _medicineIdMeta,
          medicineId.isAcceptableOrUnknown(
              data['medicine_id']!, _medicineIdMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('reminder_type')) {
      context.handle(
          _reminderTypeMeta,
          reminderType.isAcceptableOrUnknown(
              data['reminder_type']!, _reminderTypeMeta));
    }
    if (data.containsKey('hour')) {
      context.handle(
          _hourMeta, hour.isAcceptableOrUnknown(data['hour']!, _hourMeta));
    } else if (isInserting) {
      context.missing(_hourMeta);
    }
    if (data.containsKey('minute')) {
      context.handle(_minuteMeta,
          minute.isAcceptableOrUnknown(data['minute']!, _minuteMeta));
    } else if (isInserting) {
      context.missing(_minuteMeta);
    }
    if (data.containsKey('frequency')) {
      context.handle(_frequencyMeta,
          frequency.isAcceptableOrUnknown(data['frequency']!, _frequencyMeta));
    }
    if (data.containsKey('days_of_week')) {
      context.handle(
          _daysOfWeekMeta,
          daysOfWeek.isAcceptableOrUnknown(
              data['days_of_week']!, _daysOfWeekMeta));
    }
    if (data.containsKey('interval_days')) {
      context.handle(
          _intervalDaysMeta,
          intervalDays.isAcceptableOrUnknown(
              data['interval_days']!, _intervalDaysMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    if (data.containsKey('is_synced')) {
      context.handle(_isSyncedMeta,
          isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta));
    }
    if (data.containsKey('start_date')) {
      context.handle(_startDateMeta,
          startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta));
    }
    if (data.containsKey('end_date')) {
      context.handle(_endDateMeta,
          endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta));
    }
    if (data.containsKey('last_triggered_at')) {
      context.handle(
          _lastTriggeredAtMeta,
          lastTriggeredAt.isAcceptableOrUnknown(
              data['last_triggered_at']!, _lastTriggeredAtMeta));
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
  Reminder map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Reminder(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      patientId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}patient_id'])!,
      medicineId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}medicine_id']),
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      reminderType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reminder_type'])!,
      hour: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}hour'])!,
      minute: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}minute'])!,
      frequency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}frequency'])!,
      daysOfWeek: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}days_of_week']),
      intervalDays: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}interval_days']),
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
      isSynced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_synced'])!,
      startDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_date']),
      endDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}end_date']),
      lastTriggeredAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_triggered_at']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $RemindersTable createAlias(String alias) {
    return $RemindersTable(attachedDatabase, alias);
  }
}

class Reminder extends DataClass implements Insertable<Reminder> {
  final String id;
  final String patientId;
  final String? medicineId;
  final String title;
  final String? notes;
  final String reminderType;
  final int hour;
  final int minute;
  final String frequency;
  final String? daysOfWeek;
  final int? intervalDays;
  final bool isActive;
  final bool isDeleted;
  final bool isSynced;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? lastTriggeredAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Reminder(
      {required this.id,
      required this.patientId,
      this.medicineId,
      required this.title,
      this.notes,
      required this.reminderType,
      required this.hour,
      required this.minute,
      required this.frequency,
      this.daysOfWeek,
      this.intervalDays,
      required this.isActive,
      required this.isDeleted,
      required this.isSynced,
      this.startDate,
      this.endDate,
      this.lastTriggeredAt,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['patient_id'] = Variable<String>(patientId);
    if (!nullToAbsent || medicineId != null) {
      map['medicine_id'] = Variable<String>(medicineId);
    }
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['reminder_type'] = Variable<String>(reminderType);
    map['hour'] = Variable<int>(hour);
    map['minute'] = Variable<int>(minute);
    map['frequency'] = Variable<String>(frequency);
    if (!nullToAbsent || daysOfWeek != null) {
      map['days_of_week'] = Variable<String>(daysOfWeek);
    }
    if (!nullToAbsent || intervalDays != null) {
      map['interval_days'] = Variable<int>(intervalDays);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['is_synced'] = Variable<bool>(isSynced);
    if (!nullToAbsent || startDate != null) {
      map['start_date'] = Variable<DateTime>(startDate);
    }
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<DateTime>(endDate);
    }
    if (!nullToAbsent || lastTriggeredAt != null) {
      map['last_triggered_at'] = Variable<DateTime>(lastTriggeredAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  RemindersCompanion toCompanion(bool nullToAbsent) {
    return RemindersCompanion(
      id: Value(id),
      patientId: Value(patientId),
      medicineId: medicineId == null && nullToAbsent
          ? const Value.absent()
          : Value(medicineId),
      title: Value(title),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      reminderType: Value(reminderType),
      hour: Value(hour),
      minute: Value(minute),
      frequency: Value(frequency),
      daysOfWeek: daysOfWeek == null && nullToAbsent
          ? const Value.absent()
          : Value(daysOfWeek),
      intervalDays: intervalDays == null && nullToAbsent
          ? const Value.absent()
          : Value(intervalDays),
      isActive: Value(isActive),
      isDeleted: Value(isDeleted),
      isSynced: Value(isSynced),
      startDate: startDate == null && nullToAbsent
          ? const Value.absent()
          : Value(startDate),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
      lastTriggeredAt: lastTriggeredAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastTriggeredAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Reminder.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Reminder(
      id: serializer.fromJson<String>(json['id']),
      patientId: serializer.fromJson<String>(json['patientId']),
      medicineId: serializer.fromJson<String?>(json['medicineId']),
      title: serializer.fromJson<String>(json['title']),
      notes: serializer.fromJson<String?>(json['notes']),
      reminderType: serializer.fromJson<String>(json['reminderType']),
      hour: serializer.fromJson<int>(json['hour']),
      minute: serializer.fromJson<int>(json['minute']),
      frequency: serializer.fromJson<String>(json['frequency']),
      daysOfWeek: serializer.fromJson<String?>(json['daysOfWeek']),
      intervalDays: serializer.fromJson<int?>(json['intervalDays']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      startDate: serializer.fromJson<DateTime?>(json['startDate']),
      endDate: serializer.fromJson<DateTime?>(json['endDate']),
      lastTriggeredAt: serializer.fromJson<DateTime?>(json['lastTriggeredAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'patientId': serializer.toJson<String>(patientId),
      'medicineId': serializer.toJson<String?>(medicineId),
      'title': serializer.toJson<String>(title),
      'notes': serializer.toJson<String?>(notes),
      'reminderType': serializer.toJson<String>(reminderType),
      'hour': serializer.toJson<int>(hour),
      'minute': serializer.toJson<int>(minute),
      'frequency': serializer.toJson<String>(frequency),
      'daysOfWeek': serializer.toJson<String?>(daysOfWeek),
      'intervalDays': serializer.toJson<int?>(intervalDays),
      'isActive': serializer.toJson<bool>(isActive),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'isSynced': serializer.toJson<bool>(isSynced),
      'startDate': serializer.toJson<DateTime?>(startDate),
      'endDate': serializer.toJson<DateTime?>(endDate),
      'lastTriggeredAt': serializer.toJson<DateTime?>(lastTriggeredAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Reminder copyWith(
          {String? id,
          String? patientId,
          Value<String?> medicineId = const Value.absent(),
          String? title,
          Value<String?> notes = const Value.absent(),
          String? reminderType,
          int? hour,
          int? minute,
          String? frequency,
          Value<String?> daysOfWeek = const Value.absent(),
          Value<int?> intervalDays = const Value.absent(),
          bool? isActive,
          bool? isDeleted,
          bool? isSynced,
          Value<DateTime?> startDate = const Value.absent(),
          Value<DateTime?> endDate = const Value.absent(),
          Value<DateTime?> lastTriggeredAt = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Reminder(
        id: id ?? this.id,
        patientId: patientId ?? this.patientId,
        medicineId: medicineId.present ? medicineId.value : this.medicineId,
        title: title ?? this.title,
        notes: notes.present ? notes.value : this.notes,
        reminderType: reminderType ?? this.reminderType,
        hour: hour ?? this.hour,
        minute: minute ?? this.minute,
        frequency: frequency ?? this.frequency,
        daysOfWeek: daysOfWeek.present ? daysOfWeek.value : this.daysOfWeek,
        intervalDays:
            intervalDays.present ? intervalDays.value : this.intervalDays,
        isActive: isActive ?? this.isActive,
        isDeleted: isDeleted ?? this.isDeleted,
        isSynced: isSynced ?? this.isSynced,
        startDate: startDate.present ? startDate.value : this.startDate,
        endDate: endDate.present ? endDate.value : this.endDate,
        lastTriggeredAt: lastTriggeredAt.present
            ? lastTriggeredAt.value
            : this.lastTriggeredAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Reminder copyWithCompanion(RemindersCompanion data) {
    return Reminder(
      id: data.id.present ? data.id.value : this.id,
      patientId: data.patientId.present ? data.patientId.value : this.patientId,
      medicineId:
          data.medicineId.present ? data.medicineId.value : this.medicineId,
      title: data.title.present ? data.title.value : this.title,
      notes: data.notes.present ? data.notes.value : this.notes,
      reminderType: data.reminderType.present
          ? data.reminderType.value
          : this.reminderType,
      hour: data.hour.present ? data.hour.value : this.hour,
      minute: data.minute.present ? data.minute.value : this.minute,
      frequency: data.frequency.present ? data.frequency.value : this.frequency,
      daysOfWeek:
          data.daysOfWeek.present ? data.daysOfWeek.value : this.daysOfWeek,
      intervalDays: data.intervalDays.present
          ? data.intervalDays.value
          : this.intervalDays,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      lastTriggeredAt: data.lastTriggeredAt.present
          ? data.lastTriggeredAt.value
          : this.lastTriggeredAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Reminder(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('medicineId: $medicineId, ')
          ..write('title: $title, ')
          ..write('notes: $notes, ')
          ..write('reminderType: $reminderType, ')
          ..write('hour: $hour, ')
          ..write('minute: $minute, ')
          ..write('frequency: $frequency, ')
          ..write('daysOfWeek: $daysOfWeek, ')
          ..write('intervalDays: $intervalDays, ')
          ..write('isActive: $isActive, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('isSynced: $isSynced, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('lastTriggeredAt: $lastTriggeredAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      patientId,
      medicineId,
      title,
      notes,
      reminderType,
      hour,
      minute,
      frequency,
      daysOfWeek,
      intervalDays,
      isActive,
      isDeleted,
      isSynced,
      startDate,
      endDate,
      lastTriggeredAt,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Reminder &&
          other.id == this.id &&
          other.patientId == this.patientId &&
          other.medicineId == this.medicineId &&
          other.title == this.title &&
          other.notes == this.notes &&
          other.reminderType == this.reminderType &&
          other.hour == this.hour &&
          other.minute == this.minute &&
          other.frequency == this.frequency &&
          other.daysOfWeek == this.daysOfWeek &&
          other.intervalDays == this.intervalDays &&
          other.isActive == this.isActive &&
          other.isDeleted == this.isDeleted &&
          other.isSynced == this.isSynced &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.lastTriggeredAt == this.lastTriggeredAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class RemindersCompanion extends UpdateCompanion<Reminder> {
  final Value<String> id;
  final Value<String> patientId;
  final Value<String?> medicineId;
  final Value<String> title;
  final Value<String?> notes;
  final Value<String> reminderType;
  final Value<int> hour;
  final Value<int> minute;
  final Value<String> frequency;
  final Value<String?> daysOfWeek;
  final Value<int?> intervalDays;
  final Value<bool> isActive;
  final Value<bool> isDeleted;
  final Value<bool> isSynced;
  final Value<DateTime?> startDate;
  final Value<DateTime?> endDate;
  final Value<DateTime?> lastTriggeredAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const RemindersCompanion({
    this.id = const Value.absent(),
    this.patientId = const Value.absent(),
    this.medicineId = const Value.absent(),
    this.title = const Value.absent(),
    this.notes = const Value.absent(),
    this.reminderType = const Value.absent(),
    this.hour = const Value.absent(),
    this.minute = const Value.absent(),
    this.frequency = const Value.absent(),
    this.daysOfWeek = const Value.absent(),
    this.intervalDays = const Value.absent(),
    this.isActive = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.lastTriggeredAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RemindersCompanion.insert({
    required String id,
    required String patientId,
    this.medicineId = const Value.absent(),
    required String title,
    this.notes = const Value.absent(),
    this.reminderType = const Value.absent(),
    required int hour,
    required int minute,
    this.frequency = const Value.absent(),
    this.daysOfWeek = const Value.absent(),
    this.intervalDays = const Value.absent(),
    this.isActive = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.lastTriggeredAt = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        patientId = Value(patientId),
        title = Value(title),
        hour = Value(hour),
        minute = Value(minute),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Reminder> custom({
    Expression<String>? id,
    Expression<String>? patientId,
    Expression<String>? medicineId,
    Expression<String>? title,
    Expression<String>? notes,
    Expression<String>? reminderType,
    Expression<int>? hour,
    Expression<int>? minute,
    Expression<String>? frequency,
    Expression<String>? daysOfWeek,
    Expression<int>? intervalDays,
    Expression<bool>? isActive,
    Expression<bool>? isDeleted,
    Expression<bool>? isSynced,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<DateTime>? lastTriggeredAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (patientId != null) 'patient_id': patientId,
      if (medicineId != null) 'medicine_id': medicineId,
      if (title != null) 'title': title,
      if (notes != null) 'notes': notes,
      if (reminderType != null) 'reminder_type': reminderType,
      if (hour != null) 'hour': hour,
      if (minute != null) 'minute': minute,
      if (frequency != null) 'frequency': frequency,
      if (daysOfWeek != null) 'days_of_week': daysOfWeek,
      if (intervalDays != null) 'interval_days': intervalDays,
      if (isActive != null) 'is_active': isActive,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (isSynced != null) 'is_synced': isSynced,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (lastTriggeredAt != null) 'last_triggered_at': lastTriggeredAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RemindersCompanion copyWith(
      {Value<String>? id,
      Value<String>? patientId,
      Value<String?>? medicineId,
      Value<String>? title,
      Value<String?>? notes,
      Value<String>? reminderType,
      Value<int>? hour,
      Value<int>? minute,
      Value<String>? frequency,
      Value<String?>? daysOfWeek,
      Value<int?>? intervalDays,
      Value<bool>? isActive,
      Value<bool>? isDeleted,
      Value<bool>? isSynced,
      Value<DateTime?>? startDate,
      Value<DateTime?>? endDate,
      Value<DateTime?>? lastTriggeredAt,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return RemindersCompanion(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      medicineId: medicineId ?? this.medicineId,
      title: title ?? this.title,
      notes: notes ?? this.notes,
      reminderType: reminderType ?? this.reminderType,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      frequency: frequency ?? this.frequency,
      daysOfWeek: daysOfWeek ?? this.daysOfWeek,
      intervalDays: intervalDays ?? this.intervalDays,
      isActive: isActive ?? this.isActive,
      isDeleted: isDeleted ?? this.isDeleted,
      isSynced: isSynced ?? this.isSynced,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      lastTriggeredAt: lastTriggeredAt ?? this.lastTriggeredAt,
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
    if (patientId.present) {
      map['patient_id'] = Variable<String>(patientId.value);
    }
    if (medicineId.present) {
      map['medicine_id'] = Variable<String>(medicineId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (reminderType.present) {
      map['reminder_type'] = Variable<String>(reminderType.value);
    }
    if (hour.present) {
      map['hour'] = Variable<int>(hour.value);
    }
    if (minute.present) {
      map['minute'] = Variable<int>(minute.value);
    }
    if (frequency.present) {
      map['frequency'] = Variable<String>(frequency.value);
    }
    if (daysOfWeek.present) {
      map['days_of_week'] = Variable<String>(daysOfWeek.value);
    }
    if (intervalDays.present) {
      map['interval_days'] = Variable<int>(intervalDays.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (lastTriggeredAt.present) {
      map['last_triggered_at'] = Variable<DateTime>(lastTriggeredAt.value);
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
    return (StringBuffer('RemindersCompanion(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('medicineId: $medicineId, ')
          ..write('title: $title, ')
          ..write('notes: $notes, ')
          ..write('reminderType: $reminderType, ')
          ..write('hour: $hour, ')
          ..write('minute: $minute, ')
          ..write('frequency: $frequency, ')
          ..write('daysOfWeek: $daysOfWeek, ')
          ..write('intervalDays: $intervalDays, ')
          ..write('isActive: $isActive, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('isSynced: $isSynced, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('lastTriggeredAt: $lastTriggeredAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DoseLogsTable extends DoseLogs with TableInfo<$DoseLogsTable, DoseLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DoseLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _patientIdMeta =
      const VerificationMeta('patientId');
  @override
  late final GeneratedColumn<String> patientId = GeneratedColumn<String>(
      'patient_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _medicineIdMeta =
      const VerificationMeta('medicineId');
  @override
  late final GeneratedColumn<String> medicineId = GeneratedColumn<String>(
      'medicine_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _reminderIdMeta =
      const VerificationMeta('reminderId');
  @override
  late final GeneratedColumn<String> reminderId = GeneratedColumn<String>(
      'reminder_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _scheduledAtMeta =
      const VerificationMeta('scheduledAt');
  @override
  late final GeneratedColumn<DateTime> scheduledAt = GeneratedColumn<DateTime>(
      'scheduled_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _takenAtMeta =
      const VerificationMeta('takenAt');
  @override
  late final GeneratedColumn<DateTime> takenAt = GeneratedColumn<DateTime>(
      'taken_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
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
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
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
        patientId,
        medicineId,
        reminderId,
        scheduledAt,
        takenAt,
        status,
        notes,
        isSynced,
        isDeleted,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dose_logs';
  @override
  VerificationContext validateIntegrity(Insertable<DoseLog> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('patient_id')) {
      context.handle(_patientIdMeta,
          patientId.isAcceptableOrUnknown(data['patient_id']!, _patientIdMeta));
    } else if (isInserting) {
      context.missing(_patientIdMeta);
    }
    if (data.containsKey('medicine_id')) {
      context.handle(
          _medicineIdMeta,
          medicineId.isAcceptableOrUnknown(
              data['medicine_id']!, _medicineIdMeta));
    } else if (isInserting) {
      context.missing(_medicineIdMeta);
    }
    if (data.containsKey('reminder_id')) {
      context.handle(
          _reminderIdMeta,
          reminderId.isAcceptableOrUnknown(
              data['reminder_id']!, _reminderIdMeta));
    }
    if (data.containsKey('scheduled_at')) {
      context.handle(
          _scheduledAtMeta,
          scheduledAt.isAcceptableOrUnknown(
              data['scheduled_at']!, _scheduledAtMeta));
    } else if (isInserting) {
      context.missing(_scheduledAtMeta);
    }
    if (data.containsKey('taken_at')) {
      context.handle(_takenAtMeta,
          takenAt.isAcceptableOrUnknown(data['taken_at']!, _takenAtMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('is_synced')) {
      context.handle(_isSyncedMeta,
          isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta));
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
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
  DoseLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DoseLog(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      patientId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}patient_id'])!,
      medicineId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}medicine_id'])!,
      reminderId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reminder_id']),
      scheduledAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}scheduled_at'])!,
      takenAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}taken_at']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      isSynced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_synced'])!,
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $DoseLogsTable createAlias(String alias) {
    return $DoseLogsTable(attachedDatabase, alias);
  }
}

class DoseLog extends DataClass implements Insertable<DoseLog> {
  final String id;
  final String patientId;
  final String medicineId;
  final String? reminderId;
  final DateTime scheduledAt;
  final DateTime? takenAt;
  final String status;
  final String? notes;
  final bool isSynced;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  const DoseLog(
      {required this.id,
      required this.patientId,
      required this.medicineId,
      this.reminderId,
      required this.scheduledAt,
      this.takenAt,
      required this.status,
      this.notes,
      required this.isSynced,
      required this.isDeleted,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['patient_id'] = Variable<String>(patientId);
    map['medicine_id'] = Variable<String>(medicineId);
    if (!nullToAbsent || reminderId != null) {
      map['reminder_id'] = Variable<String>(reminderId);
    }
    map['scheduled_at'] = Variable<DateTime>(scheduledAt);
    if (!nullToAbsent || takenAt != null) {
      map['taken_at'] = Variable<DateTime>(takenAt);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['is_synced'] = Variable<bool>(isSynced);
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  DoseLogsCompanion toCompanion(bool nullToAbsent) {
    return DoseLogsCompanion(
      id: Value(id),
      patientId: Value(patientId),
      medicineId: Value(medicineId),
      reminderId: reminderId == null && nullToAbsent
          ? const Value.absent()
          : Value(reminderId),
      scheduledAt: Value(scheduledAt),
      takenAt: takenAt == null && nullToAbsent
          ? const Value.absent()
          : Value(takenAt),
      status: Value(status),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      isSynced: Value(isSynced),
      isDeleted: Value(isDeleted),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory DoseLog.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DoseLog(
      id: serializer.fromJson<String>(json['id']),
      patientId: serializer.fromJson<String>(json['patientId']),
      medicineId: serializer.fromJson<String>(json['medicineId']),
      reminderId: serializer.fromJson<String?>(json['reminderId']),
      scheduledAt: serializer.fromJson<DateTime>(json['scheduledAt']),
      takenAt: serializer.fromJson<DateTime?>(json['takenAt']),
      status: serializer.fromJson<String>(json['status']),
      notes: serializer.fromJson<String?>(json['notes']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'patientId': serializer.toJson<String>(patientId),
      'medicineId': serializer.toJson<String>(medicineId),
      'reminderId': serializer.toJson<String?>(reminderId),
      'scheduledAt': serializer.toJson<DateTime>(scheduledAt),
      'takenAt': serializer.toJson<DateTime?>(takenAt),
      'status': serializer.toJson<String>(status),
      'notes': serializer.toJson<String?>(notes),
      'isSynced': serializer.toJson<bool>(isSynced),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  DoseLog copyWith(
          {String? id,
          String? patientId,
          String? medicineId,
          Value<String?> reminderId = const Value.absent(),
          DateTime? scheduledAt,
          Value<DateTime?> takenAt = const Value.absent(),
          String? status,
          Value<String?> notes = const Value.absent(),
          bool? isSynced,
          bool? isDeleted,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      DoseLog(
        id: id ?? this.id,
        patientId: patientId ?? this.patientId,
        medicineId: medicineId ?? this.medicineId,
        reminderId: reminderId.present ? reminderId.value : this.reminderId,
        scheduledAt: scheduledAt ?? this.scheduledAt,
        takenAt: takenAt.present ? takenAt.value : this.takenAt,
        status: status ?? this.status,
        notes: notes.present ? notes.value : this.notes,
        isSynced: isSynced ?? this.isSynced,
        isDeleted: isDeleted ?? this.isDeleted,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  DoseLog copyWithCompanion(DoseLogsCompanion data) {
    return DoseLog(
      id: data.id.present ? data.id.value : this.id,
      patientId: data.patientId.present ? data.patientId.value : this.patientId,
      medicineId:
          data.medicineId.present ? data.medicineId.value : this.medicineId,
      reminderId:
          data.reminderId.present ? data.reminderId.value : this.reminderId,
      scheduledAt:
          data.scheduledAt.present ? data.scheduledAt.value : this.scheduledAt,
      takenAt: data.takenAt.present ? data.takenAt.value : this.takenAt,
      status: data.status.present ? data.status.value : this.status,
      notes: data.notes.present ? data.notes.value : this.notes,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DoseLog(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('medicineId: $medicineId, ')
          ..write('reminderId: $reminderId, ')
          ..write('scheduledAt: $scheduledAt, ')
          ..write('takenAt: $takenAt, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('isSynced: $isSynced, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      patientId,
      medicineId,
      reminderId,
      scheduledAt,
      takenAt,
      status,
      notes,
      isSynced,
      isDeleted,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DoseLog &&
          other.id == this.id &&
          other.patientId == this.patientId &&
          other.medicineId == this.medicineId &&
          other.reminderId == this.reminderId &&
          other.scheduledAt == this.scheduledAt &&
          other.takenAt == this.takenAt &&
          other.status == this.status &&
          other.notes == this.notes &&
          other.isSynced == this.isSynced &&
          other.isDeleted == this.isDeleted &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class DoseLogsCompanion extends UpdateCompanion<DoseLog> {
  final Value<String> id;
  final Value<String> patientId;
  final Value<String> medicineId;
  final Value<String?> reminderId;
  final Value<DateTime> scheduledAt;
  final Value<DateTime?> takenAt;
  final Value<String> status;
  final Value<String?> notes;
  final Value<bool> isSynced;
  final Value<bool> isDeleted;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const DoseLogsCompanion({
    this.id = const Value.absent(),
    this.patientId = const Value.absent(),
    this.medicineId = const Value.absent(),
    this.reminderId = const Value.absent(),
    this.scheduledAt = const Value.absent(),
    this.takenAt = const Value.absent(),
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DoseLogsCompanion.insert({
    required String id,
    required String patientId,
    required String medicineId,
    this.reminderId = const Value.absent(),
    required DateTime scheduledAt,
    this.takenAt = const Value.absent(),
    required String status,
    this.notes = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.isDeleted = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        patientId = Value(patientId),
        medicineId = Value(medicineId),
        scheduledAt = Value(scheduledAt),
        status = Value(status),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<DoseLog> custom({
    Expression<String>? id,
    Expression<String>? patientId,
    Expression<String>? medicineId,
    Expression<String>? reminderId,
    Expression<DateTime>? scheduledAt,
    Expression<DateTime>? takenAt,
    Expression<String>? status,
    Expression<String>? notes,
    Expression<bool>? isSynced,
    Expression<bool>? isDeleted,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (patientId != null) 'patient_id': patientId,
      if (medicineId != null) 'medicine_id': medicineId,
      if (reminderId != null) 'reminder_id': reminderId,
      if (scheduledAt != null) 'scheduled_at': scheduledAt,
      if (takenAt != null) 'taken_at': takenAt,
      if (status != null) 'status': status,
      if (notes != null) 'notes': notes,
      if (isSynced != null) 'is_synced': isSynced,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DoseLogsCompanion copyWith(
      {Value<String>? id,
      Value<String>? patientId,
      Value<String>? medicineId,
      Value<String?>? reminderId,
      Value<DateTime>? scheduledAt,
      Value<DateTime?>? takenAt,
      Value<String>? status,
      Value<String?>? notes,
      Value<bool>? isSynced,
      Value<bool>? isDeleted,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return DoseLogsCompanion(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      medicineId: medicineId ?? this.medicineId,
      reminderId: reminderId ?? this.reminderId,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      takenAt: takenAt ?? this.takenAt,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      isSynced: isSynced ?? this.isSynced,
      isDeleted: isDeleted ?? this.isDeleted,
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
    if (patientId.present) {
      map['patient_id'] = Variable<String>(patientId.value);
    }
    if (medicineId.present) {
      map['medicine_id'] = Variable<String>(medicineId.value);
    }
    if (reminderId.present) {
      map['reminder_id'] = Variable<String>(reminderId.value);
    }
    if (scheduledAt.present) {
      map['scheduled_at'] = Variable<DateTime>(scheduledAt.value);
    }
    if (takenAt.present) {
      map['taken_at'] = Variable<DateTime>(takenAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
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
    return (StringBuffer('DoseLogsCompanion(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('medicineId: $medicineId, ')
          ..write('reminderId: $reminderId, ')
          ..write('scheduledAt: $scheduledAt, ')
          ..write('takenAt: $takenAt, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('isSynced: $isSynced, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HealthLogsTable extends HealthLogs
    with TableInfo<$HealthLogsTable, HealthLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HealthLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _patientIdMeta =
      const VerificationMeta('patientId');
  @override
  late final GeneratedColumn<String> patientId = GeneratedColumn<String>(
      'patient_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _metricTypeMeta =
      const VerificationMeta('metricType');
  @override
  late final GeneratedColumn<String> metricType = GeneratedColumn<String>(
      'metric_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<double> value = GeneratedColumn<double>(
      'value', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _secondaryValueMeta =
      const VerificationMeta('secondaryValue');
  @override
  late final GeneratedColumn<double> secondaryValue = GeneratedColumn<double>(
      'secondary_value', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
      'source', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _recordedAtMeta =
      const VerificationMeta('recordedAt');
  @override
  late final GeneratedColumn<DateTime> recordedAt = GeneratedColumn<DateTime>(
      'recorded_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
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
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
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
        patientId,
        metricType,
        value,
        secondaryValue,
        notes,
        source,
        recordedAt,
        isSynced,
        isDeleted,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'health_logs';
  @override
  VerificationContext validateIntegrity(Insertable<HealthLog> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('patient_id')) {
      context.handle(_patientIdMeta,
          patientId.isAcceptableOrUnknown(data['patient_id']!, _patientIdMeta));
    } else if (isInserting) {
      context.missing(_patientIdMeta);
    }
    if (data.containsKey('metric_type')) {
      context.handle(
          _metricTypeMeta,
          metricType.isAcceptableOrUnknown(
              data['metric_type']!, _metricTypeMeta));
    } else if (isInserting) {
      context.missing(_metricTypeMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('secondary_value')) {
      context.handle(
          _secondaryValueMeta,
          secondaryValue.isAcceptableOrUnknown(
              data['secondary_value']!, _secondaryValueMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('source')) {
      context.handle(_sourceMeta,
          source.isAcceptableOrUnknown(data['source']!, _sourceMeta));
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('recorded_at')) {
      context.handle(
          _recordedAtMeta,
          recordedAt.isAcceptableOrUnknown(
              data['recorded_at']!, _recordedAtMeta));
    } else if (isInserting) {
      context.missing(_recordedAtMeta);
    }
    if (data.containsKey('is_synced')) {
      context.handle(_isSyncedMeta,
          isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta));
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
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
  HealthLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HealthLog(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      patientId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}patient_id'])!,
      metricType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}metric_type'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}value'])!,
      secondaryValue: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}secondary_value']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      source: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source'])!,
      recordedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}recorded_at'])!,
      isSynced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_synced'])!,
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $HealthLogsTable createAlias(String alias) {
    return $HealthLogsTable(attachedDatabase, alias);
  }
}

class HealthLog extends DataClass implements Insertable<HealthLog> {
  final String id;
  final String patientId;
  final String metricType;
  final double value;
  final double? secondaryValue;
  final String? notes;
  final String source;
  final DateTime recordedAt;
  final bool isSynced;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  const HealthLog(
      {required this.id,
      required this.patientId,
      required this.metricType,
      required this.value,
      this.secondaryValue,
      this.notes,
      required this.source,
      required this.recordedAt,
      required this.isSynced,
      required this.isDeleted,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['patient_id'] = Variable<String>(patientId);
    map['metric_type'] = Variable<String>(metricType);
    map['value'] = Variable<double>(value);
    if (!nullToAbsent || secondaryValue != null) {
      map['secondary_value'] = Variable<double>(secondaryValue);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['source'] = Variable<String>(source);
    map['recorded_at'] = Variable<DateTime>(recordedAt);
    map['is_synced'] = Variable<bool>(isSynced);
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  HealthLogsCompanion toCompanion(bool nullToAbsent) {
    return HealthLogsCompanion(
      id: Value(id),
      patientId: Value(patientId),
      metricType: Value(metricType),
      value: Value(value),
      secondaryValue: secondaryValue == null && nullToAbsent
          ? const Value.absent()
          : Value(secondaryValue),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      source: Value(source),
      recordedAt: Value(recordedAt),
      isSynced: Value(isSynced),
      isDeleted: Value(isDeleted),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory HealthLog.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HealthLog(
      id: serializer.fromJson<String>(json['id']),
      patientId: serializer.fromJson<String>(json['patientId']),
      metricType: serializer.fromJson<String>(json['metricType']),
      value: serializer.fromJson<double>(json['value']),
      secondaryValue: serializer.fromJson<double?>(json['secondaryValue']),
      notes: serializer.fromJson<String?>(json['notes']),
      source: serializer.fromJson<String>(json['source']),
      recordedAt: serializer.fromJson<DateTime>(json['recordedAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'patientId': serializer.toJson<String>(patientId),
      'metricType': serializer.toJson<String>(metricType),
      'value': serializer.toJson<double>(value),
      'secondaryValue': serializer.toJson<double?>(secondaryValue),
      'notes': serializer.toJson<String?>(notes),
      'source': serializer.toJson<String>(source),
      'recordedAt': serializer.toJson<DateTime>(recordedAt),
      'isSynced': serializer.toJson<bool>(isSynced),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  HealthLog copyWith(
          {String? id,
          String? patientId,
          String? metricType,
          double? value,
          Value<double?> secondaryValue = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          String? source,
          DateTime? recordedAt,
          bool? isSynced,
          bool? isDeleted,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      HealthLog(
        id: id ?? this.id,
        patientId: patientId ?? this.patientId,
        metricType: metricType ?? this.metricType,
        value: value ?? this.value,
        secondaryValue:
            secondaryValue.present ? secondaryValue.value : this.secondaryValue,
        notes: notes.present ? notes.value : this.notes,
        source: source ?? this.source,
        recordedAt: recordedAt ?? this.recordedAt,
        isSynced: isSynced ?? this.isSynced,
        isDeleted: isDeleted ?? this.isDeleted,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  HealthLog copyWithCompanion(HealthLogsCompanion data) {
    return HealthLog(
      id: data.id.present ? data.id.value : this.id,
      patientId: data.patientId.present ? data.patientId.value : this.patientId,
      metricType:
          data.metricType.present ? data.metricType.value : this.metricType,
      value: data.value.present ? data.value.value : this.value,
      secondaryValue: data.secondaryValue.present
          ? data.secondaryValue.value
          : this.secondaryValue,
      notes: data.notes.present ? data.notes.value : this.notes,
      source: data.source.present ? data.source.value : this.source,
      recordedAt:
          data.recordedAt.present ? data.recordedAt.value : this.recordedAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HealthLog(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('metricType: $metricType, ')
          ..write('value: $value, ')
          ..write('secondaryValue: $secondaryValue, ')
          ..write('notes: $notes, ')
          ..write('source: $source, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      patientId,
      metricType,
      value,
      secondaryValue,
      notes,
      source,
      recordedAt,
      isSynced,
      isDeleted,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HealthLog &&
          other.id == this.id &&
          other.patientId == this.patientId &&
          other.metricType == this.metricType &&
          other.value == this.value &&
          other.secondaryValue == this.secondaryValue &&
          other.notes == this.notes &&
          other.source == this.source &&
          other.recordedAt == this.recordedAt &&
          other.isSynced == this.isSynced &&
          other.isDeleted == this.isDeleted &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class HealthLogsCompanion extends UpdateCompanion<HealthLog> {
  final Value<String> id;
  final Value<String> patientId;
  final Value<String> metricType;
  final Value<double> value;
  final Value<double?> secondaryValue;
  final Value<String?> notes;
  final Value<String> source;
  final Value<DateTime> recordedAt;
  final Value<bool> isSynced;
  final Value<bool> isDeleted;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const HealthLogsCompanion({
    this.id = const Value.absent(),
    this.patientId = const Value.absent(),
    this.metricType = const Value.absent(),
    this.value = const Value.absent(),
    this.secondaryValue = const Value.absent(),
    this.notes = const Value.absent(),
    this.source = const Value.absent(),
    this.recordedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HealthLogsCompanion.insert({
    required String id,
    required String patientId,
    required String metricType,
    required double value,
    this.secondaryValue = const Value.absent(),
    this.notes = const Value.absent(),
    required String source,
    required DateTime recordedAt,
    this.isSynced = const Value.absent(),
    this.isDeleted = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        patientId = Value(patientId),
        metricType = Value(metricType),
        value = Value(value),
        source = Value(source),
        recordedAt = Value(recordedAt),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<HealthLog> custom({
    Expression<String>? id,
    Expression<String>? patientId,
    Expression<String>? metricType,
    Expression<double>? value,
    Expression<double>? secondaryValue,
    Expression<String>? notes,
    Expression<String>? source,
    Expression<DateTime>? recordedAt,
    Expression<bool>? isSynced,
    Expression<bool>? isDeleted,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (patientId != null) 'patient_id': patientId,
      if (metricType != null) 'metric_type': metricType,
      if (value != null) 'value': value,
      if (secondaryValue != null) 'secondary_value': secondaryValue,
      if (notes != null) 'notes': notes,
      if (source != null) 'source': source,
      if (recordedAt != null) 'recorded_at': recordedAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HealthLogsCompanion copyWith(
      {Value<String>? id,
      Value<String>? patientId,
      Value<String>? metricType,
      Value<double>? value,
      Value<double?>? secondaryValue,
      Value<String?>? notes,
      Value<String>? source,
      Value<DateTime>? recordedAt,
      Value<bool>? isSynced,
      Value<bool>? isDeleted,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return HealthLogsCompanion(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      metricType: metricType ?? this.metricType,
      value: value ?? this.value,
      secondaryValue: secondaryValue ?? this.secondaryValue,
      notes: notes ?? this.notes,
      source: source ?? this.source,
      recordedAt: recordedAt ?? this.recordedAt,
      isSynced: isSynced ?? this.isSynced,
      isDeleted: isDeleted ?? this.isDeleted,
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
    if (patientId.present) {
      map['patient_id'] = Variable<String>(patientId.value);
    }
    if (metricType.present) {
      map['metric_type'] = Variable<String>(metricType.value);
    }
    if (value.present) {
      map['value'] = Variable<double>(value.value);
    }
    if (secondaryValue.present) {
      map['secondary_value'] = Variable<double>(secondaryValue.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (recordedAt.present) {
      map['recorded_at'] = Variable<DateTime>(recordedAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
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
    return (StringBuffer('HealthLogsCompanion(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('metricType: $metricType, ')
          ..write('value: $value, ')
          ..write('secondaryValue: $secondaryValue, ')
          ..write('notes: $notes, ')
          ..write('source: $source, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $IntelligenceSnapshotsTable extends IntelligenceSnapshots
    with TableInfo<$IntelligenceSnapshotsTable, IntelligenceSnapshot> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IntelligenceSnapshotsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _patientIdMeta =
      const VerificationMeta('patientId');
  @override
  late final GeneratedColumn<String> patientId = GeneratedColumn<String>(
      'patient_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _snapshotTypeMeta =
      const VerificationMeta('snapshotType');
  @override
  late final GeneratedColumn<String> snapshotType = GeneratedColumn<String>(
      'snapshot_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _riskLevelMeta =
      const VerificationMeta('riskLevel');
  @override
  late final GeneratedColumn<String> riskLevel = GeneratedColumn<String>(
      'risk_level', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _complianceScoreMeta =
      const VerificationMeta('complianceScore');
  @override
  late final GeneratedColumn<double> complianceScore = GeneratedColumn<double>(
      'compliance_score', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _payloadJsonMeta =
      const VerificationMeta('payloadJson');
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
      'payload_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _generatedAtMeta =
      const VerificationMeta('generatedAt');
  @override
  late final GeneratedColumn<DateTime> generatedAt = GeneratedColumn<DateTime>(
      'generated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        patientId,
        snapshotType,
        riskLevel,
        complianceScore,
        payloadJson,
        generatedAt,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'intelligence_snapshots';
  @override
  VerificationContext validateIntegrity(
      Insertable<IntelligenceSnapshot> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('patient_id')) {
      context.handle(_patientIdMeta,
          patientId.isAcceptableOrUnknown(data['patient_id']!, _patientIdMeta));
    } else if (isInserting) {
      context.missing(_patientIdMeta);
    }
    if (data.containsKey('snapshot_type')) {
      context.handle(
          _snapshotTypeMeta,
          snapshotType.isAcceptableOrUnknown(
              data['snapshot_type']!, _snapshotTypeMeta));
    } else if (isInserting) {
      context.missing(_snapshotTypeMeta);
    }
    if (data.containsKey('risk_level')) {
      context.handle(_riskLevelMeta,
          riskLevel.isAcceptableOrUnknown(data['risk_level']!, _riskLevelMeta));
    }
    if (data.containsKey('compliance_score')) {
      context.handle(
          _complianceScoreMeta,
          complianceScore.isAcceptableOrUnknown(
              data['compliance_score']!, _complianceScoreMeta));
    }
    if (data.containsKey('payload_json')) {
      context.handle(
          _payloadJsonMeta,
          payloadJson.isAcceptableOrUnknown(
              data['payload_json']!, _payloadJsonMeta));
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    if (data.containsKey('generated_at')) {
      context.handle(
          _generatedAtMeta,
          generatedAt.isAcceptableOrUnknown(
              data['generated_at']!, _generatedAtMeta));
    } else if (isInserting) {
      context.missing(_generatedAtMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  IntelligenceSnapshot map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IntelligenceSnapshot(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      patientId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}patient_id'])!,
      snapshotType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}snapshot_type'])!,
      riskLevel: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}risk_level']),
      complianceScore: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}compliance_score']),
      payloadJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payload_json'])!,
      generatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}generated_at'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $IntelligenceSnapshotsTable createAlias(String alias) {
    return $IntelligenceSnapshotsTable(attachedDatabase, alias);
  }
}

class IntelligenceSnapshot extends DataClass
    implements Insertable<IntelligenceSnapshot> {
  final String id;
  final String patientId;
  final String snapshotType;
  final String? riskLevel;
  final double? complianceScore;
  final String payloadJson;
  final DateTime generatedAt;
  final DateTime createdAt;
  const IntelligenceSnapshot(
      {required this.id,
      required this.patientId,
      required this.snapshotType,
      this.riskLevel,
      this.complianceScore,
      required this.payloadJson,
      required this.generatedAt,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['patient_id'] = Variable<String>(patientId);
    map['snapshot_type'] = Variable<String>(snapshotType);
    if (!nullToAbsent || riskLevel != null) {
      map['risk_level'] = Variable<String>(riskLevel);
    }
    if (!nullToAbsent || complianceScore != null) {
      map['compliance_score'] = Variable<double>(complianceScore);
    }
    map['payload_json'] = Variable<String>(payloadJson);
    map['generated_at'] = Variable<DateTime>(generatedAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  IntelligenceSnapshotsCompanion toCompanion(bool nullToAbsent) {
    return IntelligenceSnapshotsCompanion(
      id: Value(id),
      patientId: Value(patientId),
      snapshotType: Value(snapshotType),
      riskLevel: riskLevel == null && nullToAbsent
          ? const Value.absent()
          : Value(riskLevel),
      complianceScore: complianceScore == null && nullToAbsent
          ? const Value.absent()
          : Value(complianceScore),
      payloadJson: Value(payloadJson),
      generatedAt: Value(generatedAt),
      createdAt: Value(createdAt),
    );
  }

  factory IntelligenceSnapshot.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IntelligenceSnapshot(
      id: serializer.fromJson<String>(json['id']),
      patientId: serializer.fromJson<String>(json['patientId']),
      snapshotType: serializer.fromJson<String>(json['snapshotType']),
      riskLevel: serializer.fromJson<String?>(json['riskLevel']),
      complianceScore: serializer.fromJson<double?>(json['complianceScore']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      generatedAt: serializer.fromJson<DateTime>(json['generatedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'patientId': serializer.toJson<String>(patientId),
      'snapshotType': serializer.toJson<String>(snapshotType),
      'riskLevel': serializer.toJson<String?>(riskLevel),
      'complianceScore': serializer.toJson<double?>(complianceScore),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'generatedAt': serializer.toJson<DateTime>(generatedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  IntelligenceSnapshot copyWith(
          {String? id,
          String? patientId,
          String? snapshotType,
          Value<String?> riskLevel = const Value.absent(),
          Value<double?> complianceScore = const Value.absent(),
          String? payloadJson,
          DateTime? generatedAt,
          DateTime? createdAt}) =>
      IntelligenceSnapshot(
        id: id ?? this.id,
        patientId: patientId ?? this.patientId,
        snapshotType: snapshotType ?? this.snapshotType,
        riskLevel: riskLevel.present ? riskLevel.value : this.riskLevel,
        complianceScore: complianceScore.present
            ? complianceScore.value
            : this.complianceScore,
        payloadJson: payloadJson ?? this.payloadJson,
        generatedAt: generatedAt ?? this.generatedAt,
        createdAt: createdAt ?? this.createdAt,
      );
  IntelligenceSnapshot copyWithCompanion(IntelligenceSnapshotsCompanion data) {
    return IntelligenceSnapshot(
      id: data.id.present ? data.id.value : this.id,
      patientId: data.patientId.present ? data.patientId.value : this.patientId,
      snapshotType: data.snapshotType.present
          ? data.snapshotType.value
          : this.snapshotType,
      riskLevel: data.riskLevel.present ? data.riskLevel.value : this.riskLevel,
      complianceScore: data.complianceScore.present
          ? data.complianceScore.value
          : this.complianceScore,
      payloadJson:
          data.payloadJson.present ? data.payloadJson.value : this.payloadJson,
      generatedAt:
          data.generatedAt.present ? data.generatedAt.value : this.generatedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('IntelligenceSnapshot(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('snapshotType: $snapshotType, ')
          ..write('riskLevel: $riskLevel, ')
          ..write('complianceScore: $complianceScore, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('generatedAt: $generatedAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, patientId, snapshotType, riskLevel,
      complianceScore, payloadJson, generatedAt, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IntelligenceSnapshot &&
          other.id == this.id &&
          other.patientId == this.patientId &&
          other.snapshotType == this.snapshotType &&
          other.riskLevel == this.riskLevel &&
          other.complianceScore == this.complianceScore &&
          other.payloadJson == this.payloadJson &&
          other.generatedAt == this.generatedAt &&
          other.createdAt == this.createdAt);
}

class IntelligenceSnapshotsCompanion
    extends UpdateCompanion<IntelligenceSnapshot> {
  final Value<String> id;
  final Value<String> patientId;
  final Value<String> snapshotType;
  final Value<String?> riskLevel;
  final Value<double?> complianceScore;
  final Value<String> payloadJson;
  final Value<DateTime> generatedAt;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const IntelligenceSnapshotsCompanion({
    this.id = const Value.absent(),
    this.patientId = const Value.absent(),
    this.snapshotType = const Value.absent(),
    this.riskLevel = const Value.absent(),
    this.complianceScore = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.generatedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  IntelligenceSnapshotsCompanion.insert({
    required String id,
    required String patientId,
    required String snapshotType,
    this.riskLevel = const Value.absent(),
    this.complianceScore = const Value.absent(),
    required String payloadJson,
    required DateTime generatedAt,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        patientId = Value(patientId),
        snapshotType = Value(snapshotType),
        payloadJson = Value(payloadJson),
        generatedAt = Value(generatedAt),
        createdAt = Value(createdAt);
  static Insertable<IntelligenceSnapshot> custom({
    Expression<String>? id,
    Expression<String>? patientId,
    Expression<String>? snapshotType,
    Expression<String>? riskLevel,
    Expression<double>? complianceScore,
    Expression<String>? payloadJson,
    Expression<DateTime>? generatedAt,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (patientId != null) 'patient_id': patientId,
      if (snapshotType != null) 'snapshot_type': snapshotType,
      if (riskLevel != null) 'risk_level': riskLevel,
      if (complianceScore != null) 'compliance_score': complianceScore,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (generatedAt != null) 'generated_at': generatedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  IntelligenceSnapshotsCompanion copyWith(
      {Value<String>? id,
      Value<String>? patientId,
      Value<String>? snapshotType,
      Value<String?>? riskLevel,
      Value<double?>? complianceScore,
      Value<String>? payloadJson,
      Value<DateTime>? generatedAt,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return IntelligenceSnapshotsCompanion(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      snapshotType: snapshotType ?? this.snapshotType,
      riskLevel: riskLevel ?? this.riskLevel,
      complianceScore: complianceScore ?? this.complianceScore,
      payloadJson: payloadJson ?? this.payloadJson,
      generatedAt: generatedAt ?? this.generatedAt,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (patientId.present) {
      map['patient_id'] = Variable<String>(patientId.value);
    }
    if (snapshotType.present) {
      map['snapshot_type'] = Variable<String>(snapshotType.value);
    }
    if (riskLevel.present) {
      map['risk_level'] = Variable<String>(riskLevel.value);
    }
    if (complianceScore.present) {
      map['compliance_score'] = Variable<double>(complianceScore.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (generatedAt.present) {
      map['generated_at'] = Variable<DateTime>(generatedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IntelligenceSnapshotsCompanion(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('snapshotType: $snapshotType, ')
          ..write('riskLevel: $riskLevel, ')
          ..write('complianceScore: $complianceScore, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('generatedAt: $generatedAt, ')
          ..write('createdAt: $createdAt, ')
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
  late final $MedicinesTable medicines = $MedicinesTable(this);
  late final $RemindersTable reminders = $RemindersTable(this);
  late final $DoseLogsTable doseLogs = $DoseLogsTable(this);
  late final $HealthLogsTable healthLogs = $HealthLogsTable(this);
  late final $IntelligenceSnapshotsTable intelligenceSnapshots =
      $IntelligenceSnapshotsTable(this);
  late final MedicinesDao medicinesDao = MedicinesDao(this as AppDatabase);
  late final RemindersDao remindersDao = RemindersDao(this as AppDatabase);
  late final DoseLogsDao doseLogsDao = DoseLogsDao(this as AppDatabase);
  late final HealthLogsDao healthLogsDao = HealthLogsDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        patientProfiles,
        syncQueue,
        medicines,
        reminders,
        doseLogs,
        healthLogs,
        intelligenceSnapshots
      ];
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
typedef $$MedicinesTableCreateCompanionBuilder = MedicinesCompanion Function({
  required String id,
  required String patientId,
  required String name,
  Value<String?> dosage,
  Value<String?> frequency,
  Value<String?> scheduledTimes,
  Value<String?> color,
  Value<String?> unit,
  Value<String?> form,
  Value<String?> instructions,
  Value<int?> stockCount,
  Value<bool> isActive,
  Value<bool> isDeleted,
  Value<bool> isSynced,
  Value<DateTime?> startDate,
  Value<DateTime?> endDate,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$MedicinesTableUpdateCompanionBuilder = MedicinesCompanion Function({
  Value<String> id,
  Value<String> patientId,
  Value<String> name,
  Value<String?> dosage,
  Value<String?> frequency,
  Value<String?> scheduledTimes,
  Value<String?> color,
  Value<String?> unit,
  Value<String?> form,
  Value<String?> instructions,
  Value<int?> stockCount,
  Value<bool> isActive,
  Value<bool> isDeleted,
  Value<bool> isSynced,
  Value<DateTime?> startDate,
  Value<DateTime?> endDate,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$MedicinesTableFilterComposer
    extends Composer<_$AppDatabase, $MedicinesTable> {
  $$MedicinesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get patientId => $composableBuilder(
      column: $table.patientId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dosage => $composableBuilder(
      column: $table.dosage, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get frequency => $composableBuilder(
      column: $table.frequency, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get scheduledTimes => $composableBuilder(
      column: $table.scheduledTimes,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get form => $composableBuilder(
      column: $table.form, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get instructions => $composableBuilder(
      column: $table.instructions, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get stockCount => $composableBuilder(
      column: $table.stockCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get endDate => $composableBuilder(
      column: $table.endDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$MedicinesTableOrderingComposer
    extends Composer<_$AppDatabase, $MedicinesTable> {
  $$MedicinesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get patientId => $composableBuilder(
      column: $table.patientId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dosage => $composableBuilder(
      column: $table.dosage, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get frequency => $composableBuilder(
      column: $table.frequency, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get scheduledTimes => $composableBuilder(
      column: $table.scheduledTimes,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get form => $composableBuilder(
      column: $table.form, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get instructions => $composableBuilder(
      column: $table.instructions,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get stockCount => $composableBuilder(
      column: $table.stockCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
      column: $table.endDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$MedicinesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MedicinesTable> {
  $$MedicinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get patientId =>
      $composableBuilder(column: $table.patientId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get dosage =>
      $composableBuilder(column: $table.dosage, builder: (column) => column);

  GeneratedColumn<String> get frequency =>
      $composableBuilder(column: $table.frequency, builder: (column) => column);

  GeneratedColumn<String> get scheduledTimes => $composableBuilder(
      column: $table.scheduledTimes, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<String> get form =>
      $composableBuilder(column: $table.form, builder: (column) => column);

  GeneratedColumn<String> get instructions => $composableBuilder(
      column: $table.instructions, builder: (column) => column);

  GeneratedColumn<int> get stockCount => $composableBuilder(
      column: $table.stockCount, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$MedicinesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MedicinesTable,
    Medicine,
    $$MedicinesTableFilterComposer,
    $$MedicinesTableOrderingComposer,
    $$MedicinesTableAnnotationComposer,
    $$MedicinesTableCreateCompanionBuilder,
    $$MedicinesTableUpdateCompanionBuilder,
    (Medicine, BaseReferences<_$AppDatabase, $MedicinesTable, Medicine>),
    Medicine,
    PrefetchHooks Function()> {
  $$MedicinesTableTableManager(_$AppDatabase db, $MedicinesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MedicinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MedicinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MedicinesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> patientId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> dosage = const Value.absent(),
            Value<String?> frequency = const Value.absent(),
            Value<String?> scheduledTimes = const Value.absent(),
            Value<String?> color = const Value.absent(),
            Value<String?> unit = const Value.absent(),
            Value<String?> form = const Value.absent(),
            Value<String?> instructions = const Value.absent(),
            Value<int?> stockCount = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<DateTime?> startDate = const Value.absent(),
            Value<DateTime?> endDate = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MedicinesCompanion(
            id: id,
            patientId: patientId,
            name: name,
            dosage: dosage,
            frequency: frequency,
            scheduledTimes: scheduledTimes,
            color: color,
            unit: unit,
            form: form,
            instructions: instructions,
            stockCount: stockCount,
            isActive: isActive,
            isDeleted: isDeleted,
            isSynced: isSynced,
            startDate: startDate,
            endDate: endDate,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String patientId,
            required String name,
            Value<String?> dosage = const Value.absent(),
            Value<String?> frequency = const Value.absent(),
            Value<String?> scheduledTimes = const Value.absent(),
            Value<String?> color = const Value.absent(),
            Value<String?> unit = const Value.absent(),
            Value<String?> form = const Value.absent(),
            Value<String?> instructions = const Value.absent(),
            Value<int?> stockCount = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<DateTime?> startDate = const Value.absent(),
            Value<DateTime?> endDate = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              MedicinesCompanion.insert(
            id: id,
            patientId: patientId,
            name: name,
            dosage: dosage,
            frequency: frequency,
            scheduledTimes: scheduledTimes,
            color: color,
            unit: unit,
            form: form,
            instructions: instructions,
            stockCount: stockCount,
            isActive: isActive,
            isDeleted: isDeleted,
            isSynced: isSynced,
            startDate: startDate,
            endDate: endDate,
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

typedef $$MedicinesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MedicinesTable,
    Medicine,
    $$MedicinesTableFilterComposer,
    $$MedicinesTableOrderingComposer,
    $$MedicinesTableAnnotationComposer,
    $$MedicinesTableCreateCompanionBuilder,
    $$MedicinesTableUpdateCompanionBuilder,
    (Medicine, BaseReferences<_$AppDatabase, $MedicinesTable, Medicine>),
    Medicine,
    PrefetchHooks Function()>;
typedef $$RemindersTableCreateCompanionBuilder = RemindersCompanion Function({
  required String id,
  required String patientId,
  Value<String?> medicineId,
  required String title,
  Value<String?> notes,
  Value<String> reminderType,
  required int hour,
  required int minute,
  Value<String> frequency,
  Value<String?> daysOfWeek,
  Value<int?> intervalDays,
  Value<bool> isActive,
  Value<bool> isDeleted,
  Value<bool> isSynced,
  Value<DateTime?> startDate,
  Value<DateTime?> endDate,
  Value<DateTime?> lastTriggeredAt,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$RemindersTableUpdateCompanionBuilder = RemindersCompanion Function({
  Value<String> id,
  Value<String> patientId,
  Value<String?> medicineId,
  Value<String> title,
  Value<String?> notes,
  Value<String> reminderType,
  Value<int> hour,
  Value<int> minute,
  Value<String> frequency,
  Value<String?> daysOfWeek,
  Value<int?> intervalDays,
  Value<bool> isActive,
  Value<bool> isDeleted,
  Value<bool> isSynced,
  Value<DateTime?> startDate,
  Value<DateTime?> endDate,
  Value<DateTime?> lastTriggeredAt,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$RemindersTableFilterComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get patientId => $composableBuilder(
      column: $table.patientId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get medicineId => $composableBuilder(
      column: $table.medicineId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reminderType => $composableBuilder(
      column: $table.reminderType, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get hour => $composableBuilder(
      column: $table.hour, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get minute => $composableBuilder(
      column: $table.minute, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get frequency => $composableBuilder(
      column: $table.frequency, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get daysOfWeek => $composableBuilder(
      column: $table.daysOfWeek, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get intervalDays => $composableBuilder(
      column: $table.intervalDays, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get endDate => $composableBuilder(
      column: $table.endDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastTriggeredAt => $composableBuilder(
      column: $table.lastTriggeredAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$RemindersTableOrderingComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get patientId => $composableBuilder(
      column: $table.patientId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get medicineId => $composableBuilder(
      column: $table.medicineId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reminderType => $composableBuilder(
      column: $table.reminderType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get hour => $composableBuilder(
      column: $table.hour, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get minute => $composableBuilder(
      column: $table.minute, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get frequency => $composableBuilder(
      column: $table.frequency, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get daysOfWeek => $composableBuilder(
      column: $table.daysOfWeek, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get intervalDays => $composableBuilder(
      column: $table.intervalDays,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
      column: $table.endDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastTriggeredAt => $composableBuilder(
      column: $table.lastTriggeredAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$RemindersTableAnnotationComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get patientId =>
      $composableBuilder(column: $table.patientId, builder: (column) => column);

  GeneratedColumn<String> get medicineId => $composableBuilder(
      column: $table.medicineId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get reminderType => $composableBuilder(
      column: $table.reminderType, builder: (column) => column);

  GeneratedColumn<int> get hour =>
      $composableBuilder(column: $table.hour, builder: (column) => column);

  GeneratedColumn<int> get minute =>
      $composableBuilder(column: $table.minute, builder: (column) => column);

  GeneratedColumn<String> get frequency =>
      $composableBuilder(column: $table.frequency, builder: (column) => column);

  GeneratedColumn<String> get daysOfWeek => $composableBuilder(
      column: $table.daysOfWeek, builder: (column) => column);

  GeneratedColumn<int> get intervalDays => $composableBuilder(
      column: $table.intervalDays, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<DateTime> get lastTriggeredAt => $composableBuilder(
      column: $table.lastTriggeredAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$RemindersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RemindersTable,
    Reminder,
    $$RemindersTableFilterComposer,
    $$RemindersTableOrderingComposer,
    $$RemindersTableAnnotationComposer,
    $$RemindersTableCreateCompanionBuilder,
    $$RemindersTableUpdateCompanionBuilder,
    (Reminder, BaseReferences<_$AppDatabase, $RemindersTable, Reminder>),
    Reminder,
    PrefetchHooks Function()> {
  $$RemindersTableTableManager(_$AppDatabase db, $RemindersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RemindersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RemindersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RemindersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> patientId = const Value.absent(),
            Value<String?> medicineId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String> reminderType = const Value.absent(),
            Value<int> hour = const Value.absent(),
            Value<int> minute = const Value.absent(),
            Value<String> frequency = const Value.absent(),
            Value<String?> daysOfWeek = const Value.absent(),
            Value<int?> intervalDays = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<DateTime?> startDate = const Value.absent(),
            Value<DateTime?> endDate = const Value.absent(),
            Value<DateTime?> lastTriggeredAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RemindersCompanion(
            id: id,
            patientId: patientId,
            medicineId: medicineId,
            title: title,
            notes: notes,
            reminderType: reminderType,
            hour: hour,
            minute: minute,
            frequency: frequency,
            daysOfWeek: daysOfWeek,
            intervalDays: intervalDays,
            isActive: isActive,
            isDeleted: isDeleted,
            isSynced: isSynced,
            startDate: startDate,
            endDate: endDate,
            lastTriggeredAt: lastTriggeredAt,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String patientId,
            Value<String?> medicineId = const Value.absent(),
            required String title,
            Value<String?> notes = const Value.absent(),
            Value<String> reminderType = const Value.absent(),
            required int hour,
            required int minute,
            Value<String> frequency = const Value.absent(),
            Value<String?> daysOfWeek = const Value.absent(),
            Value<int?> intervalDays = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<DateTime?> startDate = const Value.absent(),
            Value<DateTime?> endDate = const Value.absent(),
            Value<DateTime?> lastTriggeredAt = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              RemindersCompanion.insert(
            id: id,
            patientId: patientId,
            medicineId: medicineId,
            title: title,
            notes: notes,
            reminderType: reminderType,
            hour: hour,
            minute: minute,
            frequency: frequency,
            daysOfWeek: daysOfWeek,
            intervalDays: intervalDays,
            isActive: isActive,
            isDeleted: isDeleted,
            isSynced: isSynced,
            startDate: startDate,
            endDate: endDate,
            lastTriggeredAt: lastTriggeredAt,
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

typedef $$RemindersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RemindersTable,
    Reminder,
    $$RemindersTableFilterComposer,
    $$RemindersTableOrderingComposer,
    $$RemindersTableAnnotationComposer,
    $$RemindersTableCreateCompanionBuilder,
    $$RemindersTableUpdateCompanionBuilder,
    (Reminder, BaseReferences<_$AppDatabase, $RemindersTable, Reminder>),
    Reminder,
    PrefetchHooks Function()>;
typedef $$DoseLogsTableCreateCompanionBuilder = DoseLogsCompanion Function({
  required String id,
  required String patientId,
  required String medicineId,
  Value<String?> reminderId,
  required DateTime scheduledAt,
  Value<DateTime?> takenAt,
  required String status,
  Value<String?> notes,
  Value<bool> isSynced,
  Value<bool> isDeleted,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$DoseLogsTableUpdateCompanionBuilder = DoseLogsCompanion Function({
  Value<String> id,
  Value<String> patientId,
  Value<String> medicineId,
  Value<String?> reminderId,
  Value<DateTime> scheduledAt,
  Value<DateTime?> takenAt,
  Value<String> status,
  Value<String?> notes,
  Value<bool> isSynced,
  Value<bool> isDeleted,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$DoseLogsTableFilterComposer
    extends Composer<_$AppDatabase, $DoseLogsTable> {
  $$DoseLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get patientId => $composableBuilder(
      column: $table.patientId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get medicineId => $composableBuilder(
      column: $table.medicineId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reminderId => $composableBuilder(
      column: $table.reminderId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get scheduledAt => $composableBuilder(
      column: $table.scheduledAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get takenAt => $composableBuilder(
      column: $table.takenAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$DoseLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $DoseLogsTable> {
  $$DoseLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get patientId => $composableBuilder(
      column: $table.patientId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get medicineId => $composableBuilder(
      column: $table.medicineId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reminderId => $composableBuilder(
      column: $table.reminderId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get scheduledAt => $composableBuilder(
      column: $table.scheduledAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get takenAt => $composableBuilder(
      column: $table.takenAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$DoseLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DoseLogsTable> {
  $$DoseLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get patientId =>
      $composableBuilder(column: $table.patientId, builder: (column) => column);

  GeneratedColumn<String> get medicineId => $composableBuilder(
      column: $table.medicineId, builder: (column) => column);

  GeneratedColumn<String> get reminderId => $composableBuilder(
      column: $table.reminderId, builder: (column) => column);

  GeneratedColumn<DateTime> get scheduledAt => $composableBuilder(
      column: $table.scheduledAt, builder: (column) => column);

  GeneratedColumn<DateTime> get takenAt =>
      $composableBuilder(column: $table.takenAt, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$DoseLogsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DoseLogsTable,
    DoseLog,
    $$DoseLogsTableFilterComposer,
    $$DoseLogsTableOrderingComposer,
    $$DoseLogsTableAnnotationComposer,
    $$DoseLogsTableCreateCompanionBuilder,
    $$DoseLogsTableUpdateCompanionBuilder,
    (DoseLog, BaseReferences<_$AppDatabase, $DoseLogsTable, DoseLog>),
    DoseLog,
    PrefetchHooks Function()> {
  $$DoseLogsTableTableManager(_$AppDatabase db, $DoseLogsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DoseLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DoseLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DoseLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> patientId = const Value.absent(),
            Value<String> medicineId = const Value.absent(),
            Value<String?> reminderId = const Value.absent(),
            Value<DateTime> scheduledAt = const Value.absent(),
            Value<DateTime?> takenAt = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DoseLogsCompanion(
            id: id,
            patientId: patientId,
            medicineId: medicineId,
            reminderId: reminderId,
            scheduledAt: scheduledAt,
            takenAt: takenAt,
            status: status,
            notes: notes,
            isSynced: isSynced,
            isDeleted: isDeleted,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String patientId,
            required String medicineId,
            Value<String?> reminderId = const Value.absent(),
            required DateTime scheduledAt,
            Value<DateTime?> takenAt = const Value.absent(),
            required String status,
            Value<String?> notes = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              DoseLogsCompanion.insert(
            id: id,
            patientId: patientId,
            medicineId: medicineId,
            reminderId: reminderId,
            scheduledAt: scheduledAt,
            takenAt: takenAt,
            status: status,
            notes: notes,
            isSynced: isSynced,
            isDeleted: isDeleted,
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

typedef $$DoseLogsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DoseLogsTable,
    DoseLog,
    $$DoseLogsTableFilterComposer,
    $$DoseLogsTableOrderingComposer,
    $$DoseLogsTableAnnotationComposer,
    $$DoseLogsTableCreateCompanionBuilder,
    $$DoseLogsTableUpdateCompanionBuilder,
    (DoseLog, BaseReferences<_$AppDatabase, $DoseLogsTable, DoseLog>),
    DoseLog,
    PrefetchHooks Function()>;
typedef $$HealthLogsTableCreateCompanionBuilder = HealthLogsCompanion Function({
  required String id,
  required String patientId,
  required String metricType,
  required double value,
  Value<double?> secondaryValue,
  Value<String?> notes,
  required String source,
  required DateTime recordedAt,
  Value<bool> isSynced,
  Value<bool> isDeleted,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$HealthLogsTableUpdateCompanionBuilder = HealthLogsCompanion Function({
  Value<String> id,
  Value<String> patientId,
  Value<String> metricType,
  Value<double> value,
  Value<double?> secondaryValue,
  Value<String?> notes,
  Value<String> source,
  Value<DateTime> recordedAt,
  Value<bool> isSynced,
  Value<bool> isDeleted,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$HealthLogsTableFilterComposer
    extends Composer<_$AppDatabase, $HealthLogsTable> {
  $$HealthLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get patientId => $composableBuilder(
      column: $table.patientId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get metricType => $composableBuilder(
      column: $table.metricType, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get secondaryValue => $composableBuilder(
      column: $table.secondaryValue,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get recordedAt => $composableBuilder(
      column: $table.recordedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$HealthLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $HealthLogsTable> {
  $$HealthLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get patientId => $composableBuilder(
      column: $table.patientId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get metricType => $composableBuilder(
      column: $table.metricType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get secondaryValue => $composableBuilder(
      column: $table.secondaryValue,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get recordedAt => $composableBuilder(
      column: $table.recordedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$HealthLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HealthLogsTable> {
  $$HealthLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get patientId =>
      $composableBuilder(column: $table.patientId, builder: (column) => column);

  GeneratedColumn<String> get metricType => $composableBuilder(
      column: $table.metricType, builder: (column) => column);

  GeneratedColumn<double> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<double> get secondaryValue => $composableBuilder(
      column: $table.secondaryValue, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<DateTime> get recordedAt => $composableBuilder(
      column: $table.recordedAt, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$HealthLogsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $HealthLogsTable,
    HealthLog,
    $$HealthLogsTableFilterComposer,
    $$HealthLogsTableOrderingComposer,
    $$HealthLogsTableAnnotationComposer,
    $$HealthLogsTableCreateCompanionBuilder,
    $$HealthLogsTableUpdateCompanionBuilder,
    (HealthLog, BaseReferences<_$AppDatabase, $HealthLogsTable, HealthLog>),
    HealthLog,
    PrefetchHooks Function()> {
  $$HealthLogsTableTableManager(_$AppDatabase db, $HealthLogsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HealthLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HealthLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HealthLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> patientId = const Value.absent(),
            Value<String> metricType = const Value.absent(),
            Value<double> value = const Value.absent(),
            Value<double?> secondaryValue = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String> source = const Value.absent(),
            Value<DateTime> recordedAt = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              HealthLogsCompanion(
            id: id,
            patientId: patientId,
            metricType: metricType,
            value: value,
            secondaryValue: secondaryValue,
            notes: notes,
            source: source,
            recordedAt: recordedAt,
            isSynced: isSynced,
            isDeleted: isDeleted,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String patientId,
            required String metricType,
            required double value,
            Value<double?> secondaryValue = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            required String source,
            required DateTime recordedAt,
            Value<bool> isSynced = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              HealthLogsCompanion.insert(
            id: id,
            patientId: patientId,
            metricType: metricType,
            value: value,
            secondaryValue: secondaryValue,
            notes: notes,
            source: source,
            recordedAt: recordedAt,
            isSynced: isSynced,
            isDeleted: isDeleted,
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

typedef $$HealthLogsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $HealthLogsTable,
    HealthLog,
    $$HealthLogsTableFilterComposer,
    $$HealthLogsTableOrderingComposer,
    $$HealthLogsTableAnnotationComposer,
    $$HealthLogsTableCreateCompanionBuilder,
    $$HealthLogsTableUpdateCompanionBuilder,
    (HealthLog, BaseReferences<_$AppDatabase, $HealthLogsTable, HealthLog>),
    HealthLog,
    PrefetchHooks Function()>;
typedef $$IntelligenceSnapshotsTableCreateCompanionBuilder
    = IntelligenceSnapshotsCompanion Function({
  required String id,
  required String patientId,
  required String snapshotType,
  Value<String?> riskLevel,
  Value<double?> complianceScore,
  required String payloadJson,
  required DateTime generatedAt,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$IntelligenceSnapshotsTableUpdateCompanionBuilder
    = IntelligenceSnapshotsCompanion Function({
  Value<String> id,
  Value<String> patientId,
  Value<String> snapshotType,
  Value<String?> riskLevel,
  Value<double?> complianceScore,
  Value<String> payloadJson,
  Value<DateTime> generatedAt,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$IntelligenceSnapshotsTableFilterComposer
    extends Composer<_$AppDatabase, $IntelligenceSnapshotsTable> {
  $$IntelligenceSnapshotsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get patientId => $composableBuilder(
      column: $table.patientId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get snapshotType => $composableBuilder(
      column: $table.snapshotType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get riskLevel => $composableBuilder(
      column: $table.riskLevel, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get complianceScore => $composableBuilder(
      column: $table.complianceScore,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get payloadJson => $composableBuilder(
      column: $table.payloadJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get generatedAt => $composableBuilder(
      column: $table.generatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$IntelligenceSnapshotsTableOrderingComposer
    extends Composer<_$AppDatabase, $IntelligenceSnapshotsTable> {
  $$IntelligenceSnapshotsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get patientId => $composableBuilder(
      column: $table.patientId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get snapshotType => $composableBuilder(
      column: $table.snapshotType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get riskLevel => $composableBuilder(
      column: $table.riskLevel, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get complianceScore => $composableBuilder(
      column: $table.complianceScore,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get payloadJson => $composableBuilder(
      column: $table.payloadJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get generatedAt => $composableBuilder(
      column: $table.generatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$IntelligenceSnapshotsTableAnnotationComposer
    extends Composer<_$AppDatabase, $IntelligenceSnapshotsTable> {
  $$IntelligenceSnapshotsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get patientId =>
      $composableBuilder(column: $table.patientId, builder: (column) => column);

  GeneratedColumn<String> get snapshotType => $composableBuilder(
      column: $table.snapshotType, builder: (column) => column);

  GeneratedColumn<String> get riskLevel =>
      $composableBuilder(column: $table.riskLevel, builder: (column) => column);

  GeneratedColumn<double> get complianceScore => $composableBuilder(
      column: $table.complianceScore, builder: (column) => column);

  GeneratedColumn<String> get payloadJson => $composableBuilder(
      column: $table.payloadJson, builder: (column) => column);

  GeneratedColumn<DateTime> get generatedAt => $composableBuilder(
      column: $table.generatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$IntelligenceSnapshotsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $IntelligenceSnapshotsTable,
    IntelligenceSnapshot,
    $$IntelligenceSnapshotsTableFilterComposer,
    $$IntelligenceSnapshotsTableOrderingComposer,
    $$IntelligenceSnapshotsTableAnnotationComposer,
    $$IntelligenceSnapshotsTableCreateCompanionBuilder,
    $$IntelligenceSnapshotsTableUpdateCompanionBuilder,
    (
      IntelligenceSnapshot,
      BaseReferences<_$AppDatabase, $IntelligenceSnapshotsTable,
          IntelligenceSnapshot>
    ),
    IntelligenceSnapshot,
    PrefetchHooks Function()> {
  $$IntelligenceSnapshotsTableTableManager(
      _$AppDatabase db, $IntelligenceSnapshotsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IntelligenceSnapshotsTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$IntelligenceSnapshotsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IntelligenceSnapshotsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> patientId = const Value.absent(),
            Value<String> snapshotType = const Value.absent(),
            Value<String?> riskLevel = const Value.absent(),
            Value<double?> complianceScore = const Value.absent(),
            Value<String> payloadJson = const Value.absent(),
            Value<DateTime> generatedAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              IntelligenceSnapshotsCompanion(
            id: id,
            patientId: patientId,
            snapshotType: snapshotType,
            riskLevel: riskLevel,
            complianceScore: complianceScore,
            payloadJson: payloadJson,
            generatedAt: generatedAt,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String patientId,
            required String snapshotType,
            Value<String?> riskLevel = const Value.absent(),
            Value<double?> complianceScore = const Value.absent(),
            required String payloadJson,
            required DateTime generatedAt,
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              IntelligenceSnapshotsCompanion.insert(
            id: id,
            patientId: patientId,
            snapshotType: snapshotType,
            riskLevel: riskLevel,
            complianceScore: complianceScore,
            payloadJson: payloadJson,
            generatedAt: generatedAt,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$IntelligenceSnapshotsTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $IntelligenceSnapshotsTable,
        IntelligenceSnapshot,
        $$IntelligenceSnapshotsTableFilterComposer,
        $$IntelligenceSnapshotsTableOrderingComposer,
        $$IntelligenceSnapshotsTableAnnotationComposer,
        $$IntelligenceSnapshotsTableCreateCompanionBuilder,
        $$IntelligenceSnapshotsTableUpdateCompanionBuilder,
        (
          IntelligenceSnapshot,
          BaseReferences<_$AppDatabase, $IntelligenceSnapshotsTable,
              IntelligenceSnapshot>
        ),
        IntelligenceSnapshot,
        PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PatientProfilesTableTableManager get patientProfiles =>
      $$PatientProfilesTableTableManager(_db, _db.patientProfiles);
  $$SyncQueueTableTableManager get syncQueue =>
      $$SyncQueueTableTableManager(_db, _db.syncQueue);
  $$MedicinesTableTableManager get medicines =>
      $$MedicinesTableTableManager(_db, _db.medicines);
  $$RemindersTableTableManager get reminders =>
      $$RemindersTableTableManager(_db, _db.reminders);
  $$DoseLogsTableTableManager get doseLogs =>
      $$DoseLogsTableTableManager(_db, _db.doseLogs);
  $$HealthLogsTableTableManager get healthLogs =>
      $$HealthLogsTableTableManager(_db, _db.healthLogs);
  $$IntelligenceSnapshotsTableTableManager get intelligenceSnapshots =>
      $$IntelligenceSnapshotsTableTableManager(_db, _db.intelligenceSnapshots);
}
