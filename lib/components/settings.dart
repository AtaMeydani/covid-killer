import 'dart:async';

import 'package:animated_button/animated_button.dart';
import 'package:covid/models/settings_manager.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../config/game_config.dart';
import '../models/settings_state.dart';
import '../screens/game_screen.dart';
import 'music.dart';

class SettingDialog extends StatefulWidget {
  GameScreenState? object;

  SettingDialog({this.object, Key? key}) : super(key: key);

  @override
  State<SettingDialog> createState() => _SettingDialogState(object);
}

class _SettingDialogState extends State<SettingDialog> {
  Music gameMusic = Music();
  final settingsState = SettingsState();
  var parserEmoji = EmojiParser();
  GameScreenState? object;

  _SettingDialogState(this.object);

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
              if (object != null) {
                object!.timer.cancel();
              }
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
            ),
          ),
        );
      },
    );
  }

  Widget textInstructions(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white,
        fontSize: ResponsiveValue(
          context,
          defaultValue: 18.0,
          valueWhen: const [
            Condition.largerThan(
              name: TABLET,
              value: 28.0,
            )
          ],
        ).value,
      ),
    );
  }

  Future instructionsDialog(BuildContext context) {
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
                      defaultValue: 600.0,
                      valueWhen: const [
                        Condition.largerThan(
                          name: TABLET,
                          value: 650.0,
                        )
                      ],
                    ).value,
                    width: ResponsiveValue(
                      context,
                      defaultValue: MediaQuery.of(context).size.height / 2,
                      valueWhen: const [
                        Condition.largerThan(
                          name: TABLET,
                          value: 400.0,
                        )
                      ],
                    ).value,
                    decoration: kGradientBoxDecoration,
                    // color: Colors.black,
                    padding: const EdgeInsets.all(5),
                    child: Container(
                      height: 150,
                      decoration: kInnerDecoration,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // const Spacer(),
                              Text(
                                "How to play",
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
                              const SizedBox(
                                height: 15,
                              ),
                              textInstructions(
                                  "🔘  Touch the doctor and swipe it in any of the four directions with your finger to move the doctor one step towards the swiped direction."),
                              Container(
                                height: 400,
                                width: 400,
                                decoration: const BoxDecoration(
                                    image: DecorationImage(
                                  fit: BoxFit.cover,
                                  // opacity: 60,
                                  image: AssetImage("assets/instructions/four_directions.png"),
                                )),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              textInstructions("🔘  If the directions you're swiping have a wall, you won't be able to swipe the doctor."),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                height: 200,
                                width: 400,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    // opacity: 60,
                                    image: AssetImage("assets/instructions/wall_no_move.png"),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              textInstructions("🔘  If the directions you’re swiping have a apray, you get ${GameConfig.spraysInBox} sprays"),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                height: 220,
                                width: 400,
                                decoration: const BoxDecoration(
                                  // color: Colors.black,
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    // opacity: 60,
                                    image: AssetImage("assets/instructions/get_spray.png"),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              textInstructions("If the directions you’re swiping have a covid, You have to use your sprays to get rid of them.\n"
                                  "In case of success, the number of your sprays (for the red virus, ${GameConfig.redCovidSprayNeeded} and "
                                  "for the green virus, ${GameConfig.greenCovidSprayNeeded}) will be reduced.\n"
                                  "And in return you will receive a bonus (${GameConfig.redCovidScore} points for the red virus"
                                  " and ${GameConfig.greenCovidScore} points for the green virus).\n"
                                  "If the number of your sprays is not enough to kill the viruses, the game ends. So you have to kill all "
                                  "the viruses in the game and if you succeed, you will be given a number of stars based on the elapsed time."),
                              const SizedBox(
                                height: 15,
                              ),
                              AnimatedButton(
                                onPressed: () async {
                                  settingsStatus.musicStatus ? gameMusic.buttonClick() : "";
                                  settingsStatus.vibrateStatus ? HapticFeedback.vibrate() : "";
                                  Navigator.of(context).pop();
                                },
                                enabled: true,
                                shadowDegree: ShadowDegree.dark,
                                width: 60,
                                height: 40,
                                duration: 60,
                                color: Colors.transparent,
                                shape: BoxShape.rectangle,
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black, width: 2),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black54,
                                          blurRadius: 12.0,
                                          offset: Offset(0.0, 5.0),
                                        ),
                                      ],
                                      gradient: const LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Colors.orange,
                                          Colors.orangeAccent,
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(60)),
                                  child: const Center(
                                    child: Text(
                                      "OK",
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                              // const SizedBox(height: 15,),
                              // const Spacer(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
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
                          BoxShadow(color: Colors.black, offset: Offset(1.0, 1.0), blurRadius: 5.0),
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
                            child: Icon(
                              Icons.chevron_left,
                              size: ResponsiveValue(
                                context,
                                defaultValue: 35.0,
                                valueWhen: [
                                  const Condition.largerThan(
                                    name: TABLET,
                                    value: 35.0,
                                  )
                                ],
                              ).value,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: -1,
                    child: Container(
                      margin: const EdgeInsets.all(1),
                      height: 35,
                      width: 35,
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
                          child: const Center(
                            child: Text(
                              "X",
                              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ]),
              );
            },
          );
        });
  }

  Future settingsDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Consumer<SettingsManager>(
            builder: (context, settingsStatus, child) {
              return Dialog(
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
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
                            const SizedBox(
                              height: 20,
                            ),
                            //Music
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Music",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: ResponsiveValue(
                                        context,
                                        defaultValue: 20.0,
                                        valueWhen: const [
                                          Condition.largerThan(
                                            name: TABLET,
                                            value: 30.0,
                                          )
                                        ],
                                      ).value),
                                ),
                                FlutterSwitch(
                                  inactiveIcon: const Icon(
                                    Icons.volume_off,
                                    color: Colors.grey,
                                  ),
                                  activeIcon: const Icon(
                                    Icons.volume_up,
                                    color: Colors.orange,
                                  ),
                                  activeColor: Colors.orangeAccent,
                                  inactiveColor: Colors.grey,
                                  toggleColor: Colors.white,
                                  width: ResponsiveValue(
                                    context,
                                    defaultValue: 50.0,
                                    valueWhen: const [
                                      Condition.largerThan(
                                        name: TABLET,
                                        value: 55.0,
                                      )
                                    ],
                                  ).value!,
                                  height: ResponsiveValue(
                                    context,
                                    defaultValue: 26.0,
                                    valueWhen: const [
                                      Condition.largerThan(
                                        name: TABLET,
                                        value: 31.0,
                                      )
                                    ],
                                  ).value!,
                                  toggleSize: ResponsiveValue(
                                    context,
                                    defaultValue: 24.0,
                                    valueWhen: const [
                                      Condition.largerThan(
                                        name: TABLET,
                                        value: 29.0,
                                      )
                                    ],
                                  ).value!,
                                  value: settingsStatus.musicStatus,
                                  borderRadius: 28.0,
                                  padding: 0.0,
                                  switchBorder: Border.all(color: Colors.white),
                                  onToggle: (val) {
                                    settingsStatus.musicStatus ? gameMusic.switchMusic() : "";
                                    settingsStatus.vibrateStatus ? HapticFeedback.vibrate() : "";
                                    Provider.of<SettingsManager>(context, listen: false).updateMusicState(val);
                                  },
                                ),
                              ],
                            ),
                            const Spacer(),
                            //Vibrate
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Vibrate",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: ResponsiveValue(
                                        context,
                                        defaultValue: 20.0,
                                        valueWhen: const [
                                          Condition.largerThan(
                                            name: TABLET,
                                            value: 30.0,
                                          )
                                        ],
                                      ).value),
                                ),
                                FlutterSwitch(
                                  inactiveIcon: const Icon(
                                    Icons.vibration_outlined,
                                    color: Colors.grey,
                                  ),
                                  activeIcon: const Icon(
                                    Icons.vibration,
                                    color: Colors.orange,
                                  ),
                                  activeColor: Colors.orangeAccent,
                                  inactiveColor: Colors.grey,
                                  toggleColor: Colors.white,
                                  width: ResponsiveValue(
                                    context,
                                    defaultValue: 50.0,
                                    valueWhen: const [
                                      Condition.largerThan(
                                        name: TABLET,
                                        value: 55.0,
                                      )
                                    ],
                                  ).value!,
                                  height: ResponsiveValue(
                                    context,
                                    defaultValue: 26.0,
                                    valueWhen: const [
                                      Condition.largerThan(
                                        name: TABLET,
                                        value: 31.0,
                                      )
                                    ],
                                  ).value!,
                                  toggleSize: ResponsiveValue(
                                    context,
                                    defaultValue: 24.0,
                                    valueWhen: const [
                                      Condition.largerThan(
                                        name: TABLET,
                                        value: 29.0,
                                      )
                                    ],
                                  ).value!,
                                  value: settingsStatus.vibrateStatus,
                                  borderRadius: 28.0,
                                  padding: 0.0,
                                  switchBorder: Border.all(color: Colors.white),
                                  onToggle: (val) {
                                    settingsStatus.musicStatus ? gameMusic.switchMusic() : "";
                                    settingsStatus.vibrateStatus ? HapticFeedback.vibrate() : "";
                                    Provider.of<SettingsManager>(context, listen: false).updatevibrateState(val);
                                  },
                                ),
                              ],
                            ),
                            const Spacer(),
                            //Joy stick
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Joy Sticks",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: ResponsiveValue(
                                        context,
                                        defaultValue: 20.0,
                                        valueWhen: const [
                                          Condition.largerThan(
                                            name: TABLET,
                                            value: 30.0,
                                          )
                                        ],
                                      ).value),
                                ),
                                FlutterSwitch(
                                  inactiveIcon: const Icon(
                                    Icons.gamepad_outlined,
                                    color: Colors.grey,
                                  ),
                                  activeIcon: const Icon(
                                    Icons.gamepad,
                                    color: Colors.orange,
                                  ),
                                  activeColor: Colors.orangeAccent,
                                  inactiveColor: Colors.grey,
                                  toggleColor: Colors.white,
                                  width: ResponsiveValue(
                                    context,
                                    defaultValue: 50.0,
                                    valueWhen: const [
                                      Condition.largerThan(
                                        name: TABLET,
                                        value: 55.0,
                                      )
                                    ],
                                  ).value!,
                                  height: ResponsiveValue(
                                    context,
                                    defaultValue: 26.0,
                                    valueWhen: const [
                                      Condition.largerThan(
                                        name: TABLET,
                                        value: 31.0,
                                      )
                                    ],
                                  ).value!,
                                  toggleSize: ResponsiveValue(
                                    context,
                                    defaultValue: 24.0,
                                    valueWhen: const [
                                      Condition.largerThan(
                                        name: TABLET,
                                        value: 29.0,
                                      )
                                    ],
                                  ).value!,
                                  // width: 55.0,
                                  // height: 31.0,
                                  // toggleSize: 29.0,
                                  value: settingsStatus.joyStickstatus,
                                  borderRadius: 28.0,
                                  padding: 0.0,
                                  switchBorder: Border.all(color: Colors.white),
                                  onToggle: (val) {
                                    settingsStatus.musicStatus ? gameMusic.switchMusic() : "";
                                    settingsStatus.vibrateStatus ? HapticFeedback.vibrate() : "";
                                    Provider.of<SettingsManager>(context, listen: false).updateControllerState(val);
                                  },
                                ),
                              ],
                            ),
                            const Spacer(),
                            const Divider(
                              height: 5,
                              thickness: 1,
                              indent: 1,
                              endIndent: 1,
                              color: Colors.grey,
                            ),
                            const Spacer(),
                            //Instructions
                            GestureDetector(
                              onTap: () {
                                settingsStatus.musicStatus ? gameMusic.buttonClick() : "";
                                settingsStatus.vibrateStatus ? HapticFeedback.vibrate() : "";
                                instructionsDialog(context);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "📜  How to play",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: ResponsiveValue(
                                          context,
                                          defaultValue: 20.0,
                                          valueWhen: const [
                                            Condition.largerThan(
                                              name: TABLET,
                                              value: 30.0,
                                            )
                                          ],
                                        ).value),
                                  ),
                                  const Icon(
                                    Icons.chevron_right,
                                    size: 30,
                                    color: Colors.orange,
                                  ),
                                ],
                              ),
                            ),
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
                            if (object != null) {
                              object!.startTimer();
                            }
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
                        ),
                      ),
                    ),
                  ),
                ]),
              );
            },
          );
        });
  }
}
