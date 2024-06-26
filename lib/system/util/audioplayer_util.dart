import 'package:audioplayers/audioplayers.dart';

class AudioPlayerUtils {

  static AudioPlayer? player;
  static AudioCache audioCache = AudioCache();

  static init(){
    if(player == null){
      player = AudioPlayer();
    }
  }

  static Future<void> playAssetAudio(String resource, bool needLoop) async {
    init();
    Source source = AssetSource(resource);
     player?.setReleaseMode(needLoop ? ReleaseMode.loop : ReleaseMode.release);
    try {
      player?.play(source, mode: PlayerMode.lowLatency);
    } catch (e) {
      print("Error playing audio: $e");
      // Optionally reset the player
      player?.stop(); // Stop any current play
      player?.release(); // Release resources
      player = null; // Reset the player
      init(); // Re-initialize the player
    }
  }

  static Future<void> playerStop() async {
    await player?.stop();
  }

  static Future<void> playerDispose() async {
    await player?.dispose();
  }

  static Future<void> playerRelease() async {
    await player?.release();
  }
}
