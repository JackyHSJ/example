import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/screens/call/calling_page_view_model.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/system/zego_call/model/zego_user_model.dart';
import 'package:zego_express_engine/zego_express_engine.dart';
import 'zego_express_service_defines.dart';

class ExpressService {
  ExpressService({required this.ref});
  ProviderRef ref;
  
  ZegoUserInfo localUser = ZegoUserInfo(userID: '', userName: '');
  String currentRoomID = '';

  ValueNotifier<Widget?> localVideoView = ValueNotifier<Widget?>(null);
  int localViewID = 0;
  ValueNotifier<Widget?> remoteVideoView = ValueNotifier<Widget?>(null);
  int remoteViewID = 0;

  List<String> playingStreams = [];

  bool isInit = false;
  String title = 'status';

  bool isPublishing = false;

  /// permission use
  bool isUseMic = true;
  bool isUseFrontCamera = true;

  int publishWidth = 0;
  int publishHeight = 0;

  /// 監聽用 StreamController
  // final networkSpeedTestQualityUpdateStreamCtrl = StreamController<>.broadcast();
  // final networkSpeedTestErrorUpdateStreamCtrl = StreamController<>.broadcast();

  Future<void> init({
    required int appID,
    String? appSign,
    ZegoScenario scenario = ZegoScenario.Default,
  }) async {
    isInit = true;
    initEventHandle();
    final profile = ZegoEngineProfile(appID, scenario, appSign: appSign)
      ..scenario = scenario;
    await ZegoExpressEngine.createEngineWithProfile(profile);
    ZegoExpressEngine.setEngineConfig(ZegoEngineConfig(advancedConfig: {
      'notify_remote_device_unknown_status': 'true',
      'notify_remote_device_init_status': 'true',
    }));

    /// config mirror
    enableVideoMirroring(true);
  }

  Future<void> uninit() async {
    uninitEventHandle();
    await ZegoExpressEngine.destroyEngine();
  }

  Future<void> connectUser(String id, String name, {String? token}) async {
    localUser
      ..userID = id
      ..userName = name;
  }

  Future<void> disconnectUser() async {
    localUser
      ..userID = ''
      ..userName = '';
    uninit();
  }

  Future<void> startPublishingStream({required String roomId}) async {
    String streamID = "${currentRoomID}_${localUser.userID}";
    ZegoPublisherConfig config = ZegoPublisherConfig(roomID: roomId);
    ZegoExpressEngine.instance.startPublishingStream(streamID, config: config);
  }

  Future<void> stopPublishingStream() async {
    ZegoExpressEngine.instance.stopPublishingStream();
  }

  Future<ZegoRoomLoginResult> loginRoom(String roomID, {required String token}) async {
    final user = ZegoUser(localUser.userID, localUser.userName);
    final config = ZegoRoomConfig(0, true, token);
    final joinRoomResult = await ZegoExpressEngine.instance.loginRoom(
      roomID,
      user,
      config: config,
    );
    if (joinRoomResult.errorCode == 0) {
      currentRoomID = roomID;
    }
    return joinRoomResult;
  }

  Future<ZegoRoomLogoutResult> logoutRoom([String roomID = '']) async {
    if (roomID.isEmpty) roomID = currentRoomID;
    final leaveResult = await ZegoExpressEngine.instance.logoutRoom(roomID);
    if (leaveResult.errorCode == 0) {
      currentRoomID = '';
      localVideoView.value = null;
      remoteVideoView.value = null;
      localViewID = 0;
      await ZegoExpressEngine.instance.stopPreview();
    }
    return leaveResult;
  }

  void useFrontFacingCamera(bool isFrontFacing) {
    ZegoExpressEngine.instance.useFrontCamera(isFrontFacing);
  }

  void enableVideoMirroring(bool isVideoMirror) {
    ZegoExpressEngine.instance.setVideoMirrorMode(
      isVideoMirror ? ZegoVideoMirrorMode.BothMirror : ZegoVideoMirrorMode.NoMirror,
    );
  }

  void muteAllPlayStreamAudio(bool mute) {
    for (var streamID in playingStreams) {
      ZegoExpressEngine.instance.mutePlayStreamAudio(streamID, mute);
    }
  }

