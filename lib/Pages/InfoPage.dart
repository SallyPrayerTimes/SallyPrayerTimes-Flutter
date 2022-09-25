import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import 'package:sally_prayer_times/Providers/ThemeProvider.dart';

class InfoPage extends StatefulWidget{
  InfoPage({Key? key}) : super(key: key);
  @override
  _InfoPage createState() => _InfoPage();
}

class _InfoPage extends State<InfoPage>{
  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    Color appBarColor = Provider.of<ThemeProvider>(context, listen: true).appBarColor;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: statusBarHeight,),
            Row(
              children: [
                Flexible(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 0, right: 10, left: 10),
                      child: Text(translate('Version')+': 31.3.22(35)', style: TextStyle(fontSize: 18, color: appBarColor,),maxLines: 50,),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Flexible(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 0, right: 10, left: 10),
                      child: Text(translate('sally_waqf_message'), style: TextStyle(fontSize: 14,),maxLines: 50,),
                    ),
                  ),
                ),
              ],
            ),
            Divider(),
            Row(
              children: [
                Flexible(
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 0, right: 10, left: 10),
                      child: Text(translate('Slight_Different_in_Prayer_Times'), style: TextStyle(fontSize: 22, color: appBarColor,),maxLines: 50,),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Flexible(
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 0, right: 10, left: 10),
                      child: Text('-'+translate('info_message_1')+'\n'
                        '-'+translate('info_message_2'), style: TextStyle(fontSize: 14,),maxLines: 50,),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Flexible(
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 0, right: 10, left: 10),
                      child: Text(translate('calculation_method'), style: TextStyle(fontSize: 22, color: appBarColor,),maxLines: 5,),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Flexible(
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 0, right: 10, left: 10),
                      child: Text(translate('info_message_3'), style: TextStyle(fontSize: 14,),maxLines: 50,),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Flexible(
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 0, right: 10, left: 10),
                      child: Text(translate('info_message_4'), style: TextStyle(fontSize: 14,),maxLines: 50,),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Flexible(
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 0, right: 10, left: 10),
                      child: Text('1- '+translate('UmmAlQuraUniv')+'\n'
                          +translate('info_message_5')+'\n'
                          +translate('Fajr_angle')+': 18.5\n'
                          '* '+translate('info_message_6')+'\n'
                          +translate('Ishaa_angle')+': '+translate('info_message_7'), style: TextStyle(fontSize: 14,),maxLines: 50,),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Flexible(
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 0, right: 10, left: 10),
                      child: Text('2- '+translate('MuslimWorldLeague')+'\n'
                          +translate('info_message_8')+'\n'
                          +translate('Fajr_angle')+': 18\n'
                          +translate('Ishaa_angle')+': 17', style: TextStyle(fontSize: 14,),maxLines: 50,),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Flexible(
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 0, right: 10, left: 10),
                      child: Text('3- '+translate('EgytionGeneralAuthorityofSurvey')+'\n'
                          +translate('info_message_9')+'\n'
                          +translate('Fajr_angle')+': 19.5\n'
                          +translate('Ishaa_angle')+': 17.5', style: TextStyle(fontSize: 14,),maxLines: 50,),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Flexible(
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 0, right: 10, left: 10),
                      child: Text('4- '+translate('UnivOfIslamicScincesKarachi')+'\n'
                          +translate('info_message_10')+'\n'
                          +translate('Fajr_angle')+': 18\n'
                          +translate('Ishaa_angle')+': 18', style: TextStyle(fontSize: 14,),maxLines: 50,),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Flexible(
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 0, right: 10, left: 10),
                      child: Text('5- '+translate('IslamicSocietyOfNorthAmerica')+'\n'
                          +translate('info_message_11')+'\n'
                          +translate('Fajr_angle')+': 15\n'
                          +translate('Ishaa_angle')+': 15', style: TextStyle(fontSize: 14,),maxLines: 50,),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Flexible(
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 0, right: 10, left: 10),
                      child: Text('6- '+translate('FederationofIslamicOrganizationsinFrance')+'\n'
                          +translate('info_message_12')+'\n'
                          +translate('Fajr_angle')+': 12\n'
                          +translate('Ishaa_angle')+': 12', style: TextStyle(fontSize: 14,),maxLines: 50,),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Flexible(
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 0, right: 10, left: 10),
                      child: Text('7- '+translate('TheMinistryofAwqafandIslamicAffairsinKuwait')+'\n'
                          +translate('info_message_13')+'\n'
                          +translate('Fajr_angle')+': 18\n'
                          +translate('Ishaa_angle')+': 17.5', style: TextStyle(fontSize: 14,),maxLines: 50,),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Flexible(
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 0, right: 10, left: 10),
                      child: Text(translate('Angle_Based_Method'), style: TextStyle(fontSize: 22, color: appBarColor,),maxLines: 50,),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Flexible(
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 0, right: 10, left: 10),
                      child: Text('-'+translate('info_message_14')+'\n'
                          '-'+translate('info_message_15'), style: TextStyle(fontSize: 14,),maxLines: 50,),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Flexible(
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 0, right: 10, left: 10),
                      child: Text(translate('Calculating_Asr_Time'), style: TextStyle(fontSize: 22, color: appBarColor,),maxLines: 50,),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Flexible(
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 0, right: 10, left: 10),
                      child: Text(translate('info_message_16')+':\n'
                          '-'+translate('info_message_17')+'\n'
                          '-'+translate('info_message_18'), style: TextStyle(fontSize: 14,),maxLines: 50,),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 0, 0.0, 30.0),
            )
          ],
        ),
      ),
    );
  }

}