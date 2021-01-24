import 'package:flutter/material.dart';

class PageButton extends StatelessWidget {
  final IconData icon;
  final String pageName;
  final Function onPress;

  PageButton({this.icon, this.pageName, this.onPress});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(1000),
      child: InkWell(
        borderRadius: BorderRadius.circular(1000),
        splashColor: Colors.grey,
        onTap: onPress,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 40, color: Colors.deepOrangeAccent,),
            Text(pageName, style: Theme.of(context).textTheme.button,)
          ],
        ),
      ),
    );
  }
}
