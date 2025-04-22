import 'package:flutter/material.dart';
import 'package:sundrift/app/themes/app_theme.dart';

/// A custom button widget with various customization options
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool isOutlined;
  final bool isTextOnly;
  final bool isLoading;
  final bool isFullWidth;
  final bool isSmall;
  final Color? backgroundColor;
  final Color? textColor;
  final EdgeInsets? padding;
  final Widget? prefix;
  final Widget? suffix;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isOutlined = false,
    this.isTextOnly = false,
    this.isLoading = false,
    this.isFullWidth = false,
    this.isSmall = false,
    this.backgroundColor,
    this.textColor,
    this.padding,
    this.prefix,
    this.suffix,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determine button type and style
    if (isTextOnly) {
      return _buildTextButton(context);
    } else if (isOutlined) {
      return _buildOutlinedButton(context);
    } else {
      return _buildElevatedButton(context);
    }
  }

  // Build elevated button
  Widget _buildElevatedButton(BuildContext context) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height:
          isSmall ? AppDimensions.buttonHeightSm : AppDimensions.buttonHeightLg,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          padding: padding ??
              (isSmall
                  ? const EdgeInsets.symmetric(
                      horizontal: AppDimensions.md, vertical: AppDimensions.xs)
                  : const EdgeInsets.symmetric(
                      horizontal: AppDimensions.lg,
                      vertical: AppDimensions.sm)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          ),
        ),
        child: _buildButtonContent(context),
      ),
    );
  }

  // Build outlined button
  Widget _buildOutlinedButton(BuildContext context) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height:
          isSmall ? AppDimensions.buttonHeightSm : AppDimensions.buttonHeightLg,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: textColor ?? Theme.of(context).colorScheme.primary,
          padding: padding ??
              (isSmall
                  ? const EdgeInsets.symmetric(
                      horizontal: AppDimensions.md, vertical: AppDimensions.xs)
                  : const EdgeInsets.symmetric(
                      horizontal: AppDimensions.lg,
                      vertical: AppDimensions.sm)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          ),
        ),
        child: _buildButtonContent(context),
      ),
    );
  }

  // Build text button
  Widget _buildTextButton(BuildContext context) {
    return TextButton(
      onPressed: isLoading ? null : onPressed,
      style: TextButton.styleFrom(
        foregroundColor: textColor ?? Theme.of(context).colorScheme.primary,
        padding: padding ??
            (isSmall
                ? const EdgeInsets.symmetric(
                    horizontal: AppDimensions.md, vertical: AppDimensions.xs)
                : const EdgeInsets.symmetric(
                    horizontal: AppDimensions.md, vertical: AppDimensions.sm)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
      ),
      child: _buildButtonContent(context),
    );
  }

  // Build button content with icon and/or loading indicator
  Widget _buildButtonContent(BuildContext context) {
    // Show loading indicator
    if (isLoading) {
      return SizedBox(
        height: isSmall ? 16.0 : 20.0,
        width: isSmall ? 16.0 : 20.0,
        child: CircularProgressIndicator(
          strokeWidth: isSmall ? 2.0 : 3.0,
          valueColor: AlwaysStoppedAnimation<Color>(
            isOutlined || isTextOnly
                ? (textColor ?? Theme.of(context).colorScheme.primary)
                : Colors.white,
          ),
        ),
      );
    }

    // Normal content with optional icon and/or prefix/suffix
    final textStyle = isSmall
        ? Theme.of(context).textTheme.labelMedium
        : Theme.of(context).textTheme.labelLarge;

    final color = textColor ??
        (isOutlined || isTextOnly
            ? Theme.of(context).colorScheme.primary
            : Colors.white);

    // Create row for text with icon, prefix, suffix
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (prefix != null) ...[
          prefix!,
          const SizedBox(width: AppDimensions.sm),
        ],
        if (icon != null && suffix == null) ...[
          Icon(icon, size: isSmall ? 16.0 : 20.0, color: color),
          const SizedBox(width: AppDimensions.sm),
        ],
        Text(
          text,
          style: textStyle?.copyWith(color: color),
        ),
        if (icon != null && suffix != null) ...[
          const SizedBox(width: AppDimensions.sm),
          Icon(icon, size: isSmall ? 16.0 : 20.0, color: color),
        ],
        if (suffix != null) ...[
          const SizedBox(width: AppDimensions.sm),
          suffix!,
        ],
      ],
    );
  }
}
