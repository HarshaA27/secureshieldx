import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/data/mock_data.dart';
import '../core/models/app_models.dart';
import '../core/theme/app_colors.dart';
import '../core/widgets/custom_app_bar.dart';
import '../core/widgets/custom_button.dart';
import '../core/widgets/custom_card.dart';
import '../core/widgets/risk_badge.dart';
import '../router/route_paths.dart';

/// 1. AI Chat & Voice Interface Screen
class AiChatScreen extends StatefulWidget {
  final VoidCallback? onToggleTheme;
  final ThemeMode? currentThemeMode;

  const AiChatScreen({super.key, this.onToggleTheme, this.currentThemeMode});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final List<ChatMessageModel> _messages = List.from(MockData.sampleChatMessages);
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;

  final List<String> _suggestedPrompts = [
    '🔍 Is SuperFlashlight Ultra HD safe?',
    '🔋 Why is my battery draining fast?',
    '💳 How to report phishing SMS?',
    '🛡️ Audit my overall device privacy score',
    '⚠️ Explain CVE-2026-9042 vulnerability',
  ];

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleSendMessage(String text) {
    if (text.trim().isEmpty) return;

    final userMsg = ChatMessageModel(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      sender: ChatSender.user,
      text: text.trim(),
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(userMsg);
      _inputController.clear();
      _isTyping = true;
    });

    _scrollToBottom();

    // Simulate AI response
    Timer(const Duration(seconds: 1), () {
      if (!mounted) return;
      ChatMessageModel aiMsg;

      if (text.toLowerCase().contains('battery')) {
        aiMsg = ChatMessageModel(
          id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
          sender: ChatSender.ai,
          text: '🔋 **BATTERY DRAIN ANALYSIS**\n\nHigh battery consumption is driven by 2 apps executing background network sockets:\n\n1. **Speed Cleaner & Ram Booster** (95 MB/day)\n2. **Fast PDF Reader Pro** (48 MB/day)\n\nRecommended: Revoke background execution permissions.',
          timestamp: DateTime.now(),
          riskLevel: RiskLevel.medium,
          actionLabel: 'Open Permission Manager',
          actionRoute: RoutePaths.permissionManager,
        );
      } else if (text.toLowerCase().contains('phishing') || text.toLowerCase().contains('sms')) {
        aiMsg = ChatMessageModel(
          id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
          sender: ChatSender.ai,
          text: '💳 **PHISHING & SCAM SHIELD**\n\nTo report a suspicious banking SMS or unauthorized UPI debit, use our National Cyber Crime direct filing portal. SecureShield AI will format your legal complaint under Sec 43/66D IT Act.',
          timestamp: DateTime.now(),
          riskLevel: RiskLevel.high,
          actionLabel: 'Report Fraud Now',
          actionRoute: RoutePaths.fraudReporting,
        );
      } else {
        aiMsg = ChatMessageModel(
          id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
          sender: ChatSender.ai,
          text: '🛡️ **SECURESHIELD AI AUDIT COMPLETE**\n\nAnalyzed device status for "$text". Your current Device Health Score is **82/100**. All real-time heuristic shields are active.',
          timestamp: DateTime.now(),
          riskLevel: RiskLevel.safe,
          suggestedFollowUps: [
            'Inspect high-risk permissions',
            'Run full system scan',
            'Export weekly audit report',
          ],
        );
      }

      setState(() {
        _isTyping = false;
        _messages.add(aiMsg);
      });

      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'AI Cyber Assistant',
        subtitle: 'SecureShield AI v4.2 Active',
        showBackButton: false,
        actions: [
          IconButton(
            onPressed: () => context.go(RoutePaths.aiVoiceCommand),
            icon: const Icon(Icons.mic_rounded, color: AppColors.secondary),
            tooltip: 'Voice Command Hub',
          ),
          IconButton(
            onPressed: () => context.go(RoutePaths.aiPrivacyAdvisor),
            icon: const Icon(Icons.history_rounded),
            tooltip: 'Conversation History',
          ),
        ],
      ),
      body: Column(
        children: [
          // Suggested Prompts Carousel
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            color: isDark ? AppColors.darkSurface.withAlpha(120) : AppColors.lightSurfaceVariant,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: _suggestedPrompts.map((prompt) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ActionChip(
                      avatar: const Icon(Icons.auto_awesome_rounded, size: 14, color: AppColors.primary),
                      label: Text(prompt, style: const TextStyle(fontSize: 12)),
                      backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
                      side: BorderSide(
                        color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                      ),
                      onPressed: () => _handleSendMessage(prompt.substring(2).trim()),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Messages List Stream
          Expanded(
            child: ListView.separated(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isTyping) {
                  return _buildTypingIndicator(context);
                }
                final msg = _messages[index];
                return _buildMessageBubble(context, msg);
              },
            ),
          ),

          // Bottom Input Bar
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              border: Border(
                top: BorderSide(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => context.go(RoutePaths.aiVoiceCommand),
                  icon: const Icon(Icons.mic_rounded, color: AppColors.secondary),
                  tooltip: 'Voice Input',
                ),
                Expanded(
                  child: TextField(
                    controller: _inputController,
                    onSubmitted: _handleSendMessage,
                    decoration: InputDecoration(
                      hintText: 'Ask SecureShield AI about threats, scams...',
                      border: InputBorder.none,
                      hintStyle: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppColors.primaryGradient,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                    onPressed: () => _handleSendMessage(_inputController.text),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(BuildContext context, ChatMessageModel msg) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isUser = msg.sender == ChatSender.user;

    if (isUser) {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(4),
            ),
          ),
          child: Text(
            msg.text,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ),
      );
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.85),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
            bottomLeft: Radius.circular(4),
          ),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 12,
                  backgroundColor: AppColors.primary,
                  child: Icon(Icons.auto_awesome_rounded, size: 14, color: Colors.white),
                ),
                const SizedBox(width: 8),
                const Text(
                  'SecureShield AI',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primary),
                ),
                const Spacer(),
                if (msg.riskLevel != null) RiskBadge(level: msg.riskLevel!, size: RiskBadgeSize.small),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              msg.text,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (msg.actionLabel != null && msg.actionRoute != null) ...[
              const SizedBox(height: 12),
              CustomButton(
                text: msg.actionLabel!,
                variant: CustomButtonVariant.primary,
                isFullWidth: false,
                icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                onPressed: () => context.go(msg.actionRoute!),
              ),
            ],
            if (msg.suggestedFollowUps != null && msg.suggestedFollowUps!.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Divider(height: 12),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: msg.suggestedFollowUps!.map((f) {
                  return InkWell(
                    onTap: () => _handleSendMessage(f),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withAlpha(25),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '💡 $f',
                        style: const TextStyle(fontSize: 11, color: AppColors.secondary, fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTypingIndicator(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.primary.withAlpha(20),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)),
            ),
            SizedBox(width: 10),
            Text('SecureShield AI is analyzing...', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary)),
          ],
        ),
      ),
    );
  }
}

