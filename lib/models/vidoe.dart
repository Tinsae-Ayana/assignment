class Vidoe {
  final String title;
  final String description;
  final String location;
  final String catagory;
  final String videoUrl;
  final List<dynamic> searchKeys;

  const Vidoe(
      {required this.title,
      required this.description,
      required this.videoUrl,
      required this.location,
      required this.catagory,
      required this.searchKeys});

  factory Vidoe.fromJson({required json}) {
    return Vidoe(
        title: json['title'].toString(),
        description: json['description'].toString(),
        location: json['location'].toString(),
        catagory: json['catagory'].toString(),
        videoUrl: json['vidoeUrl'].toString(),
        searchKeys: json['searchKeys']);
  }

  copyWith({title, description, location, catagory, videoUrl, searchKeys}) {
    return Vidoe(
        title: title ?? this.title,
        description: description ?? this.description,
        videoUrl: videoUrl ?? this.videoUrl,
        location: location ?? this.location,
        catagory: catagory ?? this.catagory,
        searchKeys: searchKeys ?? this.searchKeys);
  }
}
