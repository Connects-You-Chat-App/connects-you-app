import 'package:connects_you/models/base/user.dart';
import 'package:connects_you/widgets/common/avatar.dart';
import 'package:flutter/material.dart';

class UserRow extends StatelessWidget {
  final User user;
  final bool isSelected;
  final Function() onLongPress;
  final Function() onTap;

  const UserRow({
    super.key,
    required this.user,
    this.isSelected = false,
    required this.onLongPress,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      selected: isSelected,
      selectedTileColor: theme.primaryColor.withOpacity(0.25),
      key: ValueKey(user.id),
      leading: Avatar(
        photoUrl: user.photoUrl,
        firstLetter: user.name.isEmpty ? "" : user.name[0],
      ),
      title: Text(user.name),
      subtitle: Text(
        user.email,
        style: TextStyle(
          color: theme.primaryColor.withOpacity(0.75),
        ),
      ),
      onLongPress: onLongPress,
      onTap: onTap,
    );
  }
}