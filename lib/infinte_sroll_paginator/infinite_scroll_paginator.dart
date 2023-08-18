import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../model/post.dart';
import '../widgets/post_item.dart';


class InfiniteScrollPaginatorDemo extends StatefulWidget {
  @override
  _InfiniteScrollPaginatorDemoState createState() => _InfiniteScrollPaginatorDemoState();
}

class _InfiniteScrollPaginatorDemoState extends State<InfiniteScrollPaginatorDemo> {
  final _numberOfPostsPerRequest = 20;

  final PagingController<int, Post> _pagingController =
  PagingController(firstPageKey: 0);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final response = await get(Uri.parse(
          "http://13.127.208.45:3038/post/community_post/for_feed/a6657951-67ca-4cef-8c83-e4643ccc38f3?offset=$pageKey&$_numberOfPostsPerRequest=20"));
      List responseList = json.decode(response.body);
      List<Post> postList = responseList.map((data) =>
          Post(data['url'])).toList();
      final isLastPage = postList.length < _numberOfPostsPerRequest;
      if (isLastPage) {
        _pagingController.appendLastPage(postList);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(postList, nextPageKey);
      }
    } catch (e) {
      print("error --> $e");
      _pagingController.error = e;
    }
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar:
          AppBar(title: const Text("Project app"), centerTitle: true,),
        body: RefreshIndicator(
          onRefresh: () => Future.sync(() => _pagingController.refresh()),
          child: PagedListView<int, Post>(
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate<Post>(
              itemBuilder: (context, item, index) =>
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: PostItem(
                        item.url
                    ),
                  ),

            ),

          ),
        ),
      );
}

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}