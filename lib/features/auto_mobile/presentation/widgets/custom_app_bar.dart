import 'package:automasters/features/auto_mobile/presentation/widgets/appbar_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:automasters/features/auto_mobile/presentation/pages/bottom_sheet/make_a_request_modal.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/question_button.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/animation_switcher.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/fade_slide.dart';
import 'package:automasters/features/auto_mobile/data/models/animation_item.dart';
import 'package:automasters/features/auto_mobile/data/models/custom_appbar.dart';
import 'package:automasters/features/auto_mobile/presentation/widgets/page_navigator.dart';
import 'package:string_capitalize/string_capitalize.dart';

class CustomSliverAppBar extends StatefulWidget {
  final CustomAppBarModel data;

  const CustomSliverAppBar({super.key, required this.data});

  @override
  State<CustomSliverAppBar> createState() => _CustomSliverAppBarState();
}

class _CustomSliverAppBarState extends State<CustomSliverAppBar>
    with SingleTickerProviderStateMixin {
  // Animation setups
  late AnimationController animationController;
  List<AnimationItem> animationItems = [];
  late Animation animation;
  bool switchToBgImage = false;

  @override
  void initState() {
    super.initState();

    createAnimation();

    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void createAnimation() {
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    for (int i = 0; i < 10; i++) {
      animationItems.add(
        AnimationItem(
          id: "slide-${i + 1}",
          entry: 30 * (i + 1),
          entryDuration: 250,
          visible: false,
        ),
      );
    }
    animation = Tween<double>(begin: 0, end: 300).animate(animationController)
      ..addListener(() {
        setState(() {
          animationItems = updateVisibleState(
            animationItems,
            animation.value,
          );
        });
      });
    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return _buildSliverAppBar(context, widget.data);
  }

  SliverAppBar _buildSliverAppBar(
          BuildContext context, CustomAppBarModel model) =>
      buildSliverAppBars(
        context,
        expandedHeight: model.expandedHeight ?? 250,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildBackButton(
              context,
              routeName: model.routeName,
              arguments: model.arguments,
            ),
            buildQuestionButton(
              context,
              color: Colors.white,
              bgColor: Colors.transparent,
              onPress: () => showRequestModal(context, model.currentScreen),
            ),
          ],
        ),
        FlexibleSpaceBar(
          centerTitle: true,
          background: model.imageUrl.isNotEmpty && !switchToBgImage
              ? AppBarVideoPlayer(videoUrl: model.videoUrl)
              : _buildImage(model.imageUrl),
          title: _buildTitle(model.title, model.subTitle),
          collapseMode: CollapseMode.pin,
        ),
        preferredSize: _buildSubMiniTitle(model.subMiniTitle, context),
      );

  SliverAppBar buildSliverAppBars(
    BuildContext context,
    Widget flexibleSpace, {
    required double expandedHeight,
    required Widget title,
    bool primary = true,
    bool pinned = true,
    bool floating = false,
    bool centerTitle = true,
    PreferredSizeWidget? preferredSize,
  }) {
    return SliverAppBar(
      primary: primary,
      //scrolledUnderElevation: 50.0,
      elevation: 0.0,
      pinned: pinned,
      floating: floating,
      title: title,
      centerTitle: centerTitle,
      expandedHeight: expandedHeight,
      leadingWidth: 80,
      // leading: backButton,
      automaticallyImplyLeading: false,
      flexibleSpace: flexibleSpace,
      bottom: preferredSize,
      // backgroundColor: Theme.of(context).colorScheme.primary,
      /*shape: const ContinuousRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
            ),*/
    );
  }

  Container _buildImage(String imageUrl) => Container(
        margin: const EdgeInsets.only(top: 50),
        child: buildAnimatedSwitcher(Image.asset(imageUrl), animationItems),
      );

  _buildTitle(String title, String subTitle) => title.isNotEmpty
      ? Container(
          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 3.0),
          margin: const EdgeInsets.only(bottom: 12.0),
          decoration: const BoxDecoration(
            color: Color.fromRGBO(0, 0, 0, 0.3),
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(15.0),
                topLeft: Radius.circular(15.0)),
          ),
          child: FadeSlide(
            direction: getItemVisibility("slide-2", animationItems),
            duration: getSlideDuration("slide-2", animationItems),
            offsetY: 60.0,
            offsetX: 0.0,
            child: _buildRichText(title, subTitle),
          ),
        )
      : const SizedBox.shrink();

  _buildRichText(String title, String subTitle) {
    final title0 = subTitle.isEmpty ? title : "$title\n";

    return SelectableText.rich(
      textAlign: TextAlign.center,
      TextSpan(
        text: title0.capitalizeEach(),
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 13.0,
          color: Color(0xFFFFFFFF),
          overflow: TextOverflow.ellipsis,
        ),
        children: [
          TextSpan(
            text: subTitle.capitalizeEach(),
            style: const TextStyle(
              height: 1,
              fontSize: 12.0,
              color: Colors.white70,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  PreferredSize _buildSubMiniTitle(String text, BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return PreferredSize(
      preferredSize: const Size.fromHeight(0.0),
      child: Transform.translate(
        offset: const Offset(0, 20),
        child: _floatingActionButton(color, text),
      ),
    );
  }

  FloatingActionButton _floatingActionButton(Color color, String text) {
    return FloatingActionButton.extended(
      extendedPadding: const EdgeInsets.symmetric(horizontal: 5),
      backgroundColor: color.withOpacity(0.6),
      extendedIconLabelSpacing: 3.0,
      icon: Icon(
        switchToBgImage
            ? CupertinoIcons.video_camera_solid
            : CupertinoIcons.camera,
        color: Colors.white,
      ),
      label: Text(
        text.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      onPressed: () => setState(() => switchToBgImage = !switchToBgImage),
    );
  }
}
