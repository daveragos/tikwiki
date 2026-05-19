import 'package:wikipedia_api/wikipedia_api.dart';

void main() async {
  final client = WikipediaClient();

  print('==================================================');
  print('🧪 Wikipedia API Integration Test/Example Run');
  print('==================================================\n');

  try {
    // 1. Fetching a batch of random summaries
    print('1. Polling Wikipedia for a batch of random summaries...');
    final randomBatch = await client.fetchRandomBatch(count: 3);
    print('🚀 Successfully loaded ${randomBatch.length} random summaries:');
    for (var i = 0; i < randomBatch.length; i++) {
      final article = randomBatch[i];
      print('   [$i] Title: "${article.title}" (ID: ${article.id})');
      print(
        '       Extract: "${article.extract.substring(0, article.extract.length > 80 ? 80 : article.extract.length)}..."',
      );
      if (article.thumbnailUrl != null) {
        print('       Thumbnail: ${article.thumbnailUrl}');
      }
    }
    print('');

    if (randomBatch.isEmpty) {
      print('⚠️ Random batch was empty. Skipping subsequent tests.');
      return;
    }

    final targetTitle = randomBatch.first.title;

    // 2. Fetching detailed article content
    print('2. Fetching full article content for "$targetTitle"...');
    final content = await client.fetchArticleContent(targetTitle);
    print('📖 Loaded page content:');
    print('   - ID: ${content.id}');
    print('   - Title: ${content.title}');
    print('   - Mobile URL: ${content.mobileUrl}');
    print('   - HTML Length: ${content.rawHtmlBody.length} bytes');
    print('');

    // 3. Testing Autocomplete Search
    const searchWord = 'Quantum';
    print('3. Querying search autocomplete for "$searchWord"...');
    final autocompleteResults = await client.querySearchAutocomplete(
      searchWord,
    );
    print('🔍 Found ${autocompleteResults.length} matches:');
    for (
      var i = 0;
      i < (autocompleteResults.length > 5 ? 5 : autocompleteResults.length);
      i++
    ) {
      final result = autocompleteResults[i];
      print('   [$i] ${result.title} (Page ID: ${result.pageId})');
      if (result.descriptionSnippet != null) {
        print('       Description: ${result.descriptionSnippet}');
      }
    }
    print('');

    // 4. Testing Category/Related Feed
    final categorySearch = targetTitle;
    print(
      '4. Sourcing candidate category feed topics for similar pages to "$categorySearch"...',
    );
    final categoryFeed = await client.fetchCategoryFeed(categorySearch);
    print('🧬 Found ${categoryFeed.length} related candidates:');
    for (
      var i = 0;
      i < (categoryFeed.length > 3 ? 3 : categoryFeed.length);
      i++
    ) {
      final item = categoryFeed[i];
      print('   [$i] ${item.title} (ID: ${item.id})');
      print(
        '       Extract: "${item.extract.substring(0, item.extract.length > 80 ? 80 : item.extract.length)}..."',
      );
      print('       Category Hint: ${item.categoryHint}');
    }
    print('');

    print('==================================================');
    print('✅ Wikipedia API package functions work correctly!');
    print('==================================================');
  } catch (e) {
    print('❌ Failed to run Wikipedia API integration: $e');
  }
}
