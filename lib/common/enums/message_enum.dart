enum MessageEnum {
  text('text'),
  image('image'),
  audio('audio'),
  video('video'),
  file('file'),
  gif('gif');

  const MessageEnum(this.type);
  final String type;
}

extension ConvertMessage on String {
  MessageEnum toEnum() {
    switch (this) {
      case 'audio':
        return MessageEnum.audio;
      case 'image':
        return MessageEnum.image;
      case 'text':
        return MessageEnum.text;
      case 'video':
        return MessageEnum.video;
      case 'gif':
        return MessageEnum.gif;
      case 'file':
        return MessageEnum.file;
      default:
        return MessageEnum.text;
    }
  }
}