/// 2. AI Voice Command Hub Screen
class AiVoiceCommandScreen extends StatefulWidget {
  final VoidCallback? onToggleTheme;
  final ThemeMode? currentThemeMode;

  const AiVoiceCommandScreen({super.key, this.onToggleTheme, this.currentThemeMode});

  @override
  State<AiVoiceCommandScreen> createState() => _AiVoiceCommandScreenState();
}

class _AiVoiceCommandScreenState extends State<AiVoiceCommandScreen> with SingleTickerProviderStateMixin {
  late AnimationController _waveController;
  final bool _isListening = true;
  String _transcriptText = '"Scan all installed apps for hidden spyware and check camera permissions."';

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'AI Voice Command Hub',
        subtitle: 'Hands-Free Security Queries',
        showBackButton: true,
        onBackPressed: () => context.go(RoutePaths.aiChat),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Spacer(),

            // Speech Wave Circle Visualizer
            ScaleTransition(
              scale: Tween<double>(begin: 0.9, end: 1.1).animate(_waveController),
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.primaryGradient,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.secondary.withAlpha(100),
                      blurRadius: 36,
                      spreadRadius: 8,
                    ),
                  ],
                ),
                child: Icon(
                  _isListening ? Icons.mic_rounded : Icons.mic_off_rounded,
                  size: 80,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 36),

            Text(
              _isListening ? 'Listening to your voice...' : 'Voice Query Received',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),

            // Live Speech Transcript Box
            CustomCard(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  _transcriptText,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w600,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            const SizedBox(height: 28),

            // Preset Command Shortcuts
            Text(
              'Try Speaking These Voice Commands:',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                _buildVoiceChip('🎙️ "Scan installed apps"'),
                _buildVoiceChip('🎙️ "Is SuperFlashlight safe?"'),
                _buildVoiceChip('🎙️ "Report phishing SMS"'),
                _buildVoiceChip('🎙️ "Turn on real-time shield"'),
              ],
            ),

            const Spacer(),

            CustomButton(
              text: 'Process Voice Command →',
              variant: CustomButtonVariant.primary,
              icon: const Icon(Icons.send_rounded),
              onPressed: () => context.go(RoutePaths.aiChat),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVoiceChip(String label) {
    return ActionChip(
      label: Text(label, style: const TextStyle(fontSize: 12)),
      onPressed: () {
        setState(() => _transcriptText = '"$label"');
      },
    );
  }
}

