import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/common/extensions/font_extension.dart';
import 'package:untitled/common/managers/ads/interstitial_manager.dart';
import 'package:untitled/common/widgets/my_cached_image.dart';
import 'package:untitled/localization/languages.dart';
import 'package:untitled/screens/feed_screen/feed_stories_controller.dart';
import 'package:untitled/screens/story_screen/create_story_screen/create_story_screen.dart';
import 'package:untitled/screens/story_screen/story_screen.dart';
import 'package:untitled/utilities/const.dart';

class FeedStoryScreen extends StatelessWidget {
  final FeedStoriesController controller;

  const FeedStoryScreen({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: cBG,
      height: 100,
      alignment: Alignment.centerLeft,
      child: GetBuilder<FeedStoriesController>(
        init: controller,
        builder: (controller) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                myCard(controller),
                ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.storyUsers.length,
                  itemBuilder: (context, index) {
                    final storyUser = controller.storyUsers[index];

                    return GestureDetector(
                      onTap: () {
                        Get.bottomSheet(
                          StoryScreen(
                            users: controller.storyUsers,
                            index: index,
                          ),
                          isScrollControlled: true,
                          ignoreSafeArea: false,
                        ).then((_) {
                          controller.fetchStories();
                        });
                      },
                      child: SizedBox(
                        width: 80,
                        height: 100, // ⭐ تثبيت الارتفاع
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: storyUser.isAllStoryShown() ? cLightText.withValues(alpha: 0.4) : cPrimary,
                                  width: 2,
                                ),
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(2),
                              child: MyCachedProfileImage(
                                imageUrl: storyUser.profile,
                                fullName: storyUser.fullName,
                                width: 56,
                                // 🔻 أصغر لمنع overflow
                                height: 56,
                                cornerRadius: 56,
                              ),
                            ),
                            const SizedBox(height: 4),
                            SizedBox(
                              width: 70,
                              child: Text(
                                storyUser.username ?? '',
                                maxLines: 1,
                                style: MyTextStyle.gilroyMedium(size: 13),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget myCard(FeedStoriesController controller) {
    final bool isAnyStory = controller.myUser.stories?.isNotEmpty ?? false;

    return GestureDetector(
      onTap: () {
        InterstitialManager.shared.loadAd();
        Get.bottomSheet(
          CreateStoryScreen(user: controller.myUser),
          isScrollControlled: true,
          ignoreSafeArea: false,
        ).then((_) {
          controller.fetchMyStories();
          InterstitialManager.shared.showAd();
        });
      },
      child: SizedBox(
        width: 90,
        height: 100, // ⭐ تثبيت الارتفاع
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isAnyStory ? (controller.myUser.isAllStoryShown() ? cLightText.withValues(alpha: 0.4) : cPrimary) : Colors.transparent,
                      width: 2,
                    ),
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(2),
                  child: MyCachedProfileImage(
                    imageUrl: controller.myUser.profile,
                    fullName: controller.myUser.fullName,
                    width: 56,
                    height: 56,
                    cornerRadius: 56,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    color: cWhite,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.add_circle,
                    color: cPrimary,
                    size: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              LKeys.you.tr,
              maxLines: 1,
              style: MyTextStyle.gilroyMedium(size: 13),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
