import 'package:flutter/material.dart';
import 'package:myapp/features/auth/presentation/screens/login_screen.dart';
import 'package:myapp/core/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/services.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _pageController;
  int _pageIndex = 0;

  static const String _onboardingKey = 'hasSeenOnboarding';

  final List<Map<String, dynamic>> demoData = [
    {
      "image": "assets/images/splash1.png",
      "title": "Kelola Keuangan Anda\ndengan Mudah",
      "description":
          "Lacak pemasukan dan pengeluaran Anda dengan mudah. Dapatkan wawasan tentang kebiasaan belanja Anda.",
    },
    {
      "image": "assets/images/splash3.png",
      "title": "Tetapkan Tujuan Tabungan\n& Pantau Hutang",
      "description":
          "Tetapkan tujuan tabungan yang realistis dan pantau pembayaran hutang Anda agar tetap pada jalurnya.",
    },
    {
      "image": "assets/images/splash4.png",
      "title": "Analisis Keuangan\nBertenaga AI",
      "description":
          "Dapatkan saran dan wawasan yang dipersonalisasi dari asisten AI canggih kami untuk mengoptimalkan keuangan Anda.",
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    // Save that user has seen onboarding
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingKey, true);

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: demoData.length,
                  onPageChanged: (index) {
                    setState(() {
                      _pageIndex = index;
                    });
                  },
                  itemBuilder: (context, index) => OnboardContent(
                    image: demoData[index]["image"],
                    title: demoData[index]["title"],
                    description: demoData[index]["description"],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Dot Indicators
                    Row(
                      children: List.generate(
                        demoData.length,
                        (index) => Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            height: 8,
                            width: _pageIndex == index ? 24 : 8,
                            decoration: BoxDecoration(
                              color: _pageIndex == index
                                  ? FinoteColors.primary
                                  : (isDark
                                      ? FinoteColors.surface
                                      : Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Next/Get Started Button
                    ElevatedButton(
                      onPressed: () {
                        if (_pageIndex == demoData.length - 1) {
                          _completeOnboarding();
                        } else {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(20),
                        backgroundColor: FinoteColors.primary,
                      ),
                      child: Icon(
                        _pageIndex == demoData.length - 1
                            ? Icons.check
                            : Icons.arrow_forward,
                        color:
                            Colors.black, // Arrow always black on cyan button
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OnboardContent extends StatelessWidget {
  const OnboardContent({
    super.key,
    required this.image,
    required this.title,
    required this.description,
  });

  final String image;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Image.asset(
            image,
            height: 250,
          ),
          const Spacer(),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          Text(
            description,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.color
                      ?.withOpacity(0.7),
                ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
