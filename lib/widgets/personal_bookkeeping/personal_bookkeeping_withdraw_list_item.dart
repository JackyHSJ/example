import 'package:flutter/material.dart';
import 'package:frechat/models/ws_res/withdraw/ws_withdraw_search_record_res.dart';
import 'package:intl/intl.dart';

class PersonalBookkeepingWithdrawListItem extends StatefulWidget {
  const PersonalBookkeepingWithdrawListItem(
      {required this.withdrawListInfo, super.key});

  final WithdrawListInfo withdrawListInfo;

  @override
  State<PersonalBookkeepingWithdrawListItem> createState() =>
      _PersonalBookkeepingWithdrawListItemState();
}

class _PersonalBookkeepingWithdrawListItemState
    extends State<PersonalBookkeepingWithdrawListItem> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 88,
      child: Row(
        children: [
          //頭像
          _buildTransactionLogo(widget.withdrawListInfo.transactionId),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitle(widget.withdrawListInfo.transactionId),
                _buildSubTitle(widget.withdrawListInfo.createTime),
                _buildCoinIncome(widget.withdrawListInfo.status, widget.withdrawListInfo.expectAmount),
              ],
            ),
          ),
          const SizedBox(width: 13),
        ],
      ),
    );
  }

  ///金融機構商標
  Widget _buildTransactionLogo(String? transactionId) {
    Widget imageWidget = const SizedBox();
    if (transactionId != null) {
      if (transactionId.substring(0, 3) == 'WWY') {
        imageWidget = Image.asset(
          'assets/strike_up_list/pay_2.png',
          fit: BoxFit.cover,
        );
      } else if (transactionId.substring(0, 3) == 'WAP') {
        imageWidget = Image.asset(
          'assets/strike_up_list/pay_1.png',
          fit: BoxFit.cover,
        );
      } else if (transactionId.substring(0, 4) == 'WiOS') {
        imageWidget = Image.asset(
          'assets/strike_up_list/pay_3.png',
          fit: BoxFit.cover,
        );
      } else {
        imageWidget = Image.asset(
          'assets/strike_up_list/pay_3.png',
          fit: BoxFit.cover,
        );
      }
    } else {
      imageWidget = Image.asset(
        'assets/strike_up_list/pay_3.png',
        fit: BoxFit.cover,
      );
    }

    return SizedBox(width: 48, height: 48, child: Center(child: imageWidget,));
  }

  Widget _buildTitle(String? transactionId) {
    String label = '';
    if (transactionId != null) {
      if (transactionId.substring(0, 3) == 'WWY') {
        label = '微信支付';
      } else if (transactionId.substring(0, 3) == 'WAP') {
        label = '支付宝';
      } else if (transactionId.substring(0, 4) == 'WiOS') {
        label = '蘋果';
      } else {
        label = '第三方支付';
      }
    }
    return Text(
      label,
      style: Theme.of(context).textTheme.titleMedium,
      overflow: TextOverflow.ellipsis,
    );
  }

  //Create time text
  Widget _buildSubTitle(num? createTime) {
    String dateTimeStr = '';
    if (createTime != null) {
      dateTimeStr = DateFormat('yyyy-MM-dd HH:mm:ss')
          .format(DateTime.fromMillisecondsSinceEpoch(createTime as int))
          .toString();
    }
    return Text(
      dateTimeStr,
      style: Theme.of(context).textTheme.bodySmall!.copyWith(
            color: Colors.grey.shade700,
            overflow: TextOverflow.ellipsis,
          ),
    );
  }

  Widget _buildCoinIncome(num? status, num? amount) {
    String statusStr = '';
    Color textColor = Colors.black;
    if (status != null) {
      switch (status) {
        case 0:
          statusStr = '提现中';
          textColor = Colors.amber.shade700;
          break;
        case 1:
          statusStr = '提现成功';
          textColor = Colors.green.shade700;
          break;
        case 2:
          statusStr = '提现被拒';
          textColor = Colors.red.shade700;
          break;
        case 3:
          statusStr = '提现失败';
          textColor = Colors.red.shade700;
          break;
        default:
          break;
      }
    }

    if (amount != null) {
      statusStr += ' ${amount.toStringAsFixed(2)}';
    }

    return Text(
      statusStr,
      style: Theme.of(context)
          .textTheme
          .bodyMedium!
          .copyWith(color: textColor, fontWeight: FontWeight.bold),
    );
  }
}
