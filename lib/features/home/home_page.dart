import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
// import 'package:share_plus/share_plus.dart';  // Temporarily removed for APK build
import 'package:url_launcher/url_launcher.dart';  // Re-added for YouTube links
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/section_header.dart';
import '../../core/widgets/shimmer_loading.dart';
import '../../core/widgets/audio_player_widget_placeholder.dart';
import '../../core/widgets/playlist_player_widget_placeholder.dart';
import '../../core/widgets/youtube_video_player.dart';
import '../../core/widgets/optimized_network_image.dart';
import '../../core/utils/performance_utils.dart';
// import '../../core/services/playlist_audio_service.dart';  // Temporarily removed for APK build

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  bool _showFullAbout = false;
  int _currentQuoteIndex = 0;
  AnimationController? _glowController;
  bool _showAudioPlayer = false;
  bool _showPlaylistPlayer = false;
  String _currentAudioTitle = '';
  String _currentAudioPath = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeAnimation();
    });
  }

  void _initializeAnimation() {
    try {
      _glowController = AnimationController(
        vsync: this,
        duration: PerformanceUtils.shouldReduceAnimations() 
            ? const Duration(seconds: 3)
            : const Duration(seconds: 2),
      );
      
      if (PerformanceUtils.supportsAdvancedGraphics()) {
        _glowController?.repeat(reverse: true);
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Animation controller initialization failed: $e');
      }
    }
  }

  @override
  void dispose() {
    try {
      _glowController?.dispose();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Animation controller dispose failed: $e');
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildGurujiSection(),
              _buildAboutSection(),
              _buildDailyQuotes(),
              _buildMeditationMusic(),
              _buildBhajans(),
              _buildExperienceVideos(),
              _buildRecommendedSection(),
              _buildUpcomingPrograms(),
              SizedBox(height: _showAudioPlayer || _showPlaylistPlayer ? 200 : 24),
            ],
          ),
        ),
      ),
      bottomSheet: _showAudioPlayer
          ? AudioPlayerWidget(
              title: _currentAudioTitle,
              subtitle: 'Audio coming soon',
            )
          : _showPlaylistPlayer
              ? PlaylistPlayerWidget(
                  songs: AppConstants.bhajans,
                )
              : null,
    );
  }

  Widget _buildGurujiSection() {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.height < 700;
    final sectionHeight = isSmallScreen ? 300.0 : 400.0;
    
    return Container(
      height: sectionHeight,
      child: Stack(
        children: [
          if (_glowController != null)
            AnimatedBuilder(
              animation: _glowController!,
              builder: (context, child) {
                return Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.gold.withOpacity(0.2 + _glowController!.value * 0.2),
                        blurRadius: 40,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: child,
                );
              },
              child: Image.asset(
                AppConstants.gurujiImageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: AppTheme.beige,
                  child: const Center(
                    child: Icon(Icons.person, size: 100, color: AppTheme.saffron),
                  ),
                ),
              ),
            )
          else
            Image.asset(
              AppConstants.gurujiImageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              errorBuilder: (context, error, stackTrace) => Container(
                color: AppTheme.beige,
                child: const Center(
                  child: Icon(Icons.person, size: 100, color: AppTheme.saffron),
                ),
              ),
            ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  AppTheme.white.withOpacity(0.9),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Text(
              'Parama Pujya Sri Jeeveswara Yogi',
              style: Theme.of(context).textTheme.displayLarge,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'About Guruji',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(height: 12),
              Text(
                _showFullAbout
                    ? AppConstants.aboutGuruji
                    : AppConstants.aboutGuruji.substring(0, 120) + '...',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              TextButton(
                onPressed: () => setState(() => _showFullAbout = !_showFullAbout),
                child: Text(_showFullAbout ? 'Read less' : 'Read more'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDailyQuotes() {
    return Column(
      children: [
        SectionHeader(title: 'Daily Wisdom'),
        CarouselSlider(
          options: CarouselOptions(
            height: MediaQuery.of(context).size.height < 700 ? 180 : 200,
            autoPlay: true,
            autoPlayInterval: PerformanceUtils.shouldReduceAnimations() 
                ? const Duration(seconds: 8) 
                : const Duration(seconds: 5),
            autoPlayAnimationDuration: PerformanceUtils.getAnimationDuration(),
            enlargeCenterPage: true,
            viewportFraction: MediaQuery.of(context).size.width < 400 ? 0.95 : 0.9,
            onPageChanged: (index, reason) {
              setState(() => _currentQuoteIndex = index);
            },
          ),
          items: AppConstants.dailyQuotes.map((quote) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    gradient: AppTheme.saffronGradient,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [AppTheme.softShadow],
                  ),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.format_quote, color: Colors.white.withOpacity(0.3), size: 40),
                            SizedBox(height: 12),
                            Text(
                              quote,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: Colors.white,
                                fontStyle: FontStyle.italic,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: IconButton(
                          icon: Icon(Icons.share, color: Colors.white),
                          // onPressed: () => Share.share(quote),  // Temporarily disabled for APK build
                          onPressed: () {
                            // TODO: Implement sharing when share_plus is enabled
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Sharing functionality temporarily disabled')),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }).toList(),
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: AppConstants.dailyQuotes.asMap().entries.map((entry) {
            return Container(
              width: 8,
              height: 8,
              margin: EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentQuoteIndex == entry.key
                    ? AppTheme.saffron
                    : AppTheme.softGray,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildMeditationMusic() {
    return Column(
      children: [
        SectionHeader(title: 'Meditation Music'),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: AppConstants.meditationMusic.length,
            itemBuilder: (context, index) {
              final music = AppConstants.meditationMusic[index];
              return Container(
                width: 280,
                margin: EdgeInsets.only(right: 12),
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _currentAudioTitle = music['title']!;
                        _currentAudioPath = music['url']!;
                        _showAudioPlayer = true;
                        _showPlaylistPlayer = false;
                      });
                    },
                    child: ListTile(
                      leading: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: AppTheme.saffronGradient,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.saffron.withOpacity(0.3),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Icon(Icons.headphones, color: Colors.white, size: 24),
                            Positioned(
                              bottom: 2,
                              right: 2,
                              child: Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppTheme.saffron, width: 1),
                                ),
                                child: Icon(
                                  Icons.play_arrow,
                                  color: AppTheme.saffron,
                                  size: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      title: Text(
                        music['title']!,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Row(
                        children: [
                          Icon(
                            Icons.music_note,
                            size: 14,
                            color: AppTheme.saffron,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            music['duration']!,
                            style: TextStyle(
                              color: AppTheme.darkBrown.withOpacity(0.7),
                              fontSize: 12,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'Tap to play',
                            style: TextStyle(
                              color: AppTheme.saffron,
                              fontSize: 11,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBhajans() {
    return Column(
      children: [
        SectionHeader(title: 'Songs & Bhajans'),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: AppConstants.bhajans.length,
            itemBuilder: (context, index) {
              final bhajan = AppConstants.bhajans[index];
              return Container(
                width: 160,
                margin: EdgeInsets.only(right: 12),
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  elevation: 4,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _currentAudioTitle = bhajan['title']!;
                        _currentAudioPath = bhajan['url']!;
                        _showAudioPlayer = true;
                        _showPlaylistPlayer = false;
                      });
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Image.asset(
                              bhajan['imageUrl']!,
                              height: 120,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                height: 120,
                                decoration: BoxDecoration(
                                  gradient: AppTheme.saffronGradient,
                                ),
                                child: Icon(
                                  Icons.music_note,
                                  size: 40,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            // Music indicator overlay
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.music_note,
                                      color: Colors.white,
                                      size: 12,
                                    ),
                                    const SizedBox(width: 2),
                                    Text(
                                      'MUSIC',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 8,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Play button overlay
                            Positioned(
                              bottom: 8,
                              right: 8,
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  gradient: AppTheme.saffronGradient,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.play_arrow,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      bhajan['title']!,
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      bhajan['artist']!,
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        fontSize: 11,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppTheme.saffron.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: AppTheme.saffron.withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.touch_app,
                                        size: 10,
                                        color: AppTheme.saffron,
                                      ),
                                      const SizedBox(width: 2),
                                      Text(
                                        'Tap to play',
                                        style: TextStyle(
                                          color: AppTheme.saffron,
                                          fontSize: 9,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
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
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildExperienceVideos() {
    return Column(
      children: [
        SectionHeader(title: 'Experience Videos'),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: AppConstants.experienceVideos.length,
            itemBuilder: (context, index) {
              final video = AppConstants.experienceVideos[index];
              return Container(
                width: 280,
                margin: EdgeInsets.only(right: 12),
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => YouTubeVideoPlayer(
                            videoId: video['youtubeId']!,
                            title: video['title']!,
                          ),
                        ),
                      );
                    },
                    child: Stack(
                      children: [
                        OptimizedNetworkImage(
                          imageUrl: video['thumbnail']!,
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          placeholder: ShimmerLoading(
                            width: double.infinity,
                            height: 180,
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.7),
                              ],
                            ),
                          ),
                        ),
                        Center(
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.play_arrow, size: 40, color: AppTheme.saffron),
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.play_arrow, size: 12, color: Colors.white),
                                SizedBox(width: 2),
                                Text(
                                  'YouTube',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 12,
                          left: 12,
                          right: 12,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                video['title']!,
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                video['duration']!,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.white70,
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
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () async {
                final url = Uri.parse(AppConstants.youtubeChannelUrl);
                // if (await canLaunchUrl(url)) {  // Temporarily disabled for APK build
                //   await launchUrl(url, mode: LaunchMode.externalApplication);
                // }
                // Temporarily show a message instead
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('External links temporarily disabled')),
                );
              },
              icon: Icon(Icons.play_circle_filled, color: Colors.white),
              label: Text('Visit YouTube Channel', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendedSection() {
    return Column(
      children: [
        SectionHeader(title: 'Recommended for You'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.auto_awesome, color: AppTheme.gold, size: 40),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Personalized content coming soon based on your spiritual journey',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUpcomingPrograms() {
    return Column(
      children: [
        SectionHeader(title: 'Upcoming Programs', onSeeAll: () {}),
        AppConstants.upcomingEvents.isEmpty
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            gradient: AppTheme.saffronGradient,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.event_available, size: 40, color: Colors.white),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Stay Tuned!',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppTheme.saffron,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Exciting spiritual programs and events are coming soon. We\'ll notify you when new programs are available.',
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 16),
                itemCount: AppConstants.upcomingEvents.length,
                itemBuilder: (context, index) {
                  final event = AppConstants.upcomingEvents[index];
                  return Card(
                    margin: EdgeInsets.only(bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CachedNetworkImage(
                          imageUrl: event['imageUrl']!,
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => ShimmerLoading(
                            width: double.infinity,
                            height: 150,
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                event['title']!,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.calendar_today, size: 16, color: AppTheme.saffron),
                                  SizedBox(width: 8),
                                  Text(event['date']!),
                                  SizedBox(width: 16),
                                  Icon(Icons.location_on, size: 16, color: AppTheme.saffron),
                                  SizedBox(width: 8),
                                  Text(event['location']!),
                                ],
                              ),
                              SizedBox(height: 12),
                              ElevatedButton(
                                onPressed: () {},
                                child: Text('Learn More'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ],
    );
  }
}
