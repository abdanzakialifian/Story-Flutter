import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:story_app/data/source/remote/response/stories_response.dart';
import 'package:story_app/ui/component/safe_on_tap.dart';
import 'package:story_app/utils/constants.dart';
import 'package:story_app/utils/extensions.dart';
import 'package:story_app/utils/hexa_color.dart';

class ItemListStory extends StatelessWidget {
  final ListStoryResponse? listStoryResponse;
  final Function()? onIconClick;
  final Function(ListStoryResponse? listStoryResponse)? onImageClick;

  const ItemListStory(
      {Key? key, this.listStoryResponse, this.onIconClick, this.onImageClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 15,
                        backgroundImage:
                            AssetImage("avatar_story.jpg".getImageAssets()),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        listStoryResponse?.name?.capitalizeByWord() ?? "",
                        style:
                            const TextStyle(fontFamily: Constants.manjariBold),
                      ),
                    ],
                  ),
                  SafeOnTap(
                    onSafeTap: onIconClick,
                    child: const Icon(
                      Icons.more_horiz,
                    ),
                  ),
                ],
              ),
            ),
            SafeOnTap(
              onSafeTap: () => onImageClick?.call(listStoryResponse),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: listStoryResponse?.photoUrl ?? "",
                    placeholder: (context, url) => Container(
                      color: HexColor(Constants.colorLightGrey),
                    ),
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SafeOnTap(
                        onSafeTap: onIconClick,
                        child: const Icon(
                          Icons.favorite_outline,
                        ),
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      SafeOnTap(
                        onSafeTap: onIconClick,
                        child: const Icon(
                          Icons.mode_comment_outlined,
                        ),
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      SafeOnTap(
                        onSafeTap: onIconClick,
                        child: const Icon(
                          Icons.share_outlined,
                        ),
                      ),
                    ],
                  ),
                  SafeOnTap(
                    onSafeTap: onIconClick,
                    child: const Icon(
                      Icons.bookmark_outline,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
