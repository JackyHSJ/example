import 'package:flutter/services.dart';
import 'package:zego_express_engine/zego_express_engine.dart';

class ZegoCameraStateChangeEvent {
  final ZegoRemoteDeviceState state;

  ZegoCameraStateChangeEvent(this.state);
}

class ZegoMicrophoneStateChangeEvent {
  final ZegoRemoteDeviceState state;

  ZegoMicrophoneStateChangeEvent(this.state);
}

class ZegoRoomUserListUpdateEvent {
  final String roomID;
  final ZegoUpdateType updateType;
  final List<ZegoUser> userList;

  ZegoRoomUserListUpdateEvent(
    this.roomID,
    this.updateType,
    this.userList,
  );

  @override
  String toString() {
    return 'ZegoRoomUserListUpdateEvent{roomID: $roomID, updateType: ${updateType.name}, userList: ${userList.map((e) => '${e.userID}(${e.userName}),')}}';
  }
}

class ZegoRoomStreamListUpdateEvent {
  final String roomID;
  final ZegoUpdateType updateType;
  final List<ZegoStream> streamList;
  final Map<String, dynamic> extendedData;

  ZegoRoomStreamListUpdateEvent(this.roomID, this.updateType, this.streamList, this.extendedData);

  @override
  String toString() {
    return 'ZegoRoomStreamListUpdateEvent{roomID: $roomID, updateType: ${updateType.name}, streamList: ${streamList.map((e) => '${e.streamID}(${e.extraInfo}),')}';
  }
}

class ZegoRoomStreamExtraInfoEvent {
  final String roomID;
  final List<ZegoStream> streamList;

  ZegoRoomStreamExtraInfoEvent(this.roomID, this.streamList);

  @override
  String toString() {
    return 'ZegoRoomStreamExtraInfoEvent{roomID: $roomID, streamList: ${streamList.map((e) => '${e.streamID}(${e.extraInfo}),')}}';
  }
}

class ZegoRoomStateEvent {
  final String roomID;
  final ZegoRoomStateChangedReason reason;
  final int errorCode;
  final Map<String, dynamic> extendedData;

  ZegoRoomStateEvent(this.roomID, this.reason, this.errorCode, this.extendedData);

  @override
  String toString() {
    return 'ZegoRoomStateEvent{roomID: $roomID, reason: ${reason.name}, errorCode: $errorCode, extendedData: $extendedData}';
  }
}

class ZegoRoomExtraInfoEvent {
  final List<ZegoRoomExtraInfo> extraInfoList;

  ZegoRoomExtraInfoEvent(this.extraInfoList);

  @override
  String toString() {
    return 'ZegoRoomExtraInfoEvent{key: $extraInfoList}';
  }
}

class ZegoRecvAudioFirstFrameEvent {
  final String streamID;

  ZegoRecvAudioFirstFrameEvent(this.streamID);

  @override
  String toString() {
    return 'ZegoRecvAudioFirstFrameEvent{streamID: $streamID}';
  }
}

class ZegoRecvVideoFirstFrameEvent {
  final String streamID;

  ZegoRecvVideoFirstFrameEvent(this.streamID);

  @override
  String toString() {
    return 'ZegoRecvVideoFirstFrameEvent{streamID: $streamID}';
  }
}

class ZegoRecvSEIEvent {
  final String streamID;
  final Uint8List data;

  ZegoRecvSEIEvent(this.streamID, this.data);

  @override
  String toString() {
    return 'ZegoRecvSEIEvent{streamID: $streamID, data: $data}';
  }
}

class ZegoMixerSoundLevelUpdateEvent {
  final Map<int, double> soundLevels;

  ZegoMixerSoundLevelUpdateEvent(this.soundLevels);

  @override
  String toString() {
    return 'ZegoMixerSoundLevelUpdateEvent{soundLevels: $soundLevels}';
  }
}