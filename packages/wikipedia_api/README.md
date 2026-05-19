# 📦 wikipedia_api

A pure Dart package that handles raw networking and data serialization for the Wikipedia/Wikimedia REST and Action APIs. This module acts as an isolated data layer and has zero dependencies on Flutter, UI elements, or state management frameworks.

---

## 🏗 System Architecture

The package contains two primary responsibilities: Data Transfer Objects (Models) and the Service Client (Network Layer).

```plaintext
lib/
├── src/
│   ├── models/
│   │   ├── wiki_summary.dart           # Swipe Feed Summary Model
│   │   ├── wiki_full_content.dart      # Serif Reading Page HTML Model
│   │   ├── wiki_search_result.dart     # Autocomplete Suggestion Model
│   │   └── wiki_category_bundle.dart   # Algorithm Candidate Sourcing Pool
│   └── services/
│       └── wikipedia_client.dart       # HTTP Request Handler & Parser
└── wikipedia_api.dart                  # Main Export Interface
```

---

## 📡 API Services & Endpoints Protocol

Inside `WikipediaClient`, four network endpoints are supported:

### 1. `fetchRandomBatch({int count = 10})`
- **Purpose:** Streams random discovery summaries for the infinite scroll feed.
- **Endpoint:** `GET https://en.wikipedia.org/api/rest_v1/page/random/summary`
- **Processing Loop:** Runs concurrent async requests via `Future.wait` and maps responses to `WikiSummary`.

### 2. `fetchArticleContent(String title)`
- **Purpose:** Fetches semantic HTML to build the reading layout.
- **Endpoint:** `GET https://en.wikipedia.org/api/rest_v1/page/html/{title}`
- **Processing Loop:** Grabs HTML body and extracts metadata page ID and Title using regular expression parsing.

### 3. `querySearchAutocomplete(String searchTerm)`
- **Purpose:** Feeds typeahead search suggestions.
- **Endpoint:** `GET https://en.wikipedia.org/w/rest.php/v1/search/title?q={searchTerm}`
- **Processing Loop:** Returns lists of prefix matches mapped to `WikiSearchResult`.

### 4. `fetchCategoryFeed(String categoryTitle)`
- **Purpose:** Sourcing contextually similar topic candidates to seed the ranking algorithm.
- **Endpoint:** `GET https://en.wikipedia.org/w/api.php?action=query&generator=search&gsrsearch=morelike:{title}&...`
- **Processing Loop:** Leverages MediaWiki's `morelike` similarity search engine and returns page metadata mapped to `WikiSummary`.

---

## 🛠 Usage Example

```dart
import 'package:wikipedia_api/wikipedia_api.dart';

void main() async {
  final client = WikipediaClient();
  
  try {
    // 1. Fetch random swipe summaries
    final feed = await client.fetchRandomBatch(count: 5);
    for (var article in feed) {
      print('Feed item: ${article.displayTitle}');
    }

    // 2. Fetch full reading HTML content
    final content = await client.fetchArticleContent('Quantum_entanglement');
    print('HTML Content Length: ${content.rawHtmlBody.length}');
  } catch (e) {
    print('Failed to poll Wikipedia API: $e');
  }
}
```
