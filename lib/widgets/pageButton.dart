import 'package:flutter/material.dart';

//
class PageButton extends StatelessWidget {
  final IconData icon;
  final String pageName;
  final Function onPress;

  PageButton({this.icon, this.pageName, this.onPress});

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkResponse(
        borderRadius: BorderRadius.circular(1000),
        splashColor: Colors.grey,
        onTap: onPress,
        radius: 70,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 40, color: onPress == null ? Colors.grey : Colors.deepOrangeAccent,),
            Text(pageName, style: Theme.of(context).textTheme.button, textAlign: TextAlign.center,)
          ],
        ),
      ),
    );
  }
}
