import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb, compute;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;

/// Serviço WebSocket - VERSÃO HÍBRIDA (Web + Mobile)
/// 
/// Na WEB: usa takePicture() com Timer (única opção disponível)
/// No MOBILE: usa startImageStream() (mais rápido)
class WebSocketService {
  static WebSocketService? _instance;
  WebSocketChannel? _channel;
  StreamController<Map<String, dynamic>>? _resultController;
  Timer? _pingTimer;
  Timer? _frameTimer;
  CameraController? _cameraController;
  bool _isProcessing = false;
  bool _isConnected = false;
  bool _isReconnecting = false;
  bool _isStreaming = false;
  
  final int _sendWidth = 640;
  final int _sendHeight = 480;
  
  int get sendWidth => _sendWidth;
  int get sendHeight => _sendHeight;
  
  // ============================================
  // ⚠️ CONFIGURAÇÃO DO SERVIDOR
  // ============================================
  // 
  // OPÇÃO 1: Mesmo computador (localhost) - para desenvolvimento web
  // static const String wsUrl = 'ws://localhost:8000/ws';
  //
  // OPÇÃO 2: Rede local Wi-Fi (use o IP do computador)
  // static const String wsUrl = 'ws://192.168.1.103:8000/ws';
  //
  // OPÇÃO 3: Hotspot do celular (IP que o computador recebe do hotspot)
  // static const String wsUrl = 'ws://192.168.43.XXX:8000/ws';
  //
  // ============================================
  
  // 🔥 ALTERE AQUI PARA O IP DO SEU SERVIDOR
  // Se estiver usando hotspot, descubra o IP com: ipconfig (Windows) ou ifconfig (Mac/Linux)
  static const String serverIp = '10.62.57.151'; // ← MUDE PARA O IP DO COMPUTADOR NO HOTSPOT
  static const int serverPort = 8000;
  static String get wsUrl => 'ws://$serverIp:$serverPort/ws';
  
  // Configurações de conexão
  static const int pingIntervalSeconds = 5;
  static const int reconnectDelayMs = 3000;
  static const int frameIntervalMs = 100; // ~10 FPS
  static const int connectionTimeoutSeconds = 10; // Timeout maior para mobile
  
  static WebSocketService get instance {
    _instance ??= WebSocketService._();
    return _instance!;
  }
  
  WebSocketService._();
  
  Stream<Map<String, dynamic>> get resultsStream => 
      _resultController?.stream ?? const Stream.empty();
  
  bool get isConnected => _isConnected;
  String get currentServerUrl => wsUrl;
  
  Future<void> connect() async {
    if (_isReconnecting || _isConnected) return;
    
    _isReconnecting = true;
    
    try {
      await _cleanupConnection();
      
      if (_resultController == null || _resultController!.isClosed) {
        _resultController = StreamController<Map<String, dynamic>>.broadcast();
      }
      
      print('[WS] ════════════════════════════════════════');
      print('[WS] Conectando a $wsUrl');
      print('[WS] Plataforma: ${kIsWeb ? "WEB" : "MOBILE"}');
      print('[WS] ════════════════════════════════════════');
      
      _channel = WebSocketChannel.connect(Uri.parse(wsUrl));
      
      // Timeout maior para conexões mobile
      await _channel!.ready.timeout(
        const Duration(seconds: connectionTimeoutSeconds),
        onTimeout: () {
          throw TimeoutException(
            'Não foi possível conectar ao servidor em $connectionTimeoutSeconds segundos.\n'
            'Verifique:\n'
            '1. O servidor Python está rodando?\n'
            '2. O IP está correto? ($serverIp)\n'
            '3. Computador e celular estão na mesma rede?'
          );
        },
      );
      
      _isConnected = true;
      _isReconnecting = false;
      print('[WS] ✅ Conectado com sucesso!');
      
      _startPingTimer();
      
      _channel!.stream.listen(
        _handleMessage,
        onError: (e) {
          print('[WS] ❌ Erro no stream: $e');
          _handleDisconnection();
        },
        onDone: () => _handleDisconnection(),
      );
      
      if (_cameraController != null && !_isStreaming) {
        _startCapture();
      }
      
    } catch (e) {
      print('[WS] ❌ Erro ao conectar: $e');
      _isReconnecting = false;
      _isConnected = false;
      
      // Tenta reconectar após delay
      Future.delayed(const Duration(milliseconds: reconnectDelayMs), () {
        if (_cameraController != null && !_isConnected) {
          print('[WS] 🔄 Tentando reconectar...');
          connect();
        }
      });
    }
  }
  
