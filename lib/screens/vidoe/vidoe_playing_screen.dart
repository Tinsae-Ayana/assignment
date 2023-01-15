import 'package:intern_assignment/models/vidoe.dart';
import 'package:flutter/material.dart';
import 'package:intern_assignment/screens/vidoe/search_screen.dart';
import 'package:intern_assignment/utils/constants.dart';
import 'package:video_player/video_player.dart';

class VidoePlayingScreen extends StatefulWidget {
  final Vidoe vidoe;
  const VidoePlayingScreen({super.key, required this.vidoe});

  @override
  State<VidoePlayingScreen> createState() => _VidoePlayingScreenState();
}

class _VidoePlayingScreenState extends State<VidoePlayingScreen> {
  late final VideoPlayerController _controller;

  @override
  void initState() {
    _controller = VideoPlayerController.network(widget.vidoe.videoUrl)
      ..initialize().then((_) {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    // FocusScope.of(context).unfocus();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: mobileBackgroundColor,
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          title: InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: ((context) => const SearchScreen())));
            },
            child: Center(
              child: Container(
                alignment: Alignment.center,
                height: 45,
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: const Color.fromARGB(255, 163, 159, 159))),
                child: const Text('Search videos',
                    style: TextStyle(color: Colors.white, fontSize: 14)),
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: height * 0.4,
                  child: _controller.value.isInitialized
                      ? AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller))
                      : const Center(child: CircularProgressIndicator()),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                        onPressed: () {
                          if (_controller.value.isPlaying) {
                            _controller.seekTo(_controller.value.position -
                                const Duration(seconds: 10));
                          }
                        },
                        icon:
                            const Icon(Icons.fast_rewind, color: Colors.white)),
                    IconButton(
                        onPressed: () {
                          if (_controller.value.isPlaying) {
                            _controller.seekTo(_controller.value.position +
                                const Duration(seconds: 10));
                          }
                        },
                        icon: const Icon(Icons.fast_forward,
                            color: Colors.white)),
                    IconButton(
                        onPressed: () {
                          if (_controller.value.isPlaying) {
                            _controller.pause();
                          }
                        },
                        icon: const Icon(Icons.pause, color: Colors.white)),
                    IconButton(
                        onPressed: () {
                          if (!_controller.value.isPlaying) {
                            _controller.play();
                          }
                        },
                        icon: const Icon(Icons.play_arrow, color: Colors.white))
                  ],
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: RichText(
                      text: TextSpan(
                          text: 'Vidoe title ',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          children: [
                        TextSpan(
                            style:
                                const TextStyle(fontWeight: FontWeight.normal),
                            text: widget.vidoe.title),
                      ])),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: RichText(
                      text: TextSpan(
                          text: 'Vidoe descrpiton ',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          children: [
                        TextSpan(
                            style:
                                const TextStyle(fontWeight: FontWeight.normal),
                            text: widget.vidoe.description),
                      ])),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: RichText(
                      text: TextSpan(
                          text: 'Vidoe Catagory ',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          children: [
                        TextSpan(
                            style:
                                const TextStyle(fontWeight: FontWeight.normal),
                            text: widget.vidoe.catagory),
                      ])),
                )
              ],
            ),
          ),
        ));
  }
}
