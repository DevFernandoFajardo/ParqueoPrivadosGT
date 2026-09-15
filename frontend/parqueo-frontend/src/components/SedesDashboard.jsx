import { useCallback, useEffect, useMemo, useState } from 'react';
import { agregarSede, buscarSedes, consultarSedes, editarSede, eliminarSede } from '../api/sedes.js';
import { useToast } from './Toast.jsx';
import SedeFormModal from './SedeFormModal.jsx';

export default function SedesDashboard({ usuario, onCerrarSesion }) {
  const [sedes, setSedes] = useState([]);
  const [cargando, setCargando] = useState(true);
  const [textoBusqueda, setTextoBusqueda] = useState('');
  const [modalAbierto, setModalAbierto] = useState(false);
  const [sedeSeleccionada, setSedeSeleccionada] = useState(null);
  const mostrarToast = useToast();

  const codigoDe = (sede) => sede.codigosede ?? sede.codigoSede;

  const cargarSedes = useCallback(async () => {
    setCargando(true);
    try {
      const respuesta = await consultarSedes();
      setSedes(respuesta.datos || []);
    } catch (error) {
      const mensaje = error.response?.data?.mensaje || 'No se pudieron cargar las sedes.';
      mostrarToast(mensaje, 'error');
    } finally {
      setCargando(false);
    }
  }, [mostrarToast]);

  useEffect(() => {
    cargarSedes();
  }, [cargarSedes]);

  const manejarBusqueda = async (evento) => {
    evento.preventDefault();
    const texto = textoBusqueda.trim();

    if (!texto) {
      cargarSedes();
      return;
    }

    // El backend busca por CodigoSede exacto (número entero), no por texto libre.
    if (!/^\d+$/.test(texto)) {
      mostrarToast('Ingresa un Código de Sede válido (solo números).', 'error');
      return;
    }

    setCargando(true);
    try {
      const respuesta = await buscarSedes(texto);
      setSedes(respuesta.datos || []);
    } catch (error) {
      const mensaje = error.response?.data?.mensaje || 'No se encontró ninguna sede con ese código.';
      mostrarToast(mensaje, 'error');
      setSedes([]);
    } finally {
      setCargando(false);
    }
  };

  const abrirModalAgregar = () => {
    setSedeSeleccionada(null);
    setModalAbierto(true);
  };

  const abrirModalEditar = (sede) => {
    setSedeSeleccionada(sede);
    setModalAbierto(true);
  };

  const cerrarModal = () => {
    setModalAbierto(false);
    setSedeSeleccionada(null);
  };

  const guardarSede = async (datos) => {
    if (sedeSeleccionada) {
      await editarSede(codigoDe(sedeSeleccionada), datos);
      mostrarToast('Sede actualizada correctamente.', 'success');
    } else {
      await agregarSede(datos);
      mostrarToast('Sede agregada correctamente.', 'success');
    }
    cerrarModal();
    cargarSedes();
  };

  const manejarEliminar = async (sede) => {
    const confirmado = window.confirm(
      `¿Eliminar la sede "${sede.nombresede ?? sede.nombreSede}"? Esta acción no se puede deshacer.`,
    );
    if (!confirmado) return;

    try {
      await eliminarSede(codigoDe(sede));
      mostrarToast('Sede eliminada correctamente.', 'success');
      cargarSedes();
    } catch (error) {
      const mensaje = error.response?.data?.mensaje || 'No se pudo eliminar la sede.';
      mostrarToast(mensaje, 'error');
    }
  };

  // En la base de datos, Estado de Tbl_Sedes es un texto ('Activa' / 'Inactiva'),
  // no un booleano — hay que compararlo como cadena exacta.
  const estaActiva = (sede) => sede.estado === 'Activa';

  const estadisticas = useMemo(() => {
    const total = sedes.length;
    const activas = sedes.filter(estaActiva).length;
    return { total, activas, inactivas: total - activas };
  }, [sedes]);

  return (
    <>
      <header className="glass-card topbar">
        <div className="topbar-brand">
          <div className="icon-badge">🅿️</div>
          <div>
            <h2>Parqueo Privados GT</h2>
            <span>Gestión de sedes</span>
          </div>
        </div>
        <div className="topbar-user">
          <div className="user-chip">
            <strong>{usuario?.nombreUsuario || 'Usuario'}</strong>
            <span>{usuario?.tipoUsuario || 'Sesión activa'}</span>
          </div>
          <button className="btn btn-danger btn-sm" onClick={onCerrarSesion}>
            Cerrar sesión
          </button>
        </div>
      </header>

      <main className="dashboard">
        <div className="dashboard-header">
          <div>
            <h1>Sedes</h1>
            <p>Administra las sedes de Parqueo Privados GT, S.A.</p>
          </div>
          <button className="btn btn-primary" onClick={abrirModalAgregar}>
            + Agregar sede
          </button>
        </div>

        <div className="stats-row">
          <div className="glass-card stat-card">
            <span>Total de sedes</span>
            <strong>{estadisticas.total}</strong>
          </div>
          <div className="glass-card stat-card">
            <span>Activas</span>
            <strong>{estadisticas.activas}</strong>
          </div>
          <div className="glass-card stat-card">
            <span>Inactivas</span>
            <strong>{estadisticas.inactivas}</strong>
          </div>
        </div>

        <form className="toolbar" onSubmit={manejarBusqueda}>
          <div className="search-box">
            <input
              className="glass-input"
              style={{ width: '100%' }}
              type="text"
              placeholder="Buscar por Código de Sede (ej. 1, 2, 3...)"
              value={textoBusqueda}
              onChange={(e) => setTextoBusqueda(e.target.value)}
            />
          </div>
          <button type="submit" className="btn btn-outline">
            Buscar
          </button>
          <button
            type="button"
            className="btn btn-outline"
            onClick={() => {
              setTextoBusqueda('');
              cargarSedes();
            }}
          >
            Limpiar
          </button>
        </form>

        <div className="glass-card table-wrap">
          {cargando ? (
            <div className="full-page-loader" style={{ padding: 60 }}>
              <span className="spinner" />
            </div>
          ) : sedes.length === 0 ? (
            <div className="empty-state">No hay sedes registradas todavía.</div>
          ) : (
            <table className="glass-table">
              <thead>
                <tr>
                  <th>Código</th>
                  <th>Nombre</th>
                  <th>Ubicación</th>
                  <th>Teléfono</th>
                  <th>Horario</th>
                  <th>Capacidad</th>
                  <th>Estado</th>
                  <th></th>
                </tr>
              </thead>
              <tbody>
                {sedes.map((sede) => (
                  <tr key={codigoDe(sede)}>
                    <td>{codigoDe(sede)}</td>
                    <td>{sede.nombresede ?? sede.nombreSede}</td>
                    <td>
                      {sede.direccion}
                      <br />
                      <span style={{ color: 'var(--text-muted)', fontSize: 12 }}>
                        {sede.municipio}, {sede.departamento}
                      </span>
                    </td>
                    <td>{sede.telefono}</td>
                    <td>
                      {(sede.horaapertura ?? sede.horaApertura ?? '').toString().slice(0, 5)} -{' '}
                      {(sede.horacierre ?? sede.horaCierre ?? '').toString().slice(0, 5)}
                    </td>
                    <td>{sede.capacidadtotal ?? sede.capacidadTotal}</td>
                    <td>
                      <span className={`badge ${estaActiva(sede) ? 'badge-activo' : 'badge-inactivo'}`}>
                        {estaActiva(sede) ? 'Activa' : 'Inactiva'}
                      </span>
                    </td>
                    <td>
                      <div className="row-actions">
                        <button className="btn btn-outline btn-sm" onClick={() => abrirModalEditar(sede)}>
                          Editar
                        </button>
                        <button className="btn btn-danger btn-sm" onClick={() => manejarEliminar(sede)}>
                          Eliminar
                        </button>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          )}
        </div>
      </main>

      {modalAbierto && (
        <SedeFormModal sede={sedeSeleccionada} onGuardar={guardarSede} onCerrar={cerrarModal} />
      )}
    </>
  );
}
