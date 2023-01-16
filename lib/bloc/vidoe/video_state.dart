part of 'video_bloc.dart';

enum VideoStatus { inprogress, uploaded, beforeupload }

class VideoState extends Equatable {
  final File? vidoeFile;
  final Uint8List? vidoeFileThumnail;
  final String description;
  final String title;
  final String location;
  final List<String> searchKeys;
  final String catagory;
  final VideoStatus isVideoUploading;
  final List<Vidoe> videoFeed;

  const VideoState(
      {required this.title,
      required this.vidoeFileThumnail,
      required this.videoFeed,
      required this.vidoeFile,
      required this.searchKeys,
      required this.description,
      required this.location,
      required this.catagory,
      required this.isVideoUploading});
  @override
  List<Object?> get props => [
        vidoeFile,
        description,
        location,
        title,
        catagory,
        searchKeys,
        isVideoUploading,
        videoFeed,
        vidoeFileThumnail
      ];

  copyWith(
      {vidoeFile,
      description,
      title,
      location,
      catagory,
      isVideoUploading,
      videoFeed,
      vidoeFileThumnail,
      clearThumnail,
      searchKeys}) {
    return VideoState(
        videoFeed: videoFeed ?? this.videoFeed,
        vidoeFileThumnail: (vidoeFileThumnail == null && clearThumnail == true)
            ? null
            : clearThumnail == false
                ? vidoeFileThumnail
                : this.vidoeFileThumnail,
        title: title ?? this.title,
        searchKeys: searchKeys ?? this.searchKeys,
        vidoeFile: vidoeFile ?? this.vidoeFile,
        description: description ?? this.description,
        location: location ?? this.location,
        catagory: catagory ?? this.catagory,
        isVideoUploading: isVideoUploading ?? this.isVideoUploading);
  }
}
