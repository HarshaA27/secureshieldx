import 'package:flutter/material.dart';
import '../models/app_models.dart';
import '../widgets/risk_badge.dart';
import '../../router/route_paths.dart';

class MockData {
  // Onboarding Slides
  static const List<OnboardingSlideModel> onboardingSlides = [
    OnboardingSlideModel(
      title: 'AI Cyber Threat Shield',
      subtitle: 'Real-Time Malware & Heuristic Protection',
      description:
          'Scan installed apps, APK files, and system processes with 2026 AI heuristic engines to stop spyware, ransomware, and trojans.',
      icon: Icons.shield_rounded,
      highlightTags: ['Real-time Heuristics', 'Zero-Day Shield', 'Instant Quarantine'],
    ),
    OnboardingSlideModel(
      title: 'Privacy & Permission Guard',
      subtitle: 'Audit Microphones, Cameras & Background Data',
      description:
          'Detect silent background eavesdropping, unauthorized camera access, location tracking, and hidden telemetry trackers.',
      icon: Icons.admin_panel_settings_rounded,
      highlightTags: ['Camera Guard', 'Mic Sentinel', 'Tracker Blocker'],
    ),
    OnboardingSlideModel(
      title: 'Cyber Fraud & Scam Shield',
      subtitle: 'Protect Financial Accounts & Report Phishing',
      description:
          'Safeguard your bank accounts, UPI apps, and personal identity. One-tap incident reporting directly to cyber crime authorities.',
      icon: Icons.report_problem_rounded,
      highlightTags: ['Financial Protection', 'Phishing Blocker', 'Fraud Portal'],
    ),
  ];

  // Supported Languages Catalog (Expandable dynamically via generic LLM prompts)
  // Note: Sign Language support (ISL / ASL AI video avatar generation) is a planned future feature.
  static const List<LanguageModel> languages = [
    LanguageModel(code: 'en', name: 'English', nativeName: 'English', flagEmoji: '🇺🇸', isPopular: true),
    LanguageModel(code: 'hi', name: 'Hindi', nativeName: 'हिन्दी', flagEmoji: '🇮🇳', isPopular: true),
    LanguageModel(code: 'te', name: 'Telugu', nativeName: 'తెలుగు', flagEmoji: '🇮🇳', isPopular: true),
    LanguageModel(code: 'ta', name: 'Tamil', nativeName: 'தமிழ்', flagEmoji: '🇮🇳', isPopular: true),
    LanguageModel(code: 'kn', name: 'Kannada', nativeName: 'ಕನ್ನಡ', flagEmoji: '🇮🇳', isPopular: true),
    LanguageModel(code: 'ml', name: 'Malayalam', nativeName: 'മലയാളം', flagEmoji: '🇮🇳', isPopular: true),
    LanguageModel(code: 'bn', name: 'Bengali', nativeName: 'বাংলা', flagEmoji: '🇮🇳', isPopular: true),
    LanguageModel(code: 'mr', name: 'Marathi', nativeName: 'मराठी', flagEmoji: '🇮🇳', isPopular: true),
    LanguageModel(code: 'gu', name: 'Gujarati', nativeName: 'ગુજરાતી', flagEmoji: '🇮🇳', isPopular: true),
    LanguageModel(code: 'pa', name: 'Punjabi', nativeName: 'ਪੰਜਾਬੀ', flagEmoji: '🇮🇳', isPopular: true),
    LanguageModel(code: 'or', name: 'Odia', nativeName: 'ଓଡ଼ିଆ', flagEmoji: '🇮🇳'),
    LanguageModel(code: 'ur', name: 'Urdu', nativeName: 'اردو', flagEmoji: '🇮🇳'),
    LanguageModel(code: 'as', name: 'Assamese', nativeName: 'অসমীয়া', flagEmoji: '🇮🇳'),
    LanguageModel(code: 'pt', name: 'Portuguese', nativeName: 'Português', flagEmoji: '🇵🇹'),
    LanguageModel(code: 'es', name: 'Spanish', nativeName: 'Español', flagEmoji: '🇪🇸'),
    LanguageModel(code: 'fr', name: 'French', nativeName: 'Français', flagEmoji: '🇫🇷'),
  ];


