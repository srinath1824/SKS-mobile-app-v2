import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'spiritual_pages.dart';\nimport 'splash_screen.dart';\nimport 'lib/features/notifications/notifications_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  FlutterError.onError = (FlutterErrorDetails details) {
    if (kDebugMode) {
      FlutterError.presentError(details);
    }
  };
  
  runApp(const SpiritualApp());
}

class SpiritualApp extends StatelessWidget {
  const SpiritualApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Siva Kundalini Sadhana',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
      routes: {
        '/home': (context) => const MainApp(),
      },
    );
  }
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _pages = [
    const HomePage(),
    const LearningsPage(),
    const ConnectPage(),
    const EventsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: AppTheme.saffron,
        unselectedItemColor: AppTheme.darkBrown.withOpacity(0.6),
        backgroundColor: AppTheme.lightCream,
        elevation: 8,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Learnings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.connect_without_contact),
            label: 'Connect',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Events',
          ),
        ],
      ),
    );
  }
}

// HomePage with safe error handling
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int _currentQuoteIndex = 0;
  int _currentAudioIndex = 0;
  bool _isAudioPlaying = false;
  bool _isDisposed = false;
  Timer? _quoteTimer;
  late AnimationController _audioAnimationController;

  @override
  void initState() {
    super.initState();
    _audioAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _startQuoteRotation();
  }

  void _startQuoteRotation() {
    if (AppConstants.dailyQuotes.isNotEmpty) {
      _quoteTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
        if (!_isDisposed && mounted) {
          try {
            setState(() {
              _currentQuoteIndex = (_currentQuoteIndex + 1) % AppConstants.dailyQuotes.length;
            });
          } catch (e) {
            if (kDebugMode) {
              debugPrint('Quote rotation error: $e');
            }
          }
        }
      });
    }
  }

  void _toggleAudioPlayback() {
    try {
      if (mounted) {
        setState(() {
          _isAudioPlaying = !_isAudioPlaying;
        });
        
        // Animate play button
        if (_isAudioPlaying) {
          _audioAnimationController.forward();
        } else {
          _audioAnimationController.reverse();
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  _isAudioPlaying ? Icons.play_arrow : Icons.pause,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(_isAudioPlaying ? '🎵 Playing meditation music...' : '⏸️ Audio paused'),
              ],
            ),
            backgroundColor: AppTheme.saffron,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Audio toggle error: $e');
      }
    }
  }

  void _nextAudio() {
    try {
      if (mounted && AppConstants.meditationMusic.isNotEmpty) {
        setState(() {
          _currentAudioIndex = (_currentAudioIndex + 1) % AppConstants.meditationMusic.length;
          _isAudioPlaying = false;
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Next audio error: $e');
      }
    }
  }

  void _previousAudio() {
    try {
      if (mounted && AppConstants.meditationMusic.isNotEmpty) {
        setState(() {
          _currentAudioIndex = _currentAudioIndex > 0 ? _currentAudioIndex - 1 : AppConstants.meditationMusic.length - 1;
          _isAudioPlaying = false;
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Previous audio error: $e');
      }
    }
  }

  Future<void> _launchUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      if (kDebugMode) {
        print('URL launch error: $e');
      }
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _quoteTimer?.cancel();
    _audioAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background with spiritual image and gradients
          Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                // Top section with spiritual image and warm gradient
                Expanded(
                  flex: 45,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: AppTheme.topGradient,
                    ),
                    child: Stack(
                      children: [
                        // Spiritual figure background
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/images/Guruji_Meditation.PNG'),
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.mode(
                                  AppTheme.warmBeige.withOpacity(0.3),
                                  BlendMode.overlay,
                                ),
                              ),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    AppTheme.warmBeige.withOpacity(0.8),
                                    AppTheme.warmBeige.withOpacity(0.6),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Safe area content
                        SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Top bar with greeting
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundImage: AssetImage('assets/images/Guruji.JPG'),
                                      backgroundColor: Colors.white,
                                      child: Icon(Icons.person, color: AppTheme.darkNavy),
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                  // App title
                                  Text(
                                    'Siva Kundalini Sadhana',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.darkNavy,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                            'Welcome, Seeker!',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: AppTheme.darkNavy.withOpacity(0.7),
                                            ),
                                          ),
                                          Text(
                                            'Ganesh Prasanth...',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: AppTheme.darkNavy,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const NotificationsPage(),
                                          ),
                                        );
                                      },
                                      child: Icon(Icons.notifications, color: AppTheme.darkNavy),
                                    ),
                                  ],
                                ),
                                
                                Spacer(),
                                
                                // Quote dots indicator
                                Row(
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: AppTheme.accent,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: AppTheme.accent.withOpacity(0.3),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: AppTheme.accent.withOpacity(0.3),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                                
                                // Main quote text
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 500),
                                  child: Text(
                                    AppConstants.dailyQuotes.isNotEmpty 
                                      ? AppConstants.dailyQuotes[_currentQuoteIndex]
                                      : 'For Peace to be real must be unaffected by circumstances.',
                                    key: ValueKey(_currentQuoteIndex),
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white,
                                      height: 1.3,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Bottom section with dark background
                Expanded(
                  flex: 55,
                  child: Container(
                    color: AppTheme.darkNavy,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20),
                            
                            // Quote card overlay (positioned to overlap)
                            ),
                            
                            // Quotes section - moved outside image overlay
                            SizedBox(height: 20),
                            Container(
                              padding: EdgeInsets.all(20),
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'QUOTE OF THE DAY',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.darkNavy.withOpacity(0.7),
                                      letterSpacing: 1,
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 500),
                                    child: Text(
                                      AppConstants.dailyQuotes.isNotEmpty 
                                        ? AppConstants.dailyQuotes[_currentQuoteIndex]
                                        : 'For Peace to be real must be unaffected by circumstances.',
                                      key: ValueKey(_currentQuoteIndex),
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: AppTheme.darkNavy,
                                        height: 1.4,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  // Quote navigation dots
                                  Row(
                                    children: [
                                      Container(
                                        width: 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          color: AppTheme.accent,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Container(
                                        width: 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          color: AppTheme.accent.withOpacity(0.3),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Container(
                                        width: 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          color: AppTheme.accent.withOpacity(0.3),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            
                            // Spiritual Features Section
                            SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Spiritual Journey',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'Explore',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.accent,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            
                            // Spiritual features grid
                            Row(
                              children: [
                                Expanded(
                                  child: _buildSpiritualFeatureCard(
                                    'Daily Meditation',
                                    'Guided Sessions',
                                    Icons.self_improvement,
                                    Color(0xFFFF6B35),
                                    () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => DailyMeditationPage()),
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: _buildSpiritualFeatureCard(
                                    'Sacred Music',
                                    'Divine Bhajans',
                                    Icons.music_note,
                                    Color(0xFFFFD23F),
                                    () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => SacredMusicPage()),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildSpiritualFeatureCard(
                                    'Spiritual Videos',
                                    'Experience Stories',
                                    Icons.play_circle,
                                    Color(0xFF06FFA5),
                                    () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => SpiritualVideosPage()),
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: _buildSpiritualFeatureCard(
                                    'About Guruji',
                                    'Sacred Journey',
                                    Icons.person,
                                    Color(0xFF4ECDC4),
                                    () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => AboutGurujiPage()),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 30),
                            
                            // Upcoming Events section
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Upcoming Events',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'See all',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.accent,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            
                            // Event cards
                            Row(
                              children: [
                                Expanded(
                                  child: _buildEventCard(
                                    'Sacred Rituals',
                                    '25/08/2024',
                                    'BHAKTHI MANDOR',
                                    'assets/images/event1.png',
                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: _buildEventCard(
                                    'Meditation Session',
                                    '25/08/2024',
                                    'DEVOTION HALL',
                                    'assets/images/event2.png',
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 30),
                            
                            // Spiritual Features Section
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Spiritual Journey',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'Explore',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.accent,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            
                            // Spiritual features grid
                            Row(
                              children: [
                                Expanded(
                                  child: _buildSpiritualFeatureCard(
                                    'Daily Meditation',
                                    'Guided Sessions',
                                    Icons.self_improvement,
                                    Color(0xFFFF6B35),
                                    () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => DailyMeditationPage()),
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: _buildSpiritualFeatureCard(
                                    'Sacred Music',
                                    'Divine Bhajans',
                                    Icons.music_note,
                                    Color(0xFFFFD23F),
                                    () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => SacredMusicPage()),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildSpiritualFeatureCard(
                                    'Spiritual Videos',
                                    'Experience Stories',
                                    Icons.play_circle_filled,
                                    Color(0xFF06FFA5),
                                    () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => SpiritualVideosPage()),
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: _buildSpiritualFeatureCard(
                                    'About Guruji',
                                    'Sacred Journey',
                                    Icons.person,
                                    Color(0xFF4ECDC4),
                                    () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => AboutGurujiPage()),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppTheme.spaceXL),
      decoration: BoxDecoration(
        gradient: AppTheme.cardGradient,
        borderRadius: BorderRadius.circular(AppTheme.radiusXL),
        boxShadow: const [AppTheme.cardShadow],
        border: Border.all(
          color: AppTheme.surfaceContainer,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppTheme.spaceMD,
                    vertical: AppTheme.spaceSM,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.self_improvement,
                        size: 16,
                        color: AppTheme.primary,
                      ),
                      SizedBox(width: AppTheme.spaceSM),
                      Text(
                        'Welcome',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: AppTheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppTheme.spaceMD),
                Text(
                  'Begin Your\nSpiritual Journey',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: AppTheme.spaceMD),
                Text(
                  'Discover inner peace through meditation, wisdom, and divine connection.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: AppTheme.spaceLG),
          Expanded(
            flex: 1,
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppTheme.radiusLG),
                boxShadow: const [AppTheme.softShadow],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppTheme.radiusLG),
                child: Image.asset(
                  AppConstants.gurujiImageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        gradient: AppTheme.spiritualGradient,
                        borderRadius: BorderRadius.circular(AppTheme.radiusLG),
                      ),
                      child: const Icon(
                        Icons.account_circle,
                        size: 60,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyQuoteSection(BuildContext context) {
    if (AppConstants.dailyQuotes.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(AppTheme.spaceSM),
              decoration: BoxDecoration(
                color: AppTheme.accent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusSM),
              ),
              child: Icon(
                Icons.format_quote,
                color: AppTheme.accent,
                size: 20,
              ),
            ),
            SizedBox(width: AppTheme.spaceMD),
            Text(
              'Daily Wisdom',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: AppTheme.spaceMD),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(AppTheme.spaceXL),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.accent.withOpacity(0.05),
                AppTheme.primary.withOpacity(0.03),
              ],
            ),
            borderRadius: BorderRadius.circular(AppTheme.radiusXL),
            border: Border.all(
              color: AppTheme.accent.withOpacity(0.2),
              width: 1,
            ),
            boxShadow: const [AppTheme.cardShadow],
          ),
          child: Column(
            children: [
              const Icon(
                Icons.format_quote,
                color: AppTheme.saffron,
                size: 32,
              ),
              const SizedBox(height: 16),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: Text(
                  '"${AppConstants.dailyQuotes[_currentQuoteIndex]}"',
                  key: ValueKey(_currentQuoteIndex),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: AppTheme.darkBrown,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '- Ancient Wisdom',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.saffron,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAudioPlayerSection(BuildContext context) {
    if (AppConstants.meditationMusic.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Daily Meditation',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: AppTheme.spiritualGradient,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [AppTheme.softShadow],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppTheme.saffron,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.music_note,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppConstants.meditationMusic.isNotEmpty 
                            ? AppConstants.meditationMusic[_currentAudioIndex]['title'] ?? 'Meditation Music'
                            : 'Meditation Music',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Guided meditation with Parama Pujya Sri Jeeveswara Yogi',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: _previousAudio,
                    icon: const Icon(Icons.skip_previous),
                    color: Colors.white,
                    iconSize: 32,
                  ),
                  const SizedBox(width: 20),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: _isAudioPlaying 
                        ? [
                            BoxShadow(
                              color: AppTheme.saffron.withOpacity(0.3),
                              spreadRadius: 3,
                              blurRadius: 8,
                            ),
                          ]
                        : [],
                    ),
                    child: ScaleTransition(
                      scale: Tween(begin: 1.0, end: 1.1).animate(
                        CurvedAnimation(
                          parent: _audioAnimationController,
                          curve: Curves.easeInOut,
                        ),
                      ),
                      child: IconButton(
                        onPressed: _toggleAudioPlayback,
                        icon: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            _isAudioPlaying ? Icons.pause : Icons.play_arrow,
                            key: ValueKey(_isAudioPlaying),
                          ),
                        ),
                        color: AppTheme.saffron,
                        iconSize: 42,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    onPressed: _nextAudio,
                    icon: const Icon(Icons.skip_next),
                    color: Colors.white,
                    iconSize: 32,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Progress bar and track info
              Column(
                children: [
                  Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: LinearProgressIndicator(
                        value: _isAudioPlaying ? 0.4 : 0.0, // Simulate progress
                        backgroundColor: Colors.transparent,
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _isAudioPlaying ? '2:30' : '0:00',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                      Text(
                        AppConstants.meditationMusic[_currentAudioIndex]['duration'] ?? '15:00',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAboutGuru(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About Our Guruji',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.beige,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [AppTheme.softShadow],
          ),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: const BoxDecoration(
                    gradient: AppTheme.spiritualGradient,
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 60,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                AppConstants.aboutGuruji,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBhajansSection(BuildContext context) {
    if (AppConstants.bhajans.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Songs',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 12),
        Container(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: AppConstants.bhajans.length,
            itemBuilder: (context, index) {
              final bhajan = AppConstants.bhajans[index];
              return Container(
                width: 160,
                height: 190, // Fixed height to prevent overflow
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: AppTheme.beige,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [AppTheme.softShadow],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                        child: bhajan['imageUrl'] != null
                            ? Image.asset(
                                bhajan['imageUrl']!,
                                height: 100,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                alignment: Alignment.center,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: 100,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [Color(0xFF8B4513), Color(0xFFD2B48C)],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.music_note,
                                        color: Colors.white,
                                        size: 40,
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Container(
                                height: 100,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Color(0xFF8B4513), Color(0xFFD2B48C)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.music_note,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                ),
                              ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            bhajan['title'] ?? '',
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            bhajan['artist'] ?? '',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.saffron,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('🎵 Playing: ${bhajan['title']}'),
                                    backgroundColor: AppTheme.saffron,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.play_arrow, size: 16),
                              label: const Text('Play', style: TextStyle(fontSize: 12)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.saffron,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                minimumSize: const Size(0, 32),
                              ),
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
        ),
      ],
    );
  }

  Widget _buildVideosSection(BuildContext context) {
    if (AppConstants.experienceVideos.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Experience Videos',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 12),
        ...AppConstants.experienceVideos.take(2).map((video) => 
          _buildVideoCard(context, video)).toList(),
      ],
    );
  }

  Widget _buildVideoCard(BuildContext context, Map<String, String> video) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 4,
        color: AppTheme.beige,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          leading: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppTheme.saffron,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.play_circle_fill, color: Colors.white, size: 30),
          ),
          title: Text(video['title'] ?? 'Video'),
          subtitle: Text(video['description'] ?? 'Experience video'),
          onTap: () {
            final url = video['url'];
            if (url != null) {
              _launchUrl(url);
            }
          },
        ),
      ),
    );
  }
  
  Widget _buildEventCard(String title, String date, String venue, String imagePath) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey[900],
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Stack(
        children: [
          // Background gradient to match other cards
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF4ECDC4).withOpacity(0.3),
                  Color(0xFF06FFA5).withOpacity(0.3),
                ],
              ),
            ),
          ),
          // Content
          Positioned(
            bottom: 12,
            left: 12,
            right: 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  venue,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withOpacity(0.7),
                    letterSpacing: 1,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSpiritualFeatureCard(String title, String subtitle, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[800]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    size: 20,
                    color: color,
                  ),
                ),
                Spacer(),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white.withOpacity(0.3),
                  size: 16,
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Placeholder pages
class LearningsPage extends StatefulWidget {
  const LearningsPage({super.key});

  @override
  State<LearningsPage> createState() => _LearningsPageState();
}

class _LearningsPageState extends State<LearningsPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            // Top section with warm gradient
            Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: AppTheme.topGradient,
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(Icons.arrow_back, color: AppTheme.darkNavy),
                          ),
                          Spacer(),
                          Text(
                            'Sacred Learnings',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.darkNavy,
                            ),
                          ),
                          Spacer(),
                          Icon(Icons.more_horiz, color: AppTheme.darkNavy),
                        ],
                      ),
                      SizedBox(height: 30),
                      Text(
                        'Expand Your\nSpiritual Knowledge',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w300,
                          color: AppTheme.darkNavy,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Bottom section with dark background
            Expanded(
              child: Container(
                color: AppTheme.darkNavy,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        
                        // Categories
                        Text(
                          'Learning Categories',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 16),
                        
                        // Category cards in grid
                        GridView.count(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1.2,
                          children: [
                            _buildLearningCard(
                              'Sacred Texts',
                              'Ancient scriptures',
                              Icons.book,
                              Color(0xFFFF6B35),
                            ),
                            _buildLearningCard(
                              'Meditation',
                              'Guided practices',
                              Icons.self_improvement,
                              Color(0xFFFFD23F),
                            ),
                            _buildLearningCard(
                              'Philosophy',
                              'Spiritual wisdom',
                              Icons.psychology,
                              Color(0xFF06FFA5),
                            ),
                            _buildLearningCard(
                              'Rituals',
                              'Sacred ceremonies',
                              Icons.spa,
                              Color(0xFF4ECDC4),
                            ),
                          ],
                        ),
                        
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  
  Widget _buildLearningCard(String title, String subtitle, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(
                icon,
                size: 32,
                color: color,
              ),
            ),
            SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class ConnectPage extends StatefulWidget {
  const ConnectPage({super.key});

  @override
  State<ConnectPage> createState() => _ConnectPageState();
}

class _ConnectPageState extends State<ConnectPage> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            // Top section with warm gradient
            Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: AppTheme.topGradient,
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(Icons.arrow_back, color: AppTheme.darkNavy),
                          ),
                          Spacer(),
                          Text(
                            'Connect with Guruji',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.darkNavy,
                            ),
                          ),
                          Spacer(),
                          Icon(Icons.more_horiz, color: AppTheme.darkNavy),
                        ],
                      ),
                      SizedBox(height: 30),
                      Text(
                        'Divine Connection\nAwaits You',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w300,
                          color: AppTheme.darkNavy,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Bottom section with dark background
            Expanded(
              child: Container(
                color: AppTheme.darkNavy,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        
                        // Connection options
                        Text(
                          'Connection Options',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 16),
                        
                        // Connection cards in grid
                        GridView.count(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1.1,
                          children: [
                            _buildConnectCard(
                              'Personal\nSession',
                              Icons.video_call_outlined,
                              Color(0xFFFF6B35),
                            ),
                            _buildConnectCard(
                              'Spiritual\nChat',
                              Icons.chat_bubble_outline,
                              Color(0xFFFFD23F),
                            ),
                            _buildConnectCard(
                              'Guided\nMeditation',
                              Icons.self_improvement,
                              Color(0xFF06FFA5),
                            ),
                            _buildConnectCard(
                              'Daily\nPractice',
                              Icons.spa_outlined,
                              Color(0xFF4ECDC4),
                            ),
                          ],
                        ),
                        
                        SizedBox(height: 30),
                        
                        // Quick actions
                        Text(
                          'Quick Actions',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 16),
                        
                        // Quick action cards
                        _buildQuickActionCard(
                          'Schedule a Personal Session',
                          'Book your one-on-one spiritual guidance',
                          Icons.calendar_today,
                          Color(0xFFFF6B35),
                        ),
                        SizedBox(height: 16),
                        _buildQuickActionCard(
                          'Join Community Chat',
                          'Connect with fellow spiritual seekers',
                          Icons.group,
                          Color(0xFF06FFA5),
                        ),
                        
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectCard(String title, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              icon,
              size: 32,
              color: color,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  
  Widget _buildQuickActionCard(String title, String subtitle, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              size: 24,
              color: color,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.white.withOpacity(0.5),
            size: 16,
          ),
        ],
      ),
    );
  }
}

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            // Top section with warm gradient
            Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: AppTheme.topGradient,
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(Icons.arrow_back, color: AppTheme.darkNavy),
                          ),
                          Spacer(),
                          Text(
                            'Sacred Events',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.darkNavy,
                            ),
                          ),
                          Spacer(),
                          Icon(Icons.more_horiz, color: AppTheme.darkNavy),
                        ],
                      ),
                      SizedBox(height: 30),
                      Text(
                        'Join Sacred\nGatherings',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w300,
                          color: AppTheme.darkNavy,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Bottom section with dark background
            Expanded(
              child: Container(
                color: AppTheme.darkNavy,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        
                        // Upcoming events
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Upcoming Events',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'See all',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppTheme.accent,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        
                        // Event cards
                        _buildEventCard(
                          'Sacred Rituals',
                          'Tomorrow • 6:00 PM',
                          Icons.spa,
                          Color(0xFFFF6B35),
                          'BHAKTHI MANOR',
                        ),
                        SizedBox(height: 16),
                        _buildEventCard(
                          'Meditation Session',
                          'Friday • 7:00 AM',
                          Icons.self_improvement,
                          Color(0xFFFFD23F),
                          'DEVOTION HALL',
                        ),
                        SizedBox(height: 16),
                        _buildEventCard(
                          'Satsang Gathering',
                          'Sunday • 5:00 PM',
                          Icons.people_outline,
                          Color(0xFF06FFA5),
                          'COMMUNITY CENTER',
                        ),
                        SizedBox(height: 16),
                        _buildEventCard(
                          'Yoga Practice',
                          'Daily • 6:00 AM',
                          Icons.fitness_center,
                          Color(0xFF4ECDC4),
                          'YOGA STUDIO',
                        ),
                        
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventCard(String title, String time, IconData icon, Color color, String venue) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              size: 24,
              color: color,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  venue,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withOpacity(0.7),
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.white.withOpacity(0.5),
            size: 16,
          ),
        ],
      ),
    );
  }
}

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            // Top section with warm gradient
            Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: AppTheme.topGradient,
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(Icons.arrow_back, color: AppTheme.darkNavy),
                          ),
                          Spacer(),
                          Text(
                            'Notifications',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.darkNavy,
                            ),
                          ),
                          Spacer(),
                          Icon(Icons.more_horiz, color: AppTheme.darkNavy),
                        ],
                      ),
                      SizedBox(height: 30),
                      Text(
                        'Stay Connected\nWith Divine Messages',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w300,
                          color: AppTheme.darkNavy,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Bottom section with dark background
            Expanded(
              child: Container(
                color: AppTheme.darkNavy,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        
                        // Recent notifications
                        Text(
                          'Recent Messages',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 16),
                        
                        // Notification cards
                        _buildNotificationCard(
                          'Sacred Ritual Tomorrow',
                          'Join us for the evening spiritual gathering at 6:00 PM',
                          '2 hours ago',
                          Icons.spa,
                          Color(0xFFFF6B35),
                        ),
                        SizedBox(height: 16),
                        _buildNotificationCard(
                          'New Teaching Available',
                          'A new meditation guide has been added to your library',
                          '1 day ago',
                          Icons.book,
                          Color(0xFFFFD23F),
                        ),
                        SizedBox(height: 16),
                        _buildNotificationCard(
                          'Community Message',
                          'Welcome to our spiritual community! Begin your journey',
                          '3 days ago',
                          Icons.group,
                          Color(0xFF06FFA5),
                        ),
                        
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard(String title, String message, String time, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              size: 24,
              color: color,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  time,
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
