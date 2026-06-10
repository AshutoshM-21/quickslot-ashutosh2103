class ResponsiveUtils {
  ResponsiveUtils._();

  static const double tabletBreakpoint = 600;
  static const double desktopBreakpoint = 900;
  static const double maxContentWidth = 720;

  static double horizontalPadding(double width) {
    if (width >= desktopBreakpoint) {
      return 32;
    }
    if (width >= tabletBreakpoint) {
      return 24;
    }
    return 16;
  }

  static int slotGridCrossAxisCount(double width) {
    if (width >= desktopBreakpoint) {
      return 4;
    }
    if (width >= tabletBreakpoint) {
      return 3;
    }
    return 2;
  }
}
