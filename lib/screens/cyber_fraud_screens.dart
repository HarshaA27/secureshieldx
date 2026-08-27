import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../core/data/mock_data.dart';
import '../core/models/app_models.dart';
import '../core/theme/app_colors.dart';
import '../core/widgets/custom_app_bar.dart';
import '../core/widgets/custom_button.dart';
import '../core/widgets/custom_card.dart';
import '../core/config/env_config.dart';
import '../core/services/llm_risk_explanation_service.dart';
import '../router/route_paths.dart';




/// Active Fraud Report In-Memory State Store
class ActiveFraudReportStore {
  static String selectedCategory = 'Financial Cyber Fraud';
  static String lossAmount = '25,000';
  static String scammerIdentifier = 'fakebank@ybl (+91 98123 45678)';
  static String summary = 'Received SMS claiming bank account freeze. Clicked link and entered OTP, resulting in unauthorized debit of ₹25,000 to fakebank@ybl.';
  static String reportedAppName = 'SuperFlashlight Ultra HD (com.bright.flashlight.free.ad)';
  static List<EvidenceFileModel> attachedFiles = List.from(MockData.sampleEvidenceFiles);
}

/// 4. Report Fraud Portal Screen
class FraudReportingPortalScreen extends StatefulWidget {
  final VoidCallback? onToggleTheme;
  final ThemeMode? currentThemeMode;

  const FraudReportingPortalScreen({super.key, this.onToggleTheme, this.currentThemeMode});

  @override
  State<FraudReportingPortalScreen> createState() => _FraudReportingPortalScreenState();
}

class _FraudReportingPortalScreenState extends State<FraudReportingPortalScreen> {
  String _selectedCategory = ActiveFraudReportStore.selectedCategory;
  String _selectedApp = ActiveFraudReportStore.reportedAppName;
  late final TextEditingController _amountController;
  late final TextEditingController _scammerController;
  late final TextEditingController _summaryController;

