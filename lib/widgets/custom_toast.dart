import 'package:flutter/material.dart';

class CustomToast extends StatelessWidget {
  final String message;
  final Duration duration;
  final ToastType type;

  const CustomToast({
    super.key,
    required this.message,
    this.duration = const Duration(seconds: 2),
    this.type = ToastType.info,
  });

  static void show(BuildContext context, String message,
      {ToastType type = ToastType.info}) {
    _removeCurrentToast();

    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: MediaQuery.of(context).padding.bottom + 50,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            onEnd: () {
              Future.delayed(const Duration(seconds: 2), () {
                if (overlayEntry.mounted) {
                  _animateOut(overlayEntry);
                }
              });
            },
            builder: (context, value, child) => Transform.translate(
              offset: Offset(0, 20 * (1 - value)),
              child: Opacity(
                opacity: value,
                child: Material(
                  color: Colors.transparent,
                  child: Semantics(
                    label: message,
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 400),
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                      decoration: BoxDecoration(
                        color: _getBackgroundColor(type).withOpacity(0.95),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.15),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: _getBackgroundColor(type).withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _getIcon(type),
                          const SizedBox(width: 12),
                          Flexible(
                            child: Text(
                              message,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.95),
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.2,
                                height: 1.2,
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
      ),
    );

    Overlay.of(context).insert(overlayEntry);
    _currentToast = overlayEntry;
  }

  static Color _getBackgroundColor(ToastType type) {
    switch (type) {
      case ToastType.success:
        return const Color(0xFF2E7D32);
      case ToastType.error:
        return const Color(0xFFD32F2F);
      case ToastType.warning:
        return const Color(0xFFF57C00);
      case ToastType.info:
      default:
        return const Color(0xFF323232);
    }
  }

  static Widget _getIcon(ToastType type) {
    IconData icon;
    Color iconColor = Colors.white.withOpacity(0.95);

    switch (type) {
      case ToastType.success:
        icon = Icons.check_circle_rounded;
        break;
      case ToastType.error:
        icon = Icons.error_rounded;
        break;
      case ToastType.warning:
        icon = Icons.warning_rounded;
        break;
      case ToastType.info:
      default:
        icon = Icons.info_rounded;
    }

    return Container(
      padding: const EdgeInsets.all(2),
      child: Icon(
        icon,
        color: iconColor,
        size: 22,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  static OverlayEntry? _currentToast;

  static void _removeCurrentToast() {
    _currentToast?.remove();
    _currentToast = null;
  }

  static void _animateOut(OverlayEntry overlayEntry) {
    if (!overlayEntry.mounted) return;

    final context = overlayEntry.mounted;

    if (!context) {
      overlayEntry.remove();
      return;
    }

    OverlayEntry animatedOverlay = OverlayEntry(
      builder: (builderContext) => TweenAnimationBuilder<double>(
        tween: Tween(begin: 1.0, end: 0.0),
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeIn,
        onEnd: () {
          overlayEntry.remove();
        },
        builder: (_, value, child) {
          return Opacity(
            opacity: value,
            child: overlayEntry.builder(builderContext),
          );
        },
      ),
    );

    overlayEntry.remove();
    Overlay.of(context as BuildContext).insert(animatedOverlay);
  }
}

enum ToastType {
  success,
  error,
  warning,
  info,
}
