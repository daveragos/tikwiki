import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/wiki_summary.dart';
import '../models/wiki_full_content.dart';
import '../models/wiki_search_result.dart';

class WikipediaApiException implements Exception {
  final String message;
  final int? statusCode;
  final String? uri;

  WikipediaApiException(this.message, {this.statusCode, this.uri});

  @override
  String toString() {
    return 'WikipediaApiException: $message${statusCode != null ? ' (Status: $statusCode)' : ''}${uri != null ? ' [URI: $uri]' : ''}';
  }
}

class WikipediaClient {
  final http.Client _client;
  final String _userAgent;

  WikipediaClient({http.Client? client, String? userAgent})
    : _client = client ?? http.Client(),
      _userAgent =
          userAgent ??
          'TikWikiClient/1.0 (daveragoose/tikwiki; contact: daveyeinde@gmail.com)';

  Map<String, String> get _headers => {
    'User-Agent': _userAgent,
    'Accept': 'application/json',
  };

  /// Constantly streams fresh discovery material into the app's local memory architecture.
  /// Runs concurrent async requests up to the requested batch count threshold.
  Future<List<WikiSummary>> fetchRandomBatch({int count = 10}) async {
    final uri = Uri.parse(
      'https://en.wikipedia.org/api/rest_v1/page/random/summary',
    );

    final futures = List.generate(count, (_) async {
      try {
        final response = await _client.get(uri, headers: _headers);
        if (response.statusCode != 200) {
          throw WikipediaApiException(
            'Failed to fetch random summary',
            statusCode: response.statusCode,
            uri: uri.toString(),
          );
        }
        final data = jsonDecode(response.body);
        if (data is Map<String, dynamic>) {
          return WikiSummary.fromJson(data);
        } else {
          throw WikipediaApiException(
            'Invalid JSON format returned by random summary API',
          );
        }
      } catch (e) {
        if (e is WikipediaApiException) rethrow;
        throw WikipediaApiException('Network error: $e', uri: uri.toString());
      }
    });

    return await Future.wait(futures);
  }

  /// Fetches the structural HTML payload to build the serif reading layout view.
  Future<WikiFullContent> fetchArticleContent(String title) async {
    final encodedTitle = Uri.encodeComponent(title);
    final uri = Uri.parse(
      'https://en.wikipedia.org/api/rest_v1/page/html/$encodedTitle',
    );

    try {
      final headers = Map<String, String>.from(_headers)
        ..['Accept'] = 'text/html; charset=utf-8';
      final response = await _client.get(uri, headers: headers);

      if (response.statusCode != 200) {
        throw WikipediaApiException(
          'Failed to fetch article content',
          statusCode: response.statusCode,
          uri: uri.toString(),
        );
      }

      final mobileUrl = 'https://en.m.wikipedia.org/wiki/$encodedTitle';
      return WikiFullContent.fromHtml(
        response.body,
        title: title,
        mobileUrl: mobileUrl,
      );
    } catch (e) {
      if (e is WikipediaApiException) rethrow;
      throw WikipediaApiException('Network error: $e', uri: uri.toString());
    }
  }

  /// Feeds the typeahead search drawer layer when a user manually searches for specific topics.
  Future<List<WikiSearchResult>> querySearchAutocomplete(
    String searchTerm,
  ) async {
    final encodedQuery = Uri.encodeComponent(searchTerm);
    final uri = Uri.parse(
      'https://en.wikipedia.org/w/rest.php/v1/search/title?q=$encodedQuery',
    );

    try {
      final response = await _client.get(uri, headers: _headers);
      if (response.statusCode != 200) {
        throw WikipediaApiException(
          'Failed to autocomplete search',
          statusCode: response.statusCode,
          uri: uri.toString(),
        );
      }

      final data = jsonDecode(response.body);
      if (data is Map<String, dynamic> && data['pages'] is List) {
        final pagesList = data['pages'] as List;
        return pagesList
            .map(
              (item) => WikiSearchResult.fromJson(item as Map<String, dynamic>),
            )
            .toList();
      }
      return <WikiSearchResult>[];
    } catch (e) {
      if (e is WikipediaApiException) rethrow;
      throw WikipediaApiException('Network error: $e', uri: uri.toString());
    }
  }

  /// Feeds candidate topics into the algorithm pipeline by utilizing Wikipedia's
  /// semantic relatedness graphing maps (morelike query).
  Future<List<WikiSummary>> fetchCategoryFeed(String categoryTitle) async {
    final encodedTitle = Uri.encodeComponent(categoryTitle);
    final urlString =
        'https://en.wikipedia.org/w/api.php'
        '?action=query'
        '&generator=search'
        '&gsrsearch=morelike:$encodedTitle'
        '&prop=pageimages|extracts|info'
        '&inprop=url'
        '&piprop=thumbnail'
        '&pithumbsize=320'
        '&exintro=1'
        '&explaintext=1'
        '&exsentences=3'
        '&format=json';

    final uri = Uri.parse(urlString);

    try {
      final response = await _client.get(uri, headers: _headers);
      if (response.statusCode != 200) {
        throw WikipediaApiException(
          'Failed to fetch category feed',
          statusCode: response.statusCode,
          uri: uri.toString(),
        );
      }

      final data = jsonDecode(response.body);
      if (data is Map<String, dynamic> &&
          data['query'] is Map &&
          data['query']['pages'] is Map) {
        final pagesMap = data['query']['pages'] as Map<String, dynamic>;
        final list = <WikiSummary>[];
        for (final entry in pagesMap.values) {
          if (entry is Map<String, dynamic>) {
            list.add(WikiSummary.fromJson(entry, categoryHint: categoryTitle));
          }
        }
        return list;
      }
      return <WikiSummary>[];
    } catch (e) {
      if (e is WikipediaApiException) rethrow;
      throw WikipediaApiException('Network error: $e', uri: uri.toString());
    }
  }
}
