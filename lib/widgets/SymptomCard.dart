import 'package:flutter/material.dart';

class SymptomCard extends StatelessWidget {
  SymptomCard(
      {@required this.active,
      @required this.onActiveChange,
      @required this.title,
      @required this.description});

  final bool active;
  final VoidCallback onActiveChange;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16),
      child: InkResponse(
        onTap: onActiveChange,
        child: Card(
          shape: RoundedRectangleBorder(
              side: BorderSide(
                  color: active
                      ? Theme.of(context).primaryColor
                      : Colors.transparent,
                  width: 2),
              borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 24, bottom: 24),
            child: Column(
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: active,
                      onChanged: (bool value) {
                        onActiveChange();
                      },
                    ),
                    Flexible(child: Text(title, style: Theme.of(context).textTheme.headline6,)),
                  ],
                ),
                Divider(),
                Align(alignment: Alignment.centerLeft,child: Text(description,))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
