import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'sync_providers.dart';
import 'sync_queue_service.dart';
import 'sync_status_service.dart';

final syncStatusServiceProvider = Provider<SyncStatusService>((ref) {
  return SyncStatusService(
    syncQueueService: ref.watch(syncQueueServiceProvider),
    profileSyncService: ref.watch(profileSyncServiceProvider),
    medicineSyncService: ref.watch(medicineSyncServiceProvider),
    reminderSyncService: ref.watch(reminderSyncServiceProvider),
    doseLogSyncService: ref.watch(doseLogSyncServiceProvider),
  );
});

final syncStatusStreamProvider = StreamProvider.autoDispose<SyncStatusSnapshot>((
  ref,
) async* {
  final service = ref.watch(syncStatusServiceProvider);

  yield await service.getQueueStats();

  while (true) {
    await Future.delayed(const Duration(seconds: 3));
    yield await service.getQueueStats();
  }
});

class SyncActionState {
  final bool isWorking;
  final String? successMessage;
  final String? errorMessage;

  const SyncActionState({
    required this.isWorking,
    required this.successMessage,
    required this.errorMessage,
  });

  factory SyncActionState.initial() {
    return const SyncActionState(
      isWorking: false,
      successMessage: null,
      errorMessage: null,
    );
  }

  SyncActionState copyWith({
    bool? isWorking,
    String? successMessage,
    String? errorMessage,
    bool clearSuccess = false,
    bool clearError = false,
  }) {
    return SyncActionState(
      isWorking: isWorking ?? this.isWorking,
      successMessage: clearSuccess
          ? null
          : (successMessage ?? this.successMessage),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

final syncActionProvider =
    StateNotifierProvider<SyncActionNotifier, SyncActionState>((ref) {
      return SyncActionNotifier(ref);
    });

class SyncActionNotifier extends StateNotifier<SyncActionState> {
  final Ref _ref;

  SyncActionNotifier(this._ref) : super(SyncActionState.initial());

  Future<void> syncNow() async {
    state = state.copyWith(
      isWorking: true,
      clearError: true,
      clearSuccess: true,
    );

    try {
      await _ref.read(syncStatusServiceProvider).syncNow();
      _ref.invalidate(syncStatusStreamProvider);

      state = state.copyWith(
        isWorking: false,
        successMessage: 'Sync completed successfully.',
      );
    } catch (e) {
      state = state.copyWith(
        isWorking: false,
        errorMessage: 'Sync failed: $e',
      );
    }
  }

  Future<void> retryFailed() async {
    state = state.copyWith(
      isWorking: true,
      clearError: true,
      clearSuccess: true,
    );

    try {
      await _ref.read(syncStatusServiceProvider).retryFailed();
      _ref.invalidate(syncStatusStreamProvider);

      state = state.copyWith(
        isWorking: false,
        successMessage: 'Failed sync items retried.',
      );
    } catch (e) {
      state = state.copyWith(
        isWorking: false,
        errorMessage: 'Retry failed: $e',
      );
    }
  }

  Future<void> clearSynced() async {
    state = state.copyWith(
      isWorking: true,
      clearError: true,
      clearSuccess: true,
    );

    try {
      final removed = await _ref
          .read(syncStatusServiceProvider)
          .clearSyncedQueueItems();
      _ref.invalidate(syncStatusStreamProvider);

      state = state.copyWith(
        isWorking: false,
        successMessage: removed > 0
            ? 'Cleared $removed synced queue item${removed == 1 ? '' : 's'}.'
            : 'No synced queue items to clear.',
      );
    } catch (e) {
      state = state.copyWith(
        isWorking: false,
        errorMessage: 'Clear failed: $e',
      );
    }
  }

  void clearMessages() {
    state = state.copyWith(clearError: true, clearSuccess: true);
  }
}
