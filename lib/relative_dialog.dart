import 'package:flutter/material.dart';

Offset _calculatePositionOffset({
  required BuildContext context,
  required Alignment alignment,
}) {
  // This is the render box of the widget that the dialog should be positioned relative to.
  final RenderBox renderBox = context.findRenderObject() as RenderBox;
  final renderBoxSize = renderBox.size;
  final renderBoxHeight = renderBoxSize.height;
  final renderBoxWidth = renderBoxSize.width;
  final renderBoxOffset = renderBox.localToGlobal(Offset.zero);

  if (alignment == Alignment.bottomLeft) {
    return Offset(
      renderBoxOffset.dx,
      renderBoxOffset.dy + renderBoxHeight,
    );
  } else if (alignment == Alignment.bottomCenter) {
    return Offset(
      renderBoxOffset.dx + renderBoxWidth / 2,
      renderBoxOffset.dy + renderBoxHeight,
    );
  } else if (alignment == Alignment.bottomRight) {
    return Offset(
      renderBoxOffset.dx + renderBoxWidth,
      renderBoxOffset.dy + renderBoxHeight,
    );
  } else if (alignment == Alignment.centerLeft) {
    return Offset(
      renderBoxOffset.dx,
      renderBoxOffset.dy + renderBoxHeight / 2,
    );
  } else if (alignment == Alignment.center) {
    return Offset(
      renderBoxOffset.dx + renderBoxWidth / 2,
      renderBoxOffset.dy + renderBoxHeight / 2,
    );
  } else if (alignment == Alignment.centerRight) {
    return Offset(
      renderBoxOffset.dx + renderBoxWidth,
      renderBoxOffset.dy + renderBoxHeight / 2,
    );
  } else if (alignment == Alignment.topLeft) {
    return Offset(
      renderBoxOffset.dx,
      renderBoxOffset.dy,
    );
  } else if (alignment == Alignment.topCenter) {
    return Offset(renderBoxOffset.dx + renderBoxWidth / 2, renderBoxOffset.dy);
  } else if (alignment == Alignment.topRight) {
    return Offset(renderBoxOffset.dx + renderBoxWidth, renderBoxOffset.dy);
  }

  throw ('Unsupported alignment');
}

Offset _calculateTranslationOffset({
  required Alignment alignment,
}) {
  if (alignment == Alignment.bottomLeft) {
    return Offset.zero;
  } else if (alignment == Alignment.bottomCenter) {
    return const Offset(-0.5, 0);
  } else if (alignment == Alignment.bottomRight) {
    return const Offset(-1.0, 0);
  } else if (alignment == Alignment.centerLeft) {
    return const Offset(0, -0.5);
  } else if (alignment == Alignment.center) {
    return const Offset(-0.5, -0.5);
  } else if (alignment == Alignment.centerRight) {
    return const Offset(-1.0, -0.5);
  } else if (alignment == Alignment.topLeft) {
    return const Offset(0, -1.0);
  } else if (alignment == Alignment.topCenter) {
    return const Offset(-0.5, -1.0);
  } else if (alignment == Alignment.topRight) {
    return const Offset(-1.0, -1.0);
  }

  throw ('Unsupported alignment');
}

/// Displays a dialog above the current contents of the app using [showDialog] relative to the widget
/// associated with the given BuildContext.
Future<T?> showRelativeDialog<T>({
  /// The BuildContext of the widget that the dialog should be shown relative to.
  required BuildContext context,

  /// The builder for the child widget to display in the dialog.
  required WidgetBuilder builder,

  /// The alignment of the dialog relative to the widget specified by the given BuildContext.
  Alignment alignment = Alignment.bottomLeft,

  /// A fixed offset for the dialog relative to its specified alignment.
  Offset offset = Offset.zero,

  /// Pass through fields from [showDialog].
  String barrierLabel = 'dismiss',
  Color? barrierColor = Colors.black54,
  bool useSafeArea = true,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
}) {
  final positionOffset = _calculatePositionOffset(
    context: context,
    alignment: alignment,
  );
  final translationOffset = _calculateTranslationOffset(
    alignment: alignment,
  );

  return showDialog<T>(
    context: context,
    barrierDismissible: true,
    barrierLabel: barrierLabel,
    barrierColor: barrierColor,
    useRootNavigator: useRootNavigator,
    useSafeArea: useSafeArea,
    routeSettings: routeSettings,
    builder: (context) {
      return Stack(
        children: [
          Positioned(
            top: positionOffset.dy + offset.dy,
            left: positionOffset.dx + offset.dx,
            child: FractionalTranslation(
              translation: translationOffset,
              child: builder(context),
            ),
          ),
        ],
      );
    },
  );
}
