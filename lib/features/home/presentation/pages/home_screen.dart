import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qemma_task/core/di/injector.dart';
import 'package:qemma_task/core/ui/shared_widgets/app_snackbar.dart';
import 'package:qemma_task/features/home/presentation/cubit/home_cubit.dart';
import 'package:qemma_task/features/home/presentation/widgets/custom_app_bar.dart';
import 'package:qemma_task/features/home/presentation/widgets/custom_body.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final ScrollController _scrollController;
  late final TextEditingController _searchController;
  late final HomeCubit _cubit;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _searchController = TextEditingController();
    _cubit = Injector().homeCubit;

    _cubit.fetchMovies();
    _setupScrollListener();
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      if (_shouldLoadMore() && !_isLoadingMore) {
        _loadMore();
      }
    });
  }

  bool _shouldLoadMore() {
    if (!_scrollController.hasClients) return false;
    
    final position = _scrollController.position;
    final state = _cubit.state;
    
    return position.pixels >= position.maxScrollExtent - 200 &&
        !state.hasReachedEnd &&
        state.isLoaded &&
        !state.isLoading;
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore) return;
    
    setState(() {
      _isLoadingMore = true;
    });
    
    await _cubit.fetchMovies();
    
    if (mounted) {
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _cubit.close();
    super.dispose();
  }

  void _clearSearch() {
    _searchController.clear();
    // Exit search mode and reset to normal movie list
    _cubit.searchMovies('');
    Future.delayed(const Duration(milliseconds: 100), () {
      _cubit.fetchMovies(refresh: true);
    });
  }

  void _handleRefresh() {
    _cubit.fetchMovies(refresh: true);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {
          if (state.isError) {
            showSnackBar(context, message: state.errorMessage);
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: HomeAppBar(
              isSearching: state.isSearching,
              searchController: _searchController,
              onSearchToggle: () {
                if (state.isSearching) {
                  _clearSearch();
                } else {
                  _cubit.searchMovies('');
                }
              },
              onClearSearch: _clearSearch,
              onSearchChanged: (query) {
                if (query.isEmpty) {
                  _cubit.fetchMovies(refresh: true);
                } else {
                  _cubit.searchMovies(query);
                }
              },
            ),  
            body: MoviesGridBody(
              isLoading: state.isLoading && state.movies.isEmpty,
              hasReachedEnd: state.hasReachedEnd,
              movies: state.movies,
              onRefresh: _handleRefresh,
              scrollController: _scrollController,
            ),
          );
        },
      ),
    );
  }
}