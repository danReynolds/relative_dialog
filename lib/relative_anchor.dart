import 'package:flutter/material.dart';
import 'package:relative_dialog/relative_dialog.dart';

class RelativeAnchor<T> extends StatelessWidget {
  final Widget Function(
    BuildContext context, {
    required Future<void> Function({
      /// The builder for the child widget to display in the dialog.
      required WidgetBuilder builder,

      /// The alignment of the dialog relative to the widget specified by the given BuildContext.
      Alignment alignment,

      /// A fixed offset for the dialog relative to its specified alignment.
      Offset offset,

      /// Pass through fields from [showDialog].
      String barrierLabel,
      Color barrierColor,
      bool barrierDismissible,
      bool useSafeArea,
      bool useRootNavigator,
      RouteSettings? routeSettings,
      RouteTransitionsBuilder? transitionBuilder,
      Duration transitionDuration,
    }) show,
  }) builder;

  const RelativeAnchor({
    super.key,
    required this.builder,
  });

  @override
  build(context) {
    return Builder(
      builder: (context) {
        return builder(
          context,
          show: ({
            required WidgetBuilder builder,
            Alignment alignment = Alignment.bottomLeft,
            Offset offset = Offset.zero,
            String barrierLabel = 'dismiss',
            Color barrierColor = Colors.black54,
            bool barrierDismissible = true,
            bool useSafeArea = true,
            bool useRootNavigator = true,
            RouteSettings? routeSettings,
            RouteTransitionsBuilder? transitionBuilder,
            Duration transitionDuration = const Duration(milliseconds: 200),
          }) {
            return showRelativeDialog(
              context: context,
              builder: builder,
              alignment: alignment,
              offset: offset,
              barrierLabel: barrierLabel,
              barrierColor: barrierColor,
              barrierDismissible: barrierDismissible,
              useSafeArea: useSafeArea,
              useRootNavigator: useRootNavigator,
              routeSettings: routeSettings,
              transitionBuilder: transitionBuilder,
              transitionDuration: transitionDuration,
            );
          },
        );
      },
    );
  }
}
