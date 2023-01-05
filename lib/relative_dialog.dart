import 'package:flutter/material.dart';

/// Calculates the positional offset that the dialog should take relative to the [BuildContext]
/// associated with the widget that opened it.
/// For example, if the specified alignment is [Alignment.bottomRight], then since the position
/// of the dialog starts at the top-left relative to the widget that opened it, the dialog can be positioned
/// at the bottom right of that box using a positional offset of:
/// x-axis: renderBoxOffset.dx + renderBoxWidth
/// y-axis: renderBoxOffset.dy + renderBoxHeight
/// The translational offset function below is then used to translate the dialog relative to its own width,
/// since its coordinates also start top-left and to achieve a [Alignment.bottomRight] alignment, it needs
/// to be translated in the x-axis by its own width to align its right bound with the right bound of the widget that opened it.
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

/// Calculates the translational offset that the dialog should take relative to the
/// [BuildContext] of the widget that opened it.
/// For example, if the specified alignment is [Alignment.bottomRight], then since positional offset calculation
/// positions the dialog at the bottom right of the widget that opened it, the translational offset will need to apply
/// an x-axis translation of Offset(-1.0, 0) since the dialog's position starts top-left and to have it's right bound
/// end at the right bound of the widget that opened it, it needs a negative translation equal to its own width.
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

Widget _defaultFadeTransition(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  return FadeTransition(
    opacity: animation,
    child: child,
  );
}

/// Builds the dialog in the position relative to the widget that opened it as specified by the given [Alignment].
Widget _transitionBuilder({
  required BuildContext relativeContext,
  required BuildContext transitionContext,
  required RouteTransitionsBuilder? transitionBuilder,
  required Alignment alignment,
  required Offset offset,
  required Widget child,
  required Animation<double> a1,
  required Animation<double> a2,
}) {
  transitionBuilder ??= _defaultFadeTransition;

  final positionOffset = _calculatePositionOffset(
    context: relativeContext,
    alignment: alignment,
  );
  final translationOffset = _calculateTranslationOffset(
    alignment: alignment,
  );

  return Stack(
    children: [
      Positioned(
        top: positionOffset.dy + offset.dy,
        left: positionOffset.dx + offset.dx,
        child: FractionalTranslation(
          translation: translationOffset,
          child: transitionBuilder.call(transitionContext, a1, a2, child),
        ),
      ),
    ],
  );
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
  Color barrierColor = Colors.black54,
  bool barrierDismissible = true,
  bool useSafeArea = true,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
  RouteTransitionsBuilder? transitionBuilder,
  Duration transitionDuration = const Duration(milliseconds: 200),
}) {
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierLabel: barrierLabel,
    barrierColor: barrierColor,
    useRootNavigator: useRootNavigator,
    routeSettings: routeSettings,
    transitionBuilder: (transitionContext, a1, a2, child) => _transitionBuilder(
      transitionBuilder: transitionBuilder,
      transitionContext: transitionContext,
      relativeContext: context,
      a1: a1,
      a2: a2,
      child: child,
      alignment: alignment,
      offset: offset,
    ),
    transitionDuration: transitionDuration,
    pageBuilder: (_, animation1, animation2) => builder(context),
  );
}
