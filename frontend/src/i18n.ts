export type ReadSeekLanguage = 'zh' | 'en';

export function currentLanguage(): ReadSeekLanguage {
  const saved = localStorage.getItem('readseek_language');
  if (saved === 'zh' || saved === 'en') {
    return saved;
  }
  return navigator.language?.toLowerCase().startsWith('zh') ? 'zh' : 'en';
}

export function setLanguagePreference(language: ReadSeekLanguage) {
  localStorage.setItem('readseek_language', language);
}

export function isDemoModeEnabled(): boolean {
  return localStorage.getItem('readseek_demo_mode') === 'true';
}

export function setDemoModePreference(enabled: boolean) {
  localStorage.setItem('readseek_demo_mode', String(enabled));
}

export function bi(zh: string, en: string): string {
  return currentLanguage() === 'en' ? en : zh;
}

export function yesNo(value?: boolean): string {
  return value ? bi('是', 'Yes') : bi('否', 'No');
}

export function emptyText(zh = '暂无数据', en = 'No data'): string {
  return bi(zh, en);
}

export function formatDateTime(value?: string | null): string {
  if (!value) return '-';
  const date = new Date(value);
  if (Number.isNaN(date.getTime())) return String(value);
  return date.toLocaleString('zh-CN');
}

export function formatNumber(value?: number | null, fallback = '-'): string {
  if (value === null || value === undefined || Number.isNaN(Number(value))) return fallback;
  return Number(value).toLocaleString('zh-CN');
}
