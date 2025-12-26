import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';

class PermissionScreen extends StatefulWidget {
  const PermissionScreen({Key? key}) : super(key: key);

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  bool _isLoading = false;

  Future<void> _requestPermissions() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      if (kIsWeb) {
        // Web: Request browser permissions
        try {
          await Permission.camera.request();
        } catch (e) {}
        try {
          await Permission.microphone.request();
        } catch (e) {}
        try {
          await Permission.notification.request();
        } catch (e) {}
      } else {
        // Mobile: Request permissions based on Android version
        final permissions = <Permission>[];
        
        // Always needed permissions
        permissions.addAll([
          Permission.camera,
          Permission.microphone,
          Permission.notification,
        ]);
        
        // Storage permissions based on Android version
        try {
          if (await Permission.photos.status.isDenied) {
            permissions.add(Permission.photos);
          }
        } catch (e) {}
        
        try {
          if (await Permission.storage.status.isDenied) {
            permissions.add(Permission.storage);
          }
        } catch (e) {}
        
        // Location permission
        permissions.add(Permission.location);
        
        // Request all permissions with individual error handling
        final statuses = <Permission, PermissionStatus>{};
        for (final permission in permissions) {
          try {
            statuses[permission] = await permission.request();
          } catch (e) {
            // Continue with other permissions if one fails
            statuses[permission] = PermissionStatus.denied;
          }
        }
        
        // Check if critical permissions are granted (don't block if failed)
        bool hasRequiredPermissions = true;
        try {
          for (final permission in [Permission.camera, Permission.microphone]) {
            if (statuses[permission]?.isDenied == true) {
              hasRequiredPermissions = false;
              break;
            }
          }
        } catch (e) {
          hasRequiredPermissions = true; // Continue anyway
        }
        
        if (!hasRequiredPermissions) {
          try {
            _showPermissionDialog();
          } catch (e) {
            // If dialog fails, just continue to app
            if (mounted) context.go('/');
          }
          setState(() => _isLoading = false);
          return;
        }
      }
      
      setState(() => _isLoading = false);
      if (mounted) context.go('/');
    } catch (e) {
      // If everything fails, still allow user to continue
      setState(() => _isLoading = false);
      if (mounted) context.go('/');
    }
  }
  
  void _showPermissionDialog() {
    if (!mounted) return;
    
    try {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => AlertDialog(
          title: const Text('Permissions Required'),
          content: const Text('Please enable permissions in Settings to use all features.'),
          actions: [
            TextButton(
              onPressed: () {
                try {
                  Navigator.pop(context);
                  context.go('/');
                } catch (e) {
                  // Fallback navigation
                  SystemNavigator.pop();
                }
              },
              child: const Text('Skip'),
            ),
            ElevatedButton(
              onPressed: () {
                try {
                  Navigator.pop(context);
                  openAppSettings();
                } catch (e) {
                  // If settings can't open, just continue
                  try {
                    Navigator.pop(context);
                    context.go('/');
                  } catch (e2) {
                    SystemNavigator.pop();
                  }
                }
              },
              child: const Text('Settings'),
            ),
          ],
        ),
      );
    } catch (e) {
      // If dialog fails, just navigate to home
      if (mounted) {
        try {
          context.go('/');
        } catch (e2) {
          SystemNavigator.pop();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenHeight < 700;
    
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.spiritualGradient),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.06,
                  vertical: isSmallScreen ? 16 : 24,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          SizedBox(height: isSmallScreen ? 20 : 40),
                          Container(
                            width: isSmallScreen ? 100 : 120,
                            height: isSmallScreen ? 100 : 120,
                            decoration: const BoxDecoration(
                              gradient: AppTheme.saffronGradient,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0x4DFF9933),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.security,
                              size: isSmallScreen ? 50 : 60,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: isSmallScreen ? 20 : 32),
                          Text(
                            'Permissions Required',
                            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                              fontSize: isSmallScreen ? 24 : null,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: isSmallScreen ? 12 : 16),
                          const Text(
                            'To provide you with the best spiritual experience, we need access to:',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppTheme.darkBrown,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: isSmallScreen ? 20 : 32),
                          ..._buildPermissionItems(isSmallScreen),
                        ],
                      ),
                      Column(
                        children: [
                          SizedBox(height: isSmallScreen ? 20 : 32),
                          Container(
                            width: double.infinity,
                            constraints: const BoxConstraints(
                              maxWidth: 400,
                            ),
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _requestPermissions,
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                  vertical: isSmallScreen ? 14 : 16,
                                ),
                                elevation: 8,
                                shadowColor: AppTheme.saffron.withOpacity(0.3),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    )
                                  : Text(
                                      'Grant Access',
                                      style: TextStyle(
                                        fontSize: isSmallScreen ? 16 : 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: _isLoading ? null : () {
                              try {
                                context.go('/');
                              } catch (e) {
                                SystemNavigator.pop();
                              }
                            },
                            child: Text(
                              'Skip for now',
                              style: TextStyle(
                                color: AppTheme.darkBrown.withOpacity(0.7),
                                fontSize: 14,
                              ),
                            ),
                          ),
                          SizedBox(height: isSmallScreen ? 10 : 20),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
  
  List<Widget> _buildPermissionItems(bool isSmallScreen) {
    final permissions = [
      {'icon': Icons.camera_alt, 'title': 'Camera', 'desc': 'Capture spiritual moments'},
      {'icon': Icons.mic, 'title': 'Microphone', 'desc': 'Audio recordings'},
      {'icon': Icons.folder, 'title': 'Storage', 'desc': 'Save content offline'},
      {'icon': Icons.notifications, 'title': 'Notifications', 'desc': 'Spiritual reminders'},
      {'icon': Icons.location_on, 'title': 'Location', 'desc': 'Find nearby events'},
    ];
    
    return permissions.map((perm) => _buildPermissionItem(
      perm['icon'] as IconData,
      perm['title'] as String,
      perm['desc'] as String,
      isSmallScreen,
    )).toList();
  }

  Widget _buildPermissionItem(IconData icon, String title, String description, bool isSmallScreen) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 6 : 8),
      child: Container(
        padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: isSmallScreen ? 40 : 48,
              height: isSmallScreen ? 40 : 48,
              decoration: BoxDecoration(
                color: AppTheme.saffron.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: AppTheme.saffron,
                size: isSmallScreen ? 20 : 24,
              ),
            ),
            SizedBox(width: isSmallScreen ? 12 : 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: isSmallScreen ? 14 : 16,
                    ),
                  ),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: isSmallScreen ? 12 : 14,
                    ),
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