  void _handleMessage(dynamic message) {
    if (message == 'pong') return;
    
    try {
      final data = json.decode(message);
      _resultController?.add(data);
      
      final faces = data['faces'] as List?;
      if (faces != null && faces.isNotEmpty) {
        print('[WS] 🎯 ${faces.length} face(s) detectada(s):');
        for (var f in faces) {
          final name = f['name'];
          final confidence = f['confidence'];
          print('  → $name (${(confidence * 100).toStringAsFixed(1)}%)');
        }
      }
    } catch (e) {
      print('[WS] Erro ao processar mensagem: $e');
    }
  }
  
  Future<void> _cleanupConnection() async {
    _stopPingTimer();
    _stopCapture();
    await _channel?.sink.close();
    _channel = null;
    _isConnected = false;
  }
  
  void _handleDisconnection() {
    if (!_isConnected) return;
    _isConnected = false;
    _stopPingTimer();
    _stopCapture();
    
    print('[WS] ⚠️ Desconectado. Reconectando em ${reconnectDelayMs}ms...');
    
    Future.delayed(const Duration(milliseconds: reconnectDelayMs), () {
      if (_cameraController != null && !_isConnected) connect();
    });
  }
  
  void _startPingTimer() {
    _stopPingTimer();
    _pingTimer = Timer.periodic(const Duration(seconds: pingIntervalSeconds), (_) {
      if (_isConnected) {
        try {
          _channel?.sink.add('ping');
        } catch (_) {
          _handleDisconnection();
        }
      }
    });
  }
  
  void _stopPingTimer() {
    _pingTimer?.cancel();
    _pingTimer = null;
  }
  
  Future<void> disconnect() async {
    _stopCapture();
    _cameraController = null;
    await _cleanupConnection();
    await _resultController?.close();
    _resultController = null;
  }
  
  void startCameraStream(CameraController controller) {
    _cameraController = controller;
    
    if (!_isConnected) {
      connect().then((_) {
        if (_isConnected) _startCapture();
      });
    } else {
      _startCapture();
    }
  }
  
  void _startCapture() {
    if (_cameraController == null || 
        !_cameraController!.value.isInitialized ||
        _isStreaming) {
      return;
    }
    
    _isStreaming = true;
    
    if (kIsWeb) {
      print('[WS] 🌐 Modo WEB - usando takePicture() com Timer');
      _startWebCapture();
    } else {
      print('[WS] 📱 Modo MOBILE - usando startImageStream()');
      _startMobileCapture();
    }
  }
  
  void _startWebCapture() {
    _frameTimer = Timer.periodic(
      const Duration(milliseconds: frameIntervalMs),
      (_) => _captureWebFrame(),
    );
    print('[WS] ✅ Timer de captura web iniciado (${1000 ~/ frameIntervalMs} FPS)');
  }
  
  Future<void> _captureWebFrame() async {
    if (_isProcessing || 
        !_isConnected || 
        _channel == null ||
        _cameraController == null ||
        !_cameraController!.value.isInitialized ||
        _cameraController!.value.isTakingPicture) {
      return;
    }
    
    _isProcessing = true;
    
    try {
      final XFile imageFile = await _cameraController!.takePicture();
      final Uint8List bytes = await imageFile.readAsBytes();
      
      final String base64Image = base64Encode(bytes);
      final String dataUrl = 'data:image/jpeg;base64,$base64Image';
      
      if (_isConnected && _channel != null) {
        _channel!.sink.add(dataUrl);
      }
      
    } catch (e) {
      print('[WS] ❌ Erro ao capturar frame web: $e');
    } finally {
      _isProcessing = false;
    }
  }
  
  void _startMobileCapture() {
    try {
      _cameraController!.startImageStream((CameraImage image) {
        _processMobileFrame(image);
      });
      print('[WS] ✅ Image stream móvel iniciado');
    } catch (e) {
      print('[WS] ⚠️ startImageStream() falhou, usando fallback web: $e');
      _startWebCapture();
    }
  }
  
  DateTime _lastFrameTime = DateTime.now();
  
  Future<void> _processMobileFrame(CameraImage image) async {
    final now = DateTime.now();
    if (now.difference(_lastFrameTime).inMilliseconds < frameIntervalMs) return;
    if (_isProcessing || !_isConnected) return;
    
    _isProcessing = true;
    _lastFrameTime = now;
    
    try {
      final params = ImageParams(
        width: image.width,
        height: image.height,
        yBytes: Uint8List.fromList(image.planes[0].bytes),
        uBytes: Uint8List.fromList(image.planes[1].bytes),
        vBytes: Uint8List.fromList(image.planes[2].bytes),
        yRowStride: image.planes[0].bytesPerRow,
        uvRowStride: image.planes[1].bytesPerRow,
        uvPixelStride: image.planes[1].bytesPerPixel ?? 1,
        targetWidth: _sendWidth,
        targetHeight: _sendHeight,
      );
      
      final dataUrl = await compute(convertYuvToJpeg, params);
      
      if (dataUrl != null && _isConnected) {
        _channel?.sink.add(dataUrl);
      }
    } catch (e) {
      print('[WS] Erro no frame mobile: $e');
    } finally {
      _isProcessing = false;
    }
  }
  
