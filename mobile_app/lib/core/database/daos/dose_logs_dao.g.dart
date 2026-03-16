// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dose_logs_dao.dart';

// ignore_for_file: type=lint
mixin _$DoseLogsDaoMixin on DatabaseAccessor<AppDatabase> {
  $DoseLogsTable get doseLogs => attachedDatabase.doseLogs;
  DoseLogsDaoManager get managers => DoseLogsDaoManager(this);
}

class DoseLogsDaoManager {
  final _$DoseLogsDaoMixin _db;
  DoseLogsDaoManager(this._db);
  $$DoseLogsTableTableManager get doseLogs =>
      $$DoseLogsTableTableManager(_db.attachedDatabase, _db.doseLogs);
}
