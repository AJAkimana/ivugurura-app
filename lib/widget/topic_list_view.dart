import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:ivugurura_app/core/data/repository.dart';
import 'package:ivugurura_app/core/models/topic.dart';
import 'package:ivugurura_app/widget/display_error.dart';
import 'package:ivugurura_app/widget/no_display_data.dart';
import 'package:ivugurura_app/widget/topic_list_item.dart';

class TopicListView extends StatefulWidget {
  final Repository repository;
  const TopicListView({
    Key? key,
    required this.repository,
  }) : super(key: key);

  _TopicListView createState() => _TopicListView();
}

class _TopicListView extends State<TopicListView> {
  Repository get _repository => widget.repository;
  final int pageSize = 4;

  final pagingController = PagingController<int, Topic>(firstPageKey: 1);

  Future<void> fetchPage(int pageKey) async {
    try {
      final newPage = await _repository.getListTopics(
          pageNumber: pageKey, pageSize: pageSize);
      final previouslyFetchedItemsCount =
          pagingController.itemList?.length ?? 0;
      final isLastPage = newPage.isLastPage(previouslyFetchedItemsCount);
      final newItems = newPage.itemList;

      if (isLastPage) {
        pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      pagingController.error = error;
    }
  }

  @override
  void initState() {
    pagingController.addPageRequestListener((pageKey) {
      fetchPage(pageKey);
    });
    super.initState();
  }

  @override
  void dispose() {
    pagingController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: ()=>Future.sync(() => pagingController.refresh()),
      child: PagedListView.separated(
        pagingController: pagingController,
        builderDelegate: PagedChildBuilderDelegate<Topic>(
          itemBuilder: (context, topic, index){
            return TopicListItem(topic: topic);
          },
          firstPageErrorIndicatorBuilder: (context){
            return DisplayError(
              error: pagingController.error,
              onTryAgain:() => pagingController.refresh(),
            );
          },
          noItemsFoundIndicatorBuilder: (context)=>NoDisplayData()
        ),
        padding: const EdgeInsets.all(8),
        separatorBuilder: (context, index){
          return const SizedBox(height: 1);
        },
      ),
    );
  }
}
