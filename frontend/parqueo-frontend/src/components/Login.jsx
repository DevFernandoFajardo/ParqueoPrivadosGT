import { useState } from 'react';
import { iniciarSesion } from '../api/auth.js';

export default function Login({ onLoginExitoso }) {
  const [nombreUsuario, setNombreUsuario] = useState('');
  const [claveUsuario, setClaveUsuario] = useState('');
  const [cargando, setCargando] = useState(false);
  const [error, setError] = useState('');

  const manejarEnvio = async (evento) => {
    evento.preventDefault();
    setError('');

    if (!nombreUsuario.trim() || !claveUsuario.trim()) {
      setError('Debes ingresar el usuario y la clave.');
      return;
    }

    setCargando(true);
    try {
      const respuesta = await iniciarSesion(nombreUsuario.trim(), claveUsuario);
      const { accessToken, refreshToken, usuario } = respuesta.datos;
      // Todavía no guardamos nada en localStorage: primero hay que pasar
      // por la pantalla de verificación de token.
      onLoginExitoso({ accessToken, refreshToken, usuario });
    } catch (error) {
      const mensaje =
        error.response?.data?.mensaje || 'No se pudo iniciar sesión. Verifica tus datos.';
      setError(mensaje);
    } finally {
      setCargando(false);
    }
  };

  return (
    <div className="login-page">
      <form className="glass-card login-card" onSubmit={manejarEnvio}>
        <div className="login-brand">
          <div className="icon-badge">🅿️</div>
          <h1>Parqueo Privados GT</h1>
          <p>Panel administrativo de sedes</p>
        </div>

        {error && <div className="error-banner">{error}</div>}

        <div className="field-group">
          <label htmlFor="nombreUsuario">Usuario</label>
          <input
            id="nombreUsuario"
            className="glass-input"
            type="text"
            placeholder="admin"
            value={nombreUsuario}
            onChange={(evento) => setNombreUsuario(evento.target.value)}
            autoComplete="username"
          />
        </div>

        <div className="field-group">
          <label htmlFor="claveUsuario">Contraseña</label>
          <input
            id="claveUsuario"
            className="glass-input"
            type="password"
            placeholder="••••••••"
            value={claveUsuario}
            onChange={(evento) => setClaveUsuario(evento.target.value)}
            autoComplete="current-password"
          />
        </div>

        <button className="btn btn-primary" type="submit" disabled={cargando}>
          {cargando ? <span className="spinner" /> : 'Iniciar sesión'}
        </button>

        <p className="login-credentials-hint">© {new Date().getFullYear()} Dev Fernando Fajardo</p>
      </form>
    </div>
  );
}
