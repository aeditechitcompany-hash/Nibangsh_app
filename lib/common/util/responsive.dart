import 'package:flutter/material.dart';

/// Breakpoints used across the app.
/// mobile   : < 600
/// tablet   : 600 - 1023
/// laptop   : 1024 - 1439
/// desktop  : >= 1440
class Breakpoints {
  static const double mobile = 600;
  static const double tablet = 1024;
  static const double laptop = 1440;
}

enum DeviceType { mobile, tablet, laptop, desktop }

extension ResponsiveContext on BuildContext {
  Size get _size => MediaQuery.of(this).size;

  double get screenWidth => _size.width;
  double get screenHeight => _size.height;

  bool get isMobile => screenWidth < Breakpoints.mobile;
  bool get isTablet =>
      screenWidth >= Breakpoints.mobile && screenWidth < Breakpoints.tablet;
  bool get isLaptop =>
      screenWidth >= Breakpoints.tablet && screenWidth < Breakpoints.laptop;
  bool get isDesktop => screenWidth >= Breakpoints.laptop;

  /// True for tablet and above - useful for switching from bottom nav to
  /// a side navigation rail, single column to multi column, etc.
  bool get isTabletOrLarger => screenWidth >= Breakpoints.mobile;

  DeviceType get deviceType {
    if (isMobile) return DeviceType.mobile;
    if (isTablet) return DeviceType.tablet;
    if (isLaptop) return DeviceType.laptop;
    return DeviceType.desktop;
  }

  /// Pick a value depending on the current breakpoint. Falls back to the
  /// closest smaller breakpoint value if a specific one isn't provided.
  T responsive<T>({required T mobile, T? tablet, T? laptop, T? desktop}) {
    switch (deviceType) {
      case DeviceType.mobile:
        return mobile;
      case DeviceType.tablet:
        return tablet ?? mobile;
      case DeviceType.laptop:
        return laptop ?? tablet ?? mobile;
      case DeviceType.desktop:
        return desktop ?? laptop ?? tablet ?? mobile;
    }
  }

  /// Horizontal page padding that grows on larger viewports.
  double get pagePadding =>
      responsive(mobile: 20.0, tablet: 40.0, laptop: 64.0, desktop: 96.0);

  /// Max content width so text/forms don't stretch edge-to-edge on
  /// laptop/desktop viewports.
  double get contentMaxWidth => responsive(
    mobile: double.infinity,
    tablet: 640.0,
    laptop: 720.0,
    desktop: 780.0,
  );

  /// Max width for wide dashboard/grid style screens (admin panels, lists).
  double get dashboardMaxWidth => responsive(
    mobile: double.infinity,
    tablet: 900.0,
    laptop: 1200.0,
    desktop: 1400.0,
  );

  /// Number of grid columns for card/grid layouts.
  int gridColumns({
    int mobile = 1,
    int tablet = 2,
    int laptop = 3,
    int desktop = 4,
  }) {
    return responsive(
      mobile: mobile,
      tablet: tablet,
      laptop: laptop,
      desktop: desktop,
    );
  }

  /// Scales a base font size gently for larger screens. Clamped so text
  /// never becomes uncomfortably large.
  double scaleFont(double base) {
    final factor = responsive(
      mobile: 1.0,
      tablet: 1.05,
      laptop: 1.1,
      desktop: 1.12,
    );
    return base * factor;
  }
}

/// Wraps screen content so it stays readable on tablet/laptop/desktop by
/// centering it and constraining its width, while remaining full-width
/// (unchanged) on mobile. Use this to wrap the widget passed to
/// `Scaffold(body: ...)` on form/content screens.
class ResponsiveWrapper extends StatelessWidget {
  final Widget child;
  final double? maxWidth;
  final EdgeInsetsGeometry? padding;
  final AlignmentGeometry alignment;

  const ResponsiveWrapper({
    super.key,
    required this.child,
    this.maxWidth,
    this.padding,
    this.alignment = Alignment.topCenter,
  });

  @override
  Widget build(BuildContext context) {
    final width = maxWidth ?? context.contentMaxWidth;
    return Align(
      alignment: alignment,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: width),
        child: Padding(
          padding:
              padding ??
              EdgeInsets.symmetric(
                horizontal: context.isTabletOrLarger ? 24 : 0,
              ),
          child: child,
        ),
      ),
    );
  }
}

/// Same idea as [ResponsiveWrapper] but sized for wide dashboard/list
/// screens (admin panels, students lists, grids of cards).
class ResponsiveDashboardWrapper extends StatelessWidget {
  final Widget child;

  const ResponsiveDashboardWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: context.dashboardMaxWidth),
        child: child,
      ),
    );
  }
}

/// A responsive grid that automatically picks a column count based on the
/// current breakpoint. Drop-in alternative to GridView.count for card
/// layouts across the app.
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final double runSpacing;
  final double childAspectRatio;
  final int mobileColumns;
  final int tabletColumns;
  final int laptopColumns;
  final int desktopColumns;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.spacing = 16,
    this.runSpacing = 16,
    this.childAspectRatio = 1.0,
    this.mobileColumns = 1,
    this.tabletColumns = 2,
    this.laptopColumns = 3,
    this.desktopColumns = 4,
    this.shrinkWrap = true,
    this.physics = const NeverScrollableScrollPhysics(),
  });

  @override
  Widget build(BuildContext context) {
    final columns = context.gridColumns(
      mobile: mobileColumns,
      tablet: tabletColumns,
      laptop: laptopColumns,
      desktop: desktopColumns,
    );
    return GridView.builder(
      shrinkWrap: shrinkWrap,
      physics: physics,
      padding: EdgeInsets.zero,
      itemCount: children.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: spacing,
        mainAxisSpacing: runSpacing,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) => children[index],
    );
  }
}

/// Adaptive shell: shows a bottom navigation bar on mobile and a side
/// [NavigationRail] on tablet/laptop/desktop. Pass the same items/state
/// used to build a bottom nav bar.
class AdaptiveNavShell extends StatelessWidget {
  final Widget body;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<NavigationRailDestination> railDestinations;
  final Widget bottomNavBar;
  final Color? railBackgroundColor;
  final Widget? railLeading;

  const AdaptiveNavShell({
    super.key,
    required this.body,
    required this.currentIndex,
    required this.onTap,
    required this.railDestinations,
    required this.bottomNavBar,
    this.railBackgroundColor,
    this.railLeading,
  });

  @override
  Widget build(BuildContext context) {
    if (context.isTabletOrLarger) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: currentIndex,
              onDestinationSelected: onTap,
              backgroundColor: railBackgroundColor,
              leading: railLeading,
              labelType: context.isDesktop
                  ? NavigationRailLabelType.none
                  : NavigationRailLabelType.selected,
              extended: context.isDesktop,
              minExtendedWidth: 200,
              destinations: railDestinations,
            ),
            const VerticalDivider(width: 1),
            Expanded(child: body),
          ],
        ),
      );
    }

    return Scaffold(body: body, bottomNavigationBar: bottomNavBar);
  }
}
