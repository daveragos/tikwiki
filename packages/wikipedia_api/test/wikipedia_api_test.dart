import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:test/test.dart';
import 'package:wikipedia_api/wikipedia_api.dart';

void main() {
  group('Data Models', () {
    test('WikiSummary.fromJson parses correctly', () {
      final json = {
        'pageid': 24723,
        'title': 'Quantum_entanglement',
        'displaytitle': 'Quantum entanglement',
        'extract': 'Quantum entanglement is a physical phenomenon...',
        'thumbnail': {
          'source': 'https://upload.wikimedia.org/image.jpg',
          'width': 320,
          'height': 240
        }
      };

      final summary = WikiSummary.fromJson(json, categoryHint: 'Physics');

      expect(summary.id, '24723');
      expect(summary.title, 'Quantum_entanglement');
      expect(summary.displayTitle, 'Quantum entanglement');
      expect(summary.extract, startsWith('Quantum entanglement'));
      expect(summary.thumbnailUrl, 'https://upload.wikimedia.org/image.jpg');
      expect(summary.categoryHint, 'Physics');

      final serialized = summary.toJson();
      final roundtrip = WikiSummary.fromJson(serialized);
      expect(roundtrip, summary);
    });

    test('WikiFullContent.fromHtml parses correctly', () {
      const html = '''
<!DOCTYPE html>
<html>
<head>
  <meta property="mw:pageId" content="998877"/>
  <title>Parsed HTML Title</title>
</head>
<body>
  <p>Article body content here.</p>
</body>
</html>
''';

      final content = WikiFullContent.fromHtml(
        html,
        title: 'Original Title',
        mobileUrl: 'https://en.m.wikipedia.org/wiki/Original_Title',
      );

      expect(content.id, '998877');
      expect(content.title, 'Parsed HTML Title');
      expect(content.rawHtmlBody, html);
      expect(content.mobileUrl, 'https://en.m.wikipedia.org/wiki/Original_Title');
    });

    test('WikiSearchResult.fromJson parses correctly', () {
      final json = {
        'id': 123,
        'title': 'Search Title',
        'description': 'Search description snippet',
        'thumbnail': {
          'url': '//upload.wikimedia.org/image_small.jpg'
        }
      };

      final result = WikiSearchResult.fromJson(json);

      expect(result.pageId, 123);
      expect(result.title, 'Search Title');
      expect(result.descriptionSnippet, 'Search description snippet');
      expect(result.tinyThumbnailUrl, 'https://upload.wikimedia.org/image_small.jpg');

      final serialized = result.toJson();
      final roundtrip = WikiSearchResult.fromJson(serialized);
      expect(roundtrip, result);
    });

    test('WikiCategoryBundle parses and validates equality', () {
      final json = {
        'categoryName': 'Space',
        'associatedTitles': ['Mars', 'Venus', 'Earth']
      };

      final bundle = WikiCategoryBundle.fromJson(json);
      expect(bundle.categoryName, 'Space');
      expect(bundle.associatedTitles, ['Mars', 'Venus', 'Earth']);

      final serialized = bundle.toJson();
      final roundtrip = WikiCategoryBundle.fromJson(serialized);
      expect(roundtrip, bundle);
    });
  });

  group('WikipediaClient', () {
    test('fetchRandomBatch returns valid list of summaries', () async {
      var callCount = 0;
      final mockHttpClient = MockClient((request) async {
        callCount++;
        expect(request.url.toString(), 'https://en.wikipedia.org/api/rest_v1/page/random/summary');
        expect(request.headers['User-Agent'], contains('TikWikiClient'));
        return http.Response(
          jsonEncode({
            'pageid': callCount,
            'title': 'Random Page $callCount',
            'displaytitle': 'Random Page Title $callCount',
            'extract': 'Extract $callCount',
          }),
          200,
        );
      });

      final client = WikipediaClient(client: mockHttpClient);
      final batch = await client.fetchRandomBatch(count: 3);

      expect(batch.length, 3);
      expect(callCount, 3);
      expect(batch[0].id, '1');
      expect(batch[1].id, '2');
      expect(batch[2].id, '3');
    });

    test('fetchArticleContent retrieves and parses HTML body', () async {
      final mockHttpClient = MockClient((request) async {
        expect(request.url.toString(), 'https://en.wikipedia.org/api/rest_v1/page/html/Quantum_entanglement');
        expect(request.headers['Accept'], 'text/html; charset=utf-8');
        return http.Response(
          '''
<html>
<head>
  <meta property="mw:pageId" content="25336"/>
  <title>Quantum entanglement</title>
</head>
<body>Content</body>
</html>
''',
          200,
        );
      });

      final client = WikipediaClient(client: mockHttpClient);
      final content = await client.fetchArticleContent('Quantum_entanglement');

      expect(content.id, '25336');
      expect(content.title, 'Quantum entanglement');
      expect(content.mobileUrl, 'https://en.m.wikipedia.org/wiki/Quantum_entanglement');
      expect(content.rawHtmlBody, contains('<body>Content</body>'));
    });

    test('querySearchAutocomplete retrieves and maps results', () async {
      final mockHttpClient = MockClient((request) async {
        expect(request.url.toString(), 'https://en.wikipedia.org/w/rest.php/v1/search/title?q=Quantum');
        return http.Response(
          jsonEncode({
            'pages': [
              {
                'id': 25280,
                'title': 'Quantum teleportation',
                'description': 'Physical phenomenon',
                'thumbnail': {'url': '//upload.wikimedia.org/thumb.jpg'}
              }
            ]
          }),
          200,
        );
      });

      final client = WikipediaClient(client: mockHttpClient);
      final results = await client.querySearchAutocomplete('Quantum');

      expect(results.length, 1);
      expect(results[0].pageId, 25280);
      expect(results[0].title, 'Quantum teleportation');
      expect(results[0].descriptionSnippet, 'Physical phenomenon');
      expect(results[0].tinyThumbnailUrl, 'https://upload.wikimedia.org/thumb.jpg');
    });

    test('fetchCategoryFeed queries action API with morelike parameter', () async {
      final mockHttpClient = MockClient((request) async {
        expect(request.url.toString(), contains('action=query'));
        expect(request.url.toString(), contains('gsrsearch=morelike:Quantum_entanglement'));
        return http.Response(
          jsonEncode({
            'query': {
              'pages': {
                '3423431': {
                  'pageid': 3423431,
                  'title': 'LOCC',
                  'displaytitle': 'LOCC Title',
                  'extract': 'LOCC extract details',
                  'thumbnail': {'source': 'https://example.com/locc.png'}
                }
              }
            }
          }),
          200,
        );
      });

      final client = WikipediaClient(client: mockHttpClient);
      final results = await client.fetchCategoryFeed('Quantum_entanglement');

      expect(results.length, 1);
      expect(results[0].id, '3423431');
      expect(results[0].title, 'LOCC');
      expect(results[0].extract, 'LOCC extract details');
      expect(results[0].categoryHint, 'Quantum_entanglement');
    });

    test('Exception is thrown when HTTP response is not 200', () async {
      final mockHttpClient = MockClient((request) async {
        return http.Response('Server Error', 500);
      });

      final client = WikipediaClient(client: mockHttpClient);

      expect(
        () => client.fetchArticleContent('Quantum'),
        throwsA(isA<WikipediaApiException>().having((e) => e.statusCode, 'statusCode', 500)),
      );
    });
  });
}
