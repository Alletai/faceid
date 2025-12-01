import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:camera/camera.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import '../../../../services/websocket_service.dart';
import '../../../../theme/app_theme.dart';
import '../../../../widgets/k_spacers.dart';

/// Painel de câmera - VERSÃO COM WIDGETS (mais confiável que CustomPaint na Web)
class CameraPanel extends StatefulWidget {
  final String cameraName;
  final bool isLive;
  final int fps;

  const CameraPanel({
    super.key,
    required this.cameraName,
    required this.isLive,
    required this.fps,
  });

  @override
  State<CameraPanel> createState() => _CameraPanelState();
}

class _CameraPanelState extends State<CameraPanel> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  bool _isConnecting = false;
  RecognitionResult? _lastResult;
  String _statusMessage = 'Inicializando...';
  int _frameCount = 0;
  
  final WebSocketService _wsService = WebSocketService.instance;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _listenToResults();
  }

  @override
  void dispose() {
    _disposeCamera();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    try {
      setState(() {
        _statusMessage = 'Procurando câmeras...';
        _isConnecting = true;
      });

      _cameras = await availableCameras();
      
      if (_cameras == null || _cameras!.isEmpty) {
        setState(() {
          _statusMessage = 'Nenhuma câmera encontrada';
          _isConnecting = false;
        });
        return;
      }

      CameraDescription camera;
      if (kIsWeb) {
        camera = _cameras!.first;
      } else {
        camera = _cameras!.firstWhere(
          (cam) => cam.lensDirection == CameraLensDirection.back,
          orElse: () => _cameras!.first,
        );
      }

      _cameraController = CameraController(
        camera,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: kIsWeb ? null : ImageFormatGroup.yuv420,
      );

      await _cameraController!.initialize();

      setState(() {
        _isCameraInitialized = true;
        _statusMessage = 'Conectando...';
      });

      await _wsService.connect();
      _wsService.startCameraStream(_cameraController!);

      setState(() {
        _isConnecting = false;
        _statusMessage = 'Ao vivo';
      });

    } catch (e) {
      print('[Camera] Erro: $e');
      setState(() {
        _statusMessage = 'Erro: $e';
        _isConnecting = false;
      });
    }
  }

  void _listenToResults() {
    _wsService.resultsStream.listen((data) {
      if (mounted) {
        final result = RecognitionResult.fromJson(data);
        
        if (result.faces.isNotEmpty) {
          print('>>> RECEBIDO: ${result.faces.length} faces');
          for (var f in result.faces) {
            print('   ${f.name}: ${f.bbox}');
          }
        }
        
        setState(() {
          _lastResult = result;
          _frameCount++;
        });
      }
    });
  }

  Future<void> _disposeCamera() async {
    _wsService.stopCameraStream();
    await _cameraController?.dispose();
  }

  Future<void> _reconnect() async {
    await _disposeCamera();
    setState(() {
      _isCameraInitialized = false;
      _lastResult = null;
      _frameCount = 0;
    });
    await _initializeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardBackground(context),
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(
          color: widget.isLive ? AppTheme.successGreen : Colors.grey,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(context),
          AspectRatio(
            aspectRatio: 4 / 3,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(AppTheme.radiusMedium - 2),
              ),
              child: _buildCameraView(),
            ),
          ),
          if (_lastResult != null) _buildRecognitionInfo(),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: KPadding.a16,
      decoration: BoxDecoration(
        color: AppTheme.surfaceMuted(context).withOpacity(
          Theme.of(context).brightness == Brightness.dark ? 0.6 : 0.9,
        ),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppTheme.radiusMedium - 2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            BootstrapIcons.camera_video,
            color: widget.isLive ? AppTheme.successGreen : Colors.grey,
          ),
          KSpacer.h8,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.cameraName, style: Theme.of(context).textTheme.titleMedium),
                KSpacer.v4,
                Row(
                  children: [
                    _buildStatusBadge(context),
                    KSpacer.h8,
                    Text('${widget.fps} FPS', style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(BootstrapIcons.arrow_clockwise, color: _isConnecting ? Colors.grey : AppTheme.successGreen),
            onPressed: _isConnecting ? null : _reconnect,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    final Color color = _isConnecting ? Colors.orange : (_wsService.isConnected ? AppTheme.successGreen : Colors.red);
    final String text = _isConnecting ? 'Conectando' : (_wsService.isConnected ? 'Ao Vivo' : 'Offline');
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 6, height: 6, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          KSpacer.h4,
          Text(text, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  /// View da câmera - USA WIDGETS para os quadrados
  Widget _buildCameraView() {
    if (!_isCameraInitialized || _cameraController == null) {
      return Container(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isConnecting) const CircularProgressIndicator(color: AppTheme.successGreen),
              KSpacer.v16,
              Text(_statusMessage, style: const TextStyle(color: Colors.white)),
            ],
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final viewWidth = constraints.maxWidth;
        final viewHeight = constraints.maxHeight;
        
        // Dimensões da imagem enviada pelo WebSocket
        final sourceWidth = _wsService.sendWidth.toDouble();
        final sourceHeight = _wsService.sendHeight.toDouble();
        
        // Fatores de escala
        final scaleX = viewWidth / sourceWidth;
        final scaleY = viewHeight / sourceHeight;

        return Container(
          color: Colors.black,
          child: Stack(
            children: [
              // 1. Câmera
              Positioned.fill(
                child: CameraPreview(_cameraController!),
              ),
              
              // 2. Quadrados das faces - USANDO WIDGETS
              if (_lastResult != null)
                ..._lastResult!.faces.map((face) {
                  return _buildFaceBox(face, scaleX, scaleY);
                }),
              
              // 3. Quadrados das pessoas (YOLO)
              if (_lastResult != null)
                ..._lastResult!.persons.map((person) {
                  return _buildPersonBox(person, scaleX, scaleY);
                }),
              
              // 4. Info no canto
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Frame: $_frameCount', style: const TextStyle(color: Colors.white70, fontSize: 10)),
                      if (_lastResult != null && _lastResult!.faces.isNotEmpty)
                        Text(
                          '${_lastResult!.faces.length} face(s)',
                          style: const TextStyle(color: Colors.greenAccent, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Widget para caixa de face - MUITO MAIS CONFIÁVEL que CustomPaint
  Widget _buildFaceBox(Face face, double scaleX, double scaleY) {
    final Color color = face.isStudent ? Colors.green : Colors.red;
    
    // Converte coordenadas
    final double left = face.bbox[0] * scaleX;
    final double top = face.bbox[1] * scaleY;
    final double width = (face.bbox[2] - face.bbox[0]) * scaleX;
    final double height = (face.bbox[3] - face.bbox[1]) * scaleY;
    
    print('[BOX] ${face.name}: left=$left, top=$top, w=$width, h=$height');
    
    return Positioned(
      left: left,
      top: top,
      width: width,
      height: height,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: color, width: 3),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Label acima da caixa
            Positioned(
              left: -1,
              top: -24,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  face.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Widget para caixa de pessoa (YOLO)
  Widget _buildPersonBox(Person person, double scaleX, double scaleY) {
    final double left = person.bbox[0] * scaleX;
    final double top = person.bbox[1] * scaleY;
    final double width = (person.bbox[2] - person.bbox[0]) * scaleX;
    final double height = (person.bbox[3] - person.bbox[1]) * scaleY;
    
    return Positioned(
      left: left,
      top: top,
      width: width,
      height: height,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.cyan, width: 2),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildRecognitionInfo() {
    final faces = _lastResult?.faces ?? [];
    final students = faces.where((f) => f.isStudent).toList();
    final unknowns = faces.where((f) => !f.isStudent).toList();
    
    return Container(
      padding: KPadding.a12,
      decoration: BoxDecoration(
        color: AppTheme.surfaceMuted(context).withOpacity(
          Theme.of(context).brightness == Brightness.dark ? 0.6 : 0.95,
        ),
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(AppTheme.radiusMedium - 2),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildInfoChip(BootstrapIcons.person_check, 'Alunos', students.length.toString(), Colors.green),
              _buildInfoChip(BootstrapIcons.person_x, 'Desconhecidos', unknowns.length.toString(), unknowns.isNotEmpty ? Colors.red : Colors.grey),
              _buildInfoChip(BootstrapIcons.people, 'Pessoas', (_lastResult?.persons.length ?? 0).toString(), Colors.cyan),
            ],
          ),
          if (faces.isNotEmpty) ...[
            KSpacer.v8,
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: faces.map((f) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: f.isStudent ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: f.isStudent ? Colors.green : Colors.red),
                ),
                child: Text(
                  f.name,
                  style: TextStyle(fontSize: 11, color: f.isStudent ? Colors.green : Colors.red, fontWeight: FontWeight.bold),
                ),
              )).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, String value, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        KSpacer.v4,
        Text(value, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16)),
         Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
