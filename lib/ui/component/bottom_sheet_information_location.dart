import 'package:flutter/material.dart';
import 'package:story_app/data/source/local/location_information.dart';
import 'package:story_app/utils/common.dart';
import 'package:story_app/utils/constants.dart';
import 'package:story_app/utils/extensions.dart';
import 'package:story_app/utils/function.dart';

class BottomSheetInformationLocation extends StatelessWidget {
  final String? userName;
  final DateTime? createdAt;
  final List<LocationInformation>? listLocationInformation;

  const BottomSheetInformationLocation({
    Key? key,
    this.userName,
    this.createdAt,
    this.listLocationInformation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName?.capitalizeByWord() ?? "",
                        style: const TextStyle(
                          fontFamily: Constants.manjariBold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Text(
                        "${AppLocalizations.of(context)?.created} ${dateFormat(createdAt?.toString())}",
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage(
                      "avatar_story.jpg".getImageAssets(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        listLocationInformation?[index].title ?? "-",
                        style: const TextStyle(
                          fontFamily: Constants.manjariBold,
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      IntrinsicHeight(
                        child: Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 20,
                              color: Colors.red,
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                listLocationInformation?[index].subTitle ?? "-",
                                style: const TextStyle(
                                    fontFamily: Constants.manjariBold,
                                    fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: 20,
                  );
                },
                itemCount: listLocationInformation?.length ?? 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
