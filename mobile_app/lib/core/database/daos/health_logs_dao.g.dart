// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_logs_dao.dart';

// ignore_for_file: type=lint
mixin _$HealthLogsDaoMixin on DatabaseAccessor<AppDatabase> {
  $HealthLogsTable get healthLogs => attachedDatabase.healthLogs;
  HealthLogsDaoManager get managers => HealthLogsDaoManager(this);
}

class HealthLogsDaoManager {
  final _$HealthLogsDaoMixin _db;
  HealthLogsDaoManager(this._db);
  $$HealthLogsTableTableManager get healthLogs =>
      $$HealthLogsTableTableManager(_db.attachedDatabase, _db.healthLogs);
}
