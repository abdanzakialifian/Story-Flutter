import 'dart:convert';

StoriesResponse storiesResponseFromJson(String str) =>
    StoriesResponse.fromJson(json.decode(str));

String storiesResponseToJson(StoriesResponse data) =>
    json.encode(data.toJson());

class StoriesResponse {
  bool? error;
  String? message;
  List<ListStoryResponse>? listStoryResponse;

  StoriesResponse({
    this.error,
    this.message,
    this.listStoryResponse,
  });

  factory StoriesResponse.fromJson(Map<String, dynamic> json) =>
      StoriesResponse(
        error: json["error"],
        message: json["message"],
        listStoryResponse: json["listStory"] == null
            ? []
            : List<ListStoryResponse>.from(
                json["listStory"]!.map((x) => ListStoryResponse.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "listStory": listStoryResponse == null
            ? []
            : List<dynamic>.from(listStoryResponse!.map((x) => x.toJson())),
      };
}

class ListStoryResponse {
  String? id;
  String? name;
  String? description;
  String? photoUrl;
  DateTime? createdAt;
  double? lat;
  double? lon;

  ListStoryResponse({
    this.id,
    this.name,
    this.description,
    this.photoUrl,
    this.createdAt,
    this.lat,
    this.lon,
  });

  factory ListStoryResponse.fromJson(Map<String, dynamic> json) =>
      ListStoryResponse(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        photoUrl: json["photoUrl"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        lat: json["lat"]?.toDouble(),
        lon: json["lon"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "photoUrl": photoUrl,
        "createdAt": createdAt?.toIso8601String(),
        "lat": lat,
        "lon": lon,
      };
}
