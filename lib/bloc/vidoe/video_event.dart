part of 'video_bloc.dart';

abstract class VideoEvent extends Equatable {
  const VideoEvent();

  @override
  List<Object> get props => [];
}

class FileEvent extends VideoEvent {
  final File vidoeFile;
  const FileEvent({required this.vidoeFile});
}

class DescriptionEvent extends VideoEvent {
  final String description;
  const DescriptionEvent({required this.description});
}

class LocationEvent extends VideoEvent {
  final String location;
  const LocationEvent({required this.location});
}

class CatagoryEvent extends VideoEvent {
  final String catagory;
  const CatagoryEvent({required this.catagory});
}

class TitleEvent extends VideoEvent {
  final String title;
  const TitleEvent({required this.title});
}

class SearchKeyEvent extends VideoEvent {
  final String searchKey;
  const SearchKeyEvent({required this.searchKey});
}

class UploadingEvent extends VideoEvent {
  final VideoStatus isVidoeUploading;
  const UploadingEvent({required this.isVidoeUploading});
}

class VidoeFileThumnail extends VideoEvent {
  final Uint8List? vidoeFileThumnail;
  const VidoeFileThumnail({required this.vidoeFileThumnail});
}

class FeedVideoEvent extends VideoEvent {
  final List<Vidoe> videoFeed;
  const FeedVideoEvent({required this.videoFeed});
}

class FeedVideoThumnail extends VideoEvent {
  final List<File> vidoeFeedThunai;
  const FeedVideoThumnail({required this.vidoeFeedThunai});
}

class VidoeUploadEvent extends VideoEvent {}
