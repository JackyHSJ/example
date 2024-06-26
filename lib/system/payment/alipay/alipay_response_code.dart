
class AliPayResponseCode {
  static Map<int, String> map = {
    CODE_PAY_SUCCESS: PAY_SUCCESS,
    CODE_PAYING: PAYING,
    CODE_PAY_FAIL: PAY_FAIL,
    CODE_PAY_REPEAT: PAY_REPEAT,
    CODE_PAY_CANCEL: PAY_CANCEL,
    CODE_NOTWORK_ERROR: NOTWORK_ERROR,
  };

  static int CODE_PAY_SUCCESS = 9000;
  static int CODE_PAYING = 9000;
  static int CODE_PAY_FAIL = 9000;
  static int CODE_PAY_REPEAT = 9000;
  static int CODE_PAY_CANCEL = 9000;
  static int CODE_NOTWORK_ERROR = 9000;

  static String PAY_SUCCESS = '订单支付成功';
  static String PAYING = '正在处理中';
  static String PAY_FAIL = '订单支付失败';
  static String PAY_REPEAT = '重复请求';
  static String PAY_CANCEL = '用户中途取消';
  static String NOTWORK_ERROR = '网络连接出错';
}