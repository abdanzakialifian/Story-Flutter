import 'package:flutter/material.dart';
import 'package:story_app/ui/component/shimmer_loading.dart';
import 'package:story_app/utils/constants.dart';
import 'package:story_app/utils/hexa_color.dart';

class ItemListStoryPlaceholder extends StatelessWidget {
  const ItemListStoryPlaceholder({Key? key}) : super(key: key);

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
                      const ShimmerLoading(
                        widget: CircleAvatar(
                          radius: 15,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      ShimmerLoading(
                        widget: Container(
                          decoration: BoxDecoration(
                            color: HexColor(Constants.colorLightGrey),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(6),
                            ),
                          ),
                          width: 60,
                          height: 15,
                        ),
                      ),
                    ],
                  ),
                  const ShimmerLoading(
                    widget: Icon(
                      Icons.more_horiz,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: ShimmerLoading(
                widget: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    color: HexColor(Constants.colorLightGrey),
                    height: 200,
                    width: double.infinity,
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      ShimmerLoading(
                        widget: Icon(
                          Icons.favorite_outline,
                        ),
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      ShimmerLoading(
                        widget: Icon(
                          Icons.mode_comment_outlined,
                        ),
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      ShimmerLoading(
                        widget: Icon(
                          Icons.share_outlined,
                        ),
                      ),
                    ],
                  ),
                  ShimmerLoading(
                    widget: Icon(
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