/// 3. Conversation History & Privacy Advisor Screen
class AiPrivacyAdvisorScreen extends StatelessWidget {
  final VoidCallback? onToggleTheme;
  final ThemeMode? currentThemeMode;

  const AiPrivacyAdvisorScreen({super.key, this.onToggleTheme, this.currentThemeMode});

  @override
  Widget build(BuildContext context) {
    final sessions = MockData.sampleChatSessions;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Conversation History & Advisor',
        subtitle: 'Past AI Chat Sessions & Privacy Scorecard',
        showBackButton: true,
        onBackPressed: () => context.go(RoutePaths.aiChat),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // AI Privacy Scorecard Header
            CustomCard(
              borderGradient: AppColors.primaryGradient,
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColors.primaryGradient,
                    ),
                    child: const Center(
                      child: Text(
                        '88',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Personal AI Privacy Rating',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '2 recommendations pending: Revoke 3 background location apps.',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Past Conversation Sessions (${sessions.length})',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                TextButton(
                  onPressed: () => context.go(RoutePaths.aiChat),
                  child: const Text('+ New Chat'),
                ),
              ],
            ),

            const SizedBox(height: 12),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: sessions.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final session = sessions[index];
                return CustomCard(
                  child: InkWell(
                    onTap: () => context.go(RoutePaths.aiChat),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          backgroundColor: AppColors.primary,
                          child: Icon(Icons.chat_bubble_outline_rounded, color: Colors.white, size: 20),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                session.title,
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${session.messageCount} messages • ${session.lastMessagePreview}',
                                style: Theme.of(context).textTheme.bodySmall,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right_rounded, color: AppColors.primary),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

/// AI Threat Explainer & Video Player Screen
class AiThreatExplainerScreen extends StatefulWidget {
  final VoidCallback? onToggleTheme;
  final ThemeMode? currentThemeMode;

  const AiThreatExplainerScreen({super.key, this.onToggleTheme, this.currentThemeMode});

  @override
  State<AiThreatExplainerScreen> createState() => _AiThreatExplainerScreenState();
}

class _AiThreatExplainerScreenState extends State<AiThreatExplainerScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isPlaying = true;
  double _videoProgress = 0.45;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final video = MockData.sampleThreatVideo;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'AI Threat Explainer',
        subtitle: video.appName,
        showBackButton: true,
        onBackPressed: () => context.go(RoutePaths.aiChat),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomCard(
              padding: EdgeInsets.zero,
              borderGradient: AppColors.primaryGradient,
              child: Column(
                children: [
                  Container(
                    height: 210,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 68,
                                height: 68,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.primary.withAlpha(180),
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    _isPlaying
                                        ? Icons.pause_circle_filled_rounded
                                        : Icons.play_circle_fill_rounded,
                                    size: 44,
                                    color: Colors.white,
                                  ),
                                  onPressed: () => setState(() => _isPlaying = !_isPlaying),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.graphic_eq_rounded, color: AppColors.secondary, size: 18),
                                  const SizedBox(width: 6),
                                  Text(
                                    _isPlaying ? 'AI Voice Audio Playing...' : 'Playback Paused',
                                    style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Column(
                      children: [
                        Slider(
                          value: _videoProgress,
                          onChanged: (val) => setState(() => _videoProgress = val),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('01:42', style: TextStyle(fontFamily: 'monospace', fontSize: 11)),
                            Text(video.title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                            Text(video.duration, style: const TextStyle(fontFamily: 'monospace', fontSize: 11)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: 'View Step-by-Step Fixes →',
              variant: CustomButtonVariant.primary,
              icon: const Icon(Icons.build_circle_rounded),
              onPressed: () => context.go(RoutePaths.aiFixRecommendations),
            ),
          ],
        ),
      ),
    );
  }
}

/// How to Fix Screen (Step-by-Step Remediation)
class AiFixRecommendationsScreen extends StatefulWidget {
  final VoidCallback? onToggleTheme;
  final ThemeMode? currentThemeMode;

  const AiFixRecommendationsScreen({super.key, this.onToggleTheme, this.currentThemeMode});

  @override
  State<AiFixRecommendationsScreen> createState() => _AiFixRecommendationsScreenState();
}

class _AiFixRecommendationsScreenState extends State<AiFixRecommendationsScreen> {
  final List<bool> _stepCompleted = [true, false, false, false];

  @override
  Widget build(BuildContext context) {
    final video = MockData.sampleThreatVideo;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Interactive Remediation',
        subtitle: 'Fix Threat: ${video.appName}',
        showBackButton: true,
        onBackPressed: () => context.go(RoutePaths.aiThreatExplainer),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomCard(
              borderGradient: AppColors.primaryGradient,
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: AppColors.primary,
                    child: Icon(Icons.build_circle_rounded, color: Colors.white),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AI-Assisted 4-Step Remediation',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Follow step-by-step actions or trigger automated AI resolution script.',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Execute One-Tap Automated AI Fix-All',
              variant: CustomButtonVariant.primary,
              icon: const Icon(Icons.auto_fix_high_rounded),
              onPressed: () {
                setState(() {
                  for (int i = 0; i < _stepCompleted.length; i++) {
                    _stepCompleted[i] = true;
                  }
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Automated AI Fix Script Executed Successfully!')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// AI Avatar Customization & Voice Settings Screen (#26)
class AiAvatarCustomizationScreen extends StatefulWidget {
  final VoidCallback? onToggleTheme;
  final ThemeMode? currentThemeMode;

  const AiAvatarCustomizationScreen({super.key, this.onToggleTheme, this.currentThemeMode});

  @override
  State<AiAvatarCustomizationScreen> createState() => _AiAvatarCustomizationScreenState();
}

class _AiAvatarCustomizationScreenState extends State<AiAvatarCustomizationScreen> {
  String _selectedPersonality = 'Cyber Guardian';
  String _selectedVoice = 'Female (En-US Neural)';
  bool _isPlayingAudio = false;

  final List<Map<String, dynamic>> _personalities = [
    {
      'name': 'Cyber Guardian',
      'role': 'Proactive Defense Specialist',
      'icon': Icons.shield_rounded,
      'color': AppColors.primary,
    },
    {
      'name': 'Security Analyst',
      'role': 'Technical CVE & Code Auditor',
      'icon': Icons.analytics_rounded,
      'color': AppColors.secondary,
    },
    {
      'name': 'Friendly Assistant',
      'role': 'Plain Language Cyber Guide',
      'icon': Icons.face_rounded,
      'color': AppColors.riskSafe,
    },
    {
      'name': 'Stealth AI',
      'role': 'Zero-Logs Privacy Specialist',
      'icon': Icons.security_rounded,
      'color': AppColors.riskCritical,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'AI Avatar & Voice Customization',
        subtitle: 'Personality • TTS Accents • Speech Visualizer',
        showBackButton: true,
        onBackPressed: () => context.go(RoutePaths.aiChat),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Preview Card
            CustomCard(
              borderGradient: AppColors.primaryGradient,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 44,
                    backgroundColor: AppColors.primary.withAlpha(40),
                    child: const Icon(Icons.auto_awesome_rounded, size: 52, color: AppColors.primary),
                  ),
                  const SizedBox(height: 12),
                  Text(_selectedPersonality, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text('Voice: $_selectedVoice', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 16),
                  CustomButton(
                    text: _isPlayingAudio ? 'Playing Sample Voice...' : 'Test Speech Sample 🔊',
                    variant: CustomButtonVariant.outline,
                    onPressed: () {
                      setState(() => _isPlayingAudio = true);
                      Future.delayed(const Duration(seconds: 2), () {
                        if (mounted) setState(() => _isPlayingAudio = false);
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text('Select AI Personality:', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Column(
              children: _personalities.map((p) {
                final isSelected = p['name'] == _selectedPersonality;
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: CustomCard(
                    borderGradient: isSelected ? AppColors.primaryGradient : null,
                    padding: const EdgeInsets.all(12),
                    child: ListTile(
                      leading: Icon(p['icon'] as IconData, color: p['color'] as Color),
                      title: Text(p['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      subtitle: Text(p['role'] as String, style: const TextStyle(fontSize: 11)),
                      trailing: isSelected ? const Icon(Icons.check_circle_rounded, color: AppColors.primary) : null,
                      onTap: () => setState(() => _selectedPersonality = p['name'] as String),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

