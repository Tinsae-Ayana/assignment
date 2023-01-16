import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:geocode/geocode.dart';
import 'package:geolocator/geolocator.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:intern_assignment/models/vidoe.dart';

part 'video_event.dart';
part 'video_state.dart';

class VideoBloc extends Bloc<VideoEvent, VideoState> {
  final searchStream = StreamController<List<Vidoe>>.broadcast();
  VideoBloc()
      : super(const VideoState(
            videoFeed: [],
            vidoeFileThumnail: null,
            searchKeys: [],
            title: '',
            vidoeFile: null,
            description: '',
            location: '',
            catagory: '',
            isVideoUploading: VideoStatus.beforeupload)) {
    on<FileEvent>(_onFileEvent);
    on<DescriptionEvent>(_onDescriptionEvent);
    on<LocationEvent>(_onLocationEvent);
    on<CatagoryEvent>(_onCatagorEvent);
    on<UploadingEvent>(_onUploadingEvent);
    on<VidoeUploadEvent>(_onVidoeUpLoadEvent);
    on<TitleEvent>(_onTitleEvent);
    on<SearchKeyEvent>(_onSearchKeyEvent);
    on<VidoeFileThumnail>(_onVidoeFileThumnail);
    on<FeedVideoEvent>(_onFeedVidoeEvent);
    // on<FeedVideoThumnail>(_onFeedVideoThumnail);
    initiateFeedVideo();
  }

  _onFileEvent(FileEvent event, emit) async {
    emit(state.copyWith(vidoeFile: event.vidoeFile));
    final thumnail = await getThumnaillofVidoe(event.vidoeFile);
    add(VidoeFileThumnail(vidoeFileThumnail: thumnail));
  }

  _onVidoeFileThumnail(VidoeFileThumnail event, emit) async {
    if (event.vidoeFileThumnail == null) {
      emit(state.copyWith(
          vidoeFileThumnail: event.vidoeFileThumnail, clearThumnail: true));
    } else {
      emit(state.copyWith(
          vidoeFileThumnail: event.vidoeFileThumnail, clearThumnail: false));
    }
  }

  _onDescriptionEvent(DescriptionEvent event, emit) {
    emit(state.copyWith(description: event.description));
  }

  _onLocationEvent(LocationEvent event, emit) {
    emit(state.copyWith(location: event.location));
  }

  _onCatagorEvent(CatagoryEvent event, emit) {
    emit(state.copyWith(catagory: event.catagory));
  }

  _onTitleEvent(TitleEvent event, emit) {
    emit(state.copyWith(title: event.title));
  }

  _onUploadingEvent(UploadingEvent event, emit) {
    emit(state.copyWith(isVideoUploading: event.isVidoeUploading));
  }

  _onFeedVidoeEvent(FeedVideoEvent event, emit) {
    emit(state.copyWith(videoFeed: event.videoFeed));

    // getFeedThumnail(event.videoFeed).then((value) {
    //   add(FeedVideoThumnail(vidoeFeedThunai: value));
    // });
  }

  // _onFeedVideoThumnail(FeedVideoThumnail event, emit) {
  //   emit(state.copyWith(vidoeFeedThumnai: event.vidoeFeedThunai));
  // }

  _onSearchKeyEvent(SearchKeyEvent event, emit) {
    List<String> searchKeys = List.from(state.searchKeys)..add(event.searchKey);
    emit(state.copyWith(searchKeys: searchKeys));
  }

  //upload vidoe with all it's content
  _onVidoeUpLoadEvent(VidoeUploadEvent event, emit) async {
    if (state.catagory.isNotEmpty &&
        state.description.isNotEmpty &&
        state.vidoeFile != null &&
        state.title.isNotEmpty) {
      add(const UploadingEvent(isVidoeUploading: VideoStatus.inprogress));
      await getCurrentPosition();

      final ref = FirebaseStorage.instance
          .ref()
          .child(FirebaseAuth.instance.currentUser!.uid)
          .child(state.title);
      await ref.putFile(state.vidoeFile!);
      final link = await ref.getDownloadURL();
      FirebaseFirestore.instance.collection('posts').doc().set({
        'title': state.title,
        'description': state.description,
        'location': state.location,
        'catagory': state.catagory,
        'vidoeUrl': link,
        'searchKeys': state.searchKeys
      });
      add(const UploadingEvent(isVidoeUploading: VideoStatus.uploaded));
      add(const VidoeFileThumnail(vidoeFileThumnail: null));
    }
  }

  initiateFeedVideo() {
    FirebaseFirestore.instance
        .collection('posts')
        .snapshots()
        .map((event) =>
            event.docs.map((e) => Vidoe.fromJson(json: e.data())).toList())
        .listen((event) {
      add(FeedVideoEvent(videoFeed: event));
    });
  }

// methods related to search
  search({required String searchKey}) async {
    final searchResult = await FirebaseFirestore.instance
        .collection('posts')
        .where('searchKeys', arrayContains: searchKey)
        .get();
    final data = searchResult.docs.map((e) {
      return Vidoe.fromJson(json: e.data());
    }).toList();
    searchStream.sink.add(data);
  }

  Stream<List<Vidoe>> getSearchStream() {
    return searchStream.stream;
  }

  // get geographical location of the phone

  getCurrentPosition() async {
    final LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      await Geolocator.requestPermission();
    }
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    final location = GeoCode();
    final data = await location.reverseGeocoding(
      latitude: position.latitude,
      longitude: position.longitude,
    );
    add(LocationEvent(location: data.countryName!));
  }

  // creating thumnail of a video
  Future<Uint8List?> getThumnaillofVidoe(File? file) async {
    if (file != null) {
      final memoryFile = await VideoThumbnail.thumbnailData(
          video: file.path, imageFormat: ImageFormat.PNG);

      return memoryFile;
    } else {
      return null;
    }
  }

  Future<Uint8List> getThumnailFromUrl(String url) async {
    final fileName = await VideoThumbnail.thumbnailData(
      video: url,
      imageFormat: ImageFormat.WEBP,
      maxHeight: 64,
      quality: 75,
    );

    return fileName!;
  }

  // Future<List<File>> getFeedThumnail(List<Vidoe> videos) async {
  //   final List<Future<String>> list = [];
  //   for (var vidoe in videos) {
  //     list.add(getThumnailFromUrl(vidoe.videoUrl));
  //   }
  //   final listString = await Future.wait(list);
  //   return listString.map((e) => File(e)).toList();
  // }
}
