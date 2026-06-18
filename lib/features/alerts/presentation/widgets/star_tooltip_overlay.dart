import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ua_air_alerts/features/alerts/data/constants.dart';
import 'package:ua_air_alerts/l10n/app_localizations.dart';
import 'package:ua_air_alerts/theme/app_theme.dart';

class StarTooltipOverlay extends StatefulWidget {
  const StarTooltipOverlay({
    super.key,
    required this.child,
    this.enabled = true,
  });

  final Widget child;
  final bool enabled;

  @override
  State<StarTooltipOverlay> createState() => _StarTooltipOverlayState();
}

class _StarTooltipOverlayState extends State<StarTooltipOverlay>
    with SingleTickerProviderStateMixin {
  bool _show = false;
  late AnimationController _controller;
  late Animation<double> _bounce;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _bounce = Tween<double>(begin: 0, end: 8).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _checkFirstTime();
  }

  @override
  void didUpdateWidget(covariant StarTooltipOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.enabled && widget.enabled && !_show) {
      _checkFirstTime();
    }
  }

  Future<void> _checkFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(StorageKeys.starTooltipSeen) != true && widget.enabled) {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted && widget.enabled) {
        setState(() => _show = true);
        _controller.repeat(reverse: true);
      }
    }
  }

  Future<void> _dismiss() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(StorageKeys.starTooltipSeen, true);
    setState(() => _show = false);
    _controller.stop();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Stack(
      children: [
        widget.child,
        if (_show)
          Positioned.fill(
            child: GestureDetector(
              onTap: _dismiss,
              child: ColoredBox(
                color: Colors.black26,
                child: SafeArea(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: kToolbarHeight - 10,
                        right: 50,
                      ),
                      child: AnimatedBuilder(
                        animation: _bounce,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, -_bounce.value),
                            child: child,
                          );
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Icon(
                              Icons.arrow_upward_rounded,
                              color: Colors.white,
                              size: 32,
                            ),
                            Container(
                              padding: const EdgeInsets.all(AppSizes.paddingM),
                              constraints: const BoxConstraints(maxWidth: 220),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(AppSizes.radiusM),
                                boxShadow: const [
                                  BoxShadow(
                                    color: AppColors.dropdownShadow,
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Text(
                                l10n.starTooltip,
                                style: const TextStyle(
                                  fontSize: AppSizes.fontM,
                                  color: AppColors.textDark,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
