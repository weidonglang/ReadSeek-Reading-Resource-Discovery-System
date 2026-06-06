<template>
  <div class="page dashboard-page">
    <section class="dashboard-hero glass-panel">
      <div>
        <div class="eyebrow">ReadSeek</div>
        <h1>{{ bi('欢迎回来，', 'Welcome back, ') }}{{ displayName }}</h1>
        <p>{{ bi('帮你找书、规划阅读路径、管理借阅，并根据兴趣推荐合适资源。', 'Find books, plan reading paths, manage loans, and get useful recommendations.') }}</p>
        <div class="hero-search">
          <el-input
            v-model="quickQuery"
            size="large"
            :placeholder="bi('输入书名、作者、主题，或直接描述你的阅读需求...', 'Search title, author, topic, or describe your reading need...')"
            @keyup.enter="goSearch"
          />
          <el-button type="primary" size="large" @click="goSearch">{{ bi('智能检索', 'AI Search') }}</el-button>
        </div>
        <div class="quick-chip-row">
          <button v-for="item in quickPrompts" :key="item" type="button" @click="askAi(item)">{{ item }}</button>
        </div>
      </div>
      <div class="hero-orbit">
        <div class="orbit-card">
          <strong>{{ bi('今日阅读', 'Today') }}</strong>
          <span>{{ bi('从一个主题开始，找到下一本要读的书。', 'Start from a topic and find your next book.') }}</span>
        </div>
        <div class="orbit-metric">
          <strong>{{ overview?.shelves?.length || 0 }}</strong>
          <span>{{ bi('推荐书架', 'shelves') }}</span>
        </div>
      </div>
    </section>

    <section class="moment-panel glass-panel">
      <div class="moment-label">{{ bi('此刻信息', 'Right now') }}</div>
      <div class="moment-grid">
        <article class="moment-card">
          <span>{{ bi('当前时间', 'Current time') }}</span>
          <strong>{{ liveTime }}</strong>
          <p>{{ liveDate }}</p>
        </article>
        <article class="moment-card">
          <span>{{ bi('当前位置天气', 'Local weather') }}</span>
          <div class="weather-line">
            <div class="weather-icon">{{ weather.icon }}</div>
            <strong>{{ weather.label }} {{ weather.temperature }}</strong>
          </div>
          <p>{{ weather.copy }}</p>
          <el-button size="small" text @click="loadWeather(true)">{{ bi('刷新天气', 'Refresh weather') }}</el-button>
        </article>
        <article class="moment-card wide">
          <span>{{ bi('阅读建议', 'Reading suggestion') }}</span>
          <strong>{{ readingTip.title }}</strong>
          <p>{{ readingTip.copy }}</p>
        </article>
      </div>
    </section>

    <div class="grid grid-4">
      <MetricCard :label="bi('馆藏资源', 'Catalog resources')" :value="dashboard?.totalBooks || overviewBooks" :hint="bi('可检索与推荐的阅读资源', 'Searchable resources')" />
      <MetricCard :label="bi('到期提醒', 'Due reminders')" :value="urgentCount" :hint="bi('逾期与 3 天内到期', 'Overdue and due soon')" />
      <MetricCard v-if="auth.isAdmin" :label="bi('QA 请求', 'QA requests')" :value="qaAnalytics?.requestCount || 0" :hint="bi('问答统计', 'QA statistics')" />
      <MetricCard v-if="auth.isAdmin" :label="bi('推荐点击', 'Recommendation clicks')" :value="recAnalytics?.clickCount || 0" :hint="bi('推荐统计', 'Recommendation statistics')" />
    </div>

    <section class="dashboard-board">
      <article class="panel featured-panel">
        <div class="section-head">
          <div>
            <h2>{{ bi('为你推荐', 'Recommended for you') }}</h2>
            <p class="muted">{{ bi('保留旧首页的推荐预览，优先展示适合继续阅读的资源。', 'Recommendation preview focused on useful next reads.') }}</p>
          </div>
          <el-button @click="$router.push('/recommendations')">{{ bi('完整推荐', 'All recommendations') }}</el-button>
        </div>
        <div class="recommend-shelf-list">
          <article v-for="shelf in overview?.shelves?.slice(0, 3) || []" :key="shelf.key" class="shelf-preview modern">
            <div>
              <strong>{{ shelf.title }}</strong>
              <p>{{ shelf.description || shelf.strategy || '-' }}</p>
            </div>
            <div v-if="auth.isAdmin" class="tag-row">
              <el-tag>{{ shelf.key }}</el-tag>
              <el-tag v-if="shelf.reasonType" type="warning">{{ shelf.reasonType }}</el-tag>
              <el-tag type="success">{{ shelf.books?.length || 0 }} books</el-tag>
            </div>
            <el-tag v-else type="success">{{ shelf.books?.length || 0 }} books</el-tag>
          </article>
          <el-empty v-if="!overview?.shelves?.length" :description="emptyText()" />
        </div>
      </article>

      <article class="panel">
        <div class="section-head">
          <div>
            <h2>{{ bi('最近状态', 'Recent status') }}</h2>
            <p class="muted">{{ bi('借阅、浏览、热门趋势和新书继续保留在首页。', 'Loans, recent views, trends, and arrivals remain on the dashboard.') }}</p>
          </div>
        </div>
        <div class="status-stack">
          <div class="status-row">
            <span>{{ bi('连续阅读', 'Reading streak') }}</span>
            <strong>{{ dashboard?.readingStreakDays || 0 }} {{ bi('天', 'days') }}</strong>
          </div>
          <div class="status-row">
            <span>{{ bi('本月借阅 / 评分', 'Borrowed / rated this month') }}</span>
            <strong>{{ dashboard?.monthlyBorrowCount || 0 }} / {{ dashboard?.monthlyRatingCount || 0 }}</strong>
          </div>
          <div class="chip-cloud">
            <el-tag v-for="item in hotKeywords" :key="item.keyword || item.name" effect="plain">
              {{ item.keyword || item.name }} · {{ item.count || 0 }}
            </el-tag>
            <el-tag v-for="item in hotCategories" :key="item.name" type="success" effect="plain">
              {{ item.name }} · {{ item.count || 0 }}
            </el-tag>
          </div>
        </div>
      </article>
    </section>

    <section class="grid grid-3 dashboard-lists">
      <article class="panel">
        <h2>{{ bi('临近到期', 'Due soon') }}</h2>
        <div v-for="item in dueLoans" :key="item.id" class="compact-resource">
          <strong>{{ item.book?.name || item.bookName || '-' }}</strong>
          <span>{{ item.dueDate || item.returnDate || '-' }}</span>
        </div>
        <el-empty v-if="!dueLoans.length" :description="bi('暂无到期压力', 'No due pressure')" />
      </article>
      <article class="panel">
        <h2>{{ bi('最近浏览', 'Recently viewed') }}</h2>
        <div v-for="book in recentViewed" :key="book.id" class="compact-resource clickable" @click="$router.push(`/books/${book.id}`)">
          <strong>{{ book.name }}</strong>
          <span>{{ book.author?.name || '-' }}</span>
        </div>
        <el-empty v-if="!recentViewed.length" :description="emptyText()" />
      </article>
      <article class="panel">
        <h2>{{ bi('新书上架', 'New arrivals') }}</h2>
        <div v-for="book in newArrivals" :key="book.id" class="compact-resource clickable" @click="$router.push(`/books/${book.id}`)">
          <strong>{{ book.name }}</strong>
          <span>{{ book.category?.name || '-' }}</span>
        </div>
        <el-empty v-if="!newArrivals.length" :description="emptyText()" />
      </article>
    </section>
  </div>
