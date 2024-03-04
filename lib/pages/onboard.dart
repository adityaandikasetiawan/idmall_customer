import 'package:idmall/pages/login.dart';
import 'package:idmall/widget/content_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Onboard extends StatefulWidget {
  const Onboard({Key? key}) : super(key: key);

  @override
  State<Onboard> createState() => _OnboardState();
}

class _OnboardState extends State<Onboard> {
  int currentIndex = 0;
  late PageController _controller;

  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        body: Stack(
          children: [
            PageView.builder(
              controller: _controller,
              itemCount: contents.length,
              onPageChanged: (int index) {
                setState(() {
                  currentIndex = index;
                });
              },
              itemBuilder: (_, i) {
                return Stack(
                  children: [
                    Hero(
                      tag: 'image${contents[i].image}',
                      child: ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          Colors.black
                              .withOpacity(currentIndex == i ? 0.0 : 0.5),
                          BlendMode.srcOver,
                        ),
                        child: Image.asset(
                          contents[i].image,
                          height: double.infinity,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Center(
                        child: Transform.translate(
                          offset: Offset(0.0, -50.0 * (1.0 - currentIndex + i)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: 150),
                              AnimatedOpacity(
                                opacity: currentIndex == i ? 1.0 : 0.0,
                                duration: const Duration(milliseconds: 500),
                                child: Center(
                                  child: Image.asset(
                                    contents[i].image2,
                                    height: 200,
                                    width: 200,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 275),
                              AnimatedOpacity(
                                opacity: currentIndex == i ? 1.0 : 0.0,
                                duration: const Duration(milliseconds: 500),
                                child: Center(
                                  child: Text(
                                    contents[i].description,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        contents.length,
                        (index) => buildDot(index, context),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextButton(
                      onPressed: () {
                        if (currentIndex == contents.length - 1) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Hero(
                                tag: 'image${contents[currentIndex].image}',
                                child: ColorFiltered(
                                  colorFilter: ColorFilter.mode(
                                    Colors.black.withOpacity(
                                        currentIndex == contents.length - 1
                                            ? 0.0
                                            : 0.5),
                                    BlendMode.srcOver,
                                  ),
                                  child: const Login(),
                                ),
                              ),
                            ),
                          );
                        } else {
                          _controller.nextPage(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: currentIndex == contents.length - 1
                            ? const Color.fromARGB(255, 228, 99, 7)
                            : const Color.fromARGB(255, 228, 99, 7),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                      ),
                      child: Text(
                        currentIndex == contents.length - 1 ? "Start" : "Next",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontFamily: 'Poppins',
                        ),
                      ),
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

  Container buildDot(int index, BuildContext context) {
    return Container(
      height: 10.0,
      width: currentIndex == index ? 80 : 20,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: const Color.fromARGB(255, 228, 99, 7),
      ),
    );
  }
}
