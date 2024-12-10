import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class VideoListScreen extends StatefulWidget {
  const VideoListScreen({super.key});

  @override
  State<VideoListScreen> createState() => _VideoListScreenState();
}

class _VideoListScreenState extends State<VideoListScreen> {
  final List<String> videoUrls = [
    'assets/sample_video.mp4',
    'assets/sample_video.mp4',
    'assets/sample_video.mp4',
    'assets/sample_video.mp4',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Screen'),
      ),
      body: Container(
        color: Colors.black,
        child: SingleChildScrollView(
          child: Column(
            children: [
              for (String videoUrl in videoUrls)
                VideoCard(videoUrl: videoUrl),
            ],
          ),
        ),
      ),
    );
  }
}

class VideoCard extends StatefulWidget {
  final String videoUrl;

  const VideoCard({Key? key, required this.videoUrl}) : super(key: key);

  @override
  State<VideoCard> createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> {
  late VideoPlayerController _controller;
  bool _isVideoInitialized = false;
  int _likeCount = 0;
  bool _isLiked = false;
  bool _isPlaying = false;
  final TextEditingController _commentController = TextEditingController();
  final List<String> _comments = [];

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.videoUrl)
      ..initialize().then((_) {
        if (_controller.value.errorDescription != null) {
          print('Lỗi tải video: ${_controller.value.errorDescription}');
          return;
        }
        setState(() {
          _isVideoInitialized = true;
          _isPlaying = false;
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    _commentController.dispose();
    super.dispose();
  }

  void _copyLinkToClipboard() {
    Clipboard.setData(ClipboardData(text: 'assets/sample_video.mp4'));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã sao chép liên kết vào clipboard')),
    );
  }

  void _toggleLike() {
    setState(() {
      if (_isLiked) {
        _likeCount--;
      } else {
        _likeCount++;
      }
      _isLiked = !_isLiked;
    });
  }

  void _addComment() {
    if (_commentController.text.isNotEmpty) {
      setState(() {
        _comments.add(_commentController.text);
        _commentController.clear();
      });
    }
  }

  void _togglePlayPause() {
    setState(() {
      if (_isPlaying) {
        _controller.pause();
        _isPlaying = false;
      } else {
        _controller.play();
        _isPlaying = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black,
      elevation: 0,
      margin: const EdgeInsets.all(8), // Reduced margin
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Row for avatar and name
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundImage: AssetImage('assets/user.png'),
                ),
                const SizedBox(width: 8), // Spacing between avatar and text
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Nguyễn Văn A',
                      style: TextStyle(color: Colors.white, fontSize: 14), // Reduced font size
                    ),
                    Text(
                      '2 giờ trước',
                      style: TextStyle(color: Colors.grey, fontSize: 12), // Reduced font size
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (_isVideoInitialized)
            Container(
              height: 400, // Increased video height
              child: Stack(
                children: [
                  VideoPlayer(_controller),
                  if (_controller.value.position != _controller.value.duration)
                    VideoProgressIndicator(
                      _controller,
                      allowScrubbing: true,
                      colors: const VideoProgressColors(
                        playedColor: Colors.red,
                        bufferedColor: Colors.grey,
                        backgroundColor: Colors.white,
                      ),
                    ),
                  Align(
                    alignment: Alignment.center,
                    child: IconButton(
                      icon: Icon(
                        _isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                        size: 30,
                      ),
                      onPressed: _togglePlayPause,
                    ),
                  ),
                ],
              ),
            )
          else
            Container(
              height: 100,
              color: Colors.grey[200],
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(4), // Reduced padding
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4), // Reduced spacing
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            _isLiked ? Icons.favorite : Icons.favorite_border,
                            color: _isLiked ? Colors.red : Colors.white,
                          ),
                          onPressed: _toggleLike,
                        ),
                        Text(
                          '$_likeCount',
                          style: const TextStyle(color: Colors.white, fontSize: 12), // Reduced font size
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          'Bình luận',
                          style: TextStyle(color: Colors.white, fontSize: 12), // Reduced font size
                        ),
                        const SizedBox(width: 4), // Reduced spacing
                        const Icon(
                          Icons.chat_bubble_outline,
                          color: Colors.white,
                          size: 18, // Reduced icon size
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          'Chia sẻ',
                          style: TextStyle(color: Colors.white, fontSize: 12), // Reduced font size
                        ),
                        const SizedBox(width: 4), // Reduced spacing
                        const Icon(
                          Icons.share,
                          color: Colors.white,
                          size: 18, // Reduced icon size
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 4), // Reduced spacing
                for (String comment in _comments)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2), // Reduced spacing
                    child: Row(
                      children: [
                        const CircleAvatar(
                          backgroundImage: AssetImage('assets/user.png'),
                        ),
                        const SizedBox(width: 4), // Reduced spacing
                        Text(
                          comment,
                          style: const TextStyle(color: Colors.white, fontSize: 12), // Reduced font size
                        ),
                      ],
                    ),
                  ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _commentController,
                        style: const TextStyle(color: Colors.white, fontSize: 12), // Reduced font size
                        decoration: const InputDecoration(
                          hintText: 'Thêm bình luận...',
                          hintStyle: TextStyle(color: Colors.grey, fontSize: 12), // Reduced font size
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white, width: 1), // Reduced border width
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white, width: 1), // Reduced border width
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white, width: 1), // Reduced border width
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 18, // Reduced icon size
                      ),
                      onPressed: _addComment,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}