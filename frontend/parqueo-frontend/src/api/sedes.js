import axiosClient from './axiosClient.js';

// NOTA: estas rutas asumen la convención usada en el resto del backend
// (Usp_X_Agregar/Editar/... -> controlador con rutas "sedesAgregar",
// "sedesEditar/:codigoSede", etc.). Si en tu sedes.controller.ts los
// nombres de ruta son distintos, ajústalos aquí; es el único archivo
// que los conoce.

export async function consultarSedes() {
  const respuesta = await axiosClient.get('/sedesConsultar');
  return respuesta.data;
}

export async function buscarSedes(texto) {
  const respuesta = await axiosClient.get(`/sedesBuscar/${encodeURIComponent(texto)}`);
  return respuesta.data;
}

export async function agregarSede(datos) {
  const respuesta = await axiosClient.post('/sedesAgregar', datos);
  return respuesta.data;
}

export async function editarSede(codigoSede, datos) {
  const respuesta = await axiosClient.put(`/sedesEditar/${codigoSede}`, datos);
  return respuesta.data;
}

export async function eliminarSede(codigoSede) {
  const respuesta = await axiosClient.delete(`/sedesEliminar/${codigoSede}`);
  return respuesta.data;
}
