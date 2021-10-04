import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:ivugurura_app/core/data/repository.dart';
import 'package:ivugurura_app/core/models/audio.dart';
import 'package:ivugurura_app/widget/audio_item.dart';
import 'package:ivugurura_app/widget/display_error.dart';
import 'package:ivugurura_app/widget/no_display_data.dart';

class AudioListView extends StatefulWidget {
  final Repository repository;
  const AudioListView({
    Key? key,
    required this.repository,
  }) : super(key: key);

  _AudioListViewState createState() => _AudioListViewState();
}

class _AudioListViewState extends State<AudioListView> {
  Repository get _repository => widget.repository;
  final int pageSize = 6;
  late Audio currentAudio;

  final pagingController = PagingController<int, Audio>(firstPageKey: 1);

  Future<void> fetchPage(int pageKey) async {
    try {
      final newPage = await _repository.getListAudios(
          pageNumber: pageKey, pageSize: pageSize);
      final previouslyFetchedItemsCount =
          pagingController.itemList?.length ?? 0;
      final isLastPage = newPage.isLastPage(previouslyFetchedItemsCount);
      final newItems = newPage.itemList;

      if(pageKey==1 && newItems.length>0){
        setState(() {
          currentAudio = newItems[0];
        });
      }
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
      onRefresh: () => Future.sync(() => pagingController.refresh()),
      child: PagedListView.separated(
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        pagingController: pagingController,
        builderDelegate: PagedChildBuilderDelegate<Audio>(
            itemBuilder: (context, audio, index) {
              return AudioItem(
                audio: audio,
                audioIndex: index,
                onSetCurrent: (){
                  setCurrent(audio);
                },
                currentAudio: currentAudio,
              );
            },
            firstPageErrorIndicatorBuilder: (context) {
              return DisplayError(
                error: pagingController.error,
                onTryAgain: () => pagingController.refresh(),
              );
            },
            noItemsFoundIndicatorBuilder: (context) => NoDisplayData()
        ),
        padding: const EdgeInsets.all(8),
        separatorBuilder: (context, index) {
          return const SizedBox(height: 1);
        },
      ),
    );
  }
  void setCurrent(Audio _audio){
    setState(() {
      currentAudio = _audio;
    });
  }
}