  final List<String> _installedAppOptions = [
    'SuperFlashlight Ultra HD (com.bright.flashlight.free.ad)',
    'Fast PDF Reader Pro (org.quickpdf.view.reader)',
    'Speed Cleaner & Ram Booster (com.cleaner.booster.junk.remove)',
    'Photo Filter Magic 3D (com.filter.photo.effect.magic)',
    'Other / Web Link / Phishing SMS',
  ];

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(text: ActiveFraudReportStore.lossAmount);
    _scammerController = TextEditingController(text: ActiveFraudReportStore.scammerIdentifier);
    _summaryController = TextEditingController(text: ActiveFraudReportStore.summary);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _scammerController.dispose();
    _summaryController.dispose();
    super.dispose();
  }

  void _saveInputs() {
    ActiveFraudReportStore.selectedCategory = _selectedCategory;
    ActiveFraudReportStore.lossAmount = _amountController.text;
    ActiveFraudReportStore.scammerIdentifier = _scammerController.text;
    ActiveFraudReportStore.summary = _summaryController.text;
    ActiveFraudReportStore.reportedAppName = _selectedApp;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Report Cyber Fraud',
        subtitle: 'Official Authority Direct Filing Portal',
        showBackButton: false,
        actions: [
          IconButton(
            onPressed: () => context.go(RoutePaths.fraudReportStatus),
            icon: const Icon(Icons.history_rounded),
            tooltip: 'Complaint Status',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Authority Banner
            CustomCard(
              borderGradient: AppColors.criticalGradient,
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: AppColors.riskCriticalBgLight,
                    child: Icon(Icons.report_problem_rounded, color: AppColors.riskCritical),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'National Cyber Cell Direct Filing',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.riskCritical,
                              ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'AI generator formats legal complaints matching NCRP standards under Sec 43/66D IT Act.',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Category Selector
            Text(
              'Select Fraud Category',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildCategoryChip('Financial Cyber Fraud', Icons.account_balance_rounded),
                  const SizedBox(width: 8),
                  _buildCategoryChip('Phishing & SMS Scam', Icons.sms_rounded),
                  const SizedBox(width: 8),
                  _buildCategoryChip('Identity Theft', Icons.badge_rounded),
                  const SizedBox(width: 8),
                  _buildCategoryChip('Investment Fraud', Icons.trending_down_rounded),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Incident Details Form
            Text(
              'Incident Details',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),

            // App Being Reported Selector
            CustomCard(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('App Involved in Scam (Optional):', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _installedAppOptions.contains(_selectedApp) ? _selectedApp : _installedAppOptions[0],
                      isExpanded: true,
                      items: _installedAppOptions.map((appName) {
                        return DropdownMenuItem<String>(
                          value: appName,
                          child: Text(appName, style: const TextStyle(fontSize: 12)),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedApp = val);
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Amount Lost Input
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Financial Loss Amount (₹ INR)',
                prefixIcon: const Icon(Icons.currency_rupee_rounded, color: AppColors.primary),
                filled: true,
                fillColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),

            // Scammer Identifier Input
            TextField(
              controller: _scammerController,
              decoration: InputDecoration(
                labelText: 'Scammer UPI VPA / Phone / URL / Email',
                prefixIcon: const Icon(Icons.person_off_rounded, color: AppColors.primary),
                filled: true,
                fillColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),

            // Description Input
            TextField(
              controller: _summaryController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Brief Description of Incident',
                prefixIcon: const Icon(Icons.notes_rounded, color: AppColors.primary),
                filled: true,
                fillColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),

            const SizedBox(height: 28),

            CustomButton(
              text: 'Upload Evidence Files →',
              variant: CustomButtonVariant.primary,
              icon: const Icon(Icons.file_upload_rounded),
              onPressed: () {
                _saveInputs();
                context.go(RoutePaths.evidenceVault);
              },
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }


  Widget _buildCategoryChip(String label, IconData icon) {
    final isSelected = _selectedCategory == label;
    return ChoiceChip(
      avatar: Icon(icon, size: 16, color: isSelected ? AppColors.primary : Colors.grey),
      label: Text(label),
      selected: isSelected,
      onSelected: (val) {
        if (val) setState(() => _selectedCategory = label);
      },
    );
  }
}

/// 5. Digital Evidence Vault Screen (Upload Evidence)
class EvidenceVaultScreen extends StatefulWidget {
  final VoidCallback? onToggleTheme;
  final ThemeMode? currentThemeMode;

  const EvidenceVaultScreen({super.key, this.onToggleTheme, this.currentThemeMode});

  @override
  State<EvidenceVaultScreen> createState() => _EvidenceVaultScreenState();
}

class _EvidenceVaultScreenState extends State<EvidenceVaultScreen> {
  final List<EvidenceFileModel> _attachedFiles = List.from(MockData.sampleEvidenceFiles);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Digital Evidence Vault',
        subtitle: 'Attach Screenshots, Logs & Receipts',
        showBackButton: true,
        onBackPressed: () => context.go(RoutePaths.fraudReporting),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Upload Drag-and-Drop Card
            CustomCard(
              padding: const EdgeInsets.all(24),
              borderGradient: AppColors.primaryGradient,
              child: Center(
                child: Column(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary.withAlpha(30),
                      ),
                      child: const Icon(Icons.cloud_upload_rounded, color: AppColors.primary, size: 32),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Tap to Upload Screenshots & Files',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Supports PNG, JPG, PDF, MP3 call recordings (Max 25 MB)',
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    CustomButton(
                      text: 'Add Evidence File',
                      variant: CustomButtonVariant.outline,
                      isFullWidth: false,
                      icon: const Icon(Icons.add_photo_alternate_rounded, size: 18),
                      onPressed: () {
                        setState(() {
                          _attachedFiles.add(
                            EvidenceFileModel(
                              id: 'ev_${_attachedFiles.length + 1}',
                              fileName: 'chat_screenshot_${_attachedFiles.length + 1}.png',
                              fileSize: '1.2 MB',
                              fileType: EvidenceFileType.screenshot,
                              aiExtractedMetadata: 'Extracted Chat Text & Timestamp',
                              uploadTime: DateTime.now(),
                            ),
                          );
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('File attached to Evidence Vault!')),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Attached Files Counter
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Attached Evidence Items (${_attachedFiles.length})',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Text(
                  'AI Metadata OCR Active',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.secondary),
                ),
              ],
            ),

            const SizedBox(height: 12),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _attachedFiles.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final file = _attachedFiles[index];
                IconData icon;
                switch (file.fileType) {
                  case EvidenceFileType.screenshot:
                    icon = Icons.image_rounded;
                    break;
                  case EvidenceFileType.documentPdf:
                    icon = Icons.picture_as_pdf_rounded;
                    break;
                  case EvidenceFileType.callLog:
                    icon = Icons.audiotrack_rounded;
                    break;
                }

                return CustomCard(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primary.withAlpha(30),
                            ),
                            child: Icon(icon, color: AppColors.primary, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  file.fileName,
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${file.fileSize} • Uploaded just now',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 11),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline_rounded, color: AppColors.riskCritical),
                            onPressed: () {
                              setState(() => _attachedFiles.removeAt(index));
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.black26 : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.auto_awesome_rounded, size: 14, color: AppColors.secondary),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                file.aiExtractedMetadata,
                                style: const TextStyle(fontSize: 11, fontFamily: 'monospace'),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 28),

            CustomButton(
              text: 'Review AI-Drafted Complaint →',
              variant: CustomButtonVariant.primary,
              icon: const Icon(Icons.description_rounded),
              onPressed: () => context.go(RoutePaths.phishingReport),
            ),
          ],
        ),
      ),
    );
  }
}

/// 6. AI-Drafted Complaint Review Screen (Phishing & Financial Fraud)
class PhishingReportScreen extends StatefulWidget {
  final VoidCallback? onToggleTheme;
  final ThemeMode? currentThemeMode;

  const PhishingReportScreen({super.key, this.onToggleTheme, this.currentThemeMode});

  @override
  State<PhishingReportScreen> createState() => _PhishingReportScreenState();
}

class _PhishingReportScreenState extends State<PhishingReportScreen> {
  final FraudReportModel _report = MockData.fraudReportsHistory[0];
  late TextEditingController _complaintTextController;
  LanguageModel _selectedLanguage = MockData.languages[0]; // English by default
  bool _isGenerating = false;
  FraudComplaintResult? _llmComplaintResult;

  @override
  void initState() {
    super.initState();
    _complaintTextController = TextEditingController(text: _report.aiGeneratedComplaintBody);
    _generateLlmComplaint();
  }

  @override
  void dispose() {
    _complaintTextController.dispose();
    super.dispose();
  }

  Future<void> _generateLlmComplaint() async {
    setState(() => _isGenerating = true);

    final result = await LlmRiskExplanationService().generateFraudComplaint(
      category: ActiveFraudReportStore.selectedCategory,
      lossAmount: ActiveFraudReportStore.lossAmount,
      scammerIdentifier: ActiveFraudReportStore.scammerIdentifier,
      description: ActiveFraudReportStore.summary,
      languageCode: _selectedLanguage.code,
      languageName: _selectedLanguage.name,
      associatedAppName: ActiveFraudReportStore.reportedAppName,
      evidenceFiles: ActiveFraudReportStore.attachedFiles.map((e) => e.fileName).toList(),
    );

    if (!mounted) return;

    setState(() {
      _llmComplaintResult = result;
      _complaintTextController.text = result.complaintBody;
      _isGenerating = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isLiveLlm = _llmComplaintResult?.isLiveLlmGenerated ?? false;
    final modelName = _llmComplaintResult?.modelUsed ?? 'Local Engine';

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Review AI Formal Complaint',
        subtitle: 'NCR Standards • Multi-Lingual Legal Draft',
        showBackButton: true,
        onBackPressed: () => context.go(RoutePaths.evidenceVault),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Hero Card with Live Status Badge
            CustomCard(
              borderGradient: isLiveLlm ? AppColors.primaryGradient : null,
              child: Column(
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: AppColors.riskSafeBgLight,
                        child: Icon(Icons.verified_rounded, color: AppColors.riskSafe),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Formally Formatted Cyber Complaint',
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Formatted matching National Cyber Crime Reporting Portal (NCRP) & IT Act Sec 43/66D standards.',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            isLiveLlm ? Icons.bolt_rounded : Icons.shield_rounded,
                            size: 14,
                            color: isLiveLlm ? AppColors.primary : Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            isLiveLlm ? 'Live LLM ($modelName • ${EnvConfig.keySource})' : 'Local Template Mode',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: isLiveLlm ? AppColors.primary : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'Language: ${_selectedLanguage.name} (${_selectedLanguage.flagEmoji})',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.secondary),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Incident Inputs Summary Card
            CustomCard(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Incident Context Fed to LLM Generator:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary)),
                  const SizedBox(height: 6),
                  Text('• Category: ${ActiveFraudReportStore.selectedCategory}', style: const TextStyle(fontSize: 11)),
                  Text('• Reported App: ${ActiveFraudReportStore.reportedAppName}', style: const TextStyle(fontSize: 11)),
                  Text('• Financial Loss: ₹${ActiveFraudReportStore.lossAmount} | Suspect: ${ActiveFraudReportStore.scammerIdentifier}', style: const TextStyle(fontSize: 11)),
                  Text('• Incident Description: "${ActiveFraudReportStore.summary}"', style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic)),
                  Text('• Evidence Attached: ${ActiveFraudReportStore.attachedFiles.length} Files', style: const TextStyle(fontSize: 11)),
                ],
              ),
            ),

            const SizedBox(height: 16),


            // API Key Status Banner if not using live LLM
            if (!EnvConfig.hasApiKey)
              Container(
                margin: const EdgeInsets.only(bottom: 4),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withAlpha(20),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.secondary.withAlpha(60)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline_rounded, color: AppColors.secondary, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'To enable live multi-lingual LLM complaint drafting, set LLM_API_KEY in .env or build with --dart-define=LLM_API_KEY=your_key.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 11),
                      ),
                    ),
                  ],
                ),
              ),


            const SizedBox(height: 20),

            // Language Selector Bar
            CustomCard(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                children: [
                  const Icon(Icons.language_rounded, color: AppColors.primary, size: 20),
                  const SizedBox(width: 10),
                  const Text(
                    'Draft Language:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<LanguageModel>(
                        value: _selectedLanguage,
                        isExpanded: true,
                        items: MockData.languages.map((lang) {
                          return DropdownMenuItem<LanguageModel>(
                            value: lang,
                            child: Text(
                              '${lang.flagEmoji} ${lang.name} (${lang.nativeName})',
                              style: const TextStyle(fontSize: 12),
                            ),
                          );
                        }).toList(),
                        onChanged: (lang) {
                          if (lang != null && lang != _selectedLanguage) {
                            setState(() => _selectedLanguage = lang);
                            _generateLlmComplaint();
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Legal Complaint Body (Editable)',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy_rounded, size: 18, color: AppColors.primary),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: _complaintTextController.text));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Copied complaint draft to clipboard!')),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Complaint Draft Box with Loading Overlay
            if (_isGenerating)
              Container(
                height: 280,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primary.withAlpha(80)),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      Text(
                        'Drafting formal legal complaint in ${_selectedLanguage.name} (${_selectedLanguage.nativeName}) using LLM API...',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )
            else
              TextField(
                controller: _complaintTextController,
                maxLines: 15,
                style: const TextStyle(fontFamily: 'monospace', fontSize: 12, height: 1.4),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: _isGenerating ? 'Generating...' : 'Re-Draft with AI',
                    variant: CustomButtonVariant.outline,
                    icon: const Icon(Icons.auto_awesome_rounded, size: 18),
                    onPressed: _isGenerating ? null : () => _generateLlmComplaint(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomButton(
                    text: 'Sign & Submit →',
                    variant: CustomButtonVariant.primary,
                    icon: const Icon(Icons.send_rounded, size: 18),
                    onPressed: () => context.go(RoutePaths.fraudReportStatus),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}


/// 7. Submit to Authority & Status Tracking Screen
class FraudReportStatusScreen extends StatelessWidget {
  final VoidCallback? onToggleTheme;
  final ThemeMode? currentThemeMode;

  const FraudReportStatusScreen({super.key, this.onToggleTheme, this.currentThemeMode});

  @override
  Widget build(BuildContext context) {
    final report = MockData.fraudReportsHistory[0];

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Complaint Tracking & Status',
        subtitle: report.referenceNumber,
        showBackButton: true,
        onBackPressed: () => context.go(RoutePaths.fraudReporting),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Success Header Banner
            CustomCard(
              borderGradient: AppColors.safeGradient,
              child: Column(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColors.safeGradient,
                    ),
                    child: const Icon(Icons.check_circle_rounded, color: Colors.white, size: 40),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Complaint Submitted Successfully!',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.riskSafe,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Case Reference Ticket ID: ${report.referenceNumber}',
                    style: const TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withAlpha(30),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Status: Under Active Investigation by Cyber Cell',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.secondary),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Incident Stepper Tracker
            Text(
              'Incident Resolution Timeline',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),

            const SizedBox(height: 12),

            CustomCard(
              child: Column(
                children: [
                  _buildStepRow(context, '1. Complaint Formatted & Signed', 'Completed by SecureShield AI', true),
                  const Divider(height: 20),
                  _buildStepRow(context, '2. Dispatched to National Cyber Cell (NCRP)', 'Ref #${report.referenceNumber}', true),
                  const Divider(height: 20),
                  _buildStepRow(context, '3. Assigned to Cyber Police Inspector', 'Inspector A. Sharma assigned', true),
                  const Divider(height: 20),
                  _buildStepRow(context, '4. Beneficiary Bank VPA Freeze Notice', 'Notice sent to payee bank under Sec 43', false),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'Download PDF',
                    variant: CustomButtonVariant.outline,
                    icon: const Icon(Icons.picture_as_pdf_rounded, size: 18),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Exported official PDF complaint!')),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomButton(
                    text: 'Back to Home',
                    variant: CustomButtonVariant.primary,
                    icon: const Icon(Icons.home_rounded, size: 18),
                    onPressed: () => context.go(RoutePaths.home),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildStepRow(BuildContext context, String title, String subtitle, bool isDone) {
    return Row(
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: isDone ? AppColors.riskSafe : Colors.grey.shade400,
          child: Icon(
            isDone ? Icons.check_rounded : Icons.hourglass_top_rounded,
            size: 16,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
              ),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 11),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class FinancialFraudReportScreen extends StatelessWidget {
  final VoidCallback? onToggleTheme;
  final ThemeMode? currentThemeMode;

  const FinancialFraudReportScreen({super.key, this.onToggleTheme, this.currentThemeMode});

  @override
  Widget build(BuildContext context) {
    return PhishingReportScreen(
      onToggleTheme: onToggleTheme,
      currentThemeMode: currentThemeMode,
    );
  }
}
