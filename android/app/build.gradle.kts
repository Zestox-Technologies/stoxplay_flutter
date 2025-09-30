import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

// Load keystore properties (if present)
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
} else {
    println("⚠️  key.properties not found at ${keystorePropertiesFile.path}. Release signing will fail unless you add it.")
}

android {
    namespace = "com.zestox.stoxbook"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "29.0.13113456 rc1"

    defaultConfig {
        applicationId = "com.zestox.stoxbook"
        minSdk = 23
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    signingConfigs {
        // Kotlin DSL: use create("release") and assign with =
        create("release") {
            // Only assign if key.properties exists; otherwise leave nulls
            if (keystorePropertiesFile.exists()) {
                keyAlias = keystoreProperties["keyAlias"] as String?
                keyPassword = keystoreProperties["keyPassword"] as String?
                storePassword = keystoreProperties["storePassword"] as String?
                val storePath = keystoreProperties["storeFile"] as String?
                storeFile = storePath?.let { file(storePath) }
            }
        }
    }

    buildTypes {
        release {
            // Kotlin DSL: assign signingConfig via getByName
            signingConfig = signingConfigs.getByName("release")

            // Kotlin DSL uses boolean properties with isXxx
            isMinifyEnabled = true
            isShrinkResources = true

            // Use the optimized default ProGuard file with AGP 8+
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
        // (Optional) debug config if you need it:
        // debug {
        //     signingConfig = signingConfigs.getByName("debug")
        // }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Import the Firebase BoM
    implementation(platform("com.google.firebase:firebase-bom:34.2.0"))
    // Firebase Analytics (version comes from the BoM)
    implementation("com.google.firebase:firebase-analytics")
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
    // Add more Firebase libs as needed, without versions.
}
