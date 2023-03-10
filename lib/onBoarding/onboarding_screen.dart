import 'package:book_recommend/onBoarding/components/main_content.dart';
import 'package:book_recommend/onBoarding/components/skip_button.dart';
import 'package:book_recommend/onBoarding/components/steps_container.dart';
import 'package:book_recommend/onBoarding/config/size_config.dart';
import 'package:book_recommend/onBoarding/onboarding_model.dart';
import 'package:book_recommend/screens/welcome.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  static String id = 'OnboardingScreen';
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  List<OnboardingModel> _list = OnboardingModel.list;
  int page = 0;
  var _controller = PageController();
  var showAnimatedContainer = false;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    _controller.addListener(() {
      setState(() {
        page = _controller.page.round();
      });
    });
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                SkipButton(),
                Expanded(
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: _list.length,
                    itemBuilder: (context, index) => MainContent(
                      list: _list,
                      index: index,
                    ),
                  ),
                ),
                StepsContainer(
                  page: page,
                  list: _list,
                  controller: _controller,
                  showAnimatedContainerCallBack: (value) {
                    setState(
                      () {
                        showAnimatedContainer = value;
                        if (value) {
                          Future.delayed(
                            Duration(milliseconds: 0),
                            () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WelcomeScreen(),
                                ),
                              );
                            },
                          );
                        }
                      },
                    );
                  },
                ),
                SizedBox(
                  height: SizeConfig.defaultSize * 4,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
