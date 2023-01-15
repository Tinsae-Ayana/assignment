import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intern_assignment/bloc/vidoe/video_bloc.dart';
import 'package:intern_assignment/models/vidoe.dart';
import 'package:intern_assignment/utils/constants.dart';

class FeedCard extends StatelessWidget {
  final Vidoe video;

  const FeedCard({super.key, required this.video});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Card(
      color: mobileBackgroundColor,
      elevation: 10,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(context),
          GestureDetector(
            onDoubleTap: (() {}),
            child: FutureBuilder(
                future: context
                    .read<VideoBloc>()
                    .getThumnailFromUrl(video.videoUrl),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox(
                        height: height * 0.55,
                        width: double.infinity,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ));
                  } else {
                    return SizedBox(
                      height: height * 0.55,
                      width: double.infinity,
                      child: Image.memory(
                        snapshot.data!,
                        fit: BoxFit.cover,
                      ),
                    );
                  }
                }),
          ),
          _descriptionView(context),
          // const Text(
          //   'the post time goes here',
          //   // post.publishedDate.difference(DateTime.now()).inDays >= 30
          //   //     ? post.publishedDate.toString().substring(1, 10)
          //   //     : DateTime.now().difference(post.publishedDate).inHours >= 24
          //   //         ? "${DateTime.now().difference(post.publishedDate).inDays.toString()} days ago"
          //   //         : "${DateTime.now().difference(post.publishedDate).inHours} hours ago",
          //   style: TextStyle(fontSize: 15, color: Colors.white),
          // ),
          const Divider(
            color: Colors.white24,
          )
        ],
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(video.title,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
        Text(
          video.location,
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ]),
    );
  }

  Widget _descriptionView(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 2),
            child: RichText(
              text: TextSpan(
                  style: const TextStyle(color: Colors.black),
                  children: [
                    TextSpan(
                      style: const TextStyle(color: Colors.white),
                      text: video.description,
                    ),
                  ]),
            ),
          )
        ],
      ),
    );
  }
}
