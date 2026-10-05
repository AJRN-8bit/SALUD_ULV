import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class AutoScrollAnimation extends StatefulWidget {
  const AutoScrollAnimation({
    super.key,
    required this.builder,
    this.speed = 40,                                  // pixels per second
    this.resumeDelay = const Duration(seconds: 3),    // idle time before it resumes
    this.edgePause = const Duration(milliseconds: 800),
    this.enabled = true,
  });

  final Widget Function(BuildContext context, ScrollController controller)
      builder;
  final double speed;
  final Duration resumeDelay;
  final Duration edgePause;
  final bool enabled;

  @override
  State<AutoScrollAnimation> createState() => _AutoScrollAnimationState();
}

class _AutoScrollAnimationState extends State<AutoScrollAnimation>
    with SingleTickerProviderStateMixin {
  final _controller = ScrollController();
  late final Ticker _ticker;
  Timer? _resumeTimer;

  Duration _last = Duration.zero;
  Duration _edgeWait = Duration.zero;
  bool _paused = false; // true while the user touches / during resumeDelay
  bool _forward = true;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick);
    if (widget.enabled) _ticker.start();
  }

  @override
  void didUpdateWidget(covariant AutoScrollAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.enabled != widget.enabled) {
      if (widget.enabled) {
        _last = Duration.zero;
        _ticker.start();
      } else {
        _ticker.stop();
      }
    }
  }

  @override
  void dispose() {
    _resumeTimer?.cancel();
    _ticker.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onTick(Duration elapsed) {
    final dt = elapsed - _last;
    _last = elapsed;

    if (_paused || dt <= Duration.zero) return;
    if (!_controller.hasClients) return; // not attached yet, try next frame

    final pos = _controller.position;
    final max = pos.maxScrollExtent;
    if (max <= 0) return; // nothing to scroll (yet)

    // Pause at the ends
    if (_edgeWait > Duration.zero) {
      _edgeWait -= dt;
      return;
    }

    final delta = widget.speed * dt.inMicroseconds / 1e6;
    var next = pos.pixels + (_forward ? delta : -delta);

    if (next >= max) {
      next = max;
      _forward = false;
      _edgeWait = widget.edgePause;
    } else if (next <= 0) {
      next = 0;
      _forward = true;
      _edgeWait = widget.edgePause;
    }

    _controller.jumpTo(next);
  }

  void _onPointerDown() {
    _paused = true;
    _resumeTimer?.cancel();
  }

  void _scheduleResume() {
    _resumeTimer?.cancel();
    _resumeTimer = Timer(widget.resumeDelay, () {
      if (!mounted) return;
      // Still flinging? Wait another round.
      if (_controller.hasClients &&
          _controller.position.isScrollingNotifier.value) {
        _scheduleResume();
        return;
      }
      _paused = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => _onPointerDown(),
      onPointerUp: (_) => _scheduleResume(),
      onPointerCancel: (_) => _scheduleResume(),
      child: widget.builder(context, _controller),
    );
  }
}