import i18n from 'i18next';
import LngDetector from 'i18next-browser-languagedetector';

i18n
.use(LngDetector)
.init({
  fallbackLng: 'en',
  resources: {
    en: {
      translation: {
        chat: 'Chat',
        input: 'Input Message',
        you: 'You',
      },
    },
    ja: {
      translation: {
        chat: 'チャット',
        input: 'メッセージを入力してください',
        you: 'あなた',
      },
    },
  },
});

export default i18n;