  void setAudioOutputToSpeaker(bool useSpeaker) {
    if (kIsWeb) {
      muteAllPlayStreamAudio(!useSpeaker);
    } else {
      ZegoExpressEngine.instance.setAudioRouteToSpeaker(useSpeaker);
    }
  }

  void turnCameraOn(bool isOn) {
    ZegoExpressEngine.instance.enableCamera(isOn);
  }

  void turnMicrophoneOn(bool isOn) {
    ZegoExpressEngine.instance.mutePublishStreamAudio(!isOn);
  }

  void useFrontCamera(bool isFrontFacing) {
    ZegoExpressEngine.instance.useFrontCamera(isFrontFacing);
  }

  Future<void> startPlayingStream(String streamID) async {
    playingStreams.add(streamID);
    remoteVideoView.value = await ZegoExpressEngine.instance.createCanvasView((viewID) async {
      remoteViewID = viewID;
      ZegoCanvas canvas = ZegoCanvas(remoteViewID, viewMode: ZegoViewMode.AspectFill);
      await ZegoExpressEngine.instance.startPlayingStream(streamID, canvas: canvas);
    });
  }

  void stopPlayingStream(String streamID) async {
    playingStreams.remove(streamID);
    ZegoExpressEngine.instance.stopPlayingStream(streamID);
  }

  Future<void> startPreview() async {
    localVideoView.value = await ZegoExpressEngine.instance.createCanvasView((viewID) async {
      localViewID = viewID;
      final ZegoCanvas previewCanvas = ZegoCanvas(
        localViewID,
        viewMode: ZegoViewMode.AspectFill,
      );
      await ZegoExpressEngine.instance.startPreview(canvas: previewCanvas);
    });
  }

  Future<void> stopPreview() async {
    // localVideoView.value = null;
    localViewID = 0;
    await ZegoExpressEngine.instance.stopPreview();
  }

  Future<void> enableCustomVideoCapture({
    bool enable = true
  }) async {
    ZegoVideoBufferType bufferType = ZegoVideoBufferType.CVPixelBuffer;
    if (Platform.isAndroid) {
      bufferType = ZegoVideoBufferType.GLTexture2D;
    }
    final config = ZegoCustomVideoProcessConfig(bufferType);
    await ZegoExpressEngine.instance.enableCustomVideoProcessing(enable, config);
    // ZegoEffectsPlugin.instance.startWithCustomCaptureSource(enable);
  }

  Future<void> setVideoConfig() async {
    /// 以设置视频采集分辨率为 360p ，编码分辨率为 360p ，码率为 600 kbps，帧率为 15 fps 为例：
    ZegoVideoConfig videoConfig = ZegoVideoConfig(360, 640, 360, 640, 15, 600, ZegoVideoCodecID.Default);
    // 设置视频配置
    ZegoExpressEngine.instance.setVideoConfig(videoConfig);
    // ZegoVideoConfig videoConfig = ZegoVideoConfig.preset(ZegoVideoConfigPreset.Preset1080P);
    // ZegoExpressEngine.instance.setVideoConfig(videoConfig);
  }

  void uninitEventHandle() {
    ZegoExpressEngine.onRoomStreamUpdate = null;
    ZegoExpressEngine.onRoomUserUpdate = null;
    ZegoExpressEngine.onRoomStreamExtraInfoUpdate = null;
    ZegoExpressEngine.onRoomStateChanged = null;
    ZegoExpressEngine.onRoomExtraInfoUpdate = null;
    ZegoExpressEngine.onCapturedSoundLevelUpdate = null;
    ZegoExpressEngine.onRemoteSoundLevelUpdate = null;
    ZegoExpressEngine.onMixerSoundLevelUpdate = null;
    ZegoExpressEngine.onPlayerRecvAudioFirstFrame = null;
    ZegoExpressEngine.onPlayerRecvVideoFirstFrame = null;
    ZegoExpressEngine.onPlayerRecvSEI = null;
  }

