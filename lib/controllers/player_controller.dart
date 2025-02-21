import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query_forked/on_audio_query.dart' show OnAudioQuery;
import 'package:permission_handler/permission_handler.dart';
// import 'package:on_audio_query_forked/on_audio_query.dart';

class PlayerController extends GetxController {
  final OnAudioQuery audioQuery = OnAudioQuery();
  final AudioPlayer audioPlayer = AudioPlayer();
  RxInt playerIndx = 0.obs;
  RxBool isPlaying = false.obs;
  var duration = "".obs;
  var position = "".obs;

  var max = 0.0.obs;
  var val = 0.0.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    checkPermission();
  }

  playSongs(String? url, int index) {
    try {
      playerIndx.value = index;
      audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(url!)));
      audioPlayer.play();
      updatePosition();
      isPlaying.value = true;
    } catch (e) {
      print(e.toString());
    }
  }

  changeDurationToSeconds(seconds) {
    var duration = Duration(seconds: seconds);
    audioPlayer.seek(duration);
  }

  updatePosition() {
    audioPlayer.durationStream.listen((d) {
      duration.value = d.toString().split(".")[0];
      max.value = d!.inSeconds.toDouble();
    });

    audioPlayer.positionStream.listen((p) {
      position.value = p.toString().split(".")[0];
      val.value = p.inSeconds.toDouble();
    });
  }

  checkPermission() async {
    var permission = await Permission.storage.request();
    if (permission.isGranted) {
    } else {
      checkPermission();
    }
  }
}
