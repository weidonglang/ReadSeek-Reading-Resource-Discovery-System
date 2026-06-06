export interface ApiResponse<T> {
  success: boolean;
  timestamp: string;
  message: string;
  body: T;
}

export interface User {
  id?: number;
  email: string;
  firstName?: string;
  lastName?: string;
  role?: string;
  phoneNumber?: string;
  birthdate?: string;
  country?: string;
  age?: number;
  gender?: string;
  maritalStatus?: string;
  imageUrl?: string;
}

export interface Book {
  id: number;
  name: string;
  description?: string;
  imageUrl?: string;
  rate?: number;
  usersRateCount?: number;
  pagesNumber?: number;
  readingDuration?: number;
  price?: number;
  isbn?: string;
  publishDate?: string;
  totalCopies?: number;
  availableCopies?: number;
  author?: { id?: number; name?: string };
  category?: { id?: number; name?: string };
  publisher?: { id?: number; name?: string };
  tags?: Array<{ id?: number; name?: string }>;
  recommendationSource?: string;
  recommendationReason?: string;
  recommendationReasonType?: string;
  recommendationRank?: number;
}

export interface SearchHit {
  book: Book;
  score?: number;
  matchType?: string;
  reason?: string;
  source?: string;
  retrievalStage?: string;
  reranked?: boolean;
  explanationTags?: string[];
}

export interface SearchResponse {
  query: string;
  queryIntent?: string;
  strategy?: string;
  expandedQuery?: string;
  fallbackApplied?: boolean;
  returnedCount?: number;
  hits?: SearchHit[];
  strategySteps?: string[];
  rerankerApplied?: boolean;
  candidateCount?: number;
}

export interface EvidenceSnippet {
  resourceId?: number;
  title?: string;
  author?: string;
  category?: string;
  description?: string;
  matchType?: string;
  score?: number;
  reason?: string;
  rank?: number;
  citation?: string;
  source?: string;
  reranked?: boolean;
}

export interface QaResponse {
  question?: string;
  answer?: string;
  answerable?: boolean;
  evidence?: EvidenceSnippet[];
  citations?: string[];
  confidence?: number;
  strategy?: string;
  queryIntent?: string;
  fallbackApplied?: boolean;
  ragMode?: string;
  llmProvider?: string;
  model?: string;
  generationBackend?: string;
  retrievalLatencyMs?: number;
  generationLatencyMs?: number;
  totalLatencyMs?: number;
  llmFallbackApplied?: boolean;
  limitations?: string[];
  followUpSuggestions?: string[];
  followUps?: string[];
}

export interface ChatResponse extends QaResponse {
  sessionId: string;
  recommendations?: Array<{
    resourceId?: number;
    title?: string;
    author?: string;
    category?: string;
    source?: string;
    reason?: string;
    rank?: number;
  }>;
  userMessage?: { id: string; role: string; content: string; createdAt: string };
  assistantMessage?: { id: string; role: string; content: string; createdAt: string };
}

export interface RecommendationShelf {
  key: string;
  title: string;
  description?: string;
  source?: string;
  reasonType?: string;
  strategy?: string;
  books?: Book[];
}

export interface RecommendationOverview {
  title: string;
  shelves: RecommendationShelf[];
}