</template>

<script setup lang="ts">
import { computed, onBeforeUnmount, onMounted, ref } from 'vue';
import { useRouter } from 'vue-router';
import MetricCard from '../components/MetricCard.vue';
import { analyticsApi, catalogApi, userApi } from '../services/domain';
import { useAuthStore } from '../stores/auth';
import type { RecommendationOverview } from '../types';
import { bi, emptyText } from '../i18n';

const router = useRouter();
const auth = useAuthStore();
const overview = ref<RecommendationOverview | null>(null);
const qaAnalytics = ref<any>(null);
const recAnalytics = ref<any>(null);
const dashboard = ref<any>(null);
const quickQuery = ref('');
const now = ref(new Date());
const weather = ref({
  icon: '☁',
  label: bi('本地天气', 'Local weather'),
  temperature: '--',
  copy: bi('开启定位后可以查看本地天气；不影响主要阅读功能。', 'Enable location to view local weather; reading features are not affected.')
});
let timer: number | undefined;

const displayName = computed(() => {
  const user = auth.user;
  return `${user?.firstName || ''} ${user?.lastName || ''}`.trim() || user?.email || 'Reader';
});
const liveTime = computed(() => now.value.toLocaleTimeString('zh-CN', { hour: '2-digit', minute: '2-digit' }));
const liveDate = computed(() => now.value.toLocaleDateString('zh-CN', { year: 'numeric', month: 'long', day: 'numeric', weekday: 'long' }));
const urgentCount = computed(() => Number(dashboard.value?.dueSoonCount || 0) + Number(dashboard.value?.overdueCount || 0));
const overviewBooks = computed(() => overview.value?.shelves?.reduce((sum, shelf) => sum + (shelf.books?.length || 0), 0) || 0);
const hotKeywords = computed(() => (dashboard.value?.hotKeywords || []).slice(0, 5));
const hotCategories = computed(() => (dashboard.value?.hotCategories || []).slice(0, 5));
const dueLoans = computed(() => (dashboard.value?.dueSoonLoans || []).slice(0, 4));
const recentViewed = computed(() => (dashboard.value?.recentViewedBooks || []).slice(0, 4));
const newArrivals = computed(() => (dashboard.value?.newArrivalBooks || []).slice(0, 4));
const readingTip = computed(() => {
  if (urgentCount.value > 0) {
    return {
      title: bi('先处理借阅节奏', 'Handle loan rhythm first'),
      copy: bi(`你有 ${urgentCount.value} 条到期相关提醒，今天适合先续借、归还或选择短篇资源。`, `You have ${urgentCount.value} due-related reminder(s). Start with renewals, returns, or shorter reads.`)
    };
  }
  const preferred = dashboard.value?.preferredCategories?.[0];
  if (preferred) {
    return {
      title: bi(`${preferred} 专注时段`, `${preferred} focus session`),
      copy: bi('根据你的偏好，今天可以先从该分类里挑一本评分较高且篇幅适中的书。', 'Start with a higher-rated, medium-length book from your preferred category.')
    };
  }
  return {
    title: bi('白天专注时段', 'Daytime focus window'),
    copy: bi('如果想系统地浏览图书，适合现在进入分类或检索页慢慢筛选。', 'This is a good time to browse categories or search deliberately.')
  };
});

