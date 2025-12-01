(() => {
  const w = typeof window !== 'undefined' ? window : undefined;
  const enabled = !!(w && w.DDC_ENABLE === true) && !(w && w.DDC_DISABLE === true);
  if (!enabled) {
    return;
  }
  const origAppendChild = Node.prototype.appendChild;
  const queue = [];
  let active = 0;
  let total = 0;
  const poolSize = window.DDC_POOL_SIZE || 1000;
  function attach(node) {
    try {
      node.async = true;
      node.addEventListener('load', onDone);
      node.addEventListener('error', onDone);
    } catch (_) {}
  }
  function onDone() {
    active = Math.max(0, active - 1);
    log();
    if (queue.length) {
      const { parent, node } = queue.shift();
      active++;
      attach(node);
      origAppendChild.call(parent, node);
    }
  }
  function log() {}
  Node.prototype.appendChild = function (node) {
    try {
      if (node && node.tagName === 'SCRIPT') {
        total++;
        if (active >= poolSize) {
          queue.push({ parent: this, node });
          return node;
        } else {
          active++;
          attach(node);
          log();
        }
      }
    } catch (_) {}
    return origAppendChild.call(this, node);
  };
  try {
    const cfgUrl = typeof window !== 'undefined' ? window.DDC_WS_URL : null;
    const disabled = typeof window !== 'undefined' ? !!window.DDC_WS_DISABLE : false;
    let attempts = 0;
    let socket = null;
    function delay() {
      const base = 500;
      const max = 10000;
      const d = Math.min(max, base * Math.pow(2, attempts));
      return d;
    }
    function connect() {
      if (disabled || !cfgUrl) return;
      attempts++;
      try {
        socket = new WebSocket(cfgUrl);
      } catch (_) {
        setTimeout(connect, delay());
        return;
      }
      if (typeof window !== 'undefined') {
        window.__DDC_MONITOR_STATE = { attempts: attempts, connected: false, url: cfgUrl };
      }
      socket.onopen = () => {
        attempts = 0;
        if (typeof window !== 'undefined') {
          window.__DDC_MONITOR_STATE = { attempts: attempts, connected: true, url: cfgUrl };
        }
      };
      socket.onerror = () => {
        try { socket.close(); } catch (_) {}
      };
      socket.onclose = () => {
        if (typeof window !== 'undefined') {
          window.__DDC_MONITOR_STATE = { attempts: attempts, connected: false, url: cfgUrl };
        }
        setTimeout(connect, delay());
      };
    }
    connect();
  } catch (_) {}
})();