  void _stopCapture() {
    _frameTimer?.cancel();
    _frameTimer = null;
    
    if (!kIsWeb && _cameraController?.value.isInitialized == true && _isStreaming) {
      try {
        _cameraController!.stopImageStream();
      } catch (_) {}
    }
    
    _isStreaming = false;
  }
  
  void stopCameraStream() {
    _stopCapture();
    _cameraController = null;
  }
  
  Map<String, dynamic> getStatus() => {
    'connected': _isConnected,
    'streaming': _isStreaming,
    'platform': kIsWeb ? 'web' : 'mobile',
    'serverUrl': wsUrl,
    'size': '${_sendWidth}x$_sendHeight',
  };
}

// ============================================
// Funções para conversão YUV (mobile only)
// ============================================

class ImageParams {
  final int width, height;
  final Uint8List yBytes, uBytes, vBytes;
  final int yRowStride, uvRowStride, uvPixelStride;
  final int targetWidth, targetHeight;
  
  ImageParams({
    required this.width,
    required this.height,
    required this.yBytes,
    required this.uBytes,
    required this.vBytes,
    required this.yRowStride,
    required this.uvRowStride,
    required this.uvPixelStride,
    required this.targetWidth,
    required this.targetHeight,
  });
}

String? convertYuvToJpeg(ImageParams p) {
  try {
    final rgbImage = img.Image(width: p.width, height: p.height);
    
    for (int y = 0; y < p.height; y++) {
      for (int x = 0; x < p.width; x++) {
        final yIdx = y * p.yRowStride + x;
        final uvIdx = (y ~/ 2) * p.uvRowStride + (x ~/ 2) * p.uvPixelStride;
        
        if (yIdx >= p.yBytes.length || uvIdx >= p.uBytes.length) continue;
        
        final yVal = p.yBytes[yIdx];
        final uVal = p.uBytes[uvIdx];
        final vVal = p.vBytes[uvIdx];
        
        final r = (yVal + 1.402 * (vVal - 128)).round().clamp(0, 255);
        final g = (yVal - 0.344 * (uVal - 128) - 0.714 * (vVal - 128)).round().clamp(0, 255);
        final b = (yVal + 1.772 * (uVal - 128)).round().clamp(0, 255);
        
        rgbImage.setPixelRgb(x, y, r, g, b);
      }
    }
    
    final resized = img.copyResize(rgbImage, width: p.targetWidth, height: p.targetHeight);
    final jpeg = img.encodeJpg(resized, quality: 70);
    
    return 'data:image/jpeg;base64,${base64Encode(jpeg)}';
  } catch (e) {
    return null;
  }
}

// ============================================
// MODELOS
// ============================================

class RecognitionResult {
  final List<Face> faces;
  final List<Person> persons;
  
  RecognitionResult({required this.faces, required this.persons});
  
  factory RecognitionResult.fromJson(Map<String, dynamic> json) => RecognitionResult(
    faces: (json['faces'] as List?)?.map((f) => Face.fromJson(f)).toList() ?? [],
    persons: (json['persons'] as List?)?.map((p) => Person.fromJson(p)).toList() ?? [],
  );
}

class Face {
  final String name;
  final List<int> bbox;
  final double confidence;
  
  Face({required this.name, required this.bbox, required this.confidence});
  
  factory Face.fromJson(Map<String, dynamic> json) => Face(
    name: json['name'] ?? 'Desconhecido',
    bbox: List<int>.from(json['bbox'] ?? [0, 0, 0, 0]),
    confidence: (json['confidence'] ?? 0.0).toDouble(),
  );
  
  bool get isStudent => name != 'NAO ALUNO' && name != 'Desconhecido';
}

class Person {
  final List<int> bbox;
  final double confidence;
  
  Person({required this.bbox, required this.confidence});
  
  factory Person.fromJson(Map<String, dynamic> json) => Person(
    bbox: List<int>.from(json['bbox'] ?? [0, 0, 0, 0]),
    confidence: (json['confidence'] ?? 0.0).toDouble(),
  );
}