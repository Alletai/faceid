## Objetivo
Corrigir o posicionamento e atualização das bounding boxes para que acompanhem múltiplos rostos em tempo real, com mapeamento correto de coordenadas entre `main.py` (YOLOv8) e `teste_websocket.html` (Canvas/DOM), sem alterações no modelo `yolov8n.pt`.

## Diagnóstico (o que verificar)
- Formato das coordenadas enviadas pelo Python: YOLOv8 pode retornar `xyxy` (pixels) ou `xywh` (centro, largura, altura), possivelmente normalizadas (0–1).
- Tamanho do frame original enviado (ex.: `frame_w`, `frame_h`). Sem isso, o front não consegue escalar corretamente.
- Frequência de envio das detecções e sincronização com o frame de vídeo exibido no HTML.
- Estratégia de desenho no front: se for via elementos `div` posicionados com CSS, há risco de default em `(0,0)`; preferir `canvas` overlay.
- Limpeza do overlay a cada frame (caso contrário, caixas “fantasmas” ou congeladas).

## Correções no Python (`main.py`)
1. Padronizar payload de detecção por frame:
   - Incluir `frame_id`, `timestamp`, `frame_w`, `frame_h`.
   - Enviar lista `detections` com caixas em pixels no formato `xywh` (top-left `x,y`, `w,h`) e `conf`, `class`.
2. Conversão consistente de coordenadas:
   - Se YOLO retorna `boxes.xyxy` (pixels), converter para `xywh` em pixels.
   - Se retorna normalizado, multiplicar por `frame_w`/`frame_h` para obter pixels antes de enviar.
3. Multiplicidade de detecções:
   - Garantir que o loop acumule TODAS as detecções por frame e envie como uma única mensagem JSON.
4. Tratamento de erros:
   - `try/except` envolvendo captura de frame, inferência e envio. Em falha, enviar `detections: []` e manter o servidor estável.
5. Controle de taxa:
   - Opcional: limitar FPS de inferência (ex.: processar 15–30 FPS) e pular frames se necessário.

Payload sugerido (exemplo):
```
{
  "frame_id": 123,
  "timestamp": 1731600000,
  "frame_w": 1280,
  "frame_h": 720,
  "detections": [
    {"x": 420, "y": 200, "w": 180, "h": 180, "class": "face", "conf": 0.92},
    {"x": 800, "y": 220, "w": 160, "h": 160, "class": "face", "conf": 0.88}
  ]
}
```

## Correções no Front-end (`teste_websocket.html`)
1. Canvas overlay sincronizado com o vídeo:
   - Criar `canvas` com mesmo tamanho visual do elemento de vídeo.
   - Atualizar `canvas.width/height` conforme `clientWidth/clientHeight` do vídeo.
2. Mapeamento de coordenadas:
   - Calcular fatores `sx = canvas.width / frame_w` e `sy = canvas.height / frame_h` vindos do payload.
   - Desenhar cada caixa com `ctx.strokeRect(sx*x, sy*y, sx*w, sy*h)` e rótulos.
3. Fluxo por mensagem:
   - Em `onmessage`, limpar o canvas e desenhar TODAS as detecções recebidas.
   - Usar `requestAnimationFrame` para evitar travamentos e garantir que o desenho siga a taxa de renderização do navegador.
4. Robustez:
   - Se `detections` vier vazio, apenas limpar o overlay.
   - Tratar reconexão do WebSocket, erros e timeouts.

Pseudo-código JS para desenho:
```
ws.onmessage = (e) => {
  const msg = JSON.parse(e.data);
  const { frame_w, frame_h, detections } = msg;
  resizeCanvasToVideo(video, canvas); // garante canvas.size
  const sx = canvas.width / frame_w;
  const sy = canvas.height / frame_h;
  const ctx = canvas.getContext('2d');
  ctx.clearRect(0, 0, canvas.width, canvas.height);
  for (const d of detections) {
    ctx.strokeStyle = '#00FF00';
    ctx.lineWidth = 2;
    ctx.strokeRect(sx*d.x, sy*d.y, sx*d.w, sy*d.h);
    ctx.fillStyle = 'rgba(0,255,0,0.2)';
    ctx.fillRect(sx*d.x, sy*d.y, sx*d.w, sy*d.h);
  }
};
```

## Melhorias de Robustez
- Enviar heartbeat/ping do servidor para cliente detectar quedas e reconectar.
- Validar payload no front e ignorar mensagens malformadas.
- Logar erros no Python com níveis e contadores; proteger contra estourar memória.

## Otimizações de Desempenho
- Reduzir `imgsz` do YOLO para equilibrar precisão/performance.
- Utilizar GPU se disponível (`device='cuda'`) e `half=True`.
- Evitar enviar frames binários via WebSocket; enviar apenas metadados das caixas.
- Debounce/redutora de taxa de envio se o browser ficar sobrecarregado.

## Testes e Validação
- Iluminação: testar ambientes claros, escuros e contra-luz; validar estabilidade das caixas.
- Múltiplos rostos: 1, 2, 3+ pessoas; verificar sobreposição e fidelidade.
- Navegadores: Chrome, Firefox, Edge; dispositivos desktop e mobile.
- Medir FPS, latência e taxa de detecção; ajustar parâmetros conforme necessidade.

## Entregáveis
- Ajustes em `main.py` para payload consistente de detecções (pixels + dimensões do frame).
- Atualização de `teste_websocket.html` para canvas overlay e mapeamento correto.
- Tratamento de erros e pequenas otimizações de desempenho.
- Pequena documentação inline nos pontos críticos (formato do payload e escala), para evitar regressões.

## Próximos Passos
Após sua confirmação, aplico as mudanças nos arquivos, executo testes locais e forneço um relatório de validação com cenários, métricas e eventuais ajustes de parâmetros.