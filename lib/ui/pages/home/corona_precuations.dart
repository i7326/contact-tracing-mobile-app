import 'package:slide_container/slide_container.dart';
import 'package:slide_container/slide_container_controller.dart';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class CoronaPrecuations extends StatefulWidget {
  CoronaPrecuations();

  @override
  _CoronaPrecuationsLayoutState createState() =>
      _CoronaPrecuationsLayoutState();
}

class _CoronaPrecuationsLayoutState extends State<CoronaPrecuations> {
  final SlideContainerController slideContainerController =
      SlideContainerController();

  _slides(index) {
    return [
      new Container(
        child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Image.asset(
                "assets/wash.png",
                fit: BoxFit.fill,
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: new Text(
                  "Wash Your Hands often",
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: new Text(
                    "Wash Your Hands often with soap and water for at least 20 seconds especially after you have been in a public place, or after blowing your nose, coughing, or sneezing."),
              )
            ]),
      ),
      new Container(
        child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Image.asset(
                "assets/clean.png",
                fit: BoxFit.fill,
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: new Text(
                  "Clean and disinfect",
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: new Text(
                    "Clean AND disinfect frequently touched surfaces daily. This includes tables, doorknobs, light switches, countertops, handles, desks, phones, keyboards, toilets, faucets, and sinks."),
              )
            ]),
      ),
      new Container(
        child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Image.asset(
                "assets/mask.png",
                fit: BoxFit.fill,
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: new Text(
                  "Wear a facemask if you are sick",
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: new Text(
                    "If you are sick: You should wear a facemask when you are around other people (e.g., sharing a room or vehicle) and before you enter a healthcare provider’s office."),
              )
            ]),
      ),
      new Container(
        child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Image.asset(
                "assets/home.png",
                fit: BoxFit.fill,
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: new Text(
                  "Stay home if you’re sick",
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: new Text(
                    "Stay home if you are sick, except to get medical care."),
              )
            ]),
      ),
      new Container(
        child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Image.asset(
                "assets/cough.png",
                fit: BoxFit.fill,
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: new Text(
                  "Avoid close contact",
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: new Text(
                    "Avoid close contact with anyone. Maintain a distance of minimum of meter from everyone"),
              )
            ]),
      ),
      new Container(
        child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Image.asset(
                "assets/sneeze.png",
                fit: BoxFit.fill,
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: new Text(
                  "Cover your face while sneezing and coughing",
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: new Text(
                    "Cover your face while sneezing and coughing. use a hand sanitizer that contains at least 60% alcohol. Cover all surfaces of your hands and rub them together until they feel dry."),
              )
            ]),
      )
    ][index];
  }

  Widget get lineSeparator => Container(
        margin: const EdgeInsets.only(top: 10, bottom: 10),
        width: 47.0,
        height: 0.5,
        color: Colors.black,
      );

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () async {
          slideContainerController
              .forceSlide(SlideContainerDirection.topToBottom);
          return false;
        },
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: _ClosePageSlideContainer(
              controller: slideContainerController,
              child: new Swiper(
                itemBuilder: (BuildContext context, int index) {
                  return _slides(index);
                },
                itemCount: 6,
                pagination: new SwiperPagination(),
                control: new SwiperControl(),
              )),
        ),
      );
}

class _ClosePageSlideContainer extends StatefulWidget {
  final Widget child;
  final VoidCallback onSlideStarted;
  final VoidCallback onSlideCompleted;
  final VoidCallback onSlideCanceled;
  final ValueChanged<double> onSlide;
  final SlideContainerController controller;

  _ClosePageSlideContainer({
    @required this.child,
    this.onSlideStarted,
    this.onSlideCompleted,
    this.onSlideCanceled,
    this.onSlide,
    this.controller,
  });

  @override
  _ClosePageSlideContainerState createState() =>
      _ClosePageSlideContainerState();
}

class _ClosePageSlideContainerState extends State<_ClosePageSlideContainer> {
  double overlayOpacity = 1.0;

  double get maxSlideDistance => MediaQuery.of(context).size.height;

  double get minSlideDistanceToValidate => maxSlideDistance * 0.5;

  void onSlide(double verticalPosition) {
    if (mounted) {
      setState(() => overlayOpacity = (1.000912 -
              0.1701771 * verticalPosition +
              1.676138 * pow(verticalPosition, 2) -
              3.784127 * pow(verticalPosition, 3))
          .clamp(0.0, 1.0));
    }
    if (widget.onSlide != null) widget.onSlide(verticalPosition);
  }

  void onSlideCompleted() {
    if (widget.onSlideCompleted != null) widget.onSlideCompleted();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) => SlideContainer(
        controller: widget.controller,
        slideDirection: SlideContainerDirection.topToBottom,
        onSlide: onSlide,
        onSlideCompleted: onSlideCompleted,
        minDragVelocityForAutoSlide: 600.0,
        minSlideDistanceToValidate: minSlideDistanceToValidate,
        maxSlideDistance: maxSlideDistance,
        autoSlideDuration: const Duration(milliseconds: 300),
        onSlideStarted: widget.onSlideStarted,
        onSlideCanceled: widget.onSlideCanceled,
        onSlideValidated: () => HapticFeedback.mediumImpact(),
        child: Opacity(
          opacity: overlayOpacity,
          child: widget.child,
        ),
      );
}