const quickPrompts = [
  bi('AI 入门', 'AI beginner'),
  bi('机器学习', 'Machine learning'),
  bi('科幻小说', 'Science fiction'),
  bi('个人成长', 'Personal growth'),
  bi('考研复习', 'Exam preparation')
];

function goSearch() {
  const query = quickQuery.value.trim();
  router.push(query ? `/search?q=${encodeURIComponent(query)}` : '/search');
}

function askAi(prompt: string) {
  router.push(`/ai-chat?prompt=${encodeURIComponent(prompt)}`);
}

function weatherVisual(code: number) {
  if (code === 0) return { icon: '☀', label: bi('晴朗', 'Sunny') };
  if ([1, 2, 3].includes(code)) return { icon: '⛅', label: bi('多云', 'Cloudy') };
  if ([45, 48].includes(code)) return { icon: '🌫', label: bi('有雾', 'Foggy') };
  if ((code >= 51 && code <= 67) || (code >= 80 && code <= 82)) return { icon: '🌧', label: bi('下雨', 'Rainy') };
  if (code >= 71 && code <= 77) return { icon: '❄', label: bi('降雪', 'Snow') };
  if (code >= 95) return { icon: '⛈', label: bi('雷暴', 'Thunderstorm') };
  return { icon: '☁', label: bi('本地天气', 'Local weather') };
}

