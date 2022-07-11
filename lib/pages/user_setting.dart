import 'package:animated_button/animated_button.dart';
import 'package:covid/models/settings_manager.dart';
import 'package:covid/pages/register_intro.dart';
import 'package:covid/widget/my_colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../components/music.dart';
import '../db/database_helper.dart';
import '../models/settings_state.dart';

import '../widget/button_profile.dart';
import 'edit_profile.dart';

class UserSetting extends StatefulWidget {
  const UserSetting({Key? key}) : super(key: key);

  @override
  State<UserSetting> createState() => _UserSettingState();
}

class _UserSettingState extends State<UserSetting> {
  Music gameMusic = Music();
  final settingsState = SettingsState();
  var parserEmoji = EmojiParser();

  String? _imageFile;
  var dbHelper = DatabaseHelper.instance;

  final kInnerDecoration = BoxDecoration(
    color: Colors.black87,
    borderRadius: BorderRadius.circular(20),
  );

  final kGradientBoxDecoration = BoxDecoration(
    gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [
      Colors.deepOrange,
      Colors.grey,
      Colors.deepOrange,
      Colors.grey,
      Colors.deepOrange,
      Colors.grey,
      Colors.deepOrange,
      Colors.grey,
    ]),
    borderRadius: BorderRadius.circular(20),
    // boxShadow: <BoxShadow>[
    //   BoxShadow(
    //       color: Colors.black.withOpacity(0.2),
    //       offset: const Offset(1.1, 4.0),
    //       blurRadius: 8.0),
    // ],
  );

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsManager>(
      builder: (context, settingsStatus, child) {
        return AnimatedButton(
          onPressed: () {
            settingsStatus.musicStatus ? gameMusic.buttonClick() : "";
            settingsStatus.vibrateStatus ? HapticFeedback.vibrate() : "";
            setState(() {
              settingsDialog(context);
            });
          },
          enabled: true,
          shadowDegree: ShadowDegree.dark,
          width: ResponsiveValue(
            context,
            defaultValue: 40.0,
            valueWhen: const [
              Condition.smallerThan(
                name: MOBILE,
                value: 40.0,
              ),
              Condition.smallerThan(
                name: TABLET,
                value: 50.0,
              ),
              Condition.largerThan(
                name: TABLET,
                value: 60.0,
              )
            ],
          ).value!,
          height: ResponsiveValue(
            context,
            defaultValue: 40.0,
            valueWhen: const [
              Condition.smallerThan(
                name: MOBILE,
                value: 40.0,
              ),
              Condition.smallerThan(
                name: TABLET,
                value: 50.0,
              ),
              Condition.largerThan(
                name: TABLET,
                value: 60.0,
              )
            ],
          ).value!,
          duration: 60,
          color: Colors.transparent,
          shape: BoxShape.rectangle,
          child: Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 12.0,
                    offset: Offset(0.0, 5.0),
                  ),
                ],
                border: Border.all(color: Colors.white70),
                gradient: const RadialGradient(radius: 0.8, colors: [Color(0xFFb3471e), Color(0xFF4b2318)]),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.settings,
                  size: ResponsiveValue(
                    context,
                    defaultValue: 30.0,
                    valueWhen: const [
                      Condition.smallerThan(
                        name: MOBILE,
                        value: 30.0,
                      ),
                      Condition.smallerThan(
                        name: TABLET,
                        value: 35.0,
                      ),
                      Condition.largerThan(
                        name: TABLET,
                        value: 45.0,
                      )
                    ],
                  ).value,
                ),
              )),
        );
      },
    );
  }

  Future settingsDialog(
    BuildContext context,
  ) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Consumer<SettingsManager>(
            builder: (context, settingsStatus, child) {
              return Dialog(
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ), //this right here
                child: Stack(children: [
                  Container(
                    height: ResponsiveValue(
                      context,
                      defaultValue: 380.0,
                      valueWhen: const [
                        Condition.largerThan(
                          name: TABLET,
                          value: 430.0,
                        )
                      ],
                    ).value,
                    width: ResponsiveValue(
                      context,
                      defaultValue: MediaQuery.of(context).size.height / 3,
                      valueWhen: const [
                        Condition.largerThan(
                          name: TABLET,
                          value: 400.0,
                        )
                      ],
                    ).value,
                    // width: MediaQuery.of(context).size.height / 3,
                    decoration: kGradientBoxDecoration,
                    // color: Colors.black,
                    padding: const EdgeInsets.all(5),
                    child: Container(
                      height: 400,
                      decoration: kInnerDecoration,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Spacer(),
                            Text(
                              "Settings",
                              style: TextStyle(
                                  fontSize: ResponsiveValue(
                                    context,
                                    defaultValue: 34.0,
                                    valueWhen: const [
                                      Condition.largerThan(
                                        name: TABLET,
                                        value: 44.0,
                                      )
                                    ],
                                  ).value,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.yellow),
                            ),

                            const Spacer(
                              flex: 2,
                            ),
                            InkWell(
                              child: const ButtonProfile(
                                text: "Edit profile",
                              ),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(builder: ((context) => const EditProfile())));
                              },
                            ),
                            const Spacer(),

                            InkWell(
                              child: const ButtonProfile(
                                text: "Delete account",
                              ),
                              onTap: () async {
                                Alert(
                                  context: context,
                                  type: AlertType.warning,
                                  title: "Delete account",
                                  desc: "Are you sure you want to delete an account?",
                                  buttons: [
                                    DialogButton(
                                      onPressed: () => Navigator.pop(context),
                                      color: const Color.fromARGB(205, 146, 154, 156),
                                      child: const Text(
                                        "No",
                                        style: TextStyle(color: SolidColors.white, fontSize: 20),
                                      ),
                                    ),
                                    DialogButton(
                                      onPressed: () async {
                                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: ((context) => const RegisterIntro())));
                                        await dbHelper.delete(DatabaseHelper.currentLoggedInEmail!);
                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                          content: Text("Delete account is successfully."),
                                        ));
                                      },
                                      gradient: const LinearGradient(colors: GradiantColors.alertColor),
                                      child: const Text(
                                        "Yes",
                                        style: TextStyle(color: SolidColors.white, fontSize: 20),
                                      ),
                                    )
                                  ],
                                ).show();
                              },
                            ),
                            const Spacer(),
                            InkWell(
                                onTap: () async {
                                  Alert(
                                    context: context,
                                    type: AlertType.warning,
                                    title: "Log out",
                                    desc: "Are you sure you want to lig out?",
                                    buttons: [
                                      DialogButton(
                                        onPressed: () => Navigator.pop(context),
                                        color: const Color.fromARGB(205, 146, 154, 156),
                                        child: const Text(
                                          "No",
                                          style: TextStyle(color: SolidColors.white, fontSize: 20),
                                        ),
                                      ),
                                      DialogButton(
                                        onPressed: () async {
                                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: ((context) => const RegisterIntro())));

                                          DatabaseHelper dbHelper = DatabaseHelper.instance;
                                          await dbHelper.updateLoggedInUser(0, DatabaseHelper.currentLoggedInEmail);

                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                            content: Text("Logout completed successfully."),
                                          ));
                                        },
                                        gradient: const LinearGradient(colors: GradiantColors.alertColor),
                                        child: const Text(
                                          "Yes",
                                          style: TextStyle(color: SolidColors.white, fontSize: 20),
                                        ),
                                      )
                                    ],
                                  ).show();
                                },
                                child: const ButtonProfile(
                                  text: "Log out",
                                )),

                            // const Divider(
                            //   height: 5,
                            //   thickness: 1,
                            //   indent: 1,
                            //   endIndent: 1,
                            //   color: Colors.grey,
                            // ),
                            //    const Spacer(),
                            //Instructions
                            const Spacer(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      // margin: EdgeInsets.all(1),
                      height: ResponsiveValue(
                        context,
                        defaultValue: 35.0,
                        valueWhen: const [
                          Condition.largerThan(
                            name: TABLET,
                            value: 45.0,
                          )
                        ],
                      ).value,
                      width: ResponsiveValue(
                        context,
                        defaultValue: 35.0,
                        valueWhen: const [
                          Condition.largerThan(
                            name: TABLET,
                            value: 45.0,
                          )
                        ],
                      ).value,
                      decoration: BoxDecoration(
                        color: Colors.deepOrange,
                        borderRadius: BorderRadius.circular(100),
                        boxShadow: const <BoxShadow>[
                          BoxShadow(color: Colors.black, offset: Offset(-1.0, 1.0), blurRadius: 5.0),
                        ],
                      ),
                      child: Center(
                          child: GestureDetector(
                        onTap: () {
                          settingsStatus.musicStatus ? gameMusic.buttonClick() : "";
                          settingsStatus.vibrateStatus ? HapticFeedback.vibrate() : "";
                          Navigator.of(context).pop();
                        },
                        child: Center(
                          child: Text(
                            "X",
                            style: TextStyle(
                                fontSize: ResponsiveValue(
                                  context,
                                  defaultValue: 25.0,
                                  valueWhen: [
                                    Condition.largerThan(
                                      name: TABLET,
                                      value: ResponsiveValue(
                                        context,
                                        defaultValue: 25.0,
                                        valueWhen: const [
                                          Condition.largerThan(
                                            name: TABLET,
                                            value: 30.0,
                                          )
                                        ],
                                      ).value,
                                    )
                                  ],
                                ).value,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )),
                    ),
                  ),
                ]),
              );
            },
          );
        });
  }
}
