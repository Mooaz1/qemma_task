import 'package:flutter/material.dart';
import 'package:qemma_task/core/ui/app_theme/app_theme.dart';
import 'package:qemma_task/core/ui/strings_manager/strings_manager.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isSearching;
  final TextEditingController searchController;
  final VoidCallback onSearchToggle;
  final VoidCallback onClearSearch;
  final ValueChanged<String> onSearchChanged;

  const HomeAppBar({
    super.key,
    required this.isSearching,
    required this.searchController,
    required this.onSearchToggle,
    required this.onClearSearch,
    required this.onSearchChanged,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blueGrey[900],
      titleSpacing: 0,
      title: Row(
        children: [
          Expanded(child: _buildAppBarTitle()),
          _buildSearchToggleButton(),
        ],
      ),
    );
  }

  // -------------------------
  // Internal Widgets
  // -------------------------

  Widget _buildAppBarTitle() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.2, 0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        ),
      ),
      child: isSearching ? _buildSearchField() : _buildTitleText(),
    );
  }

  Widget _buildTitleText() {
    return Text(
      StringsManager.homeTitle,
      key: const ValueKey('title'),
      style: AppTheme.theme.textTheme.bodyLarge,
    );
  }

  Widget _buildSearchField() {
    return TextField(
      key: const ValueKey('searchField'),
      controller: searchController,
      autofocus: true,
      cursorColor: Colors.white,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        contentPadding: const EdgeInsetsDirectional.only(start: 10),
        hintText: StringsManager.searchHint,
        hintStyle: const TextStyle(color: Colors.white70),
        border: InputBorder.none,
        suffixIcon: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: onClearSearch,
        ),
      ),
      onChanged: onSearchChanged,
    );
  }

  Widget _buildSearchToggleButton() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: !isSearching
          ? IconButton(
              key: const ValueKey('searchIcon'),
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: onSearchToggle,
            )
          : const SizedBox.shrink(),
    );
  }
}
