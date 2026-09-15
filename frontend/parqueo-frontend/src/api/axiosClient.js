import axios from 'axios';

export const API_BASE_URL = 'http://localhost:3000/api';

const axiosClient = axios.create({
  baseURL: API_BASE_URL,
  headers: { 'Content-Type': 'application/json' },
});

// Adjunta el accessToken guardado a cada petición saliente.
axiosClient.interceptors.request.use((config) => {
  const accessToken = localStorage.getItem('accessToken');
  if (accessToken) {
    config.headers.Authorization = `Bearer ${accessToken}`;
  }
  return config;
});

// Si el access token expiró (401), lo renovamos usando el refreshToken
// (que dura más) y reintentamos la petición original una sola vez.
// Si el refreshToken también es inválido o ya expiró, ahí sí se cierra
// la sesión y se manda al login.
let renovandoToken = null;

axiosClient.interceptors.response.use(
  (response) => response,
  async (error) => {
    const peticionOriginal = error.config;
    const esErrorDeAutenticacion = error.response && error.response.status === 401;

    if (esErrorDeAutenticacion && peticionOriginal && !peticionOriginal._reintentada) {
      peticionOriginal._reintentada = true;
      const refreshToken = localStorage.getItem('refreshToken');

      if (!refreshToken) {
        localStorage.removeItem('accessToken');
        localStorage.removeItem('refreshToken');
        window.dispatchEvent(new Event('sesion-expirada'));
        return Promise.reject(error);
      }

      try {
        if (!renovandoToken) {
          renovandoToken = axios
            .post(`${API_BASE_URL}/refresh-token`, { refreshToken })
            .then((respuesta) => {
              const nuevoAccessToken = respuesta.data.datos.accessToken;
              localStorage.setItem('accessToken', nuevoAccessToken);
              return nuevoAccessToken;
            })
            .finally(() => {
              renovandoToken = null;
            });
        }

        const nuevoAccessToken = await renovandoToken;
        peticionOriginal.headers.Authorization = `Bearer ${nuevoAccessToken}`;
        return axiosClient(peticionOriginal);
      } catch (errorRenovacion) {
        localStorage.removeItem('accessToken');
        localStorage.removeItem('refreshToken');
        window.dispatchEvent(new Event('sesion-expirada'));
        return Promise.reject(errorRenovacion);
      }
    }

    return Promise.reject(error);
  },
);

export default axiosClient;
