part of photogallery;

/// Fetches the given album thumbnail from the gallery.
class AlbumThumbnailProvider extends ImageProvider<AlbumThumbnailProvider> {
  const AlbumThumbnailProvider({
    required this.albumId,
    this.mediumType,
    this.height,
    this.width,
    this.highQuality = false,
  });

  final String albumId;
  final MediumType? mediumType;
  final int? height;
  final int? width;
  final bool? highQuality;

  @override
  ImageStreamCompleter loadBuffer(key, decode) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, decode),
      scale: 1.0,
      informationCollector: () sync* {
        yield ErrorDescription('Id: $albumId');
      },
    );
  }

  Future<ui.Codec> _loadAsync(AlbumThumbnailProvider key, DecoderBufferCallback decode) async {
    assert(key == this);
    final data = await PhotoGallery.getAlbumThumbnail(
      albumId: albumId,
      mediumType: mediumType,
      height: height,
      width: width,
      highQuality: highQuality,
    );
    ui.ImmutableBuffer buffer;
    if (data != null) {
      buffer = await ui.ImmutableBuffer.fromUint8List(Uint8List.fromList(data));
    } else {
      buffer = await ui.ImmutableBuffer.fromAsset("packages/photo_gallery/images/grey.bmp");
    }
    return decode(buffer);
  }

  @override
  Future<AlbumThumbnailProvider> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<AlbumThumbnailProvider>(this);
  }

  @override
  bool operator ==(dynamic other) {
    if (other.runtimeType != runtimeType) return false;
    final AlbumThumbnailProvider typedOther = other;
    return albumId == typedOther.albumId;
  }

  @override
  int get hashCode => albumId.hashCode;

  @override
  String toString() => '$runtimeType("$albumId")';
}
