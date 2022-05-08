import 'package:flutter/material.dart';
import 'package:grocery_helper_app/presentation/screens/settings/section_editor.dart';

class SettingsChoice extends StatelessWidget {
  const SettingsChoice({
    Key? key,
    required this.iconData,
    required this.name,
    required this.redirect,
  }) : super(key: key);

  final IconData iconData;
  final String name;
  final Function redirect;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        height: 60.0,
        width: MediaQuery.of(context).size.width,
        child: GestureDetector(
          onTap: () {
            redirect();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(iconData),
                  Padding(
                    padding: EdgeInsets.only(left: 12.0),
                    child: Text(
                      name,
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                ],
              ),
              const Icon(Icons.keyboard_arrow_right_outlined),
            ],
          ),
        ),
      ),
      const Divider(
        height: 2.0,
        color: Colors.grey,
      ),
    ]);
  }
}
