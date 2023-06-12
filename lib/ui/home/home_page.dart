import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:story_app/data/source/remote/response/stories_response.dart';
import 'package:story_app/ui/component/button_state.dart';
import 'package:story_app/ui/component/item_list_story_placeholder.dart';
import 'package:story_app/ui/component/safe_on_tap.dart';
import 'package:story_app/ui/home/home_view_model.dart';
import 'package:story_app/ui/component/item_list_story.dart';
import 'package:story_app/utils/common.dart';
import 'package:story_app/utils/constants.dart';
import 'package:story_app/utils/extensions.dart';
import 'package:story_app/utils/hexa_color.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const _pageSize = 10;
  int presscount = 0;

  final PagingController<int, ListStoryResponse> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchData(pageKey);
    });
    context.read<HomeViewModel>().saveStateLogin(true);
    super.initState();
  }

  void _fetchData(int pageKey) async {
    try {
      final storyResponse =
          await HomeViewModel().getAllStories(pageKey, _pageSize);
      final listStoryResponse = storyResponse.listStoryResponse;
      final isLastPage = (listStoryResponse?.length ?? 0) < _pageSize;

      if (isLastPage) {
        _pagingController.appendLastPage(listStoryResponse ?? []);
      } else {
        final nextPageKey = pageKey += 1;
        _pagingController.appendPage(listStoryResponse ?? [], nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onBackButtonPressed,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Hero(
                            tag: Constants.appName,
                            child: Text(
                              AppLocalizations.of(context)?.story_app ?? "",
                              style: const TextStyle(
                                fontSize: 20,
                                fontFamily: Constants.manjariBold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SafeOnTap(
                      onSafeTap: () => context.push(Constants.profilePage),
                      child: Hero(
                        tag: Constants.avatar,
                        child: CircleAvatar(
                          radius: 20,
                          backgroundImage:
                              AssetImage("avatar_profile.jpg".getImageAssets()),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: Center(
                    child: RefreshIndicator(
                      notificationPredicate: (_) =>
                          (_pagingController.itemList?.isNotEmpty == true)
                              ? true
                              : false,
                      color: HexColor(Constants.colorDarkBlue),
                      backgroundColor: Colors.white,
                      onRefresh: () => Future.sync(
                        () => _pagingController.refresh(),
                      ),
                      child: PagedListView<int, ListStoryResponse>(
                        shrinkWrap: true,
                        pagingController: _pagingController,
                        builderDelegate:
                            PagedChildBuilderDelegate<ListStoryResponse>(
                          firstPageProgressIndicatorBuilder: (_) =>
                              ListView.builder(
                            shrinkWrap: true,
                            itemCount: 10,
                            itemBuilder: (_, index) =>
                                const ItemListStoryPlaceholder(),
                          ),
                          newPageProgressIndicatorBuilder: (_) => Padding(
                            padding: const EdgeInsets.all(18),
                            child: SizedBox(
                              height: 40,
                              width: 40,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: HexColor(Constants.colorDarkBlue),
                                ),
                              ),
                            ),
                          ),
                          noItemsFoundIndicatorBuilder: (_) => Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Lottie.asset(
                                "assets/animations/empty_list.json",
                                height: 300,
                              ),
                              Text(
                                AppLocalizations.of(context)?.data_not_found ??
                                    "",
                                style: const TextStyle(
                                  fontFamily: Constants.manjariBold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              ButtonState(
                                textButton: AppLocalizations.of(context)?.retry,
                                widthButton: 180,
                                onButtonPressed: () =>
                                    _pagingController.refresh(),
                              )
                            ],
                          ),
                          itemBuilder: (context, item, _) {
                            return ItemListStory(
                              listStoryResponse: item,
                              onIconClick: () {
                                AppLocalizations.of(context)
                                    ?.fitur_coming_soon
                                    .showSnackbar(context);
                              },
                              onImageClick: (listStoryResponse) {
                                context.push(Constants.detailPage,
                                    extra: listStoryResponse);
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> onBackButtonPressed() async {
    presscount++;
    if (presscount == 2) {
      if (Platform.isIOS) {
        exit(0);
      } else {
        SystemNavigator.pop();
      }
      return false;
    } else {
      AppLocalizations.of(context)?.message_exit_app.showSnackbar(context);
      return false;
    }
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
