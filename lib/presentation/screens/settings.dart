import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_helper_app/business_logic/blocs/meal_bloc/meal_bloc.dart';
import 'package:grocery_helper_app/business_logic/notifiers/section_notifier.dart';
import 'package:grocery_helper_app/data/models/meal.dart';
import 'package:grocery_helper_app/data/repositories/section/section_repository.dart';
import 'package:grocery_helper_app/presentation/screens/settings/section_editor.dart';
import 'package:grocery_helper_app/presentation/widgets/settings_choice.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) =>
            SectionNotifier(context: context, sectionRepository: SectionRepository()),
        child: const SettingsMenu());
  }
}

class SettingsMenu extends StatelessWidget {
  const SettingsMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                context.read<MealBloc>().add(GetMealsEvent());
                Navigator.pop(context);
              }),
          title: const Text('Settings'),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(50.0, 30.0, 50.0, 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SettingsChoice(
                name: "Theme",
                iconData: Icons.format_paint_outlined,
                redirect: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => const SectionEditorPage()));
                },
              ),
              SettingsChoice(
                name: "Section Order",
                iconData: Icons.list_alt_outlined,
                redirect: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => const SectionEditorPage()));
                },
              ),
            ],
          ),
        ));
  }
}
