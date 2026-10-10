import 'package:flutter/material.dart';

class PulseIconButton extends StatefulWidget {
  const PulseIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.color,
    required this.tooltip,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final Color color;
  final String tooltip;

  @override
  State<PulseIconButton> createState() => _PulseIconButtonState();
}

class _PulseIconButtonState extends State<PulseIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scale = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) _controller.forward().then((_) => _controller.reverse());
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: IconButton(
        tooltip: widget.tooltip,
        onPressed: widget.onPressed,
        icon: Icon(widget.icon, color: widget.color),
      ),
    );
  }
}
