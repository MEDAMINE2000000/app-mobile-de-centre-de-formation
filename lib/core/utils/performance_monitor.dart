import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Un service simple pour mesurer et afficher les performances
/// de l'application (Démarrage, Connexion, Navigation, etc.)
class PerformanceMonitor {
  static final Map<String, Stopwatch> _stopwatches = {};

  /// Démarre une mesure de temps pour l'opération donnée.
  static void start(String operation) {
    if (_stopwatches.containsKey(operation)) {
      _stopwatches[operation]!.reset();
      _stopwatches[operation]!.start();
    } else {
      _stopwatches[operation] = Stopwatch()..start();
    }
  }

  /// Arrête la mesure et affiche le résultat immédiatement.
  static void stop(String operation, {String? customMessage}) {
    if (_stopwatches.containsKey(operation)) {
      final stopwatch = _stopwatches[operation]!;
      stopwatch.stop();
      final ms = stopwatch.elapsedMilliseconds;
      final s = ms / 1000;
      
      final title = customMessage ?? 'Temps de $operation';
      
      debugPrint('========== PERFORMANCE ==========');
      debugPrint('$title : $ms ms (${s.toStringAsFixed(2)} s)');
      debugPrint('=================================');
      
      _stopwatches.remove(operation);
    }
  }

  /// Arrête la mesure lors du rendu de la prochaine frame.
  /// Utile pour s'assurer qu'un écran est complètement rendu.
  static void stopOnNextFrame(String operation, {String? customMessage}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      stop(operation, customMessage: customMessage);
    });
  }
}
