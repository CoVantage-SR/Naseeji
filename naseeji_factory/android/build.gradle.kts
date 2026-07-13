allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
    
    project.afterEvaluate {
        val android = project.extensions.findByName("android")
        if (android != null) {
            try {
                val setCompileSdk = android.javaClass.getMethod("setCompileSdk", java.lang.Integer::class.java)
                setCompileSdk.invoke(android, 36)
            } catch (e: Exception) {
                try {
                    val setCompileSdk = android.javaClass.getMethod("setCompileSdk", Int::class.java)
                    setCompileSdk.invoke(android, 36)
                } catch (e2: Exception) {
                    try {
                        val compileSdkVersion = android.javaClass.getMethod("compileSdkVersion", Int::class.java)
                        compileSdkVersion.invoke(android, 36)
                    } catch (e3: Exception) {
                        // Ignore
                    }
                }
            }

            try {
                val getNamespace = android.javaClass.getMethod("getNamespace")
                val setNamespace = android.javaClass.getMethod("setNamespace", String::class.java)
                if (getNamespace.invoke(android) == null) {
                    val packageName = "dev.isar.${project.name.replace("_", "").replace("-", "")}"
                    setNamespace.invoke(android, packageName)
                }
            } catch (e: Exception) {
                // Ignore
            }

            try {
                val manifestFile = project.file("src/main/AndroidManifest.xml")
                if (manifestFile.exists()) {
                    val content = manifestFile.readText()
                    if (content.contains("package=")) {
                        manifestFile.setWritable(true)
                        val cleanedContent = content.replace(Regex("""package="[^"]*""""), "")
                        manifestFile.writeText(cleanedContent)
                    }
                }
            } catch (e: Exception) {
                // Ignore
            }
        }
    }
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
