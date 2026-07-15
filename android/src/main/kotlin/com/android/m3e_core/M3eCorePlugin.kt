package com.android.m3e_core

import android.annotation.TargetApi
import android.content.Context
import android.os.Build
import android.os.VibrationEffect
import android.os.Vibrator
import android.os.VibratorManager
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class M3eCorePlugin: FlutterPlugin, MethodCallHandler {
    private lateinit var channel : MethodChannel
    private var vibrator: Vibrator? = null

    // Cache capability support values
    private var supportsLowTick: Boolean? = null
    private var supportsTick: Boolean? = null
    private var supportsClick: Boolean? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        vibrator = getVibrator(flutterPluginBinding.applicationContext)
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "m3e_haptics/haptics")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        if (call.method == "vibrate") {
            val type = call.argument<String>("type") ?: ""
            val amplitudeDouble = call.argument<Double>("amplitude") ?: 0.5
            val amplitude = amplitudeDouble.toFloat().coerceIn(0f, 1f)

            val vib = vibrator
            if (vib != null && vib.hasVibrator()) {
                vibrate(vib, type, amplitude)
            }
            result.success(null)
        } else {
            result.notImplemented()
        }
    }

    private fun getVibrator(ctx: Context): Vibrator? {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            val vibratorManager = ctx.getSystemService(Context.VIBRATOR_MANAGER_SERVICE) as? VibratorManager
            vibratorManager?.defaultVibrator
        } else {
            @Suppress("DEPRECATION")
            ctx.getSystemService(Context.VIBRATOR_SERVICE) as? Vibrator
        }
    }

    private fun vibrate(vib: Vibrator, type: String, amplitude: Float) {
        when {
            Build.VERSION.SDK_INT >= Build.VERSION_CODES.R -> vibrateWithComposition(vib, type, amplitude)
            Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q -> vibrateWithPredefined(vib, type)
            Build.VERSION.SDK_INT >= Build.VERSION_CODES.O -> vibrateWithOneShot(vib, type, amplitude)
            else -> vibrateLegacy(vib, type)
        }
    }

    @TargetApi(Build.VERSION_CODES.R)
    private fun vibrateWithComposition(vib: Vibrator, type: String, amplitude: Float) {
        cacheCompositionSupport(vib)
        try {
            val effect: VibrationEffect = when (type) {
                "dragTexture" -> {
                    if (supportsLowTick == true) {
                        VibrationEffect.startComposition()
                            .addPrimitive(
                                VibrationEffect.Composition.PRIMITIVE_LOW_TICK,
                                amplitude,
                            )
                            .compose()
                    } else {
                        VibrationEffect.createPredefined(VibrationEffect.EFFECT_TICK)
                    }
                }

                "bookendLower", "bookendUpper" -> {
                    if (supportsClick == true) {
                        VibrationEffect.startComposition()
                            .addPrimitive(
                                VibrationEffect.Composition.PRIMITIVE_CLICK,
                                amplitude,
                            )
                            .compose()
                    } else {
                        VibrationEffect.createPredefined(VibrationEffect.EFFECT_CLICK)
                    }
                }

                "tickCrossing" -> {
                    if (supportsTick == true) {
                        VibrationEffect.startComposition()
                            .addPrimitive(
                                VibrationEffect.Composition.PRIMITIVE_TICK,
                                amplitude,
                            )
                            .compose()
                    } else {
                        VibrationEffect.createPredefined(VibrationEffect.EFFECT_CLICK)
                    }
                }

                else -> VibrationEffect.createPredefined(VibrationEffect.EFFECT_CLICK)
            }
            vib.vibrate(effect)
        } catch (t: Throwable) {
            vibrateWithPredefined(vib, type)
        }
    }

    @TargetApi(Build.VERSION_CODES.Q)
    private fun vibrateWithPredefined(vib: Vibrator, type: String) {
        val effectId = when (type) {
            "dragTexture" -> VibrationEffect.EFFECT_TICK
            "bookendLower", "bookendUpper", "tickCrossing" -> VibrationEffect.EFFECT_CLICK
            else -> VibrationEffect.EFFECT_CLICK
        }
        try {
            vib.vibrate(VibrationEffect.createPredefined(effectId))
        } catch (t: Throwable) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                vibrateWithOneShot(vib, type, 0.5f)
            } else {
                vibrateLegacy(vib, type)
            }
        }
    }

    @TargetApi(Build.VERSION_CODES.O)
    private fun vibrateWithOneShot(vib: Vibrator, type: String, amplitude: Float) {
        val durationMs = durationForType(type)
        val amplitudeValue = (amplitude * 255).toInt().coerceIn(1, 255)
        vib.vibrate(VibrationEffect.createOneShot(durationMs, amplitudeValue))
    }

    @Suppress("DEPRECATION")
    private fun vibrateLegacy(vib: Vibrator, type: String) {
        vib.vibrate(durationForType(type))
    }

    private fun durationForType(type: String): Long {
        return when (type) {
            "dragTexture" -> 8L
            "bookendLower", "bookendUpper", "tickCrossing" -> 15L
            else -> 10L
        }
    }

    @TargetApi(Build.VERSION_CODES.R)
    private fun cacheCompositionSupport(vib: Vibrator) {
        if (supportsLowTick != null) return
        supportsLowTick = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            vib.areAllPrimitivesSupported(VibrationEffect.Composition.PRIMITIVE_LOW_TICK)
        } else {
            false
        }
        supportsTick = vib.areAllPrimitivesSupported(VibrationEffect.Composition.PRIMITIVE_TICK)
        supportsClick = vib.areAllPrimitivesSupported(VibrationEffect.Composition.PRIMITIVE_CLICK)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        vibrator = null
        supportsLowTick = null
        supportsTick = null
        supportsClick = null
    }
}
