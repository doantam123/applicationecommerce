import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubePlayerCustomSubtitle extends StatefulWidget {
  final String videoId = '_-Tucg4HIU4';
  const YoutubePlayerCustomSubtitle({super.key});

  @override
  State<YoutubePlayerCustomSubtitle> createState() =>
      _YoutubePlayerCustomSubtitleState();
}

class Subtitle {
  final int start;
  final int end;
  final String text;
  Subtitle({required this.start, required this.end, required this.text});
}

class _YoutubePlayerCustomSubtitleState
    extends State<YoutubePlayerCustomSubtitle> {
  late YoutubePlayerController _controller;
  List<Subtitle> subtitleList = [
    Subtitle(start: 0, end: 20, text: "Hướng Dẫn Đăng Nhập"),
    Subtitle(start: 20, end: 42, text: "Hướng Dẫn Tìm Kiếm Món Ăn"),
    Subtitle(start: 43, end: 72, text: "Hướng Dẫn Mua Hàng"),
    Subtitle(start: 73, end: 84, text: "Hướng Dẫn Xem Hóa Đơn"),
    Subtitle(start: 84, end: 99, text: "Hướng Dẫn Đánh Giá"),
    Subtitle(start: 99, end: 119, text: "Hướng Dẫn Xem Thông Tin Cá Nhân"),
    Subtitle(start: 119, end: 140, text: "Hướng Dẫn Nhắn Tin AI Tư Vấn"),
  ];
  String currentSubtitleText = "";
  bool isFullscreen = false;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(autoPlay: true, mute: false),
    )..addListener(_onPlayerStateChange);
  }

  void _onPlayerStateChange() {
    if (_controller.value.isFullScreen) {
      setState(() {
        isFullscreen = true;
      });
    } else {
      setState(() {
        isFullscreen = false;
      });
    }

    if (_controller.value.playerState == PlayerState.playing) {
      final currentTime = _controller.value.position.inSeconds;
      final currentSubtitle = subtitleList.firstWhere(
        (subtitle) =>
            currentTime >= subtitle.start && currentTime <= subtitle.end,
        orElse: () => Subtitle(
            start: 0,
            end: 0,
            text:
                ''), // Trả về một Subtitle mặc định nếu không tìm thấy phần tử
      );

      setState(() {
        currentSubtitleText = currentSubtitle.text;
      });
    }
  }

  Widget _buildSubtitleButton(
      BuildContext context, String displayTime, String text, int startTime) {
    return ElevatedButton(
      onPressed: () {
        _controller.seekTo(Duration(seconds: startTime));
        setState(() {
          currentSubtitleText = text;
        });
      },
      style: ElevatedButton.styleFrom(
        // ignore: deprecated_member_use
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 241, 97, 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Icon(
            Icons.skip_next_outlined,
            // Đặt kích thước icon theo ý muốn
            size: 24,
          ),
          const SizedBox(width: 8), // Khoảng cách giữa icon và chữ
          Text(
            text,
            textAlign: TextAlign.left, // Căn lề trái cho chữ
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isFullscreen
          ? null
          : AppBar(
              iconTheme: IconThemeData(
                color: Colors.black, //change your color here
              ),
              title: Text("Hướng Dẫn Sử Dụng"),
              centerTitle: true,
            ),
      body: Stack(
        children: [
          YoutubePlayer(controller: _controller),
          // if (!isFullscreen)
          //   Padding(
          //     padding: const EdgeInsets.only(left: 10, top: 250),
          //     child: Text(
          //       currentSubtitleText,
          //       style: const TextStyle(
          //           fontSize: 16, color: Color.fromARGB(255, 241, 97, 0)),
          //     ),
          //   ),
          if (!isFullscreen)
            Positioned(
              left: 100,
              top: 280,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.replay_5,
                      size: 64,
                    ),
                    onPressed: () {
                      _controller.seekTo(Duration(
                          seconds: _controller.value.position.inSeconds - 5));
                    },
                  ),
                  const SizedBox(width: 46),
                  IconButton(
                    icon: const Icon(
                      Icons.forward_5,
                      size: 64,
                    ),
                    onPressed: () {
                      _controller.seekTo(Duration(
                          seconds: _controller.value.position.inSeconds + 5));
                    },
                  ),
                ],
              ),
            ),
          if (!isFullscreen) // Kiểm tra chế độ toàn màn hình
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  children: [
                    for (final subtitle in subtitleList)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: _buildSubtitleButton(
                          context,
                          formatTime(subtitle.start),
                          subtitle.text,
                          subtitle.start,
                        ),
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  String formatTime(int seconds) {
    int minute = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    String formattedTime =
        "${minute.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}";
    return formattedTime;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
