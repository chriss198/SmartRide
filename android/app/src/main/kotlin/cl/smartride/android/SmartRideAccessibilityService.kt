package cl.smartride.android

import android.accessibilityservice.AccessibilityService
import android.view.accessibility.AccessibilityEvent
import android.view.accessibility.AccessibilityNodeInfo
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel

class SmartRideAccessibilityService : AccessibilityService() {

    companion object {
        var bridgeMessenger: BinaryMessenger? = null
    }

    private val uberPackage = "com.ubercab"

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        if (event?.packageName?.toString() != uberPackage) return

        val root = rootInActiveWindow ?: return
        val texts = mutableListOf<String>()
        collectTexts(root, texts)

        val fare = findCurrency(texts)
        val distance = findDistance(texts)
        val destination = findDestination(texts)

        if (fare <= 0 || distance <= 0 || destination.isBlank()) return

        bridgeMessenger?.let {
            MethodChannel(it, "cl.smartride/bridge").invokeMethod(
                "onUberOffer",
                mapOf(
                    "fare" to fare,
                    "distance" to distance,
                    "destination_text" to destination,
                    "duration_min" to 30,
                    "tolls" to 0
                )
            )
        }
    }

    override fun onInterrupt() = Unit

    private fun collectTexts(node: AccessibilityNodeInfo, target: MutableList<String>) {
        node.text?.toString()?.let(target::add)
        for (i in 0 until node.childCount) {
            node.getChild(i)?.let { collectTexts(it, target) }
        }
    }

    private fun findCurrency(texts: List<String>): Double {
        val currencyRegex = Regex("""\$\s?([0-9\.,]+)""")
        return texts.firstNotNullOfOrNull { value ->
            currencyRegex.find(value)?.groupValues?.get(1)?.replace(".", "")?.replace(",", ".")?.toDoubleOrNull()
        } ?: 0.0
    }

    private fun findDistance(texts: List<String>): Double {
        val distanceRegex = Regex("""([0-9]+([\.,][0-9]+)?)\s?km""", RegexOption.IGNORE_CASE)
        return texts.firstNotNullOfOrNull { value ->
            distanceRegex.find(value)?.groupValues?.get(1)?.replace(",", ".")?.toDoubleOrNull()
        } ?: 0.0
    }

    private fun findDestination(texts: List<String>): String {
        return texts.firstOrNull { value ->
            value.length > 6 &&
                !value.contains("km", ignoreCase = true) &&
                !value.contains("$")
        } ?: ""
    }
}
