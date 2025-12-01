import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/log_entry.dart';

abstract class LogsDataSource {
  Future<({List<LogEntry> items, DocumentSnapshot? lastDoc})> fetchLogsPage({
    DocumentSnapshot? startAfter,
    int pageSize,
  });
  Stream<List<LogEntry>> watchLatestLogs({int limit});
  Future<void> markAsViewed(String logId);
}

class LogsRepository implements LogsDataSource {
  final FirebaseFirestore _db;
  String? _cachedUsername;
  String? _cachedUsersId;

  LogsRepository({FirebaseFirestore? db}) : _db = db ?? FirebaseFirestore.instance;

  @override
  Future<({List<LogEntry> items, DocumentSnapshot? lastDoc})> fetchLogsPage({
    DocumentSnapshot? startAfter,
    int pageSize = 10,
  }) async {
    final userCtx = await _resolveUserRefs();
    Query<Map<String, dynamic>> query = _db
        .collection('logs')
        .orderBy('logsDate', descending: true)
        .limit(pageSize);
    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }
    final snap = await query.get();
    final items = snap.docs
        .map((d) => LogEntry.fromFirestore(
              d,
              username: userCtx.$1,
              usersId: userCtx.$2,
            ))
        .toList();
    final lastDoc = snap.docs.isNotEmpty ? snap.docs.last : null;
    return (items: items, lastDoc: lastDoc);
  }

  @override
  Stream<List<LogEntry>> watchLatestLogs({int limit = 10}) async* {
    final userCtx = await _resolveUserRefs();
    yield* _db
        .collection('logs')
        .orderBy('logsDate', descending: true)
        .limit(limit)
        .snapshots()
        .map((QuerySnapshot<Map<String, dynamic>> snap) => snap.docs
            .map((d) => LogEntry.fromFirestore(
                  d,
                  username: userCtx.$1,
                  usersId: userCtx.$2,
                ))
            .toList());
  }

  Future<(String?, String?)> _resolveUserRefs() async {
    if (_cachedUsername != null && _cachedUsersId != null) {
      return (_cachedUsername, _cachedUsersId);
    }
    final email = 'allyssonalexander10@gmail.com';
    final uid = '2eQWpn1bVLQJrBmqti1aTMur09x1';

    String? name;
    try {
      final byEmail = await _db
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();
      if (byEmail.docs.isNotEmpty) {
        final data = byEmail.docs.first.data();
        name = (data['name'] ?? data['username'] ?? email).toString();
      }
    } catch (_) {}

    String? resolvedUid;
    try {
      final byUid = await _db
          .collection('users')
          .where('uid', isEqualTo: uid)
          .limit(1)
          .get();
      if (byUid.docs.isNotEmpty) {
        final data = byUid.docs.first.data();
        resolvedUid = (data['uid'] ?? uid).toString();
      } else {
        resolvedUid = uid;
      }
    } catch (_) {
      resolvedUid = uid;
    }

    _cachedUsername = name ?? email;
    _cachedUsersId = resolvedUid;
    return (_cachedUsername, _cachedUsersId);
  }

  @override
  Future<void> markAsViewed(String logId) async {}
}

final logsRepositoryProvider = Provider<LogsRepository>(
  (ref) => LogsRepository(),
);
