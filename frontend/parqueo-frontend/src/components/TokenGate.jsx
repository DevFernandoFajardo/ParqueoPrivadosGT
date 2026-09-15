import { useState } from 'react';

export default function TokenGate({ accessToken, refreshToken, onIngresar, onCancelar }) {
  const [tokenIngresado, setTokenIngresado] = useState('');
  const [error, setError] = useState('');
  const [copiado, setCopiado] = useState('');

  const copiarAlPortapapeles = async (texto, campo) => {
    try {
      await navigator.clipboard.writeText(texto);
      setCopiado(campo);
      setTimeout(() => setCopiado(''), 1500);
    } catch (error) {
      // Si el navegador bloquea el portapapeles, no pasa nada: el
      // usuario puede seleccionar el texto del campo manualmente
      // (los inputs de abajo ya seleccionan todo el texto al enfocarlos).
    }
  };

  const manejarIngreso = (evento) => {
    evento.preventDefault();
    setError('');

    if (!tokenIngresado.trim()) {
      setError('Debes pegar el Access Token para continuar.');
      return;
    }

    if (tokenIngresado.trim() !== accessToken) {
      setError('El token no coincide con el que se generó. Verifica que lo copiaste completo, sin espacios de más.');
      return;
    }

    onIngresar();
  };

  return (
    <div className="login-page">
      <div className="glass-card login-card" style={{ maxWidth: 540 }}>
        <div className="login-brand">
          <div className="icon-badge">🔑</div>
          <h1>Verificación de token</h1>
          <p>Copia tu Access Token y pégalo abajo para entrar al sistema</p>
        </div>

        <div className="field-group">
          <label>Access Token</label>
          <div style={{ display: 'flex', gap: 8 }}>
            <input
              className="glass-input"
              style={{ flex: 1, fontSize: 12 }}
              type="text"
              readOnly
              value={accessToken}
              onFocus={(evento) => evento.target.select()}
            />
            <button
              type="button"
              className="btn btn-outline btn-sm"
              onClick={() => copiarAlPortapapeles(accessToken, 'access')}
            >
              {copiado === 'access' ? '✓ Copiado' : 'Copiar'}
            </button>
          </div>
        </div>

        <div className="field-group">
          <label>Refresh Token</label>
          <div style={{ display: 'flex', gap: 8 }}>
            <input
              className="glass-input"
              style={{ flex: 1, fontSize: 12 }}
              type="text"
              readOnly
              value={refreshToken}
              onFocus={(evento) => evento.target.select()}
            />
            <button
              type="button"
              className="btn btn-outline btn-sm"
              onClick={() => copiarAlPortapapeles(refreshToken, 'refresh')}
            >
              {copiado === 'refresh' ? '✓ Copiado' : 'Copiar'}
            </button>
          </div>
        </div>

        <form onSubmit={manejarIngreso}>
          <div className="field-group">
            <label htmlFor="tokenPegado">Pega aquí tu Access Token para ingresar</label>
            <input
              id="tokenPegado"
              className="glass-input"
              type="text"
              placeholder="Pega aquí el Access Token de arriba"
              value={tokenIngresado}
              onChange={(evento) => setTokenIngresado(evento.target.value)}
            />
          </div>

          {error && <div className="error-banner" style={{ marginTop: 4, marginBottom: 4 }}>{error}</div>}

          <button className="btn btn-primary" type="submit" style={{ width: '100%', marginTop: 8 }}>
            Entrar al sistema
          </button>
          <button
            type="button"
            className="btn btn-outline"
            style={{ width: '100%', marginTop: 10 }}
            onClick={onCancelar}
          >
            Cancelar y volver al login
          </button>
        </form>
      </div>
    </div>
  );
}
