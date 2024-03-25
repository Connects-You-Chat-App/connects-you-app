import 'package:flutter/material.dart';

import '../../../models/objects/room_with_room_users_and_messages.dart';
import '../../common/avatar.dart';

class UserRow extends StatelessWidget {
  const UserRow({
    required this.user,
    required this.onLongPress,
    required this.onTap,
    super.key,
    this.isSelected = false,
  });

  final UserModel user;
  final bool isSelected;
  final Function() onLongPress;
  final Function() onTap;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return ListTile(
      selected: isSelected,
      selectedTileColor: theme.primaryColor.withOpacity(0.25),
      key: ValueKey(user.id),
      leading: Avatar(
        photoUrl: user.photoUrl,
        firstLetter: user.name.isEmpty ? '' : user.name[0],
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