  void initEventHandle() {
    ZegoExpressEngine.onRoomStreamUpdate = onRoomStreamUpdate;
    ZegoExpressEngine.onRoomUserUpdate = onRoomUserUpdate;
    ZegoExpressEngine.onRoomStreamExtraInfoUpdate = onRoomStreamExtraInfoUpdate;
    ZegoExpressEngine.onRoomStateChanged = onRoomStateChanged;
    ZegoExpressEngine.onRoomOnlineUserCountUpdate = onRoomOnlineUserCountUpdate;

    ZegoExpressEngine.onCapturedSoundLevelUpdate = onCapturedSoundLevelUpdate;
    ZegoExpressEngine.onRemoteSoundLevelUpdate = onRemoteSoundLevelUpdate;
    // ZegoExpressEngine.onMixerSoundLevelUpdate = onMixerSoundLevelUpdate;
    ZegoExpressEngine.onPlayerRecvAudioFirstFrame = onPlayerRecvAudioFirstFrame;
    ZegoExpressEngine.onPlayerRecvVideoFirstFrame = onPlayerRecvVideoFirstFrame;
    ZegoExpressEngine.onPlayerRecvSEI = onPlayerRecvSEI;
    ZegoExpressEngine.onRoomExtraInfoUpdate = onRoomExtraInfoUpdate;
  }

  // void uninitFaceunityEventHandle() {
  //   /// faceunity
  //   ZegoExpressEngine.onPublisherStateUpdate = null;
  //   ZegoExpressEngine.onPublisherQualityUpdate = null;
  //   ZegoExpressEngine.onPublisherVideoSizeChanged = null;
  // }
  //
  // void initFaceunityEventHandle() {
  //   /// faceunity
  //   ZegoExpressEngine.onPublisherStateUpdate = onPublisherStateUpdate;
  //   ZegoExpressEngine.onPublisherQualityUpdate = onPublisherQualityUpdate;
  //   ZegoExpressEngine.onPublisherVideoSizeChanged = onPublisherVideoSizeChanged;
  // }

  final roomUserListUpdateStreamCtrl = StreamController<ZegoRoomUserListUpdateEvent>.broadcast();
  final streamListUpdateStreamCtrl = StreamController<ZegoRoomStreamListUpdateEvent>.broadcast();
  final roomStreamExtraInfoStreamCtrl = StreamController<ZegoRoomStreamExtraInfoEvent>.broadcast();
  final roomStateChangedStreamCtrl = StreamController<ZegoRoomStateEvent>.broadcast();
  final roomExtraInfoUpdateCtrl = StreamController<ZegoRoomExtraInfoEvent>.broadcast();
  final recvAudioFirstFrameCtrl = StreamController<ZegoRecvAudioFirstFrameEvent>.broadcast();
  final recvVideoFirstFrameCtrl = StreamController<ZegoRecvVideoFirstFrameEvent>.broadcast();
  final recvSEICtrl = StreamController<ZegoRecvSEIEvent>.broadcast();
  final mixerSoundLevelUpdateCtrl = StreamController<ZegoMixerSoundLevelUpdateEvent>.broadcast();

  Future<void> onRoomStreamUpdate(
    String roomID,
    ZegoUpdateType updateType,
    List<ZegoStream> streamList,
    Map<String, dynamic> extendedData
  ) async {
    /// 先做推拉流
    for (ZegoStream stream in streamList) {
      if (updateType == ZegoUpdateType.Add) {
        ref.read(callAuthenticationManagerProvider).currentStreamList.add(stream);
        startPlayingStream(stream.streamID);
      } else {
        stopPlayingStream(stream.streamID);
      }
    }

    streamListUpdateStreamCtrl.add(ZegoRoomStreamListUpdateEvent(roomID, updateType, streamList, extendedData));
  }

  void onRoomUserUpdate(String roomID, ZegoUpdateType updateType, List<ZegoUser> userList) {
    roomUserListUpdateStreamCtrl.add(ZegoRoomUserListUpdateEvent(roomID, updateType, userList));
  }

  // void onRemoteCameraStateUpdate(String streamID, ZegoRemoteDeviceState state) {
  //   cameraStateUpdateStreamCtrl.add(ZegoCameraStateChangeEvent(state));
  // }
  //
  // void onRemoteMicStateUpdate(String streamID, ZegoRemoteDeviceState state) {
  //   microphoneStateUpdateStreamCtrl.add(ZegoMicrophoneStateChangeEvent(state));
  // }

