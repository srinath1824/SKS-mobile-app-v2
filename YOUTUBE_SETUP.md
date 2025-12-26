# YouTube Video Integration

The app now supports YouTube video playback for experience videos.

## Current Setup:
- YouTube player integrated with custom spiritual theme
- Videos open in full-screen player
- Progress bar uses app's saffron color theme
- YouTube badge indicates video source

## To Add Your Videos:

1. **Get YouTube Video IDs:**
   - From URL: `https://www.youtube.com/watch?v=VIDEO_ID_HERE`
   - Extract the ID after `v=`

2. **Update the video IDs in app_constants.dart:**
   ```dart
   static const List<Map<String, String>> experienceVideos = [
     {'title': 'Journey to Inner Peace', 'thumbnail': '...', 'duration': '5:30', 'youtubeId': 'YOUR_VIDEO_ID_1'},
     {'title': 'Transformation Story', 'thumbnail': '...', 'duration': '8:15', 'youtubeId': 'YOUR_VIDEO_ID_2'},
     {'title': 'Divine Experiences', 'thumbnail': '...', 'duration': '6:45', 'youtubeId': 'YOUR_VIDEO_ID_3'},
   ];
   ```

## Features:
- ✅ Full-screen YouTube player
- ✅ Custom spiritual theme colors
- ✅ Auto-pause when app goes to background
- ✅ YouTube branding compliance
- ✅ Progress indicator with app colors
- ✅ Captions support
- ✅ HD quality when available

## Example Video IDs:
Replace `dQw4w9WgXcQ` with your actual YouTube video IDs.

## Note:
Make sure your YouTube videos are:
- Public or unlisted (not private)
- Embeddable (not restricted)
- Appropriate for spiritual content