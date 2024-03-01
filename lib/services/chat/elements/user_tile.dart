import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

// This should only be used for the add contact page
class UserTile extends StatefulWidget {
  final DocumentSnapshot data;
  final Function function;

  final String userUid;
  final IconData icon;

  const UserTile({
    super.key,
    required this.data,
    required this.function,
    required this.userUid,
    required this.icon,
  });

  @override
  State<UserTile> createState() => _UserTileState();
}

class _UserTileState extends State<UserTile> {
  late final username = widget.data['personal_data']['username'];
  late final imageUrl = widget.data['technical_data']['imageUrl'];

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => widget.function(),
      leading: CircleAvatar(
        radius: 24.0,
        child: imageUrl.isNotEmpty
            ? ClipOval(
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: imageUrl,
                  width: 48.0,
                  height: 48.0,
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                ),
              )
            : const Icon(Icons.person),
      ),
      title: Text(
        username,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onSecondary,
        ),
      ),
      trailing: Icon(widget.icon),
    );
  }
}