  void onRoomStateChanged(
    String roomID,
    ZegoRoomStateChangedReason reason,
    int errorCode,
    Map<String, dynamic> extendedData) {
    roomStateChangedStreamCtrl.add(ZegoRoomStateEvent(roomID, reason, errorCode, extendedData));
  }

  void onPublisherStateUpdate(String streamID, ZegoPublisherState state, int errorCode, Map<String, dynamic> extendedData) {
    if (errorCode == 0) {
      isPublishing = true;
      title = 'Publishing';
      print('onPublisherStateUpdate status: Publishing');
    } else {
      print('Publish error: $errorCode');
    }
  }

  Future<void> onRoomOnlineUserCountUpdate(String roomID, int count) async {

  }

  Future<void> startNetworkSpeedTest() async {

    final ZegoVideoConfig config = await ZegoExpressEngine.instance.getVideoConfig();

    // 进行上行测速，指定期望推流码率
    bool testUplink = true;
    int expectedUplinkBitrate = config.bitrate;

    // 进行下行测速，指定期望拉流码率
    bool testDownLink = true;
    int expectedDownLinkBitrate = config.bitrate;

    final ZegoNetworkSpeedTestConfig networkSpeedTestConfig = ZegoNetworkSpeedTestConfig(testUplink, expectedUplinkBitrate, testDownLink, expectedDownLinkBitrate);

    // 开始测速，默认回调间隔为 3 秒
    ZegoExpressEngine.instance.startNetworkSpeedTest(networkSpeedTestConfig);
  }

  Future<void> stopNetworkSpeedTest() async {
    ZegoExpressEngine.instance.stopNetworkSpeedTest();
  }

  void onPublisherVideoSizeChanged(int width, int height, ZegoPublishChannel channel) {
    publishWidth = width;
    publishHeight = height;
  }

  void onRoomStreamExtraInfoUpdate(String roomID, List<ZegoStream> streamList) {
    // for (final user in userInfoList) {
    //   for (final stream in streamList) {
    //     if (stream.streamID == user.streamID) {
    //       try {
    //         final Map<String, dynamic> extraInfoMap = convert.jsonDecode(stream.extraInfo);
    //         final isMicOn = extraInfoMap['mic'] == 'on';
    //         final isCameraOn = extraInfoMap['cam'] == 'on';
    //         user.isCamerOnNotifier.value = isCameraOn;
    //         user.isMicOnNotifier.value = isMicOn;
    //       } catch (e) {
    //         debugPrint('stream.extraInfo: ${stream.extraInfo}.');
    //       }
    //     }
    //   }
    // }
    roomStreamExtraInfoStreamCtrl.add(ZegoRoomStreamExtraInfoEvent(roomID, streamList));
  }

  Future<void> onCapturedSoundLevelUpdate(double soundLevel) async {}

  Future<void> onRemoteSoundLevelUpdate(Map<String, double> soundLevels) async {}

  Future<void> onPlayerRecvAudioFirstFrame(String streamID) async {
    recvAudioFirstFrameCtrl.add(ZegoRecvAudioFirstFrameEvent(streamID));
  }

  Future<void> onPlayerRecvVideoFirstFrame(String streamID) async {
    recvVideoFirstFrameCtrl.add(ZegoRecvVideoFirstFrameEvent(streamID));
  }

  Future<void> onPlayerRecvSEI(String streamID, Uint8List data) async {
    recvSEICtrl.add(ZegoRecvSEIEvent(streamID, data));
  }

  Future<void> startSoundLevelMonitor({int millisecond = 1000}) async {
    final config = ZegoSoundLevelConfig(millisecond, false);
    ZegoExpressEngine.instance.startSoundLevelMonitor(config: config);
  }

  Future<void> stopSoundLevelMonitor() async {
    ZegoExpressEngine.instance.stopSoundLevelMonitor();
  }

  void onRoomExtraInfoUpdate(String roomID, List<ZegoRoomExtraInfo> roomExtraInfoList) {
    roomExtraInfoUpdateCtrl.add(ZegoRoomExtraInfoEvent(roomExtraInfoList));
  }
}
