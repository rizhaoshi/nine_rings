import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import '../../../common/utils/object_util.dart';
import '../../../core/data_dao/providers/note_table_provider.dart';
import '../../../core/data_dao/providers/target_table_provider.dart';
import '../../../routes/app_routes.dart';
import '../../bean/jounery.dart';
import '../../bean/note_bean.dart';
import '../../bean/target_bean.dart';

class TargetDetailController extends GetxController {
  late TargetBean target;
  List<Jounery> jouneries = [];
  TargetTableProvider tableProvider = TargetTableProvider();
  NoteTableProvider noteTableProvider = NoteTableProvider();

  @override
  void onInit() {
    super.onInit();
    TargetBean targetArgument = Get.arguments;
    target = TargetBean.generateTargetCurrentStatus(targetArgument);
    queryNotes();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void queryNotes() async {
    List<NoteBean> queryedNotes = [];
    try {
      queryedNotes = await noteTableProvider.queryNotesByTarget(targetId: target.id!);
    } catch (e) {
      print(e);
    }

    jouneries.add(Jounery()
      ..text = 'challenge_begin'.tr
      ..createTime = target.createTime);

    if (!ObjectUtil.isEmptyList(queryedNotes) && queryedNotes.length > 0) {
      queryedNotes.forEach((element) {
        jouneries.add(Jounery()
          ..text = element.note
          ..createTime = element.createTime);
      });
    }
    if (target.targetStatus == TargetStatus.completed) {
      jouneries.add(Jounery()
        ..text = 'challenge_completed'.tr
        ..createTime = target.createTime!.add(Duration(days: target.targetDays!)));
    } else if (target.targetStatus == TargetStatus.giveUp) {
      jouneries.add(Jounery()
        ..text = 'challenge_giveup'.tr
        ..createTime = target.giveUpTime);
    }

    update(['all']);
  }

  void saveNote(String text) {
    print("=====$text=====");
    //保存日志之前，首先得判断当前目标的状态，因为用户可能停留在这个页面很久了，目标可能已经结束了。结束了就不让再输入日志了
    target = TargetBean.generateTargetCurrentStatus(target);
    if (target.targetStatus != TargetStatus.processing) {
      updateTarget(target);
    } else {
      NoteBean note = NoteBean()
        ..targetId = target.id
        ..note = text
        ..createTime = DateTime.now();

      noteTableProvider.insertNote(note).then((value) {
        jouneries.clear();
        queryNotes();
      }).catchError((error) {
        print("插入note失败");
      });
    }
  }

  //编辑目标后，更新当前详情页目标对象
  void updateTarget(TargetBean updateTarget) {
    target = updateTarget;
    print("====updateTarget====");
    update(['all', 'appbar']);
  }

  bool isProcessing() {
    //点击放弃按钮时，先判断当前target的状态（用户可能一直停在详情页，用户点击放弃按钮的时候，目标可能已经完成了），实时的
    target = TargetBean.generateTargetCurrentStatus(target);
    return target.targetStatus == TargetStatus.processing;
  }

  void pushExercisePage() {
    Get.toNamed(Routes.EXERCISE, arguments: {"from": "DetailPage"});
  }

  void giveupTarget() {
    tableProvider.giveUpTarget(target).then((value) {
      //TODO
      //取消该目标的所有推送

      target.targetStatus = TargetStatus.giveUp;
      jouneries.add(Jounery()
        ..text = 'challenge_giveup'.tr
        ..createTime = DateTime.now());
      update(['all', 'appbar']);
    }).catchError((error) {
      print(error);
    });
  }

}
