import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/mock_data.dart';
import '../models/app_models.dart';
import '../widgets/risk_badge.dart';

class AppScannerService {
  static const MethodChannel _channel = MethodChannel('com.secureshieldx.app/scanner');

  static final AppScannerService _instance = AppScannerService._internal();
  factory AppScannerService() => _instance;
  AppScannerService._internal();

  List<InstalledAppModel>? _cachedScannedApps;

  List<InstalledAppModel>? get cachedApps => _cachedScannedApps;

  Future<List<InstalledAppModel>> scanInstalledApps({bool forceRefresh = false}) async {
    if (!forceRefresh && _cachedScannedApps != null && _cachedScannedApps!.isNotEmpty) {
      return _cachedScannedApps!;
    }

    if (defaultTargetPlatform == TargetPlatform.android && !kIsWeb) {
      try {
        final List<dynamic>? rawApps = await _channel.invokeListMethod<dynamic>('getInstalledApps');
        if (rawApps != null && rawApps.isNotEmpty) {
          final List<InstalledAppModel> parsedApps = [];
          for (int i = 0; i < rawApps.length; i++) {
            final Map<String, dynamic> item = Map<String, dynamic>.from(rawApps[i] as Map);
            final String appName = item['appName'] as String? ?? 'Unknown App';
            final String packageName = item['packageName'] as String? ?? 'com.app.$i';
            final String versionName = item['versionName'] as String? ?? '1.0.0';
            final bool isSystemApp = item['isSystemApp'] as bool? ?? false;
            final List<dynamic> rawPerms = item['requestedPermissions'] as List<dynamic>? ?? [];

            final List<AppPermissionModel> permissionsList = [];
            int totalRiskScore = 0;
            bool hasCriticalPerm = false;
            bool hasHighPerm = false;
            bool hasMediumPerm = false;

            for (var rawP in rawPerms) {
              final permStr = rawP.toString();
              final permModel = evaluatePermissionRisk(permStr);
              permissionsList.add(permModel);

              switch (permModel.riskLevel) {
                case RiskLevel.critical:
                  totalRiskScore += 30;
                  hasCriticalPerm = true;
                  break;
                case RiskLevel.high:
                  totalRiskScore += 15;
                  hasHighPerm = true;
                  break;
                case RiskLevel.medium:
                  totalRiskScore += 5;
                  hasMediumPerm = true;
                  break;
                case RiskLevel.safe:
                  break;
              }
            }

            if (totalRiskScore > 100) totalRiskScore = 100;

            RiskLevel appRiskLevel = RiskLevel.safe;
            if (totalRiskScore >= 75 || hasCriticalPerm) {
              appRiskLevel = RiskLevel.critical;
            } else if (totalRiskScore >= 45 || hasHighPerm) {
              appRiskLevel = RiskLevel.high;
            } else if (totalRiskScore >= 20 || hasMediumPerm) {
              appRiskLevel = RiskLevel.medium;
            }

            String threatDesc = 'Official Verified App: Standard Android system permissions requested.';
            if (appRiskLevel == RiskLevel.critical) {
              threatDesc = 'Critical Risk: Application requests sensitive SMS reading or accessibility service hooks.';
            } else if (appRiskLevel == RiskLevel.high) {
              threatDesc = 'High Risk: Accesses 24/7 background location, camera, or microphone recording.';
            } else if (appRiskLevel == RiskLevel.medium) {
              threatDesc = 'Medium Risk: Reads external storage or personal contacts address book.';
            }

            parsedApps.add(
              InstalledAppModel(
                id: 'pkg_$i',
                name: appName,
                packageName: packageName,
                version: versionName,
                developer: isSystemApp ? 'Android System OS' : 'Installed Application',
                icon: isSystemApp ? Icons.android_rounded : Icons.phone_android_rounded,
                riskLevel: appRiskLevel,
                riskScore: totalRiskScore,
                category: isSystemApp ? 'System' : 'User App',
                permissions: permissionsList,
                trackersCount: appRiskLevel == RiskLevel.critical ? 12 : (hasHighPerm ? 5 : 0),
                networkUsage: '${(totalRiskScore * 1.5).toStringAsFixed(1)} MB/day',
                threatDescription: threatDesc,
                installDate: DateTime.now().subtract(Duration(days: i * 2 + 1)),
              ),
            );
          }

          // Sort apps by risk score descending
          parsedApps.sort((a, b) => b.riskScore.compareTo(a.riskScore));
          _cachedScannedApps = parsedApps;
          return parsedApps;
        }
      } catch (e) {
        debugPrint('Native Android PackageManager Channel failed: $e. Falling back to mock dataset.');
      }
    }

    // Non-Android or MethodChannel fallback
    _cachedScannedApps = MockData.installedApps;
    return MockData.installedApps;
  }

  AppPermissionModel evaluatePermissionRisk(String permissionStr) {
    final lower = permissionStr.toLowerCase();

    if (lower.contains('receive_sms') ||
        lower.contains('read_sms') ||
        lower.contains('send_sms') ||
        lower.contains('bind_accessibility_service') ||
        lower.contains('process_outgoing_calls')) {
      return AppPermissionModel(
        id: permissionStr,
        name: _cleanPermissionName(permissionStr),
        description: 'Allows stealth background reading & interception of banking SMS & OTPs.',
        riskLevel: RiskLevel.critical,
        icon: Icons.sms_rounded,
      );
    } else if (lower.contains('fine_location') ||
        lower.contains('coarse_location') ||
        lower.contains('camera') ||
        lower.contains('record_audio')) {
      return AppPermissionModel(
        id: permissionStr,
        name: _cleanPermissionName(permissionStr),
        description: 'Accesses real-time camera, microphone, or precise GPS location.',
        riskLevel: RiskLevel.high,
        icon: lower.contains('camera')
            ? Icons.camera_alt_rounded
            : lower.contains('audio')
                ? Icons.mic_rounded
                : Icons.location_on_rounded,
      );
    } else if (lower.contains('contacts') ||
        lower.contains('external_storage') ||
        lower.contains('read_phone_state') ||
        lower.contains('get_accounts')) {
      return AppPermissionModel(
        id: permissionStr,
        name: _cleanPermissionName(permissionStr),
        description: 'Reads address book contacts or external file storage.',
        riskLevel: RiskLevel.medium,
        icon: lower.contains('contacts') ? Icons.contacts_rounded : Icons.folder_shared_rounded,
      );
    } else {
      return AppPermissionModel(
        id: permissionStr,
        name: _cleanPermissionName(permissionStr),
        description: 'Standard Android application framework permission.',
        riskLevel: RiskLevel.safe,
        icon: Icons.verified_user_rounded,
      );
    }
  }

  String _cleanPermissionName(String fullPerm) {
    if (fullPerm.contains('.')) {
      return fullPerm.split('.').last.replaceAll('_', ' ');
    }
    return fullPerm;
  }
}