function cacheWeather(value: typeof weather.value) {
  localStorage.setItem('readseek_vue_weather', JSON.stringify({ value, savedAt: Date.now() }));
}

function cacheWeatherCoords(latitude: number, longitude: number) {
  localStorage.setItem('readseek_vue_weather_coords', JSON.stringify({ latitude, longitude, savedAt: Date.now() }));
}

function loadCachedWeatherCoords() {
  try {
    const parsed = JSON.parse(localStorage.getItem('readseek_vue_weather_coords') || 'null');
    const latitude = Number(parsed?.latitude);
    const longitude = Number(parsed?.longitude);
    return Number.isFinite(latitude) && Number.isFinite(longitude) ? { latitude, longitude } : null;
  } catch {
    return null;
  }
}

type WeatherSource = 'browser' | 'cache' | 'ip' | 'default';

function currentPosition(): Promise<GeolocationPosition> {
  return new Promise((resolve, reject) => {
    navigator.geolocation.getCurrentPosition(resolve, reject, {
      enableHighAccuracy: false,
      maximumAge: 10 * 60 * 1000,
      timeout: 4500
    });
  });
}

async function fetchJson(url: string, timeoutMs = 6000) {
  const controller = new AbortController();
  const timeoutId = window.setTimeout(() => controller.abort(), timeoutMs);
  try {
    const response = await fetch(url, { signal: controller.signal, cache: 'no-store' });
    if (!response.ok) throw new Error(`${url} ${response.status}`);
    return await response.json();
  } finally {
    window.clearTimeout(timeoutId);
  }
}

function weatherCopy(source: WeatherSource) {
  if (source === 'ip') {
    return bi('已根据当前网络位置估算天气；浏览器精确定位可用后会自动刷新。', 'Weather is estimated from your network location and will refresh when precise browser location is available.');
  }
  if (source === 'cache') {
    return bi('已使用上次可用位置刷新天气。', 'Weather refreshed from the last available location.');
  }
  if (source === 'default') {
    return bi('定位和网络位置暂不可用，已使用本机时区的默认城市估算天气。', 'Precise and network location are unavailable, so weather is estimated from the default city for this timezone.');
  }
  return bi('天气信息会根据当前位置自动更新。', 'Weather updates from your current location.');
}

async function fetchWeatherByCoords(latitude: number, longitude: number, source: WeatherSource) {
  const data = await fetchJson(`https://api.open-meteo.com/v1/forecast?latitude=${latitude}&longitude=${longitude}&current=temperature_2m,weather_code&timezone=auto`);
  const temperature = Number(data?.current?.temperature_2m);
  if (!Number.isFinite(temperature)) {
    throw new Error('weather payload missing current temperature');
  }
  const visual = weatherVisual(Number(data?.current?.weather_code));
  const value = {
    ...visual,
    temperature: `${Math.round(temperature)}°C`,
    copy: weatherCopy(source)
  };
  weather.value = value;
  cacheWeather(value);
}

