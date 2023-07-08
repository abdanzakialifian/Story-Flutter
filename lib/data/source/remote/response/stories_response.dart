import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
part 'stories_response.g.dart';

StoriesResponse storiesResponseFromJson(String str) =>
    StoriesResponse.fromJson(json.decode(str));

@JsonSerializable()
class StoriesResponse {
  bool? error;
  String? message;
  @JsonKey(name: "listStory")
  List<ListStoryResponse>? listStoryResponse;

  StoriesResponse({
    this.error,
    this.message,
    this.listStoryResponse,
  });

  factory StoriesResponse.fromJson(Map<String, dynamic> json) =>
      _$StoriesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$StoriesResponseToJson(this);
}

@JsonSerializable()
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
      _$ListStoryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ListStoryResponseToJson(this);
}
