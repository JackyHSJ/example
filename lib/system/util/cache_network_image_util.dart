import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CachedNetworkImageUtil {
  static const String placeholderImagePath = 'assets/images/placeholder.png';
  static const String errorImagePath = 'assets/images/error.png';
  static final customCacheManager = CustomCacheManager();

  static Widget load(
    String url, {
    double size = 150,
    double radius = 6.0,
    BoxFit fit = BoxFit.cover,
    Color background = Colors.transparent
  }) {
    return CachedNetworkImage(
      imageUrl: url,
      imageBuilder: (context, imageProvider) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(radius),
          image: DecorationImage(
            image: imageProvider,
            fit: fit,
          ),
        ),
      ),
      cacheManager: customCacheManager,
      placeholder: (context, url) => SizedBox(width: size, height:  size),
      errorWidget: (context, url, error) {
        return SizedBox(width: size, height:  size);
      },
    );
  }

  static Widget loadWithPlaceholder(String url, {required String placeholder}) {
    return CachedNetworkImage(
      imageUrl: url,
      placeholder: (context, url) =>
          Image.asset(placeholder ?? placeholderImagePath),
      errorWidget: (context, url, error) => Image.asset(errorImagePath),
    );
  }

  static String convertHttpsToHttp(String? httpsUrl) {
    // 检查是否以 "https://" 开头
    if (httpsUrl!.startsWith("https://")) {
      // 将 "https://" 替换为 "http://"
      return "http://" + httpsUrl.substring(8);
    }
    // 如果不是以 "https://" 开头，则返回原始 URL
    return httpsUrl;
  }
}

class CustomCacheManager extends CacheManager with ImageCacheManager {
  static const key = 'customCacheKey';
  CustomCacheManager()
      : super(Config(
          key,
          stalePeriod: Duration(days: 7), // 緩存文件的存活時長
          maxNrOfCacheObjects: 100, // 緩存的最大對象數
        ));
}
