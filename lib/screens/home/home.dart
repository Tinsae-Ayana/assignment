import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intern_assignment/bloc/vidoe/video_bloc.dart';
import 'package:intern_assignment/screens/vidoe/post_screen.dart';
import 'package:intern_assignment/screens/vidoe/search_screen.dart';
import 'package:intern_assignment/screens/vidoe/vidoe_playing_screen.dart';
import 'package:intern_assignment/utils/constants.dart';
import 'package:intern_assignment/widget/feed_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      body: IndexedStack(
        index: currentIndex,
        children: const [FeedScreen(), PostScreen()],
      ),
      bottomNavigationBar: BottomNavigationBar(
          onTap: (value) {
            setState(() {
              currentIndex = value;
            });
          },
          backgroundColor: mobileBackgroundColor,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white30,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.feed), label: 'Feed'),
            BottomNavigationBarItem(icon: Icon(Icons.add_box), label: 'Feed')
          ]),
    );
  }
}

class FeedScreen extends StatelessWidget {
  const FeedScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint(context.read<VideoBloc>().state.location);
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            InkWell(
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
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
            const SizedBox(height: 30),
            LimitedBox(
              maxHeight: MediaQuery.of(context).size.height * 0.7,
              child:
                  BlocBuilder<VideoBloc, VideoState>(builder: (context, state) {
                return state.videoFeed != []
                    ? ListView.builder(
                        itemCount: state.videoFeed.length,
                        itemBuilder: ((context, index) {
                          return InkWell(
                            onTap: (() {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: ((context) => VidoePlayingScreen(
                                      vidoe: state.videoFeed[index]))));
                            }),
                            child: FeedCard(
                              video: state.videoFeed[index],
                            ),
                          );
                        }))
                    : const Center(
                        child: Text('No vidoe is posted yet',
                            style: TextStyle(color: Colors.white)));
              }),
            )
          ],
        ),
      ),
    );
  }
}
