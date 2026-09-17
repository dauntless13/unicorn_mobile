import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

// 1. Load Keystore Properties
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.app.unicornqatar"
    compileSdk = 36
    ndkVersion = flutter.ndkVersion

    // 2. Configure Signing
    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as? String
            keyPassword = keystoreProperties["keyPassword"] as? String
            storeFile = keystoreProperties["storeFile"]?.let { file(it as String) }
            storePassword = keystoreProperties["storePassword"] as? String
        }
    }

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.app.unicornqatar"
        minSdk = flutter.minSdkVersion
        targetSdk = 36
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // 3. Apply the signing configuration
            signingConfig = signingConfigs.getByName("release")

            isMinifyEnabled = false
            isShrinkResources = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
    implementation(platform("com.google.firebase:firebase-bom:34.9.0"))
    implementation("com.google.firebase:firebase-analytics")
}

val forbiddenMediaReadPermissions = listOf(
    "android.permission.READ_MEDIA_IMAGES",
    "android.permission.READ_MEDIA_VIDEO",
    "android.permission.READ_MEDIA_VISUAL_USER_SELECTED",
)

fun File.containsShippedMediaReadPermission(permission: String): Boolean {
    if (!exists()) return false
    val text = readText()
    val declared = Regex("""android:name="$permission"""")
    if (!declared.containsMatchIn(text)) return false
    val removed = Regex("""android:name="$permission"[^>]*tools:node="remove"""")
    return !removed.containsMatchIn(text)
}

afterEvaluate {
    android.applicationVariants.configureEach {
        val variantName = name
        val capitalized = variantName.replaceFirstChar { it.uppercase() }
        val checkTaskName = "check${capitalized}PhotoPickerPolicy"
        val processManifestTask = "process${capitalized}MainManifest"

        tasks.register(checkTaskName) {
            dependsOn(processManifestTask)
            doLast {
                val buildDir = layout.buildDirectory.get().asFile
                val candidates = listOf(
                    File(buildDir, "intermediates/merged_manifest/$variantName/process${capitalized}MainManifest/AndroidManifest.xml"),
                    File(buildDir, "intermediates/merged_manifests/$variantName/AndroidManifest.xml"),
                    File(buildDir, "intermediates/packaged_manifests/$variantName/AndroidManifest.xml"),
                    File(buildDir, "intermediates/merged_manifest/$variantName/AndroidManifest.xml"),
                )
                val manifest = candidates.firstOrNull { it.exists() }
                    ?: throw GradleException(
                        "Could not find merged AndroidManifest for $variantName. Looked in:\n" +
                            candidates.joinToString("\n") { " - $it" },
                    )
                val violations = forbiddenMediaReadPermissions.filter { permission ->
                    manifest.containsShippedMediaReadPermission(permission)
                }
                if (violations.isNotEmpty()) {
                    throw GradleException(
                        "Google Play Photo Picker policy: these permissions must not ship in the merged manifest:\n" +
                            violations.joinToString("\n") { " - $it" } +
                            "\nManifest: ${manifest.absolutePath}",
                    )
                }
            }
        }

        listOf("assemble$capitalized", "bundle$capitalized").forEach { taskName ->
            tasks.matching { it.name == taskName }.configureEach {
                dependsOn(checkTaskName)
            }
        }
    }
}
//plugins {
//    id("com.android.application")
//    id("kotlin-android")
//    id("dev.flutter.flutter-gradle-plugin")
//    id("com.google.gms.google-services")
//}
//
//android {
//    namespace = "com.app.unicornqatar"
//    compileSdk = 36
//    ndkVersion = "28.2.13676358"
//
//    compileOptions {
//        sourceCompatibility = JavaVersion.VERSION_17
//        targetCompatibility = JavaVersion.VERSION_17
//        isCoreLibraryDesugaringEnabled = true
//    }
//
//    kotlinOptions {
//        jvmTarget = JavaVersion.VERSION_17.toString()
//    }
//
//    defaultConfig {
//        applicationId = "com.app.unicornqatar"
//        minSdk = 24
//        targetSdk = 36
//        versionCode = 3
//        versionName = "1.0.3"
//        multiDexEnabled = true
//    }
//
//    buildTypes {
//        release {
//
//            isMinifyEnabled = true
//            isShrinkResources = true
//
//            proguardFiles(
//                getDefaultProguardFile("proguard-android-optimize.txt"),
//                file("proguard-rules.pro")
//            )
//
//            // TEMPORARY FIX
//            // Uses debug signing for release builds
//            // Good for testing APK only
//            signingConfig = signingConfigs.getByName("debug")
//        }
//    }
//}
//
//flutter {
//    source = "../.."
//}
//
//dependencies {
//
//    implementation(platform("com.google.firebase:firebase-bom:34.9.0"))
//    implementation("com.google.firebase:firebase-analytics")
//
//    implementation("com.android.support:multidex:1.0.3")
//
//    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
//}