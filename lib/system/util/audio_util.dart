import 'dart:async';
import 'dart:io';

import 'package:audio_session/audio_session.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:frechat/system/call_back_function.dart';
import 'package:frechat/system/repository/http_setting.dart';
import 'package:frechat/system/util/permission_util.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:audioplayers/audioplayers.dart' as audio;
import 'package:just_audio/just_audio.dart' as jAudio;


class AudioUtils {
  static FlutterSoundRecorder? _recorder;
  static FlutterSoundPlayer? _player;
  static String? filePath;
  static int? audioDuration;
  static bool isPlaying = false;
  static StreamSubscription<RecordingDisposition>? _streamSubscription;

  static Future<void> init() async {
    if (_recorder != null && _player != null) {
      return;
    }
    PermissionUtil.checkAndRequestMicrophonePermission();
    _recorder = FlutterSoundRecorder();
    _player = FlutterSoundPlayer();
    _recorder!.openRecorder().then((value) {
      _recorder!.setSubscriptionDuration(const Duration(milliseconds: 1000));
    });
    _player!.openPlayer().then((value) {});
    _config();
  }

  static _config() async {
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
      avAudioSessionCategoryOptions:
          AVAudioSessionCategoryOptions.allowBluetooth |
              AVAudioSessionCategoryOptions.defaultToSpeaker,
      avAudioSessionMode: AVAudioSessionMode.spokenAudio,
      avAudioSessionRouteSharingPolicy:
          AVAudioSessionRouteSharingPolicy.defaultPolicy,
      avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
      androidAudioAttributes: const AndroidAudioAttributes(
        contentType: AndroidAudioContentType.speech,
        flags: AndroidAudioFlags.none,
        usage: AndroidAudioUsage.voiceCommunication,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
      androidWillPauseWhenDucked: true,
    ));
    await _player!.closePlayer();
    await _player!.openPlayer();
    await _player!.setSubscriptionDuration(const Duration(milliseconds: 10));
  }

  //開始錄音
  static Future<bool> startRecording(int maxTime) async {
    await init();
    final String uuid = '${const Uuid().v4()}.aac';
    Completer<bool> completer = Completer<bool>();
    final tempDir = await getTemporaryDirectory();
    final allPath = '${tempDir.path}/$uuid';
    await _recorder?.startRecorder(
      toFile: allPath,
      codec: Codec.aacADTS,
    );
    filePath = allPath;
    _streamSubscription = _recorder!.onProgress!.listen((event) {
      if (_recorder!.isRecording) {
        if (event.duration.inSeconds >= maxTime) {
          stopRecording();
          completer.complete(false);
        }
      }
      audioDuration = event.duration.inSeconds;
    });
    return completer.future;
  }

  //停止錄音
  static Future<void> stopRecording() async {

    if(_recorder == null){
      return;
    }
    await _recorder?.stopRecorder();

    if(_streamSubscription == null) {
      return ;
    }
    _streamSubscription?.cancel();
    _streamSubscription = null;
  }
  //開始播放
  static Future<bool> startPlaying() async {
    Completer<bool> completer = Completer<bool>();
    await init();
    isPlaying = true;
    _player?.startPlayer(
        codec: Codec.aacADTS,
        fromURI: filePath,
        whenFinished: () {
          isPlaying = false;
          return completer.complete(true);
        });
    return completer.future;
  }

  //開始播放
  static Future<bool> startPlayingFromUrl(
      {required String audioUrl}) async {
    Completer<bool> completer = Completer<bool>();
    await init();
    isPlaying = true;
    _player?.startPlayer(
        fromURI: audioUrl,
        whenFinished: () {
          isPlaying = false;
          return completer.complete(true);
        });
    return completer.future;
  }

  //停止播放
  static Future<void> stopPlaying() async {
    if(_player == null){
      return;
    }
    isPlaying = false;
    await _player?.stopPlayer();
  }

  static Future<Duration?> getAudioTime(
      {required String audioUrl, required bool addBaseImagePath}) async {
    try {
      Duration? duration;
      String url = audioUrl;
      audio.AudioPlayer audioPlayer = audio.AudioPlayer();
      jAudio.AudioPlayer justAudio = jAudio.AudioPlayer();
      if (addBaseImagePath == true) {
        url = HttpSetting.baseImagePath + audioUrl;
      }
      if(Platform.isIOS){
        if(url.contains('http')){
          audioPlayer.setSourceUrl(url);
        }else{
          audioPlayer.setSourceDeviceFile(url);
        }
        duration = await audioPlayer.getDuration();

      }else{
        duration = await justAudio.setUrl(url);
      }

      return duration;
    } catch (e) {
      print("Error loading audio: $e");
      return null;
    }
  }

  static Future<String?> renameFileWithExtension(String oldFilePath, String newFileNameWithExtension) async {
    try {
      // 获取文件的目录路径
      final directory = Directory(oldFilePath).parent;

      // 构建新的文件路径，将新文件名添加到目录路径后面
      final newFilePath = '${directory.path}/$newFileNameWithExtension';

      // 创建一个表示旧文件的File对象
      final oldFile = File(oldFilePath);

      // 创建一个表示新文件的File对象
      final newFile = File(newFilePath);

      // 重命名文件
      await oldFile.rename(newFile.path);

      print('文件已成功重命名为：$newFileNameWithExtension');

      return newFileNameWithExtension; // 返回新文件名（包括扩展名）
    } catch (e) {
      print('文件重命名失败：$e');
      return null; // 如果重命名失败，返回null
    }
  }
}
