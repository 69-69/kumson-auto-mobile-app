import 'package:automasters/utils/avatar_glow.dart';
import 'package:automasters/utils/size_config.dart';
import 'package:automasters/widgets/async_progress_dialog.dart';
import 'package:automasters/widgets/developer_info.dart';
import 'package:flutter/material.dart';

class SplashScreenTemplate extends StatefulWidget {
  final String? label;
  const SplashScreenTemplate({this.label, Key? key}) : super(key: key);

  @override
  State<SplashScreenTemplate> createState() => _SplashScreenTemplateState();
}

class _SplashScreenTemplateState extends State<SplashScreenTemplate>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 10),
    vsync: this,
  )..repeat(reverse: true);

  final Tween<double> turnsTween = Tween<double>(
    begin: 1,
    end: 0,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final customTheme = Theme.of(context);
    return Scaffold(
      backgroundColor: customTheme.scaffoldBackgroundColor,
      body: Center(
        child: SizedBox(
          width: getProportionateScreenWidth(400),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  clipBehavior: Clip.none,
                  children: [
                    AvatarGlow(
                      wrapChild: true,
                      endRadius: 90,
                      duration: const Duration(seconds: 2),
                      glowColor: customTheme.colorScheme.primary,
                      repeat: true,
                      repeatPauseDuration: const Duration(microseconds: 2),
                      startDelay: const Duration(seconds: 1),
                      child: RotationTransition(
                        turns: turnsTween.animate(_controller),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.asset(
                            'assets/logo.png',
                            fit: BoxFit.scaleDown,
                            scale: 1,
                          ),
                        ),
                      ),
                    ),
                    AsyncProgressDialog(
                      null,
                      isDialog: false,
                      size: 100,
                      strokeWidth: 6.0,
                      bgColor: Theme.of(context).colorScheme.inversePrimary,
                      strokeCap: StrokeCap.butt,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 135.0),
                      child: Text(
                        widget.label ?? "Getting AutoMasters ready",
                        style: TextStyle(
                            color: customTheme.colorScheme.primary,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              const DeveloperInfo(),
            ],
          ),
        ),
      ),
    );
  }
}