  // Permissions Catalog
  static const AppPermissionModel permCamera = AppPermissionModel(
    id: 'camera',
    name: 'Camera Access',
    description: 'Allows recording video or taking photos in background without notification.',
    riskLevel: RiskLevel.high,
    icon: Icons.camera_alt_rounded,
  );

  static const AppPermissionModel permLocation = AppPermissionModel(
    id: 'location',
    name: 'Background Location',
    description: 'Continuously tracks precise GPS location 24/7.',
    riskLevel: RiskLevel.critical,
    icon: Icons.location_on_rounded,
  );

  static const AppPermissionModel permMicrophone = AppPermissionModel(
    id: 'microphone',
    name: 'Microphone Recording',
    description: 'Can record ambient audio and conversations in real-time.',
    riskLevel: RiskLevel.critical,
    icon: Icons.mic_rounded,
  );

  static const AppPermissionModel permSMS = AppPermissionModel(
    id: 'sms',
    name: 'Read & Send SMS / OTP',
    description: 'Reads incoming banking OTPs and sends background premium SMS.',
    riskLevel: RiskLevel.critical,
    icon: Icons.sms_rounded,
  );

  static const AppPermissionModel permContacts = AppPermissionModel(
    id: 'contacts',
    name: 'Full Contacts Access',
    description: 'Reads all personal address book contacts and phone numbers.',
    riskLevel: RiskLevel.medium,
    icon: Icons.contacts_rounded,
  );

  static const AppPermissionModel permStorage = AppPermissionModel(
    id: 'storage',
    name: 'External File Storage',
    description: 'Reads and writes all photos, documents, and downloads.',
    riskLevel: RiskLevel.medium,
    icon: Icons.folder_shared_rounded,
  );

  static const AppPermissionModel permAccessibility = AppPermissionModel(
    id: 'accessibility',
    name: 'Accessibility Service',
    description: 'Can observe screen text, keystrokes, and simulate tap gestures.',
    riskLevel: RiskLevel.critical,
    icon: Icons.accessibility_new_rounded,
  );

