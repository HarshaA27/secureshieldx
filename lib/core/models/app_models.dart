import 'package:flutter/material.dart';
import '../widgets/risk_badge.dart';

class AppPermissionModel {
  final String id;
  final String name;
  final String description;
  final RiskLevel riskLevel;
  final IconData icon;
  final bool isGranted;

  const AppPermissionModel({
    required this.id,
    required this.name,
    required this.description,
    required this.riskLevel,
    required this.icon,
    this.isGranted = true,
  });
}

class InstalledAppModel {
  final String id;
  final String name;
  final String packageName;
  final String version;
  final String developer;
  final IconData icon;
  final RiskLevel riskLevel;
  final int riskScore; // 0 (Safe) to 100 (Critical)
  final String category;
  final List<AppPermissionModel> permissions;
  final int trackersCount;
  final String networkUsage;
  final String threatDescription;
  final bool isQuarantined;
  final DateTime installDate;

  const InstalledAppModel({
    required this.id,
    required this.name,
    required this.packageName,
    required this.version,
    required this.developer,
    required this.icon,
    required this.riskLevel,
    required this.riskScore,
    required this.category,
    required this.permissions,
    required this.trackersCount,
    required this.networkUsage,
    required this.threatDescription,
    this.isQuarantined = false,
    required this.installDate,
  });
}

class ScanResultModel {
  final DateTime scanTime;
  final int totalAppsScanned;
  final int safeCount;
  final int mediumCount;
  final int highCount;
  final int criticalCount;
  final List<InstalledAppModel> detectedThreats;
  final int securityScore; // 0-100

  const ScanResultModel({
    required this.scanTime,
    required this.totalAppsScanned,
    required this.safeCount,
    required this.mediumCount,
    required this.highCount,
    required this.criticalCount,
    required this.detectedThreats,
    required this.securityScore,
  });
}

class LanguageModel {
  final String code;
  final String name;
  final String nativeName;
  final String flagEmoji;
  final bool isPopular;

  const LanguageModel({
    required this.code,
    required this.name,
    required this.nativeName,
    required this.flagEmoji,
    this.isPopular = false,
  });
}

class OnboardingSlideModel {
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final List<String> highlightTags;

  const OnboardingSlideModel({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.highlightTags,
  });
}

class TranscriptSegmentModel {
  final String timestamp; // e.g. "00:15"
  final String speaker;
  final String text;
  final bool isHighlight;

  const TranscriptSegmentModel({
    required this.timestamp,
    required this.speaker,
    required this.text,
    this.isHighlight = false,
  });
}

class AiThreatVideoModel {
  final String id;
  final String title;
  final String appName;
  final String duration;
  final String quality;
  final String summary;
  final List<TranscriptSegmentModel> transcript;
  final List<String> remediationSteps;

  const AiThreatVideoModel({
    required this.id,
    required this.title,
    required this.appName,
    required this.duration,
    required this.quality,
    required this.summary,
    required this.transcript,
    required this.remediationSteps,
  });
}

enum EvidenceFileType { screenshot, documentPdf, callLog }

class EvidenceFileModel {
  final String id;
  final String fileName;
  final String fileSize;
  final EvidenceFileType fileType;
  final String aiExtractedMetadata;
  final DateTime uploadTime;

  const EvidenceFileModel({
    required this.id,
    required this.fileName,
    required this.fileSize,
    required this.fileType,
    required this.aiExtractedMetadata,
    required this.uploadTime,
  });
}

enum FraudStatus { submitted, dispatched, underInvestigation, resolved }

class FraudReportModel {
  final String id;
  final String referenceNumber; // e.g. CRN-2026-9842019
  final String title;
  final String category;
  final String lossAmount;
  final String scammerIdentifier;
  final String incidentSummary;
  final String? associatedAppName;
  final String aiGeneratedComplaintBody;
  final FraudStatus status;
  final DateTime dateReported;
  final List<EvidenceFileModel> attachedEvidence;

  const FraudReportModel({
    required this.id,
    required this.referenceNumber,
    required this.title,
    required this.category,
    required this.lossAmount,
    required this.scammerIdentifier,
    required this.incidentSummary,
    this.associatedAppName,
    required this.aiGeneratedComplaintBody,
    required this.status,
    required this.dateReported,
    required this.attachedEvidence,
  });
}

enum ChatSender { user, ai }

class ChatMessageModel {
  final String id;
  final ChatSender sender;
  final String text;
  final DateTime timestamp;
  final RiskLevel? riskLevel;
  final String? actionLabel;
  final String? actionRoute;
  final List<String>? suggestedFollowUps;

  const ChatMessageModel({
    required this.id,
    required this.sender,
    required this.text,
    required this.timestamp,
    this.riskLevel,
    this.actionLabel,
    this.actionRoute,
    this.suggestedFollowUps,
  });
}

class ChatSessionModel {
  final String id;
  final String title;
  final DateTime lastMessageTime;
  final int messageCount;
  final String lastMessagePreview;

  const ChatSessionModel({
    required this.id,
    required this.title,
    required this.lastMessageTime,
    required this.messageCount,
    required this.lastMessagePreview,
  });
}
