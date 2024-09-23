import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:notes/helpers/loading/loding_screen_controller.dart';

class LoadingScreen {
  // singleton constructor
  LoadingScreen._sharedInstance();
  static final LoadingScreen _shared = LoadingScreen._sharedInstance();
  factory LoadingScreen() => _shared;

  LoadingScreenController? controller;

  LoadingScreenController showOverlay(
      {required BuildContext context, required String text}) {
    final _text = StreamController<String>();
    _text.add(text);
    final state = Overlay.of(context); // get state of current state
    final renderBox =
        context.findRenderObject() as RenderBox; // get the render box
    final size = renderBox.size; // get its size

    final overlay = OverlayEntry(builder: (context) {
      return Material(
        color: Colors.black.withAlpha(150),
        child: Center(
          child: Container(
            // size constraints etc.
            constraints: BoxConstraints(
                maxWidth: size.width *
                    0.8, // permitted to occupy only 80% of screen irrespective of text content length
                maxHeight: size.height * 0.8,
                minWidth: 0.5 * size.width),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                backgroundBlendMode: BlendMode.color),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  const CircularProgressIndicator(),
                  const SizedBox(height: 20),
                  StreamBuilder(
                      stream: _text.stream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text(
                            snapshot.data as String,
                            textAlign: TextAlign.center,
                          );
                        } else {
                          return Container();
                        }
                      })
                ],
              )),
            ),
          ),
        ),
      ); // this material will try to take over the entire screen
    }); // overlayentry is the actual overlay - creating it
    state.insert(overlay);

    return LoadingScreenController(close: () {
      _text.close(); // close stream
      overlay.remove(); // close overlay
      return true;
    }, update: (text) {
      _text.add(text); // update
      return true;
    });
  }

  void hide() {
    controller?.close(); // hide it if it exists
    controller = null;
  }

  void show({required BuildContext context, required String text}) {
    if (controller?.update(text) ?? false) {
      return; // if no controller, go to else
    } else {
      controller = showOverlay(context: context, text: text);
    }
  }
}