  // Installed Apps Sample List
  static final List<InstalledAppModel> installedApps = [
    InstalledAppModel(
      id: 'app_1',
      name: 'SuperFlashlight Ultra HD',
      packageName: 'com.bright.flashlight.free.ad',
      version: '2.4.1',
      developer: 'Unknown Dev Studio (High Risk)',
      icon: Icons.flash_on_rounded,
      riskLevel: RiskLevel.critical,
      riskScore: 94,
      category: 'Utilities',
      permissions: [permCamera, permLocation, permMicrophone, permSMS, permContacts],
      trackersCount: 14,
      networkUsage: '142 MB/day (Background)',
      threatDescription: 'Stealth Spyware Detected: Sends banking SMS OTPs and background GPS location to unauthorized offshore servers.',
      installDate: DateTime.now().subtract(const Duration(days: 3)),
    ),
    InstalledAppModel(
      id: 'app_2',
      name: 'Fast PDF Reader Pro',
      packageName: 'org.quickpdf.view.reader',
      version: '5.1.0',
      developer: 'Apex Mobile Tech',
      icon: Icons.picture_as_pdf_rounded,
      riskLevel: RiskLevel.high,
      riskScore: 78,
      category: 'Productivity',
      permissions: [permStorage, permLocation, permSMS, permContacts],
      trackersCount: 9,
      networkUsage: '48 MB/day',
      threatDescription: 'Adware & Contact Harvester: Uploads address book contacts without user consent.',
      installDate: DateTime.now().subtract(const Duration(days: 12)),
    ),
    InstalledAppModel(
      id: 'app_3',
      name: 'Speed Cleaner & Ram Booster',
      packageName: 'com.cleaner.booster.junk.remove',
      version: '1.0.8',
      developer: 'CleanMaster Global',
      icon: Icons.cleaning_services_rounded,
      riskLevel: RiskLevel.high,
      riskScore: 72,
      category: 'System Tools',
      permissions: [permAccessibility, permStorage, permLocation],
      trackersCount: 11,
      networkUsage: '95 MB/day',
      threatDescription: 'Abuses Accessibility API to bypass system security dialogs and show full-screen intrusive popup ads.',
      installDate: DateTime.now().subtract(const Duration(days: 7)),
    ),
    InstalledAppModel(
      id: 'app_4',
      name: 'Photo Filter Magic 3D',
      packageName: 'com.filter.photo.effect.magic',
      version: '3.2.0',
      developer: 'PixArt Media',
      icon: Icons.filter_b_and_w_rounded,
      riskLevel: RiskLevel.medium,
      riskScore: 54,
      category: 'Photography',
      permissions: [permCamera, permStorage, permContacts],
      trackersCount: 6,
      networkUsage: '18 MB/day',
      threatDescription: 'Excessive analytics trackers embedded. Requests contact access unnecessary for photo editing.',
      installDate: DateTime.now().subtract(const Duration(days: 20)),
    ),
    InstalledAppModel(
      id: 'app_5',
      name: 'Secure Bank Pay',
      packageName: 'com.nationalbank.mobile.pay',
      version: '8.9.2',
      developer: 'National Financial Corp',
      icon: Icons.account_balance_rounded,
      riskLevel: RiskLevel.safe,
      riskScore: 5,
      category: 'Finance',
      permissions: [permContacts, permSMS],
      trackersCount: 0,
      networkUsage: '2.5 MB/day',
      threatDescription: 'Verified Official Banking App: Fully encrypted with zero analytics telemetry trackers.',
      installDate: DateTime.now().subtract(const Duration(days: 90)),
    ),
    InstalledAppModel(
      id: 'app_6',
      name: 'SecureShield X Mobile',
      packageName: 'com.secureshieldx.antivirus',
      version: '4.2.0',
      developer: 'SecureShield Cyber Security',
      icon: Icons.shield_rounded,
      riskLevel: RiskLevel.safe,
      riskScore: 0,
      category: 'Security',
      permissions: [permStorage],
      trackersCount: 0,
      networkUsage: '1.1 MB/day',
      threatDescription: 'Core System Defense Engine: Real-time protective shield active.',
      installDate: DateTime.now().subtract(const Duration(days: 120)),
    ),
    InstalledAppModel(
      id: 'app_7',
      name: 'Chat Connect Messenger',
      packageName: 'com.chatconnect.social.app',
      version: '12.0.4',
      developer: 'Connect Labs Inc.',
      icon: Icons.chat_rounded,
      riskLevel: RiskLevel.medium,
      riskScore: 42,
      category: 'Communication',
      permissions: [permMicrophone, permCamera, permContacts, permStorage],
      trackersCount: 4,
      networkUsage: '320 MB/day',
      threatDescription: 'Standard social app permissions. Keep background location revoked for optimal privacy.',
      installDate: DateTime.now().subtract(const Duration(days: 45)),
    ),
    InstalledAppModel(
      id: 'app_8',
      name: 'Crypto Vault Wallet',
      packageName: 'io.cryptovault.decentralized',
      version: '2.1.0',
      developer: 'Decentralized Chain Ltd',
      icon: Icons.account_balance_wallet_rounded,
      riskLevel: RiskLevel.safe,
      riskScore: 12,
      category: 'Finance',
      permissions: [permCamera, permStorage],
      trackersCount: 1,
      networkUsage: '12 MB/day',
      threatDescription: 'Cryptographic wallet verified. No suspicious memory hooks or keystroke loggers found.',
      installDate: DateTime.now().subtract(const Duration(days: 30)),
    ),
  ];

