import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_task_manager/state_controller/new_task_state_controller.dart';
import 'package:getx_task_manager/state_controller/summary_count_state_controller.dart';
import 'package:getx_task_manager/widgets/screen_background.dart';
import 'package:getx_task_manager/widgets/app_bar.dart';
import 'package:getx_task_manager/widgets/task_list_tiles.dart';
import '../../widgets/SummaryCard.dart';
import 'add_new_task.dart';

class NewTaskScreen extends StatelessWidget {
  final NewTaskController newTaskController = Get.put(NewTaskController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Column(
          children: [
            appBar(),
            GetBuilder<SummaryCountController>(
              builder: (_) {
                if (_.getCountSummaryInProgress) {
                  return const LinearProgressIndicator();
                }
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 80,
                    width: double.infinity,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _.summaryCountModel.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        return SummaryCard(
                          title: _.summaryCountModel.data?[index].sId ?? 'New',
                          number: _.summaryCountModel.data?[index].sum ?? 0,
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const Divider(
                          height: 4,
                        );
                      },
                    ),
                  ),
                );
              },
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  newTaskController.getNewTasks();
                  newTaskController.getCountSummary();
                },
                child: Obx(
                      () {
                    if (newTaskController.getNewTaskInProgress.value) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return ListView.separated(
                      itemCount: newTaskController.taskListModel.value.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        final taskData = newTaskController.taskListModel.value.data;
                        if (taskData == null) {
                          return const SizedBox(); // Handle the case when data is null
                        }
                        return TaskListTiles(
                          data: taskData[index],
                          onDeleteTap: () {
                            newTaskController.deleteTask(taskData[index].sId!);
                          },
                          onEditTap: () {
                            newTaskController.showStatusUpdateBottomSheet(taskData[index]);
                          },
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const Divider(
                          height: 4,
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Get.to( AddNewTaskScreen());
        },
      ),
    );
  }
}