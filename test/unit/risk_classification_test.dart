import 'package:flutter_test/flutter_test.dart';
import 'package:secureshieldx/core/services/app_scanner_service.dart';
import 'package:secureshieldx/core/widgets/risk_badge.dart';

void main() {
  group('Risk Classification Engine Unit Tests', () {
    late AppScannerService scannerService;

    setUp(() {
      scannerService = AppScannerService();
    });

    group('Permission -> Risk Level Mapping', () {
      test('Critical Risk Permissions Map to RiskLevel.critical', () {
        final criticalPermissions = [
          'android.permission.RECEIVE_SMS',
          'android.permission.READ_SMS',
          'android.permission.SEND_SMS',
          'android.permission.BIND_ACCESSIBILITY_SERVICE',
          'android.permission.PROCESS_OUTGOING_CALLS',
        ];

        for (final perm in criticalPermissions) {
          final result = scannerService.evaluatePermissionRisk(perm);
          expect(
            result.riskLevel,
            equals(RiskLevel.critical),
            reason: 'Permission $perm should be classified as Critical risk',
          );
        }
      });

      test('High Risk Permissions Map to RiskLevel.high', () {
        final highPermissions = [
          'android.permission.ACCESS_FINE_LOCATION',
          'android.permission.ACCESS_COARSE_LOCATION',
          'android.permission.CAMERA',
          'android.permission.RECORD_AUDIO',
        ];

        for (final perm in highPermissions) {
          final result = scannerService.evaluatePermissionRisk(perm);
          expect(
            result.riskLevel,
            equals(RiskLevel.high),
            reason: 'Permission $perm should be classified as High risk',
          );
        }
      });

      test('Medium Risk Permissions Map to RiskLevel.medium', () {
        final mediumPermissions = [
          'android.permission.READ_CONTACTS',
          'android.permission.WRITE_EXTERNAL_STORAGE',
          'android.permission.READ_PHONE_STATE',
          'android.permission.GET_ACCOUNTS',
        ];

        for (final perm in mediumPermissions) {
          final result = scannerService.evaluatePermissionRisk(perm);
          expect(
            result.riskLevel,
            equals(RiskLevel.medium),
            reason: 'Permission $perm should be classified as Medium risk',
          );
        }
      });

      test('Safe Permissions Map to RiskLevel.safe', () {
        final safePermissions = [
          'android.permission.INTERNET',
          'android.permission.VIBRATE',
          'android.permission.WAKE_LOCK',
          'android.permission.ACCESS_NETWORK_STATE',
        ];

        for (final perm in safePermissions) {
          final result = scannerService.evaluatePermissionRisk(perm);
          expect(
            result.riskLevel,
            equals(RiskLevel.safe),
            reason: 'Permission $perm should be classified as Safe',
          );
        }
      });
    });

    group('Permission Clean Name Formatting', () {
      test('Cleans package-qualified permission string into human readable name', () {
        final permModel = scannerService.evaluatePermissionRisk('android.permission.RECEIVE_SMS');
        expect(permModel.name, equals('RECEIVE SMS'));
        expect(permModel.id, equals('android.permission.RECEIVE_SMS'));
      });
    });

    group('Scan Installed Apps Fallback and Risk Aggregation', () {
      test('Returns scanned apps list with valid risk scores and categories', () async {
        final apps = await scannerService.scanInstalledApps();
        expect(apps, isNotEmpty);

        for (final app in apps) {
          expect(app.riskScore, greaterThanOrEqualTo(0));
          expect(app.riskScore, lessThanOrEqualTo(100));
          expect(app.permissions, isNotNull);
        }
      });
    });
  });
}
