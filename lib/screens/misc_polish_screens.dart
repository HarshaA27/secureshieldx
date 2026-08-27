import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/theme/app_colors.dart';
import '../core/widgets/custom_app_bar.dart';
import '../core/widgets/custom_card.dart';
import '../core/widgets/empty_error_widgets.dart';
import '../router/route_paths.dart';

/// Help & Support Hub with Empty State & Error Demonstrations
class HelpSupportScreen extends StatefulWidget {
  final VoidCallback? onToggleTheme;
  final ThemeMode? currentThemeMode;

  const HelpSupportScreen({super.key, this.onToggleTheme, this.currentThemeMode});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  int _activeDemoView = 0; // 0 = FAQ List, 1 = Empty State, 2 = Error State

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Help, FAQ & Support Hub',
        subtitle: '24/7 Security Assistance',
        showBackButton: true,
        onBackPressed: () => context.go(RoutePaths.settings),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mode Selector Bar
            Text(
              'UI View Mode Demonstrator',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ChoiceChip(
                    label: const Text('FAQ Hub View'),
                    selected: _activeDemoView == 0,
                    onSelected: (val) => setState(() => _activeDemoView = 0),
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Empty State Demo'),
                    selected: _activeDemoView == 1,
                    onSelected: (val) => setState(() => _activeDemoView = 1),
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Error State Demo'),
                    selected: _activeDemoView == 2,
                    onSelected: (val) => setState(() => _activeDemoView = 2),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            if (_activeDemoView == 0) ...[
              // Active Help & FAQ List
              CustomCard(
                borderGradient: AppColors.primaryGradient,
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: AppColors.primary,
                      child: Icon(Icons.help_outline_rounded, color: Colors.white),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Emergency Cyber Support Hotline',
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Speak with certified cybersecurity analysts 24/7.',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Text(
                'Frequently Asked Questions',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),

              const SizedBox(height: 12),

              _buildFaqTile(
                context,
                question: 'How does the 2026 AI Heuristic Engine detect spyware?',
                answer: 'SecureShield X analyzes application binaries in real-time, monitoring background SMS receivers, camera access hooks, and outbound IP connections against 14.2M threat signatures.',
              ),
              const SizedBox(height: 10),
              _buildFaqTile(
                context,
                question: 'What happens when an app is quarantined?',
                answer: 'Quarantined applications are placed in an isolated sandbox where background execution, network sockets, and system permissions are revoked.',
              ),
              const SizedBox(height: 10),
              _buildFaqTile(
                context,
                question: 'Are my reported fraud complaints legally binding?',
                answer: 'Yes! Complaints generated in the Cyber Fraud Portal match National Cyber Crime Reporting Portal (NCRP) standards under IT Act Sec 43/66D.',
              ),
            ] else if (_activeDemoView == 1) ...[
              // Reusable Empty State Widget Demonstration
              CustomEmptyStateWidget(
                title: 'No Support Tickets Found',
                description: 'You have not submitted any customer support tickets. Our AI Cyber Assistant is active 24/7 to answer your queries.',
                icon: Icons.mark_chat_read_rounded,
                actionButtonText: 'Ask AI Assistant',
                onActionButtonTap: () => context.go(RoutePaths.aiChat),
              ),
            ] else ...[
              // Reusable Error Widget Demonstration
              CustomErrorWidget(
                errorCode: 'ERR_CLOUD_SYNC_TIMEOUT',
                errorMessage: 'Threat Signature Sync Failed',
                diagnosticText: 'Unable to reach global threat intelligence server (IP 192.168.1.1). Check your Wi-Fi or cellular network connection and try again.',
                onRetryTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Retrying cloud server diagnostic...')),
                  );
                },
              ),
            ],

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqTile(BuildContext context, {required String question, required String answer}) {
    return CustomCard(
      child: ExpansionTile(
        title: Text(
          question,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, fontSize: 13),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              answer,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
