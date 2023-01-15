import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intern_assignment/bloc/vidoe/video_bloc.dart';
import 'package:intern_assignment/screens/vidoe/vidoe_playing_screen.dart';
import 'package:intern_assignment/utils/constants.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      appBar: _searchBar(context),
      body: StreamBuilder(
        stream: context.read<VideoBloc>().getSearchStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child:
                  Text('No search yet', style: TextStyle(color: Colors.white)),
            );
          } else {
            if (snapshot.hasData &&
                snapshot.data != null &&
                snapshot.data!.isNotEmpty) {
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: ((context, index) {
                    return ListTile(
                      onTap: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: ((context) => VidoePlayingScreen(
                                vidoe: snapshot.data![index]))));
                      },
                      title: Text(
                        snapshot.data![index].title,
                        style: const TextStyle(color: Colors.white),
                      ),
                      trailing: const Icon(
                        Icons.arrow_back_rounded,
                        color: Colors.white,
                      ),
                    );
                  }));
            } else {
              return const Center(
                child: Text('No search result',
                    style: TextStyle(color: Colors.white)),
              );
            }
          }
        },
      ),
    );
  }

  AppBar _searchBar(BuildContext context) {
    return AppBar(
      backgroundColor: mobileBackgroundColor,
      centerTitle: true,
      title: SizedBox(
        height: 45,
        child: TextField(
          onChanged: (value) {
            BlocProvider.of<VideoBloc>(context, listen: false)
                .search(searchKey: value);
          },
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white.withOpacity(0.1),
            focusColor: Colors.white.withOpacity(0.1),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white, width: 2.0),
              borderRadius: BorderRadius.circular(30),
            ),
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white, width: 2.0),
              borderRadius: BorderRadius.circular(30),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white, width: 2.0),
              borderRadius: BorderRadius.circular(30),
            ),
            hintText: 'search',
            hintStyle: const TextStyle(color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
