import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intern_assignment/bloc/vidoe/video_bloc.dart';
import 'package:intern_assignment/utils/constants.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  late final TextEditingController descriptionController;
  late final TextEditingController titleController;
  late final TextEditingController catagoryController;
  recordVidoe(context) async {
    final ImagePicker picker = ImagePicker();
    final vidoe = await picker.pickVideo(source: ImageSource.camera);
    BlocProvider.of<VideoBloc>(context, listen: false)
        .add(FileEvent(vidoeFile: File(vidoe!.path)));
  }

  @override
  void initState() {
    descriptionController = TextEditingController();
    titleController = TextEditingController();
    catagoryController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    descriptionController.dispose();
    titleController.dispose();
    catagoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return BlocListener<VideoBloc, VideoState>(
      listener: (context, state) {
        if (state.isVideoUploading == VideoStatus.uploaded) {
          descriptionController.clear();
          titleController.clear();
          catagoryController.clear();
          showDialog(
              context: context, builder: ((context) => const OrderDialog()));
          context.read<VideoBloc>().add(
              const UploadingEvent(isVidoeUploading: VideoStatus.beforeupload));
        }
      },
      child: Scaffold(
          backgroundColor: mobileBackgroundColor,
          appBar: AppBar(
            backgroundColor: mobileBackgroundColor,
            leading: IconButton(
                onPressed: () {
                  recordVidoe(context);
                },
                icon: const Icon(
                  Icons.video_camera_back_outlined,
                )),
            title: const Text('Post video'),
            actions: [
              TextButton(
                  onPressed: () {
                    context.read<VideoBloc>().add(VidoeUploadEvent());
                  },
                  child: const Text('Share'))
            ],
          ),
          body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BlocBuilder<VideoBloc, VideoState>(
                        builder: ((context, state) {
                      return state.isVideoUploading == VideoStatus.inprogress
                          ? const SizedBox(
                              height: 2, child: LinearProgressIndicator())
                          : const SizedBox();
                    })),
                    const SizedBox(height: 3),
                    TextField(
                      controller: titleController,
                      onChanged: (value) {
                        BlocProvider.of<VideoBloc>(context, listen: false)
                            .add(TitleEvent(title: value));
                        BlocProvider.of<VideoBloc>(context, listen: false)
                            .add(SearchKeyEvent(searchKey: value));
                      },
                      style: const TextStyle(color: Colors.white),
                      autocorrect: true,
                      maxLines: 2,
                      decoration: const InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          hintStyle: TextStyle(color: Colors.white),
                          border: InputBorder.none,
                          hintText: 'video title'),
                    ),
                    TextField(
                      controller: descriptionController,
                      onChanged: (value) {
                        BlocProvider.of<VideoBloc>(context, listen: false)
                            .add(DescriptionEvent(description: value));
                      },
                      style: const TextStyle(color: Colors.white),
                      autocorrect: true,
                      maxLines: 2,
                      decoration: const InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          hintStyle: TextStyle(color: Colors.white),
                          border: InputBorder.none,
                          hintText: 'Write video description...'),
                    ),
                    TextField(
                      controller: catagoryController,
                      onChanged: (value) {
                        BlocProvider.of<VideoBloc>(context, listen: false)
                            .add(CatagoryEvent(catagory: value));
                      },
                      style: const TextStyle(color: Colors.white),
                      autocorrect: true,
                      maxLines: 2,
                      decoration: const InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          hintStyle: TextStyle(color: Colors.white),
                          border: InputBorder.none,
                          hintText: 'Catagory'),
                    ),
                    const SizedBox(height: 20),
                    BlocSelector<VideoBloc, VideoState, Uint8List?>(
                      selector: (state) {
                        return state.vidoeFileThumnail;
                      },
                      builder: (context, state) {
                        return Center(
                          child: SizedBox(
                              width: width * 0.9,
                              height: 0.4 * height,
                              child: state != null
                                  ? Image.memory(
                                      state,
                                      fit: BoxFit.cover,
                                    )
                                  : const SizedBox()),
                        );
                      },
                    )
                  ]))),
    );
  }
}

class OrderDialog extends StatelessWidget {
  const OrderDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: const Text('Your vidoe posted succesfully !'),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Ok'))
      ],
    );
  }
}
