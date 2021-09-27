import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import 'package:sally_prayer_times/Classes/Configuration.dart';
import 'package:sally_prayer_times/Providers/ThemeProvider.dart';

class AthanPlayer extends StatefulWidget {
  String title;
  List<DropdownMenuItem<String>> items;
  AthanPlayer({@required this.title, @required this.items});
  @override
  _AthanPlayer createState() => _AthanPlayer(title: this.title, items: this.items);
}

class _AthanPlayer extends State<AthanPlayer> {
  String title;
  List<DropdownMenuItem<String>> items;
  _AthanPlayer({@required this.title, @required this.items});

  final assetsAudioPlayer = AssetsAudioPlayer();
  String selectedValue = translate('ali_ben_ahmed_mala');

  void playAthan(){
    if(selectedValue == translate('abd_el_basset_abd_essamad')){
      play(Configuration.athanPath_abd_el_basset_abd_essamad);
    }else if(selectedValue == translate('ali_ben_ahmed_mala')){
      play(Configuration.athanPath_ali_ben_ahmed_mala);
    }else if(selectedValue == translate('farou9_abd_errehmane_hadraoui')){
      play(Configuration.athanPath_farou9_abd_errehmane_hadraoui);
    }else if(selectedValue == translate('mohammad_ali_el_banna')){
      play(Configuration.athanPath_mohammad_ali_el_banna);
    }else if(selectedValue == translate('mohammad_khalil_raml')){
      play(Configuration.athanPath_mohammad_khalil_raml);
    }
  }

  void play(String path) async{
    assetsAudioPlayer.open(
      Audio(path),
      showNotification: false,
      autoStart: true,
    );
  }

  void stopAthan() async{
    assetsAudioPlayer.stop();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(widget.title),
      children: [
        Padding(
            padding: EdgeInsets.all(0.0),
          child: DropdownButton<String>(
            value: selectedValue,
            items: items,
            onChanged: (String value) {setState(() {
              selectedValue = value;
            });},
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10.0, bottom: 0.0, right: 5.0, top: 0.0),
              child: IconButton(icon: Icon(Icons.play_circle_outline, color: Provider.of<ThemeProvider>(context, listen: false).appBarColor,), onPressed: playAthan,),
            ),
            Padding(
              padding: EdgeInsets.only(left: 5.0, bottom: 0.0, right: 10.0, top: 0.0),
              child: IconButton(icon: Icon(Icons.stop_circle_outlined, color: Provider.of<ThemeProvider>(context, listen: false).appBarColor,), onPressed: stopAthan,),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10.0, bottom: 0.0, right: 10.0, top: 0.0),
              child: TextButton(
                onPressed: () {
                  assetsAudioPlayer.stop();
                  Navigator.pop(context, selectedValue);
                },
                child: Text(translate('Done')),
              ),
            ),
          ],
        ),
      ],
    );
  }
}