  // Latest Scan Summary
  static final ScanResultModel lastScanResult = ScanResultModel(
    scanTime: DateTime.now().subtract(const Duration(hours: 2)),
    totalAppsScanned: 128,
    safeCount: 115,
    mediumCount: 9,
    highCount: 3,
    criticalCount: 1,
    securityScore: 82,
    detectedThreats: [
      installedApps[0], // SuperFlashlight
      installedApps[1], // Fast PDF
      installedApps[2], // Speed Cleaner
    ],
  );

  // AI Threat Explainer Video & Transcript
  static const AiThreatVideoModel sampleThreatVideo = AiThreatVideoModel(
    id: 'vid_001',
    title: 'SuperFlashlight Ultra HD: Banking SMS Spyware Analysis',
    appName: 'SuperFlashlight Ultra HD',
    duration: '03:45',
    quality: '1080p AI Video',
    summary:
        'SecureShield AI Heuristic Engine detected stealth background SMS reading in package com.bright.flashlight.free.ad. The app intercepts 6-digit banking OTPs and transmits encrypted HTTP POST requests to unauthorized remote IP 192.168.1.102.',
    transcript: [
      TranscriptSegmentModel(
        timestamp: '00:05',
        speaker: 'AI Security Voice',
        text: 'Welcome to the SecureShield X AI Threat Breakdown for SuperFlashlight Ultra HD.',
      ),
      TranscriptSegmentModel(
        timestamp: '00:20',
        speaker: 'AI Security Voice',
        text: 'Upon analysis of the application binary, our 2026 heuristic engine detected permission request android.permission.RECEIVE_SMS.',
        isHighlight: true,
      ),
      TranscriptSegmentModel(
        timestamp: '00:45',
        speaker: 'AI Security Voice',
        text: 'The app registers a stealth BroadcastReceiver that triggers whenever a banking OTP SMS arrives from major national banks.',
        isHighlight: true,
      ),
      TranscriptSegmentModel(
        timestamp: '01:15',
        speaker: 'AI Security Voice',
        text: 'Captured OTP codes are encrypted using AES-128 and transmitted to an offshore server without user knowledge.',
      ),
      TranscriptSegmentModel(
        timestamp: '02:05',
        speaker: 'AI Security Voice',
        text: 'Recommended Action: Immediately revoke SMS & Location permissions and execute one-tap uninstallation.',
        isHighlight: true,
      ),
    ],
    remediationSteps: [
      'Revoke READ_SMS and RECEIVE_SMS permissions in System Settings.',
      'Force stop background process com.bright.flashlight.free.ad.',
      'Uninstall SuperFlashlight Ultra HD from package manager.',
      'Change banking passwords and verify recent UPI transactions.',
    ],
  );

