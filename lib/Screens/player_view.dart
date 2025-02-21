import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player/controllers/player_controller.dart';
import 'package:on_audio_query_forked/on_audio_query.dart';

class PlayerView extends StatelessWidget {
  final List<SongModel> data;
  const PlayerView({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<PlayerController>();
    return Scaffold(
      backgroundColor: Color(0xff28282B),
      appBar: AppBar(backgroundColor: Color(0xff28282B)),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Obx(
          () => Column(
            spacing: 20,
            children: [
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.music_note_outlined,
                    size: 100,
                    color: Colors.purpleAccent,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    color: Color(0xff353935),
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    spacing: 20,
                    children: [
                      Text(
                        data[controller.playerIndx.value].displayNameWOExt,
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      Text(
                        data[controller.playerIndx.value].artist.toString(),
                        softWrap: true,
                        maxLines: 15,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),

                      Obx(
                        () => Row(
                          children: [
                            Text(
                              "${controller.position}",
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Expanded(
                              child: Slider(
                                value: controller.val.value,
                                max: controller.max.value,
                                min: Duration(seconds: 0).inSeconds.toDouble(),
                                onChanged: (val) {
                                  controller.changeDurationToSeconds(
                                    val.toInt(),
                                  );
                                  val = val;
                                },
                              ),
                            ),
                            Text(
                              "${controller.duration}",
                              textAlign: TextAlign.center,

                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                            onPressed: () {
                              controller.playSongs(
                                data[controller.playerIndx.value - 1].uri,
                                controller.playerIndx.value - 1,
                              );
                            },
                            icon: Icon(
                              Icons.skip_previous_rounded,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                          Obx(
                            () => GestureDetector(
                              onTap: () {
                                if (controller.isPlaying.value) {
                                  controller.audioPlayer.pause();
                                  controller.isPlaying(false);
                                } else {
                                  controller.audioPlayer.play();
                                  controller.isPlaying(true);
                                }
                              },
                              child: CircleAvatar(
                                radius: 33,

                                child: Transform.scale(
                                  scale: 2.2,
                                  child:
                                      controller.isPlaying.value
                                          ? Icon(
                                            Icons.pause,
                                            // size: 32,
                                            color: Colors.white,
                                          )
                                          : Icon(
                                            Icons.play_arrow,
                                            // size: 32,
                                            color: Colors.white,
                                          ),
                                ),
                              ),
                            ),
                          ),

                          IconButton(
                            onPressed: () {
                              controller.playSongs(
                                data[controller.playerIndx.value + 1].uri,
                                controller.playerIndx.value + 1,
                              );
                            },
                            icon: Icon(
                              Icons.skip_next_rounded,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
