import 'package:flutter/material.dart';
import 'package:riverpod_tut/models/userModel.dart';

class ItemDetailsView extends StatelessWidget {
  const ItemDetailsView({super.key, required this.data});

  final Datum data;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(data.avatar),
        ),
        Text(data.firstName + " " + data.lastName),
        Text(data.email)
      ],
    );
  }
}