  // Evidence Upload Samples
  static final List<EvidenceFileModel> sampleEvidenceFiles = [
    EvidenceFileModel(
      id: 'ev_1',
      fileName: 'phishing_sms_screenshot.png',
      fileSize: '2.4 MB',
      fileType: EvidenceFileType.screenshot,
      aiExtractedMetadata: 'Extracted URL: hxxp://bank-otp-verify-secure.com & Sender ID: AD-NATBANK',
      uploadTime: DateTime.now().subtract(const Duration(minutes: 40)),
    ),
    EvidenceFileModel(
      id: 'ev_2',
      fileName: 'unauthorized_upi_receipt.pdf',
      fileSize: '512 KB',
      fileType: EvidenceFileType.documentPdf,
      aiExtractedMetadata: 'Extracted Transaction ID: TXN984210492 • Amount: ₹25,000 • Payee: fakebank@ybl',
      uploadTime: DateTime.now().subtract(const Duration(minutes: 35)),
    ),
    EvidenceFileModel(
      id: 'ev_3',
      fileName: 'scammer_call_record.mp3',
      fileSize: '1.8 MB',
      fileType: EvidenceFileType.callLog,
      aiExtractedMetadata: 'Extracted Scammer Phone: +91 98123 45678 • Caller Identity Spoof Detected',
      uploadTime: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
  ];

  // Historical Security Score Trend Points (7 Days)
  static const List<Map<String, dynamic>> historicalScoreTrend = [
    {'day': 'Mon', 'score': 95.0, 'date': 'Aug 11'},
    {'day': 'Tue', 'score': 92.0, 'date': 'Aug 12'},
    {'day': 'Wed', 'score': 72.0, 'date': 'Aug 13'}, // Threat detected
    {'day': 'Thu', 'score': 80.0, 'date': 'Aug 14'},
    {'day': 'Fri', 'score': 88.0, 'date': 'Aug 15'},
    {'day': 'Sat', 'score': 94.0, 'date': 'Aug 16'},
    {'day': 'Sun', 'score': 98.0, 'date': 'Aug 17'},
  ];

  // Sample Notifications Feed Data
  static final List<Map<String, dynamic>> notificationsFeed = [
    {
      'id': 'notif_1',
      'title': 'Critical Malware Threat Flagged',
      'body': 'SuperFlashlight Ultra HD was detected attempting stealth SMS forwarding.',
      'time': '10m ago',
      'isRead': false,
      'riskLevel': RiskLevel.critical,
      'icon': Icons.security_rounded,
      'category': 'Malware Alert',
    },
    {
      'id': 'notif_2',
      'title': 'Silent Microphone Access Blocked',
      'body': 'Prevented unauthorized background audio recording by Fast PDF Reader.',
      'time': '2h ago',
      'isRead': false,
      'riskLevel': RiskLevel.high,
      'icon': Icons.mic_off_rounded,
      'category': 'Permission Sentinel',
    },
    {
      'id': 'notif_3',
      'title': 'Virus Database Updated (v4.2.8)',
      'body': '14,200 zero-day malware signatures downloaded from SecureShield Cloud.',
      'time': '5h ago',
      'isRead': true,
      'riskLevel': RiskLevel.safe,
      'icon': Icons.system_update_rounded,
      'category': 'Cloud Intelligence',
    },
    {
      'id': 'notif_4',
      'title': 'Automated Scheduled Scan Complete',
      'body': 'Scanned 128 apps. 115 safe, 9 medium, 4 requiring security audit.',
      'time': '1d ago',
      'isRead': true,
      'riskLevel': RiskLevel.medium,
      'icon': Icons.fact_check_rounded,
      'category': 'Scheduled Audit',
    },
  ];

  // Cyber Fraud Reports History
  static final List<FraudReportModel> fraudReportsHistory = [
    FraudReportModel(
      id: 'rep_101',
      referenceNumber: 'CRN-2026-9842019',
      title: 'Phishing SMS & Unauthorized UPI Debit Scam',
      category: 'Financial Cyber Fraud',
      lossAmount: '₹25,000 INR',
      scammerIdentifier: 'fakebank@ybl (+91 98123 45678)',
      incidentSummary:
          'Received SMS mimicking official bank warning. Tapped link and entered OTP, resulting in unauthorized UPI debit of ₹25,000 to fakebank@ybl.',
      associatedAppName: 'SuperFlashlight Ultra HD (com.bright.flashlight.free.ad)',

      aiGeneratedComplaintBody: '''TO THE OFFICER IN CHARGE,
NATIONAL CYBER CRIME REPORTING PORTAL (NCRP) / CYBER CRIME CELL

SUBJECT: FORMAL COMPLAINT REGARDING UNAUTHORIZED FINANCIAL FRAUD VIA PHISHING SMS (AMOUNT: ₹25,000)

Respected Sir/Madam,

I am submitting this formal complaint regarding a cyber financial crime executed on ${DateTime.now().day}/${DateTime.now().month}/2026. 

INCIDENT SUMMARY:
1. Offender Contact: Phone +91 98123 45678 / SMS ID AD-NATBANK.
2. Malicious URL: hxxp://bank-otp-verify-secure.com.
3. Financial Impact: Unauthorized transfer of ₹25,000 INR to UPI VPA fakebank@ybl.
4. Transaction Reference ID: TXN984210492.

EVIDENCE ATTACHED:
- Digital evidence vault items EV-1 (SMS Screenshot), EV-2 (Bank Receipt), EV-3 (Call Audio Log).

I request immediate freezing of beneficiary VPA fakebank@ybl under Sec 43/66D IT Act 2000 and registration of FIR.

Yours faithfully,
Verified SecureShield X User''',
      status: FraudStatus.underInvestigation,
      dateReported: DateTime.now().subtract(const Duration(days: 1)),
      attachedEvidence: sampleEvidenceFiles,
    ),
    FraudReportModel(
      id: 'rep_102',
      referenceNumber: 'CRN-2026-7731902',
      title: 'Fake Job Offer & Telegram Investment Scheme',
      category: 'Online Investment Scam',
      lossAmount: '₹12,500 INR',
      scammerIdentifier: '@task_manager_crypto (Telegram)',
      incidentSummary: 'Promised daily returns for rating Google maps locations. Demanded deposit before releasing earnings.',
      aiGeneratedComplaintBody: 'Formal legal complaint drafted for investment scam...',
      status: FraudStatus.resolved,
      dateReported: DateTime.now().subtract(const Duration(days: 14)),
      attachedEvidence: [],
    ),
  ];

  // Initial Sample Chat Stream
  static final List<ChatMessageModel> sampleChatMessages = [
    ChatMessageModel(
      id: 'msg_1',
      sender: ChatSender.ai,
      text: 'Hello! I am your SecureShield AI Cyber Assistant (v4.2). I am constantly monitoring your device for malware, permission leaks, and financial scams. How can I assist you today?',
      timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
      suggestedFollowUps: [
        '🔍 Is SuperFlashlight Ultra HD safe?',
        '🔋 Why is my battery draining fast?',
        '💳 How to report phishing SMS?',
        '🛡️ Audit my overall device privacy score',
      ],
    ),
    ChatMessageModel(
      id: 'msg_2',
      sender: ChatSender.user,
      text: 'Is SuperFlashlight Ultra HD safe to keep installed?',
      timestamp: DateTime.now().subtract(const Duration(minutes: 8)),
    ),
    ChatMessageModel(
      id: 'msg_3',
      sender: ChatSender.ai,
      text: '⚠️ **CRITICAL THREAT DETECTED**\n\nSuperFlashlight Ultra HD (`com.bright.flashlight.free.ad`) contains stealth spyware. Our 2026 heuristic engine detected background SMS interception (`RECEIVE_SMS`) and encrypted data transmission to unauthorized offshore servers.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 7)),
      riskLevel: RiskLevel.critical,
      actionLabel: 'Inspect & Uninstall Threat',
      actionRoute: RoutePaths.appDetails,
      suggestedFollowUps: [
        'How to revoke SMS permissions?',
        'Watch AI Threat Video Explainer',
        'Check if my bank OTP was exposed',
      ],
    ),
  ];

  // Past Conversation Sessions
  static final List<ChatSessionModel> sampleChatSessions = [
    ChatSessionModel(
      id: 'sess_1',
      title: 'SuperFlashlight Ultra HD Spyware Audit',
      lastMessageTime: DateTime.now().subtract(const Duration(hours: 2)),
      messageCount: 6,
      lastMessagePreview: 'Inspect & Uninstall SuperFlashlight Ultra HD',
    ),
    ChatSessionModel(
      id: 'sess_2',
      title: 'Banking App & Camera Permission Audit',
      lastMessageTime: DateTime.now().subtract(const Duration(days: 1)),
      messageCount: 12,
      lastMessagePreview: 'Verified official bank app cryptographic signature.',
    ),
    ChatSessionModel(
      id: 'sess_3',
      title: 'Phishing SMS & Fake UPI Link Verification',
      lastMessageTime: DateTime.now().subtract(const Duration(days: 3)),
      messageCount: 4,
      lastMessagePreview: 'Generated formal cyber complaint draft CRN-2026-9842019.',
    ),
  ];
}
