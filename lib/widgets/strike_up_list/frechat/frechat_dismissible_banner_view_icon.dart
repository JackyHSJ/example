import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/models/ws_res/banner/ws_banner_info_res.dart';
import 'package:frechat/system/provider/user_info_provider.dart';
import 'package:frechat/system/providers.dart';
import 'package:frechat/widgets/banner_view/banner_view.dart';

class FrechatDismissibleBannerViewIcon extends ConsumerStatefulWidget {
  const FrechatDismissibleBannerViewIcon({required this.locatedPageFilter, required this.dismissible, super.key});

  // 放置頁面(0:全部 1:首頁 2:充值彈窗 3:消息頁面 4:通話頁面懸浮 5:我的頁面 6:首页悬浮)
  // 此參數只有填 1 ~ 6 才有意義，0 基本上不產生作用，因為 locatedPage = 0 必定顯示
  // 這邊命名太麻煩，也不容易理解，就不做 enum 處理了。
  final int locatedPageFilter;

  //[Dep]: 他們說不要了，改為每次登入會重置。
  // 這邊我們給外部使用者最大的方便之處，直接傳入 PreKey 作為讀取時間條件依據。
  // 這個 key 會讓我們得知最後一次的被 Dismiss 時間，我們拿它作為初始是否顯示依據。
  // final String referencePrefKey;

  //是否允許關閉。
  final bool dismissible;

  @override
  ConsumerState<FrechatDismissibleBannerViewIcon> createState() => _FrechatDismissibleBannerViewIconState();
}

class _FrechatDismissibleBannerViewIconState extends ConsumerState<FrechatDismissibleBannerViewIcon> {
  @override
  void initState() {
    super.initState();
    // _decideInitialVisible();
  }

  @override
  Widget build(BuildContext context) {
    List<BannerInfo> bannerInfo = _filteredBannerInfoList(locatedPage: widget.locatedPageFilter);

    if (ref.watch(strikeUpBannerIconVisibleProvider) && bannerInfo.isNotEmpty) {
      return Container(
        margin: const EdgeInsets.only(right: 8),
        width: 72,
        height: 82,
        child: Stack(
          // clipBehavior: Clip.none,
          children: [
            //THE Banner.
            BannerView(
              padding: EdgeInsets.zero,
              locatedPageFilter: widget.locatedPageFilter,
              borderRadius: 3,
              aspectRatio: 0.878,
              pageIndicatorBottomPadding: 0,
              pageIndicatorScale: 0.5,
            ),

            //Dismiss button.
            Visibility(
              visible: widget.dismissible,
              child: Positioned(
                right: 0,
                top: 5,
                child: InkWell(
                  borderRadius: BorderRadius.circular(32),
                  onTap: () {
                    setState(() {
                      ref.read(strikeUpBannerIconVisibleProvider.notifier).state = false;
                    });
                  },
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withOpacity(0.5), // 黑色半透明背景
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white, // 白色不透明的图标颜色
                      size: 12,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  List<BannerInfo> _filteredBannerInfoList({num? locatedPage}) {
    List<BannerInfo> returnList = [];
    WsBannerInfoRes? bannerInfoRes = ref.read(userUtilProvider).bannerInfo;

    // log('[bannerInfoRes]: ${jsonEncode(bannerInfoRes)}');

    if (bannerInfoRes != null && bannerInfoRes.list != null) {
      returnList.addAll(bannerInfoRes.list!.where((bannerInfo) {
        //檢查這個 bannerInfo 是否合法
        if (bannerInfo.status != 0) {
          return false;
        } else if (bannerInfo.startTime != null && bannerInfo.endTime != null) {
          //檢查時間
          DateTime startDateTime = DateTime.fromMillisecondsSinceEpoch(bannerInfo.startTime as int);
          DateTime endDateTime = DateTime.fromMillisecondsSinceEpoch(bannerInfo.endTime as int);
          //不在時限內，未開始或者已過期．
          if (DateTime.now().isAfter(endDateTime) || DateTime.now().isBefore(startDateTime)) {
            return false;
          }
        }

        //所屬頁面過濾 (1 首頁)
        if (bannerInfo.locatedPage != 0 && bannerInfo.locatedPage != locatedPage) {
          return false;
        }
        //防呆
        if (bannerInfo.activityBanner == null || bannerInfo.activityBanner!.isEmpty) {
          return false;
        }

        return true;
      }));
    }

    return returnList;
  }
}
