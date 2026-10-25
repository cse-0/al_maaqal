package com.example.al_maaqal
// أبقِ سطر package الأول الموجود في ملفك كما هو ثم الصق ما يلي تحته:
import android.app.PendingIntent
import android.content.Intent
import android.nfc.NfcAdapter
import android.nfc.Tag
import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private var nfcAdapter: NfcAdapter? = null
    private var channel: MethodChannel? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        nfcAdapter = NfcAdapter.getDefaultAdapter(this)
        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "al_maaqal.edu.iq/nfc")
    }

    override fun onResume() {
        super.onResume()
        val adapter = nfcAdapter ?: return
        if (adapter.isEnabled) {
            val intent = Intent(this, javaClass).addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP)
            val flags = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) PendingIntent.FLAG_MUTABLE else 0
            val pendingIntent = PendingIntent.getActivity(this, 0, intent, flags)
            adapter.enableForegroundDispatch(this, pendingIntent, null, null)
        }
    }

    override fun onPause() {
        super.onPause()
        nfcAdapter?.disableForegroundDispatch(this)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        val tag: Tag? = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            intent.getParcelableExtra(NfcAdapter.EXTRA_TAG, Tag::class.java)
        } else {
            @Suppress("DEPRECATION")
            intent.getParcelableExtra(NfcAdapter.EXTRA_TAG)
        }
        tag?.id?.let { bytes ->
            val tagHex = bytes.joinToString(":") { "%02X".format(it) }
            channel?.invokeMethod("onNfcTagDiscovered", tagHex)
        }
    }
}