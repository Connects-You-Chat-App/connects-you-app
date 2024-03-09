import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Avatar extends StatelessWidget {

  const Avatar({
    super.key,
    this.photoUrl,
    this.firstLetter,
    this.icon,
  });
  final String? photoUrl;

  final Icon? icon;
  final String? firstLetter;

  Widget squircleAvatar() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(17.5),
        color: Get.theme.primaryColor,
        image: photoUrl == null
            ? null
            : DecorationImage(
                image: NetworkImage(photoUrl!),
                fit: BoxFit.cover,
              ),
      ),
      child: photoUrl == null
          ? icon ??
              (firstLetter == null
                  ? null
                  : Center(
                      child: Text(
                        firstLetter!,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ))
          : null,
    );
  }

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return SizedBox(
      height: 48,
      width: 48,
      child: squircleAvatar(),
    );
  }
}