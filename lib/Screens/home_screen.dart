import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player/Screens/player_view.dart';
import 'package:music_player/controllers/player_controller.dart';
import 'package:on_audio_query_forked/on_audio_query.dart'
    show OrderType, SongModel, UriType;

class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(PlayerController());
    return Scaffold(
      backgroundColor: Color(0xff28282B),
      appBar: AppBar(
        backgroundColor: Colors.purple.shade100,
        centerTitle: true,
        title: Text(
          "All Songs",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(15.0),

        child: FutureBuilder<List<SongModel>>(
          // Default values:
          future: controller.audioQuery.querySongs(
            sortType: null,
            orderType: OrderType.ASC_OR_SMALLER,
            uriType: UriType.EXTERNAL,
            ignoreCase: true,
          ),
          builder: (context, item) {
            // Display error, if any.
            if (item.hasError) {
              return Text(item.error.toString());
            }

            // Waiting content.
            if (item.data == null) {
              return Center(
                child: const CircularProgressIndicator(color: Colors.white),
              );
            }

            // 'Library' is empty.
            if (item.data!.isEmpty) return const Text("Nothing found!");
            print(item.data);
            // You can use [item.data!] direct or you can create a:
            // List<SongModel> songs = item.data!;
            return ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: item.data!.length,

              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  margin: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color(0xff353935),
                  ),
                  height: 90,
                  child: Obx(
                    () => ListTile(
                      leading: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.purple.shade100,
                        ),
                        child: Icon(
                          Icons.music_note,
                          size: 32,
                          color: Colors.purpleAccent,
                        ),
                      ),
                      title: Text(
                        item.data![index].title,
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      subtitle: Text(
                        item.data![index].artist ?? "No Artist",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          if (controller.isPlaying.value) {
                            controller.audioPlayer.pause();
                            controller.isPlaying(false);
                          } else {
                            controller.playSongs(item.data![index].uri, index);
                          }
                        },
                        icon:
                            controller.playerIndx.value == index &&
                                    controller.isPlaying.value
                                ? Icon(
                                  Icons.pause,
                                  color: Colors.white,
                                  size: 27,
                                )
                                : Icon(
                                  Icons.play_arrow,
                                  color: Colors.white,
                                  size: 27,
                                ),
                      ),
                      onTap: () {
                        Get.to(() => PlayerView(data: item.data!));
                        controller.playSongs(item.data![index].uri, index);
                      },
                    ),
                  ),
                );
              },
            );

            // ListView.builder(
            //   itemCount: item.data!.length,
            //   itemBuilder: (context, index) {
            //     return ListTile(
            //       title: Text(item.data![index].title),
            //       subtitle: Text(item.data![index].artist ?? "No Artist"),
            //       trailing: const Icon(Icons.arrow_forward_rounded),
            //       // This Widget will query/load image.
            //       // You can use/create your own widget/method using [queryArtwork].
            //       leading: QueryArtworkWidget(
            //         controller: _audioQuery,
            //         id: item.data![index].id,
            //         type: ArtworkType.AUDIO,
            //       ),
            //     );
            //   },
            // );
          },
        ),
      ),

      // child:
      //
    );
  }
}
