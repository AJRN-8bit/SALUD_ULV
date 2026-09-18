

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoBackgroundContainer extends StatefulWidget {
  const VideoBackgroundContainer({
    super.key,
    required this.videoAsset,
    required this.child,
    this.overlayColor = Colors.black,
    this.overlayOpacity = 0.4,
    this.isNetwork = false,
    this.loop = true,
    this.muted = true,
  });

  final String videoAsset;
  final Widget child;
  final Color overlayColor;
  final double overlayOpacity;
  final bool isNetwork;
  final bool loop;
  final bool muted;

  @override
  State<VideoBackgroundContainer> createState() =>
      _VideoBackgroundContainerState();
}

class _VideoBackgroundContainerState extends State<VideoBackgroundContainer> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = widget.isNetwork
        ? VideoPlayerController.networkUrl(Uri.parse(widget.videoAsset))
        : VideoPlayerController.asset(widget.videoAsset);

    _controller.initialize().then((_) {
      setState(() {});
      _controller.setLooping(widget.loop);
      _controller.setVolume(widget.muted ? 0 : 1);
      _controller.play();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand, // fuerza a que el Stack ocupe todo el espacio
      children: [
        // 1. Video de fondo
        _controller.value.isInitialized
            ? FittedBox(
                fit: BoxFit.cover, // que el video llene la pantalla sin deformarse
                child: SizedBox(
                  width: _controller.value.size.width,
                  height: _controller.value.size.height,
                  child: VideoPlayer(_controller),
                ),
              )
            : Container(color: Colors.black), // fondo mientras carga

        // 2. Overlay oscuro transparente
        Container(
          color: widget.overlayColor.withOpacity(widget.overlayOpacity),
        ),

        // 3. Tus widgets encima
        widget.child,
      ],
    );
  }
}