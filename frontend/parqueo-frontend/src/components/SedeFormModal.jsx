import { useEffect, useState } from 'react';

const FORMULARIO_VACIO = {
  nombreSede: '',
  direccion: '',
  municipio: '',
  departamento: '',
  telefono: '',
  horaApertura: '06:00',
  horaCierre: '20:00',
  capacidadTotal: '',
  estado: true,
};

export default function SedeFormModal({ sede, onGuardar, onCerrar }) {
  const [formulario, setFormulario] = useState(FORMULARIO_VACIO);
  const [guardando, setGuardando] = useState(false);
  const [error, setError] = useState('');

  const esEdicion = !!sede;

  useEffect(() => {
    if (sede) {
      setFormulario({
        nombreSede: sede.nombresede ?? sede.nombreSede ?? '',
        direccion: sede.direccion ?? '',
        municipio: sede.municipio ?? '',
        departamento: sede.departamento ?? '',
        telefono: sede.telefono ?? '',
        horaApertura: (sede.horaapertura ?? sede.horaApertura ?? '06:00').toString().slice(0, 5),
        horaCierre: (sede.horacierre ?? sede.horaCierre ?? '20:00').toString().slice(0, 5),
        capacidadTotal: sede.capacidadtotal ?? sede.capacidadTotal ?? '',
        // En la base de datos, Estado es texto ('Activa' / 'Inactiva'), no booleano.
        estado: sede.estado === undefined ? true : sede.estado === 'Activa',
      });
    } else {
      setFormulario(FORMULARIO_VACIO);
    }
  }, [sede]);

  const actualizarCampo = (campo, valor) => {
    setFormulario((actual) => ({ ...actual, [campo]: valor }));
  };

  const manejarEnvio = async (evento) => {
    evento.preventDefault();
    setError('');

    if (!formulario.nombreSede.trim() || !formulario.direccion.trim()) {
      setError('El nombre y la dirección de la sede son obligatorios.');
      return;
    }

    const capacidad = Number(formulario.capacidadTotal);
    if (!Number.isInteger(capacidad) || capacidad <= 0) {
      setError('La capacidad total debe ser un número entero mayor a cero.');
      return;
    }

    setGuardando(true);
    try {
      await onGuardar({
        ...formulario,
        capacidadTotal: capacidad,
        // El backend espera el texto 'Activa' / 'Inactiva', no true/false.
        estado: formulario.estado ? 'Activa' : 'Inactiva',
      });
    } catch (error) {
      const mensaje = error.response?.data?.mensaje || 'No se pudo guardar la sede.';
      setError(mensaje);
    } finally {
      setGuardando(false);
    }
  };

  return (
    <div className="modal-overlay" onClick={onCerrar}>
      <form
        className="glass-card modal-card"
        onClick={(evento) => evento.stopPropagation()}
        onSubmit={manejarEnvio}
      >
        <div className="modal-header">
          <h3>{esEdicion ? 'Editar sede' : 'Agregar sede'}</h3>
          <button type="button" className="modal-close" onClick={onCerrar}>
            ✕
          </button>
        </div>

        {error && <div className="error-banner" style={{ marginBottom: 16 }}>{error}</div>}

        <div className="modal-grid">
          <div className="field-group full">
            <label>Nombre de la sede</label>
            <input
              className="glass-input"
              type="text"
              value={formulario.nombreSede}
              onChange={(e) => actualizarCampo('nombreSede', e.target.value)}
              placeholder="Sede Zona 10"
            />
          </div>

          <div className="field-group full">
            <label>Dirección</label>
            <input
              className="glass-input"
              type="text"
              value={formulario.direccion}
              onChange={(e) => actualizarCampo('direccion', e.target.value)}
              placeholder="12 Calle 5-10"
            />
          </div>

          <div className="field-group">
            <label>Municipio</label>
            <input
              className="glass-input"
              type="text"
              value={formulario.municipio}
              onChange={(e) => actualizarCampo('municipio', e.target.value)}
              placeholder="Guatemala"
            />
          </div>

          <div className="field-group">
            <label>Departamento</label>
            <input
              className="glass-input"
              type="text"
              value={formulario.departamento}
              onChange={(e) => actualizarCampo('departamento', e.target.value)}
              placeholder="Guatemala"
            />
          </div>

          <div className="field-group">
            <label>Teléfono</label>
            <input
              className="glass-input"
              type="text"
              value={formulario.telefono}
              onChange={(e) => actualizarCampo('telefono', e.target.value)}
              placeholder="22345678"
            />
          </div>

          <div className="field-group">
            <label>Capacidad total</label>
            <input
              className="glass-input"
              type="number"
              min="1"
              value={formulario.capacidadTotal}
              onChange={(e) => actualizarCampo('capacidadTotal', e.target.value)}
              placeholder="120"
            />
          </div>

          <div className="field-group">
            <label>Hora de apertura</label>
            <input
              className="glass-input"
              type="time"
              value={formulario.horaApertura}
              onChange={(e) => actualizarCampo('horaApertura', e.target.value)}
            />
          </div>

          <div className="field-group">
            <label>Hora de cierre</label>
            <input
              className="glass-input"
              type="time"
              value={formulario.horaCierre}
              onChange={(e) => actualizarCampo('horaCierre', e.target.value)}
            />
          </div>

          <div className="field-group full checkbox-row">
            <input
              id="estadoSede"
              type="checkbox"
              checked={formulario.estado}
              onChange={(e) => actualizarCampo('estado', e.target.checked)}
            />
            <label htmlFor="estadoSede" style={{ textTransform: 'none', fontSize: 13 }}>
              Sede activa
            </label>
          </div>
        </div>

        <div className="modal-actions">
          <button type="button" className="btn btn-outline" onClick={onCerrar} disabled={guardando}>
            Cancelar
          </button>
          <button type="submit" className="btn btn-primary" disabled={guardando}>
            {guardando ? <span className="spinner" /> : esEdicion ? 'Guardar cambios' : 'Agregar sede'}
          </button>
        </div>
      </form>
    </div>
  );
}
