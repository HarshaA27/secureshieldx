import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/data/mock_data.dart';
import '../core/services/auth_service.dart';
import '../core/theme/app_colors.dart';
import '../core/widgets/custom_app_bar.dart';
import '../core/widgets/custom_button.dart';
import '../core/widgets/custom_card.dart';
import '../router/route_paths.dart';

/// 1. Splash Screen
class SplashScreen extends StatefulWidget {
  final VoidCallback? onToggleTheme;
  final ThemeMode? currentThemeMode;

  const SplashScreen({super.key, this.onToggleTheme, this.currentThemeMode});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;
  double _progress = 0.1;
  String _statusMessage = 'Initializing SecureShield AI Engine v4.2...';

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _startLoadingSequence();
  }

  void _startLoadingSequence() {
    Timer(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() {
          _progress = 0.4;
          _statusMessage = 'Loading virus signature database (14.2M hashes)...';
        });
      }
    });
    Timer(const Duration(milliseconds: 1400), () {
      if (mounted) {
        setState(() {
          _progress = 0.8;
          _statusMessage = 'Verifying real-time permission guard & OS integrity...';
        });
      }
    });
    Timer(const Duration(milliseconds: 2200), () {
      if (mounted) {
        setState(() {
          _progress = 1.0;
          _statusMessage = 'Shield Active & Ready!';
        });
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            children: [
              // Top Bar with Theme Toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (widget.onToggleTheme != null)
                    IconButton(
                      onPressed: widget.onToggleTheme,
                      icon: Icon(
                        isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                        color: isDark ? AppColors.secondary : AppColors.primary,
                      ),
                    ),
                ],
              ),
              const Spacer(),

              // Animated Shield Logo
              ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppColors.primaryGradient,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withAlpha(100),
                        blurRadius: 36,
                        spreadRadius: 8,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.shield_rounded,
                    size: 64,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Title
              Text(
                'SECURESHIELD X',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2.0,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                '2026 AI-Powered Mobile Security Suite',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
              ),

              const Spacer(),

              // Initialization Progress Card
              CustomCard(
                child: Column(
                  children: [
                    Row(
                      children: [
                        const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _statusMessage,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                        Text(
                          '${(_progress * 100).toInt()}%',
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.bold,
                            color: AppColors.secondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: _progress,
                        minHeight: 6,
                        backgroundColor: isDark ? Colors.white10 : Colors.black12,
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.secondary),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Primary Actions
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'Interactive Onboarding',
                      variant: CustomButtonVariant.outline,
                      onPressed: () => context.go(RoutePaths.onboarding),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomButton(
                      text: 'Launch Shield',
                      variant: CustomButtonVariant.primary,
                      icon: const Icon(Icons.bolt_rounded),
                      onPressed: () => context.go(RoutePaths.home),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  final VoidCallback? onToggleTheme;
  final ThemeMode? currentThemeMode;

  const WelcomeScreen({super.key, this.onToggleTheme, this.currentThemeMode});

  @override
  Widget build(BuildContext context) {
    return OnboardingScreen(
      onToggleTheme: onToggleTheme,
      currentThemeMode: currentThemeMode,
    );
  }
}

/// 2. Onboarding Slides Screen
class OnboardingScreen extends StatefulWidget {
  final VoidCallback? onToggleTheme;
  final ThemeMode? currentThemeMode;

  const OnboardingScreen({super.key, this.onToggleTheme, this.currentThemeMode});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final slides = MockData.onboardingSlides;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Welcome to SecureShield',
        subtitle: 'Step ${_currentPage + 1} of ${slides.length}',
        showBackButton: false,
        actions: [
          TextButton(
            onPressed: () => context.go(RoutePaths.login),
            child: const Text('Skip', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: slides.length,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemBuilder: (context, index) {
                  final slide = slides[index];
                  return Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Hero Icon Circle
                        Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: AppColors.primaryGradient,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withAlpha(80),
                                blurRadius: 30,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                          child: Icon(slide.icon, size: 72, color: Colors.white),
                        ),
                        const SizedBox(height: 36),

                        // Title & Subtitle
                        Text(
                          slide.title,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          slide.subtitle,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                color: AppColors.secondary,
                                fontWeight: FontWeight.w600,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),

                        // Description
                        Text(
                          slide.description,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                              ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 28),

                        // Tags
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          alignment: WrapAlignment.center,
                          children: slide.highlightTags.map((tag) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withAlpha(25),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: AppColors.primary.withAlpha(60)),
                              ),
                              child: Text(
                                tag,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Page Indicator Dots & Controls
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(slides.length, (index) {
                      final isActive = index == _currentPage;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 8,
                        width: isActive ? 24 : 8,
                        decoration: BoxDecoration(
                          color: isActive ? AppColors.primary : Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      if (_currentPage > 0)
                        Expanded(
                          child: CustomButton(
                            text: 'Previous',
                            variant: CustomButtonVariant.outline,
                            onPressed: () {
                              _pageController.previousPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                          ),
                        ),
                      if (_currentPage > 0) const SizedBox(width: 12),
                      Expanded(
                        child: CustomButton(
                          text: _currentPage == slides.length - 1 ? 'Get Started' : 'Next Step',
                          variant: CustomButtonVariant.primary,
                          onPressed: () {
                            if (_currentPage < slides.length - 1) {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            } else {
                              context.go(RoutePaths.login);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 4. Phone Entry Screen (Login)
class LoginScreen extends StatefulWidget {
  final VoidCallback? onToggleTheme;
  final ThemeMode? currentThemeMode;

  const LoginScreen({super.key, this.onToggleTheme, this.currentThemeMode});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController(text: '9876543210');
  String _selectedCountryCode = '+91';
  bool _isSubmitting = false;

  void _sendOtp() async {
    final rawPhone = _phoneController.text.trim().replaceAll(RegExp(r'\s+'), '');
    if (rawPhone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid mobile number.')),
      );
      return;
    }

    final fullPhone = '$_selectedCountryCode$rawPhone';
    setState(() => _isSubmitting = true);

    await AuthService().verifyPhoneNumber(
      phoneNumber: fullPhone,
      onCodeSent: (String verificationId, int? resendToken) {
        if (!mounted) return;
        setState(() => _isSubmitting = false);
        context.go(
          RoutePaths.register,
          extra: {
            'phoneNumber': fullPhone,
            'verificationId': verificationId,
          },
        );
      },
      onCodeAutoRetrievalTimeout: (String verificationId) {
        debugPrint('Auto retrieval timeout: $verificationId');
      },
      onVerificationFailed: (exception) {
        if (!mounted) return;
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Verification Failed: ${exception.message}')),
        );
      },
      onVerificationCompleted: (credential) {
        if (!mounted) return;
        context.go(RoutePaths.home);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Sign In / Account Setup',
        subtitle: 'Secure Phone Verification',
        showBackButton: true,
        onBackPressed: () => context.go(RoutePaths.onboarding),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Shield Banner
            CustomCard(
              borderGradient: AppColors.primaryGradient,
              child: Row(
                children: [
                  const Icon(Icons.verified_user_rounded, color: AppColors.secondary, size: 36),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Encrypted Identity Verification',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Zero spam • End-to-end 256-bit encrypted authentication token.',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            Text(
              'Enter Your Mobile Number',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'We will send a 6-digit security code to confirm your phone.',
              style: Theme.of(context).textTheme.bodySmall,
            ),

            const SizedBox(height: 20),

            // Country Code & Phone Input
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedCountryCode,
                      items: const [
                        DropdownMenuItem(value: '+91', child: Text('🇮🇳 +91')),
                        DropdownMenuItem(value: '+1', child: Text('🇺🇸 +1')),
                        DropdownMenuItem(value: '+44', child: Text('🇬🇧 +44')),
                      ],
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedCountryCode = val);
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: 'Enter 10-digit number',
                      prefixIcon: const Icon(Icons.phone_android_rounded, color: AppColors.primary),
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
                ),
              ],
            ),

            const SizedBox(height: 28),

            // Submit Button
            CustomButton(
              text: _isSubmitting ? 'Sending OTP SMS...' : 'Send Verification Code (OTP)',
              variant: CustomButtonVariant.primary,
              icon: _isSubmitting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.arrow_forward_rounded),
              onPressed: _isSubmitting ? () {} : _sendOtp,
            ),

            const SizedBox(height: 20),

            // Alternative Biometrics Entry
            Center(
              child: TextButton.icon(
                onPressed: () => context.go(RoutePaths.authPinBiometrics),
                icon: const Icon(Icons.fingerprint_rounded, color: AppColors.secondary),
                label: const Text(
                  'Unlock with Biometrics / FaceID',
                  style: TextStyle(color: AppColors.secondary, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 5. OTP Verification Screen (Register/Auth)
class RegisterScreen extends StatefulWidget {
  final VoidCallback? onToggleTheme;
  final ThemeMode? currentThemeMode;
  final Map<String, String>? authData;

  const RegisterScreen({
    super.key,
    this.onToggleTheme,
    this.currentThemeMode,
    this.authData,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final List<TextEditingController> _otpControllers =
      List.generate(6, (_) => TextEditingController());
  int _secondsRemaining = 45;
  Timer? _timer;
  bool _isVerifying = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _secondsRemaining = 45;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        _timer?.cancel();
      }
    });
  }

  void _verifyOtp() async {
    final code = _otpControllers.map((c) => c.text).join();
    if (code.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter full 6-digit OTP code.')),
      );
      return;
    }

    setState(() => _isVerifying = true);
    final verId = widget.authData?['verificationId'] ?? 'dummy_ver_id_12345';

    try {
      await AuthService().signInWithOtp(verificationId: verId, smsCode: code);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Phone number verified! Protection activated.')),
      );
      context.go(RoutePaths.home);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isVerifying = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Verification Failed: $e')),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var c in _otpControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final displayPhone = widget.authData?['phoneNumber'] ?? '+91 98765 43210';

    return Scaffold(
      appBar: CustomAppBar(
        title: 'OTP Verification',
        subtitle: 'Enter 6-Digit Security Code',
        showBackButton: true,
        onBackPressed: () => context.go(RoutePaths.login),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text(
              'Code sent to $displayPhone',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              'Check your SMS messages and enter the verification pin.',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            // 6 OTP Box Inputs
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (index) {
                return SizedBox(
                  width: 44,
                  height: 54,
                  child: TextField(
                    controller: _otpControllers[index],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    onChanged: (val) {
                      if (val.isNotEmpty && index < 5) {
                        FocusScope.of(context).nextFocus();
                      }
                    },
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                    decoration: InputDecoration(
                      counterText: '',
                      filled: true,
                      fillColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.primary, width: 2),
                      ),
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 28),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.timer_outlined, size: 16, color: Colors.grey),
                const SizedBox(width: 6),
                Text(
                  _secondsRemaining > 0
                      ? 'Resend OTP in 0:${_secondsRemaining.toString().padLeft(2, '0')}'
                      : 'Didn\'t receive code?',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                if (_secondsRemaining == 0)
                  TextButton(
                    onPressed: () {
                      _startTimer();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Resent verification OTP SMS.')),
                      );
                    },
                    child: const Text('Resend Now'),
                  ),
              ],
            ),

            const SizedBox(height: 32),

            CustomButton(
              text: _isVerifying ? 'Verifying OTP...' : 'Verify & Activate Protection',
              variant: CustomButtonVariant.primary,
              icon: _isVerifying
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.verified_rounded),
              onPressed: _isVerifying ? () {} : _verifyOtp,
            ),
          ],
        ),
      ),
    );
  }
}


/// 6. Auth PIN & Biometrics Screen
class AuthPinBiometricsScreen extends StatelessWidget {
  final VoidCallback? onToggleTheme;
  final ThemeMode? currentThemeMode;

  const AuthPinBiometricsScreen({super.key, this.onToggleTheme, this.currentThemeMode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Biometric Shield Unlock',
        subtitle: 'Touch Sensor or Enter Security PIN',
        showBackButton: true,
        onBackPressed: () => context.go(RoutePaths.login),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondary.withAlpha(30),
                border: Border.all(color: AppColors.secondary, width: 2),
              ),
              child: const Icon(Icons.fingerprint_rounded, size: 60, color: AppColors.secondary),
            ),
            const SizedBox(height: 24),
            Text(
              'Biometric Authentication',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Scan your registered fingerprint or FaceID to access administrative controls.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 36),
            CustomButton(
              text: 'Authenticate with Fingerprint',
              variant: CustomButtonVariant.primary,
              icon: const Icon(Icons.fingerprint_rounded),
              onPressed: () => context.go(RoutePaths.home),
            ),
            const SizedBox(height: 12),
            CustomButton(
              text: 'Use Account Password Instead',
              variant: CustomButtonVariant.outline,
              onPressed: () => context.go(RoutePaths.login),
            ),
          ],
        ),
      ),
    );
  }
}

class ForgotPasswordScreen extends StatelessWidget {
  final VoidCallback? onToggleTheme;
  final ThemeMode? currentThemeMode;

  const ForgotPasswordScreen({super.key, this.onToggleTheme, this.currentThemeMode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Reset Security PIN',
        showBackButton: true,
        onBackPressed: () => context.go(RoutePaths.login),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Reset Instructions', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              'Enter your registered email address to receive a secure password reset token.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 24),
            const TextField(
              decoration: InputDecoration(
                hintText: 'user@secureshield.com',
                prefixIcon: Icon(Icons.email_rounded),
              ),
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Send Reset Email',
              variant: CustomButtonVariant.primary,
              onPressed: () => context.go(RoutePaths.login),
            ),
          ],
        ),
      ),
    );
  }
}
