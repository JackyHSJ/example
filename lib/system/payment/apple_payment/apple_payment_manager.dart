
import 'dart:async';
import 'dart:io';
import 'package:frechat/system/payment/apple_payment/consumable_store.dart';
import 'package:frechat/system/payment/apple_payment/delegate.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';

class ApplePaymentManager {
  Stream<List<PurchaseDetails>>? purchaseUpdated;
  static final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  static StreamSubscription<List<PurchaseDetails>>? _subscription;
  static List<PurchaseDetails> _purchases = [];
  static bool _purchasePending = false;
  static List<String> consumables = [];
  static bool _isAvailable = false;
  static List<ProductDetails> products = [];
  static List<String> _notFoundIds = [];
  static String? _queryProductError;

  static const bool _kAutoConsume = true;
  static List<ProductDetails> iapProductList = [];

  // static const String frechatCoin1 = 'com.frechat.coin1';
  // static const String frechatCoin3 = 'com.frechat.coin3';
  // static const String frechatCoin6 = 'com.frechat.coin6';
  //
  // static const List<String> _kProductIds = <String>[
  //   frechatCoin1,
  //   frechatCoin3,
  //   frechatCoin6,
  // ];

  static List<String> kProductIds = <String>[];

  static late Function() onLoadingProduct;
  static late Function() onProductError;
  static late Function(List<ProductDetails>) onProductDone;
  static late Function() onPurchasing;
  static late Function() onPurchaseDone;
  static late Function(IAPError?) onPurchaseError;

  static Future<void> init({
    required Function() onLoadingProduct,
    required Function() onProductError,
    required Function(List<ProductDetails>) onProductDone,
    required Function() onPurchasing,
    required Function() onPurchaseDone,
    required Function(IAPError?) onPurchaseError,
    required List<String> ids
  }) async {

    if (_subscription != null) return;

    /// 載入ids
    kProductIds = ids;

    ApplePaymentManager.onLoadingProduct = onLoadingProduct;
    ApplePaymentManager.onProductError = onProductError;
    ApplePaymentManager.onProductDone = onProductDone;
    ApplePaymentManager.onPurchasing = onPurchasing;
    ApplePaymentManager.onPurchaseDone = onPurchaseDone;
    ApplePaymentManager.onPurchaseError = onPurchaseError;

    final Stream<List<PurchaseDetails>> purchaseUpdated = _inAppPurchase.purchaseStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription?.cancel();
    }, onError: (error) {
      _subscription?.resume();
    });

    await initStoreInfo();
  }

  static dispose() {
    if (Platform.isIOS) {
      final iosPlatformAddition = _inAppPurchase.getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      iosPlatformAddition.setDelegate(null);
    }

    if (_subscription != null) {
      _subscription?.cancel();
      _subscription = null;
    }
  }

  static Future<void> initStoreInfo() async {
    onLoadingProduct();
    final bool isAvailable = await _inAppPurchase.isAvailable();
    if (!isAvailable) {
      onProductError();
      _isAvailable = isAvailable;
      products = [];
      _purchases = [];
      _notFoundIds = [];
      consumables = [];
      _purchasePending = false;
      return;
    }

    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition = _inAppPurchase.getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iosPlatformAddition.setDelegate(PaymentQueueDelegate());
    }

    /// 結束上一次購買流程
    final SKPaymentQueueWrapper paymentWrapper = SKPaymentQueueWrapper();
    final List<SKPaymentTransactionWrapper> transactions = await paymentWrapper.transactions();
    transactions.forEach((transaction) async {
      await paymentWrapper.finishTransaction(transaction);
    });

    ProductDetailsResponse productDetailResponse = await _inAppPurchase.queryProductDetails(kProductIds.toSet());
    if (productDetailResponse.error != null) {
      onProductError();
      _queryProductError = productDetailResponse.error!.message;
      _isAvailable = isAvailable;
      products = productDetailResponse.productDetails;
      _purchases = [];
      _notFoundIds = productDetailResponse.notFoundIDs;
      consumables = [];
      _purchasePending = false;
      return;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      onProductDone(productDetailResponse.productDetails);
      _queryProductError = null;
      _isAvailable = isAvailable;
      products = productDetailResponse.productDetails;
      _purchases = [];
      _notFoundIds = productDetailResponse.notFoundIDs;
      consumables = [];
      _purchasePending = false;
    }

    consumables = await ConsumableStore.load();
    _isAvailable = isAvailable;
    products = productDetailResponse.productDetails;
    _notFoundIds = productDetailResponse.notFoundIDs;
    _purchasePending = false;
    onProductDone(productDetailResponse.productDetails);
    iapProductList = productDetailResponse.productDetails;

  }

  static void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        ///支付中
        print('AAA-支付中 ${purchaseDetailsList.length}');
        showPendingUI();
      } else {
        if (purchaseDetails.status == PurchaseStatus.error || purchaseDetails.status == PurchaseStatus.canceled) {
          print('AAA-支付GG  ${purchaseDetailsList.length}');
          handleError(purchaseDetails.error);
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          print('AAA-購買成功');
          bool valid = await _verifyPurchase(purchaseDetails);
          if (valid) {
            /// TODO: api post callback
            deliverProduct(purchaseDetails);
          } else {
            _handleInvalidPurchase(purchaseDetails);
            return;
          }
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await _inAppPurchase.completePurchase(purchaseDetails);
        }
      }
    });
  }



  static void deliverProduct(PurchaseDetails purchaseDetails) async {
    // IMPORTANT!! Always verify purchase details before delivering the product.
    if (kProductIds.contains(purchaseDetails.productID)) {
      await ConsumableStore.save(purchaseDetails.purchaseID!);
      consumables = await ConsumableStore.load();
      _purchasePending = false;
      onPurchaseDone();
    } else {
      _purchases.add(purchaseDetails);
      _purchasePending = false;
    }
  }

  static void buyProduct(ProductDetails purchaseDetails) async {
    onPurchasing();
    final PurchaseParam purchaseParam = PurchaseParam(
      productDetails: purchaseDetails,
      applicationUserName: 'oderId123123123',
    );

    /// 消耗型商品
    if (kProductIds.contains(purchaseDetails.id)) {
      final bool result = await _inAppPurchase.buyConsumable(purchaseParam: purchaseParam, autoConsume: _kAutoConsume || Platform.isIOS);

      /// 失敗
      if(result == false) {
        onPurchaseError(null);
      }
    } else {
      /// 非消耗型商品
      _inAppPurchase.buyNonConsumable(
          purchaseParam: purchaseParam);
    }
  }

  static void showPendingUI() {
    _purchasePending = true;
  }

  static Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
    // IMPORTANT!! Always verify a purchase before delivering the product.
    // For the purpose of an example, we directly return true.
    return Future<bool>.value(true);
  }

  static void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    // handle invalid purchase here if  _verifyPurchase` failed.
    onPurchaseError(null);
  }

  static void handleError(IAPError? error) {
    _purchasePending = false;
    onPurchaseError(error);
  }
}