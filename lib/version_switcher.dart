import 'package:flutter/material.dart';
import 'main.dart' as original;
import 'main_clean.dart' as clean;
import 'main_new.dart' as new_version;
import 'main_theme_v2.dart' as theme_v2;

void main() {
  runApp(const VersionSwitcherApp());
}

class VersionSwitcherApp extends StatelessWidget {
  const VersionSwitcherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spiritual App - Version Switcher',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'SF Pro Display',
      ),
      home: const VersionSwitcherScreen(),
    );
  }
}

class VersionSwitcherScreen extends StatelessWidget {
  const VersionSwitcherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5F3),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Text(
                'Siva Kundalini Sadhana',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF4A7C27),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Choose Your App Version',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: const Color(0xFF6B9B37),
                ),
              ),
              const SizedBox(height: 40),
              
              Expanded(
                child: ListView(
                  children: [
                    _buildVersionCard(
                      context,
                      'Theme V2 - Modern Yoga Design 🧘‍♀️',
                      'Beautiful modern design inspired by top yoga apps with waveform audio player, smooth animations, and organic shapes.',
                      const Color(0xFF6B9B37),
                      Icons.auto_awesome,
                      () => _launchVersion(context, 'theme_v2'),
                      isRecommended: true,
                    ),
                    
                    const SizedBox(height: 16),
                    
                    _buildVersionCard(
                      context,
                      'Clean Version ✨',
                      'Stable working version with all features functional. Recommended for daily use.',
                      const Color(0xFF4CAF50),
                      Icons.check_circle,
                      () => _launchVersion(context, 'clean'),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    _buildVersionCard(
                      context,
                      'New Version 🚀',
                      'Latest development version with enhanced audio players and navigation content.',
                      const Color(0xFF2196F3),
                      Icons.new_releases,
                      () => _launchVersion(context, 'new'),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    _buildVersionCard(
                      context,
                      'Original Version 📱',
                      'The original base version of the spiritual app.',
                      const Color(0xFF9E9E9E),
                      Icons.history,
                      () => _launchVersion(context, 'original'),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF6B9B37).withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: const Color(0xFF6B9B37),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Version Management',
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Each version is preserved separately. You can switch between them anytime.',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
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

  Widget _buildVersionCard(
    BuildContext context,
    String title,
    String description,
    Color color,
    IconData icon,
    VoidCallback onTap, {
    bool isRecommended = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: isRecommended 
            ? Border.all(color: color, width: 2)
            : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          if (isRecommended)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'NEW',
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Launch App',
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward,
                        color: color,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _launchVersion(BuildContext context, String version) {
    Widget targetApp;
    
    switch (version) {
      case 'theme_v2':
        targetApp = const theme_v2.ModernSpiritualApp();
        break;
      case 'clean':
        targetApp = const clean.SpiritualApp();
        break;
      case 'new':
        targetApp = const new_version.SpiritualApp();
        break;
      case 'original':
      default:
        targetApp = const original.SpiritualApp();
        break;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MaterialApp(
          title: 'Spiritual App',
          debugShowCheckedModeBanner: false,
          home: targetApp,
        ),
      ),
    );
  }
}