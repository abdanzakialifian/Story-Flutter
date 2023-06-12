import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:story_app/data/source/remote/response/stories_response.dart';
import 'package:story_app/ui/component/safe_on_tap.dart';
import 'package:story_app/utils/common.dart';
import 'package:story_app/utils/constants.dart';
import 'package:story_app/utils/extensions.dart';
import 'package:story_app/utils/function.dart';
import 'package:story_app/utils/hexa_color.dart';

class BottomSheetDetail extends StatelessWidget {
  final ListStoryResponse? listStoryResponse;
  final Function()? onIconCloseClick;

  const BottomSheetDetail(
      {Key? key, this.listStoryResponse, this.onIconCloseClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          listStoryResponse?.name?.capitalizeByWord() ?? "",
                          style: const TextStyle(
                              fontFamily: Constants.manjariBold),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          "${AppLocalizations.of(context)?.created} ${dateFormat(listStoryResponse?.createdAt?.toString())}",
                          style: const TextStyle(fontSize: 12),
                        )
                      ],
                    ),
                  ],
                ),
                SafeOnTap(
                  onSafeTap: onIconCloseClick,
                  child: const Icon(Icons.close),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            ClipRRect(
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
            const SizedBox(
              height: 20,
            ),
            Text(
              AppLocalizations.of(context)?.description ?? "",
              style: const TextStyle(fontFamily: Constants.manjariBold),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(listStoryResponse?.description ?? "")
          ],
        ),
      ),
    );
  }
}
