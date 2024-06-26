

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frechat/system/database/model/chat_audio_model.dart';
import 'package:frechat/system/database/model/chat_gift_model.dart';

import '../system/provider/chat_Gift_model_provider.dart';

class Test extends ConsumerStatefulWidget {
  const Test({super.key});

  @override
  ConsumerState<Test> createState() => _TestState();
}

class _TestState extends ConsumerState<Test> {
  List<Map<String, dynamic>> selectRes = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('sqflite'),
        ),
        body: InkWell(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: Consumer(
                builder: (context, ref, _) {
                  return _buildList(ref);
                },
              )),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(onPressed: () => create(), child: Text('Create')),
                  ElevatedButton(onPressed: () => select(), child: Text('Select')),
                  ElevatedButton(onPressed: () => update(), child: Text('Update')),
                  ElevatedButton(onPressed: () => delete(), child: Text('Delete')),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).padding.bottom,
              )
            ],
          ),
        ),
      ),
    );
  }

  _buildList(WidgetRef ref) {
    final value = ref.watch(chatGiftModelNotifierProvider);
    return SingleChildScrollView(
      child: Column(
        children: value.map((Gift) {
          return Text('${Gift.messageUuid} ${Gift.senderId}');
        }).toList(),
      ),
    );
  }

  void create() {
    ref.read(chatGiftModelNotifierProvider.notifier).setDataToSql(chatGiftModelList: [
        ChatGiftModel(messageUuid: '123123', senderId: 10000)
      ]
    );
  }

  void select() {
    ref.read(chatGiftModelNotifierProvider.notifier).loadDataFromSql();
  }

  Future<void> update() async {
    final res = await ref.read(chatGiftModelNotifierProvider.notifier).updateDataToSql(
        updateModel: ChatGiftModel(messageUuid: '0', senderId: 123),
        whereModel: ChatGiftModel(messageUuid: '333')
    );
  }

  Future<void> delete() async {
    await ref.read(chatGiftModelNotifierProvider.notifier).clearSql(
    );
  }
}