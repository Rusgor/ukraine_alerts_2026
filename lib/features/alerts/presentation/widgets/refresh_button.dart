import 'dart:async';

import 'package:flutter/material.dart';

class RefreshButton extends StatefulWidget {
  const RefreshButton({
    super.key,
    required this.onRefresh,
    required this.color,
    required this.tooltip,
    this.cooldown = const Duration(seconds: 30),
  });

  final VoidCallback onRefresh;
  final Color color;
  final String tooltip;
  final Duration cooldown;

  @override
  State<RefreshButton> createState() => _RefreshButtonState();
}

class _RefreshButtonState extends State<RefreshButton>
    with SingleTickerProviderStateMixin {
  bool _enabled = true;
  Timer? _timer;
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    // Pulse on appear
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _animController.forward().then((_) => _animController.reverse());
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animController.dispose();
    super.dispose();
  }

  void _onTap() {
    if (!_enabled) return;
    widget.onRefresh();
    setState(() => _enabled = false);
    _timer = Timer(widget.cooldown, () {
      if (mounted) {
        setState(() => _enabled = true);
        _animController.forward().then((_) => _animController.reverse());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: IconButton(
        tooltip: widget.tooltip,
        onPressed: _enabled ? _onTap : null,
        icon: Icon(
          Icons.refresh,
          color: _enabled ? widget.color : widget.color.withValues(alpha: 0.3),
        ),
      ),
    );
  }
}
