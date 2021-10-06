import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:ivugurura_app/core/data/repository.dart';
import 'package:ivugurura_app/core/models/audio.dart';
import 'package:ivugurura_app/core/redux/actions/audio_actions.dart';
import 'package:ivugurura_app/core/redux/base_state.dart';
import 'package:ivugurura_app/core/redux/store.dart';
import 'package:ivugurura_app/widget/audio_item.dart';
import 'package:ivugurura_app/widget/display_error.dart';
import 'package:ivugurura_app/widget/no_display_data.dart';
import 'package:ivugurura_app/widget/player_widget.dart';

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
  final int pageSize = 10;
  late Audio currentAudio = Audio();

  final pagingController = PagingController<int, Audio>(firstPageKey: 1);

  Future<void> fetchPage(int pageKey) async {
    try {
      final newPage = await _repository.getListAudios(pageKey, pageSize);
      final previouslyFetchedItemsCount =
          pagingController.itemList?.length ?? 0;
      final isLastPage = newPage.isLastPage(previouslyFetchedItemsCount);
      final newItems = newPage.itemList;

      if (pageKey == 1 && newItems.length > 0) {
        setCurrentAudio(newItems[0]);
      }
      if (isLastPage) {
        pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      print(error);
      print('==============================>');
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
    double height = MediaQuery.of(context).size.height;
    double topHeight = height * 0.4;
    return StoreConnector<AppState, BaseState<Audio, AudioDetail>>(
      distinct: true,
      converter: (store)=>store.state.currentAudio,
      builder: (context, audioState){
        Audio theAudio = audioState.theObject!;
        return Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                        height: topHeight,
                        width: MediaQuery.of(context).size.width,
                        child: PlayerWidget(audio: theAudio))
                  ],
                ),
                Container(
                    height: height * 0.6,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            stops: [0, 0.5, 1],
                            colors: [
                              Color(0xFF014F82),
                              Color(0xff00395f),
                              Color(0xFF001726)
                            ])),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 25),
                        Text(' Buffering... ',
                            style: TextStyle(color: Colors.white, fontSize: 25)),
                        // _progress(),
                        Expanded(
                            child: RefreshIndicator(
                              onRefresh: () =>
                                  Future.sync(() => pagingController.refresh()),
                              child: PagedListView.separated(
                                physics: BouncingScrollPhysics(
                                    parent: AlwaysScrollableScrollPhysics()),
                                pagingController: pagingController,
                                builderDelegate: PagedChildBuilderDelegate<Audio>(
                                    itemBuilder: (context, audio, index) {
                                      return AudioItem(
                                        audio: audio,
                                        audioIndex: index,
                                        onSetCurrent: () {
                                          setCurrent(audio);
                                        },
                                        currentAudio: theAudio,
                                      );
                                    },
                                    firstPageErrorIndicatorBuilder: (context) {
                                      return DisplayError(
                                        error: pagingController.error,
                                        onTryAgain: () => pagingController.refresh(),
                                      );
                                    },
                                    noItemsFoundIndicatorBuilder: (context) =>
                                        NoDisplayData()),
                                padding: const EdgeInsets.all(8),
                                separatorBuilder: (context, index) {
                                  return const SizedBox(height: 1);
                                },
                              ),
                            ))
                      ],
                    ))
              ],
            ),
            Positioned(
              left: MediaQuery.of(context).size.width * 0.15,
              top: topHeight - 35,
              child: FractionalTranslation(
                translation: Offset(0, 0.5),
                child: playerWidget(),
              ),
            )
          ],
        );
      },
    );
  }

  playerWidget() {
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        Container(
          alignment: Alignment.topCenter,
          height: 35,
          width: MediaQuery.of(context).size.width * 0.7,
          margin: EdgeInsets.only(bottom: 6),
          decoration: BoxDecoration(
              boxShadow: [BoxShadow(blurRadius: 5)],
              borderRadius: BorderRadius.circular(50),
              color: Colors.blue),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.skip_previous,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(
                  Icons.fast_rewind,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
              SizedBox(
                width: 25,
              ),
              IconButton(
                  icon: Icon(
                    Icons.fast_forward,
                    color: Colors.white,
                  ),
                  onPressed: () {}),
              IconButton(
                icon: Icon(
                  Icons.skip_next,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
            ],
          ),
        )
      ],
    );
  }

  void setCurrent(Audio _audio) {
    setCurrentAudio(_audio);
  }
}