async function fetchWeatherByIp() {
  const providers = [
    {
      url: 'https://ipwho.is/',
      parse: (data: any) => ({
        ok: data?.success,
        latitude: Number(data?.latitude),
        longitude: Number(data?.longitude)
      })
    },
    {
      url: 'https://ipapi.co/json/',
      parse: (data: any) => ({
        ok: !data?.error,
        latitude: Number(data?.latitude),
        longitude: Number(data?.longitude)
      })
    }
  ];

  for (const provider of providers) {
    try {
      const data = await fetchJson(provider.url, 4500);
      const location = provider.parse(data);
      if (location.ok && Number.isFinite(location.latitude) && Number.isFinite(location.longitude)) {
        cacheWeatherCoords(location.latitude, location.longitude);
        await fetchWeatherByCoords(location.latitude, location.longitude, 'ip');
        return;
      }
    } catch {
      // Try the next provider.
    }
  }
  throw new Error('ip location unavailable');
}

function defaultWeatherCoords() {
  const timeZone = Intl.DateTimeFormat().resolvedOptions().timeZone;
  if (timeZone === 'Asia/Shanghai') {
    return { latitude: 31.2304, longitude: 121.4737 };
  }
  return null;
}

async function fetchWeatherByDefaultLocation() {
  const fallback = defaultWeatherCoords();
  if (!fallback) {
    throw new Error('no default weather location for timezone');
  }
  await fetchWeatherByCoords(fallback.latitude, fallback.longitude, 'default');
}

async function loadWeather(force = false) {
  if (!force) {
    const cached = localStorage.getItem('readseek_vue_weather');
    if (cached) {
      try {
        const parsed = JSON.parse(cached);
        if (Date.now() - Number(parsed.savedAt || 0) < 30 * 60 * 1000) {
          weather.value = parsed.value;
          return;
        }
      } catch {
        localStorage.removeItem('readseek_vue_weather');
      }
    }
  }

  weather.value = {
    ...weather.value,
    copy: bi('正在刷新天气；如果精确定位不可用，会自动尝试网络位置。', 'Refreshing weather; network location will be used if precise location is unavailable.')
  };

  try {
    if (navigator.geolocation) {
      const permission = await navigator.permissions?.query?.({ name: 'geolocation' as PermissionName }).catch(() => null);
      if (!permission || permission.state !== 'denied') {
        const position = await currentPosition();
        const { latitude, longitude } = position.coords;
        cacheWeatherCoords(latitude, longitude);
        await fetchWeatherByCoords(latitude, longitude, 'browser');
        return;
      }
    }
  } catch {
    // Continue to cache/IP fallback below.
  }

  try {
    const cachedCoords = loadCachedWeatherCoords();
    if (cachedCoords) {
      await fetchWeatherByCoords(cachedCoords.latitude, cachedCoords.longitude, 'cache');
      return;
    }
  } catch {
    // Continue to IP fallback below.
  }

  try {
    await fetchWeatherByIp();
  } catch {
    try {
      await fetchWeatherByDefaultLocation();
    } catch {
      weather.value = {
        icon: '☁',
        label: bi('天气离线', 'Weather offline'),
        temperature: bi('待连接', 'Offline'),
        copy: bi('天气服务暂时不可用；检索、问答和推荐功能不受影响。', 'Weather service is unavailable; search, QA, and recommendations are not affected.')
      };
    }
  }
}

onMounted(async () => {
  timer = window.setInterval(() => { now.value = new Date(); }, 30000);
  const [recommendations, home] = await Promise.allSettled([
    catalogApi.recommendationOverview(),
    userApi.dashboard()
  ]);
  if (recommendations.status === 'fulfilled') overview.value = recommendations.value;
  if (home.status === 'fulfilled') dashboard.value = home.value;
  if (auth.isAdmin) {
    const [qa, rec] = await Promise.allSettled([
      analyticsApi.qaAnalytics(),
      analyticsApi.recAnalytics()
    ]);
    if (qa.status === 'fulfilled') qaAnalytics.value = qa.value;
    if (rec.status === 'fulfilled') recAnalytics.value = rec.value;
  }
  loadWeather();
});

onBeforeUnmount(() => {
  if (timer) window.clearInterval(timer);
});
</script>
