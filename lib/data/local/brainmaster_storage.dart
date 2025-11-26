import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class BrainmasterData {
  final int wordsFound;
  final List<bool> claimedRewards;
  final int freeHints;
  final DateTime lastResetAt;

  const BrainmasterData({
    required this.wordsFound,
    required this.claimedRewards,
    required this.freeHints,
    required this.lastResetAt,
  });

  factory BrainmasterData.initial({DateTime? now}) => BrainmasterData(
    wordsFound: 0,
    claimedRewards: List<bool>.filled(10, false),
    freeHints: 0,
    lastResetAt: now ?? DateTime.now(),
  );

  factory BrainmasterData.fromJson(Map<String, dynamic> json) {
    final claimed =
    (json['claimedRewards'] as List?)?.map((e) => e == true).toList();
    final lastResetRaw = json['lastResetAt'];
    DateTime? lastResetAt;
    if (lastResetRaw is int) {
      lastResetAt = DateTime.fromMillisecondsSinceEpoch(lastResetRaw);
    } else if (lastResetRaw is String) {
      lastResetAt = DateTime.tryParse(lastResetRaw);
    }
    return BrainmasterData(
      wordsFound: (json['wordsFound'] as int?) ?? 0,
      claimedRewards: claimed != null && claimed.length == 10
          ? claimed
          : List<bool>.filled(10, false),
      freeHints: (json['freeHints'] as int?) ?? 0,
      lastResetAt: lastResetAt ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'wordsFound': wordsFound,
    'claimedRewards': claimedRewards,
    'freeHints': freeHints,
    'lastResetAt': lastResetAt.toIso8601String(),
  };

  BrainmasterData copyWith({
    int? wordsFound,
    List<bool>? claimedRewards,
    int? freeHints,
    DateTime? lastResetAt,
  }) {
    return BrainmasterData(
      wordsFound: wordsFound ?? this.wordsFound,
      claimedRewards: claimedRewards ?? List<bool>.from(this.claimedRewards),
      freeHints: freeHints ?? this.freeHints,
      lastResetAt: lastResetAt ?? this.lastResetAt,
    );
  }

  bool isRewardClaimed(int index) => claimedRewards[index];

  BrainmasterData markClaimed(int index) {
    final updated = List<bool>.from(claimedRewards);
    updated[index] = true;
    return copyWith(claimedRewards: updated);
  }
}

class BrainmasterStorage {
  BrainmasterStorage._();

  static final BrainmasterStorage instance = BrainmasterStorage._();

  static const _fileName = 'brainmaster_progress.json';
  File? _cachedFile;
  BrainmasterData? _cachedData;

  Future<File> _resolveFile() async {
    if (_cachedFile != null) return _cachedFile!;
    final dir = await getApplicationSupportDirectory();
    final file = File('${dir.path}/$_fileName');
    if (!await file.exists()) {
      await file.create(recursive: true);
      await file.writeAsString(
        jsonEncode(BrainmasterData.initial().toJson()),
      );
    }
    _cachedFile = file;
    return file;
  }

  Future<BrainmasterData> load() async {
    if (_cachedData == null) {
      final file = await _resolveFile();
      final content = await file.readAsString();
      if (content.trim().isEmpty) {
        _cachedData = BrainmasterData.initial();
        await file.writeAsString(jsonEncode(_cachedData!.toJson()));
      } else {
        final decoded = jsonDecode(content) as Map<String, dynamic>;
        _cachedData = BrainmasterData.fromJson(decoded);
      }
    }

    return _maybeRefresh(_cachedData!);
  }

  Future<void> _save(BrainmasterData data) async {
    final file = await _resolveFile();
    await file.writeAsString(jsonEncode(data.toJson()));
    _cachedData = data;
  }

  Future<BrainmasterData> _maybeRefresh(BrainmasterData current) async {
    final now = DateTime.now();
    if (now.isAfter(current.lastResetAt.add(const Duration(hours: 24)))) {
      final resetData = BrainmasterData.initial(now: now);
      await _save(resetData);
      return resetData;
    }
    return current;
  }

  Future<BrainmasterData> incrementWordCount() async {
    final data = await load();
    final updated = data.copyWith(wordsFound: data.wordsFound + 1);
    await _save(updated);
    return updated;
  }

  Future<BrainmasterData> addHints(int amount) async {
    final data = await load();
    final updated = data.copyWith(freeHints: data.freeHints + amount);
    await _save(updated);
    return updated;
  }

  Future<bool> consumeHint() async {
    final data = await load();
    if (data.freeHints <= 0) return false;
    final updated = data.copyWith(freeHints: data.freeHints - 1);
    await _save(updated);
    return true;
  }

  Future<BrainmasterData> updateClaimed(int index) async {
    final data = await load();
    final updated = data.markClaimed(index);
    await _save(updated);
    return updated;
  }

  Future<void> overwrite(BrainmasterData data) => _save(data);
}