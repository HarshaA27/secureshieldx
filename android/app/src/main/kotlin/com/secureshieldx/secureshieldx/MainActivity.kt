package com.secureshieldx.secureshieldx

import android.content.pm.ApplicationInfo
import android.content.pm.PackageManager
import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.secureshieldx.app/scanner"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getInstalledApps") {
                Thread {
                    try {
                        val appsList = getNativeInstalledApps()
                        runOnUiThread {
                            result.success(appsList)
                        }
                    } catch (e: Exception) {
                        runOnUiThread {
                            result.error("SCAN_ERROR", e.message, null)
                        }
                    }
                }.start()
            } else {
                result.notImplemented()
            }
        }
    }

    private fun getNativeInstalledApps(): List<Map<String, Any?>> {
        val pm = packageManager
        val flags = PackageManager.GET_PERMISSIONS
        val packages = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            pm.getInstalledPackages(PackageManager.PackageInfoFlags.of(flags.toLong()))
        } else {
            @Suppress("DEPRECATION")
            pm.getInstalledPackages(flags)
        }

        val apps = mutableListOf<Map<String, Any?>>()
        for (pkgInfo in packages) {
            val appInfo = pkgInfo.applicationInfo ?: continue
            val isSystemApp = (appInfo.flags and ApplicationInfo.FLAG_SYSTEM) != 0

            val appName = pm.getApplicationLabel(appInfo).toString()
            val packageName = pkgInfo.packageName
            val versionName = pkgInfo.versionName ?: "1.0.0"
            val requestedPermissions = pkgInfo.requestedPermissions?.toList() ?: emptyList<String>()

            val appData = mapOf(
                "appName" to appName,
                "packageName" to packageName,
                "versionName" to versionName,
                "isSystemApp" to isSystemApp,
                "requestedPermissions" to requestedPermissions,
                "firstInstallTime" to pkgInfo.firstInstallTime,
                "lastUpdateTime" to pkgInfo.lastUpdateTime
            )
            apps.add(appData)
        }
        return apps
    }
}
