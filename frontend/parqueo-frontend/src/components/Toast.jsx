import { createContext, useCallback, useContext, useState } from 'react';

const ToastContext = createContext(null);

export function ToastProvider({ children }) {
  const [toasts, setToasts] = useState([]);

  const mostrarToast = useCallback((mensaje, tipo = 'success') => {
    const id = Date.now() + Math.random();
    setToasts((actuales) => [...actuales, { id, mensaje, tipo }]);
    setTimeout(() => {
      setToasts((actuales) => actuales.filter((toast) => toast.id !== id));
    }, 3500);
  }, []);

  return (
    <ToastContext.Provider value={mostrarToast}>
      {children}
      <div className="toast-container">
        {toasts.map((toast) => (
          <div key={toast.id} className={`glass-card toast toast-${toast.tipo}`}>
            {toast.mensaje}
          </div>
        ))}
      </div>
    </ToastContext.Provider>
  );
}

export function useToast() {
  const contexto = useContext(ToastContext);
  if (!contexto) {
    throw new Error('useToast debe usarse dentro de un <ToastProvider>.');
  }
  return contexto;
}
