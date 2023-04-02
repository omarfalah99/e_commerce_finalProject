import 'package:flutter/material.dart';
import 'package:flutter_onboard/flutter_onboard.dart';

import 'welcome_screen.dart';

class OnboardScreen extends StatelessWidget {
  final PageController _pageController = PageController();

  OnboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void onNextTap(OnBoardState onBoardState) {
      if (!onBoardState.isLastPage) {
        _pageController.animateToPage(
          onBoardState.page + 1,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOutSine,
        );
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return LoginScreen();
        }));
      }
    }

    return Scaffold(
      body: OnBoard(
        pageController: _pageController,
        onBoardData: onBoardData,
        titleStyles: const TextStyle(
          color: Colors.black,
          fontSize: 22,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.15,
        ),
        descriptionStyles: const TextStyle(
          fontSize: 16,
          color: Colors.grey,
        ),
        pageIndicatorStyle: const PageIndicatorStyle(
          width: 70,
          inactiveColor: Colors.deepOrangeAccent,
          activeColor: Colors.deepOrange,
          inactiveSize: Size(8, 8),
          activeSize: Size(12, 12),
        ),
        skipButton: TextButton(
          onPressed: () {
            _pageController.animateToPage(
              2,
              duration: const Duration(microseconds: 250),
              curve: Curves.easeInOutSine,
            );
          },
          child: const Text(
            "Skip",
            style: TextStyle(color: Colors.black),
          ),
        ),
        nextButton: OnBoardConsumer(
          builder: (context, ref, child) {
            final state = ref.watch(onBoardStateProvider);
            return InkWell(
              onTap: () => onNextTap(state),
              child: Container(
                width: 230,
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: const LinearGradient(
                    colors: [Color.fromRGBO(246, 121, 82, 1), Colors.redAccent],
                  ),
                ),
                child: Text(
                  state.isLastPage ? "Get Started" : "Next",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

final List<OnBoardModel> onBoardData = [
  const OnBoardModel(
    title: "Choose Products",
    description: "A product is the item offered for sale."
        "A product can be a service or an item. It can be"
        "physical or in virtual or cyber form",
    imgUrl: "assets/first.png",
  ),
  const OnBoardModel(
    title: "Make Payment",
    description: "Payment is the transfer of money"
        "services in exchange product or Payments typically made terms agreed ",
    imgUrl: 'assets/second.png',
  ),
  const OnBoardModel(
    title: "Get Your Order",
    description: "Business or commerce an order is a stated"
        "intention either spoken to engage in a commercial transaction specific products",
    imgUrl: 'assets/third.png',
  ),
];
