library carousel;

import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';

class Carousel extends StatefulWidget {
    final Function(int currentIndex) onPageChanged;
    final IndexedWidgetBuilder itemBuilder;
    final PageController pageController;
    final bool autoPlay;
    final Duration duration;
    final Duration animationDuration;
    final Curve animationCurve;
    final int itemCount;
    final bool loop;
    final int realPage;
    final int initialPage;
    final double viewportFraction;
    final double width;
    final double height;
    final Color color;

    Carousel({
        @required this.itemBuilder,
        this.itemCount = 0,
        this.onPageChanged,
        this.initialPage = 0,
        this.loop = true,
        this.realPage = 2,
        this.height = 150.0,
        this.width = double.infinity,
        this.color,
        this.viewportFraction,
        this.autoPlay = true,
        this.duration = const Duration(seconds: 4),
        this.animationDuration = const Duration(milliseconds: 300),
        this.animationCurve = Curves.ease,
    }) : this.pageController = PageController(
        viewportFraction: viewportFraction ?? (itemCount <= 1 ? 1 : 0.8),
        initialPage: (loop && itemCount > 1 ? realPage : 0) + initialPage,
    );


    @override
    _CarouselState createState () => _CarouselState();
}

class _CarouselState extends State<Carousel> {
    Timer timer;

    @override
    void initState() {
        super.initState();

        if (widget.autoPlay) {
            this.runAutoPlay();
        }
    }

    Timer runAutoPlay () {
        if (timer != null) {
            timer.cancel();
        }

        if (widget.itemCount <= 1) {
            return null;
        }

        timer = Timer.periodic(widget.duration, (_) {
            widget.pageController.nextPage(duration: widget.animationDuration, curve: widget.animationCurve);
        });

         return timer;
    }

    @override
    Widget build(BuildContext context) {
        int realPage = widget.loop && widget.itemCount > 1 ? widget.realPage : 0;

        if (widget.itemCount == 0) {
            return Container();
        }

        if (widget.itemCount <= 1 && timer != null) {
            timer.cancel();
        }

        return Container(
            width: widget.width,
            height: widget.height,
            color: widget.color,
            child: PageView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.loop && widget.itemCount > 1 ? null : widget.itemCount,
                reverse: false,
                physics: PageScrollPhysics(parent: BouncingScrollPhysics()),
                onPageChanged: (i) {
                    int currentIndex = i - realPage;
                    int max = realPage + widget.itemCount - 1;

                    if (i < realPage) {
                        currentIndex = max;
                        widget.pageController.jumpToPage(max);
                    } else if (i > max) {
                        currentIndex = 0;
                        widget.pageController.jumpToPage(realPage);
                    } else if (widget.onPageChanged != null) {
                        widget.onPageChanged(currentIndex);
                    }
                },
                controller: widget.pageController,
                itemBuilder: (context, index) {
                    final currentIndex = index - realPage;
                    return Listener(
                        onPointerDown: (_) {
                            if (timer != null) {
                                timer.cancel();
                            }
                        },
                        onPointerUp: (_) {
                            this.runAutoPlay();
                        },
                        child: AnimatedBuilder(
                            animation: widget.pageController,
                            child: widget.itemBuilder != null
                                    ? widget.itemBuilder(context, currentIndex >= widget.itemCount ? 0 : currentIndex)
                                    : Center(child: Text('slider $currentIndex')),
                            builder: (BuildContext context, Widget child) {
                                return child;
                            },
                        ),
                    );
                }
            ),
        );
    }
}