import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String? imageUrl;
  final double radius;
  final Color? backgroundColor;
  final Color? iconColor;
  final double? iconSize;

  const ProfileAvatar({
    super.key,
    required this.radius,
    this.imageUrl,
    this.backgroundColor,
    this.iconColor,
    this.iconSize,
  });

  bool get _hasImage => imageUrl != null && imageUrl!.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final avatarDiameter = radius * 2;

    return ClipOval(
      child: SizedBox(
        width: avatarDiameter,
        height: avatarDiameter,
        child: _hasImage
            ? Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                width: avatarDiameter,
                height: avatarDiameter,
                errorBuilder: (_, __, ___) => _fallback(),
              )
            : _fallback(),
      ),
    );
  }

  Widget _fallback() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: backgroundColor ?? Colors.grey.shade300,
      alignment: Alignment.center,
      child: Icon(
        Icons.person,
        color: iconColor ?? Colors.white,
        size: iconSize ?? radius,
      ),
    );
  }
}
