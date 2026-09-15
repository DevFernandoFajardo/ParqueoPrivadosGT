import { useCallback, useEffect, useState } from 'react';
import Login from './components/Login.jsx';
import TokenGate from './components/TokenGate.jsx';
import SedesDashboard from './components/SedesDashboard.jsx';
import { ToastProvider } from './components/Toast.jsx';
import { cerrarSesionRemota } from './api/auth.js';

export default function App() {
  const [autenticado, setAutenticado] = useState(() => !!localStorage.getItem('accessToken'));
  const [usuario, setUsuario] = useState(() => {
    const guardado = localStorage.getItem('usuario');
    return guardado ? JSON.parse(guardado) : null;
  });

  // Tokens recién generados por el login, pendientes de que el usuario
  // los confirme pegando el accessToken en la pantalla de verificación.
  // Todavía no se guardan en localStorage ni se usan para nada.
  const [sesionPendiente, setSesionPendiente] = useState(null);

  const cerrarSesion = useCallback(async () => {
    try {
      // Avisa al backend para que invalide ambos tokens de inmediato
      // (sube la VersionToken del usuario). Si falla, igual cerramos
      // la sesión localmente.
      await cerrarSesionRemota();
    } catch (error) {
      // No hacemos nada: el cierre de sesión local continúa de todas formas.
    } finally {
      localStorage.removeItem('accessToken');
      localStorage.removeItem('refreshToken');
      localStorage.removeItem('usuario');
      setAutenticado(false);
      setUsuario(null);
      setSesionPendiente(null);
    }
  }, []);

  // El login ya fue exitoso contra el backend, pero todavía no dejamos
  // entrar al dashboard: primero se muestra la pantalla de verificación.
  const manejarLoginExitoso = (datosSesion) => {
    setSesionPendiente(datosSesion);
  };

  // El usuario pegó correctamente el accessToken: ahora sí guardamos
  // todo y entramos al sistema.
  const manejarTokenConfirmado = () => {
    if (!sesionPendiente) return;
    const { accessToken, refreshToken, usuario: datosUsuario } = sesionPendiente;
    localStorage.setItem('accessToken', accessToken);
    localStorage.setItem('refreshToken', refreshToken);
    localStorage.setItem('usuario', JSON.stringify(datosUsuario));
    setUsuario(datosUsuario);
    setAutenticado(true);
    setSesionPendiente(null);
  };

  const cancelarVerificacion = () => {
    setSesionPendiente(null);
  };

  // El axiosClient dispara este evento SOLO cuando el accessToken expiró
  // Y el refreshToken también resultó inválido o expirado (o cuando el
  // backend nos dice que la sesión fue cerrada por VersionToken).
  useEffect(() => {
    const manejarSesionExpirada = () => cerrarSesion();
    window.addEventListener('sesion-expirada', manejarSesionExpirada);
    return () => window.removeEventListener('sesion-expirada', manejarSesionExpirada);
  }, [cerrarSesion]);

  let contenido;
  if (autenticado) {
    contenido = <SedesDashboard usuario={usuario} onCerrarSesion={cerrarSesion} />;
  } else if (sesionPendiente) {
    contenido = (
      <TokenGate
        accessToken={sesionPendiente.accessToken}
        refreshToken={sesionPendiente.refreshToken}
        onIngresar={manejarTokenConfirmado}
        onCancelar={cancelarVerificacion}
      />
    );
  } else {
    contenido = <Login onLoginExitoso={manejarLoginExitoso} />;
  }

  return (
    <ToastProvider>
      <div className="app-shell">{contenido}</div>
    </ToastProvider>
  );
}
