import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../models/app_models.dart';
import '../widgets/risk_badge.dart';
import 'auth_service.dart';

class FirestoreService {
  static final FirestoreService _instance = FirestoreService._internal();
  factory FirestoreService() => _instance;
  FirestoreService._internal();

  FirebaseFirestore? get _db {
    try {
      return FirebaseFirestore.instance;
    } catch (e) {
      debugPrint('FirebaseFirestore unavailable: $e');
      return null;
    }
  }

  String get _userId => AuthService().currentUser?.uid ?? 'device_guest_user';

  /// Saves a newly completed scan result & security score snapshot to Cloud Firestore
  Future<void> saveScanResult(ScanResultModel result) async {
    final db = _db;
    if (db == null) return;

    try {
      final docRef = db.collection('users').doc(_userId).collection('scans').doc();
      final threatsData = result.detectedThreats.map((app) => {
        'id': app.id,
        'name': app.name,
        'packageName': app.packageName,
        'version': app.version,
        'developer': app.developer,
        'riskLevel': app.riskLevel.name,
        'riskScore': app.riskScore,
        'category': app.category,
        'trackersCount': app.trackersCount,
        'threatDescription': app.threatDescription,
        'permissionsCount': app.permissions.length,
      }).toList();

      await docRef.set({
        'scanTime': Timestamp.fromDate(result.scanTime),
        'totalAppsScanned': result.totalAppsScanned,
        'safeCount': result.safeCount,
        'mediumCount': result.mediumCount,
        'highCount': result.highCount,
        'criticalCount': result.criticalCount,
        'securityScore': result.securityScore,
        'detectedThreats': threatsData,
        'createdTimestamp': FieldValue.serverTimestamp(),
      });

      // Update user security score summary profile
      await db.collection('users').doc(_userId).set({
        'lastScanTime': Timestamp.fromDate(result.scanTime),
        'lastSecurityScore': result.securityScore,
        'lastTotalApps': result.totalAppsScanned,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      debugPrint('Firestore: Successfully saved scan result #${docRef.id} with score ${result.securityScore}.');
    } catch (e) {
      debugPrint('Firestore saveScanResult failed: $e');
    }
  }

  /// Real-time stream of user scan history records from Cloud Firestore
  Stream<List<ScanResultModel>> getScanHistoryStream() {
    final db = _db;
    if (db == null) {
      return Stream.value([MockData.lastScanResult]);
    }

    try {
      return db
          .collection('users')
          .doc(_userId)
          .collection('scans')
          .orderBy('scanTime', descending: true)
          .snapshots()
          .map((snapshot) {
        if (snapshot.docs.isEmpty) {
          return [MockData.lastScanResult];
        }

        return snapshot.docs.map((doc) {
          final data = doc.data();
          final DateTime scanTime = (data['scanTime'] as Timestamp?)?.toDate() ?? DateTime.now();
          final int totalAppsScanned = (data['totalAppsScanned'] as num?)?.toInt() ?? 0;
          final int safeCount = (data['safeCount'] as num?)?.toInt() ?? 0;
          final int mediumCount = (data['mediumCount'] as num?)?.toInt() ?? 0;
          final int highCount = (data['highCount'] as num?)?.toInt() ?? 0;
          final int criticalCount = (data['criticalCount'] as num?)?.toInt() ?? 0;
          final int securityScore = (data['securityScore'] as num?)?.toInt() ?? 100;
          final List<dynamic> rawThreats = data['detectedThreats'] as List<dynamic>? ?? [];

          final List<InstalledAppModel> parsedThreats = rawThreats.map((t) {
            final map = Map<String, dynamic>.from(t as Map);
            final String name = map['name'] as String? ?? 'Threat Package';
            final String pkgName = map['packageName'] as String? ?? 'com.app.threat';
            final String riskLevelStr = map['riskLevel'] as String? ?? 'high';
            final int rScore = (map['riskScore'] as num?)?.toInt() ?? 80;
            final String desc = map['threatDescription'] as String? ?? 'Suspicious background activity.';

            RiskLevel level = RiskLevel.high;
            if (riskLevelStr == 'critical') {
              level = RiskLevel.critical;
            } else if (riskLevelStr == 'medium') {
              level = RiskLevel.medium;
            } else if (riskLevelStr == 'safe') {
              level = RiskLevel.safe;
            }


            return InstalledAppModel(
              id: map['id'] as String? ?? pkgName,
              name: name,
              packageName: pkgName,
              version: map['version'] as String? ?? '1.0.0',
              developer: map['developer'] as String? ?? 'Installed Application',
              icon: level == RiskLevel.critical ? Icons.warning_rounded : Icons.phone_android_rounded,
              riskLevel: level,
              riskScore: rScore,
              category: map['category'] as String? ?? 'App',
              permissions: const [],
              trackersCount: (map['trackersCount'] as num?)?.toInt() ?? 0,
              networkUsage: '12 MB/day',
              threatDescription: desc,
              installDate: DateTime.now(),
            );
          }).toList();

          return ScanResultModel(
            scanTime: scanTime,
            totalAppsScanned: totalAppsScanned,
            safeCount: safeCount,
            mediumCount: mediumCount,
            highCount: highCount,
            criticalCount: criticalCount,
            detectedThreats: parsedThreats,
            securityScore: securityScore,
          );
        }).toList();
      });
    } catch (e) {
      debugPrint('Firestore getScanHistoryStream error: $e');
      return Stream.value([MockData.lastScanResult]);
    }
  }

  /// Logs security auditing actions (e.g. app quarantined, threat uninstalled, scan started)
  Future<void> logSecurityAction({
    required String title,
    required String subtitle,
    required String category,
    String? riskLevel,
  }) async {
    final db = _db;
    if (db == null) return;

    try {
      await db.collection('users').doc(_userId).collection('action_logs').add({
        'title': title,
        'subtitle': subtitle,
        'category': category,
        'riskLevel': riskLevel ?? 'info',
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Firestore logSecurityAction error: $e');
    }
  }

  /// Stream of real-time security action logs
  Stream<List<Map<String, dynamic>>> getActionLogsStream() {
    final db = _db;
    if (db == null) {
      return Stream.value([]);
    }

    try {
      return db
          .collection('users')
          .doc(_userId)
          .collection('action_logs')
          .orderBy('timestamp', descending: true)
          .limit(30)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) => doc.data()).toList();
      });
    } catch (e) {
      debugPrint('Firestore getActionLogsStream error: $e');
      return Stream.value([]);
    }
  }
}
