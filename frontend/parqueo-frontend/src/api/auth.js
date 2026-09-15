import axios from 'axios';
import axiosClient, { API_BASE_URL } from './axiosClient.js';

export async function iniciarSesion(nombreUsuario, claveUsuario) {
  const respuesta = await axiosClient.post('/login', { nombreUsuario, claveUsuario });
  return respuesta.data;
}

// Usa axios "puro" (sin el interceptor de axiosClient) para no entrar
// en un ciclo si esta misma llamada llegara a fallar.
export async function renovarToken(refreshToken) {
  const respuesta = await axios.post(`${API_BASE_URL}/refresh-token`, { refreshToken });
  return respuesta.data;
}

// Avisa al backend que el usuario cerró sesión, para que invalide de
// inmediato tanto el accessToken como el refreshToken (sube la
// VersionToken del usuario en la base de datos).
export async function cerrarSesionRemota() {
  const respuesta = await axiosClient.post('/logout');
  return respuesta.data;
}
