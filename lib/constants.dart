const BASE_URL = 'https://trpc-server.vercel.app/api/trpc';

const baseUrl = BASE_URL;

enum APIUrls { refresh, login, register, user, logout }

Map<APIUrls, String> apiUrls = {
  APIUrls.refresh: '$baseUrl/auth.refresh_token',
  APIUrls.login: '$baseUrl/auth.login',
  APIUrls.register: '$baseUrl/auth.register',
  APIUrls.user: '$baseUrl/auth.user',
  APIUrls.logout: '$baseUrl/auth.logout',
};

const localStore = 'my_app';
