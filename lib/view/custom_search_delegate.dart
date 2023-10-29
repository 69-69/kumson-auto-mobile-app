import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef OnSearchChanged = Future<List<String>> Function(String);

class SearchWithSuggestionDelegate extends SearchDelegate<String> {
  ///[onSearchChanged] gets the [query] as an argument. Then this callback
  ///should process [query] then return an [List<String>] as suggestions.
  ///Since its returns a [Future] you get suggestions from server too.
  final OnSearchChanged onSearchChanged;

  ///This [_oldFilters] used to store the previous suggestions. While waiting
  ///for [onSearchChanged] to completed, [_oldFilters] are displayed.
  List<String> _oldFilters = const [];

  SearchWithSuggestionDelegate({
    required String searchFieldLabel,
    required this.onSearchChanged,
  }) : super(searchFieldLabel: searchFieldLabel);

  ///
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => Navigator.pop(context),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => query = "",
      ),
    ];
  }

  ///OnSubmit in the keyboard, returns the [query]
  @override
  void showResults(BuildContext context) {
    close(context, query);
  }

  ///Since [showResults] is overridden we can don't have to build the results.
  @override
  Widget buildResults(BuildContext context) => const Text('results');

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: onSearchChanged(query),
      builder: (context, snapshot) {
        if (snapshot.hasData) _oldFilters = snapshot.data!;

        return ListView.builder(
          itemCount: _oldFilters.length,
          itemBuilder: (context, index) => ListTile(
              leading: const Icon(Icons.restore),
              title: Text(_oldFilters[index]),
              onTap: () => close(context, _oldFilters[index]),
            ),
        );
      },
    );
  }

}

class HomeSearch extends StatefulWidget {
  const HomeSearch({super.key});

  @override
  State<HomeSearch> createState() => _HomeSearchState();
}

class _HomeSearchState extends State<HomeSearch> {
  Future<void> _showSearch() async {
    final searchText = await showSearch<String>(
      context: context,
      delegate: SearchWithSuggestionDelegate(
        onSearchChanged: _getRecentSearchesLike,
        searchFieldLabel: '',
      ),
    );

    //Save the searchText to SharedPref so that next time you can use them as recent searches.
    await _saveToRecentSearches(searchText ?? "");

    //Do something with searchText. Note: This is not a result.
  }

  Future<List<String>> _getRecentSearchesLike(String query) async {
    final pref = await SharedPreferences.getInstance();
    final allSearches = pref.getStringList("recentSearches");
    return allSearches!.where((search) => search.startsWith(query)).toList();
  }

  Future<void> _saveToRecentSearches(String searchText) async {
    if (searchText.isEmpty) return; //Should not be empty
    final pref = await SharedPreferences.getInstance();

    //Use `Set` to avoid duplication of recentSearches
    Set<String> allSearches =
        pref.getStringList("recentSearches")?.toSet() ?? {};

    //Place it at first in the set
    allSearches = {searchText, ...allSearches};
    pref.setStringList("recentSearches", allSearches.toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Demo"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _showSearch,
          ),
        ],
      ),
    );
  }
}
