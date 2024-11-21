import { sanitizeText } from './sanitize_helpers';

const imgRegexp = /^http.+\.(jpg|jpeg|png|webp)$/;

export const renderSampleList = (entries) => {
  if (!entries) return 'No entries to display';

  if (URL.canParse(entries[0]) && imgRegexp.test(entries[0])) {
    const imageEntries = entries.map((entry) => {
      if (!URL.canParse(entry) || !imgRegexp.test(entry)) {
        return `<li>${sanitizeText(entry)}</li>`;
      }
      return `<li><img src="${entry}" /></li>`;
    });
    return `<ul class="image-list">${imageEntries.join('')}</ul>`;
  }

  return `<ul class="text-list">${entries.map(entry => `<li>${sanitizeText(entry)}</li>`).join('')}</ul>`
}
