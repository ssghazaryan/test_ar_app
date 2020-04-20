import 'package:flutter/material.dart';

class MenuItemWidget extends StatelessWidget {
  final String title;
  final Function onPress;
  final String secondTitle;
  MenuItemWidget({
    @required this.title,
    @required this.onPress, 
    this.secondTitle = '',
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          title,
          textAlign: TextAlign.start,
        ),
        subtitle: SelectableText(
          secondTitle,
          textAlign: TextAlign.start,
        ),
        onTap: onPress,
        trailing: Icon(Icons.keyboard_arrow_right),
      ),
    );
  }
}
