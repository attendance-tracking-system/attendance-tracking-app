# Keep Google Error Prone annotations
-dontwarn com.google.errorprone.annotations.**
-keep class com.google.errorprone.annotations.** { *; }

# Keep Javax annotations
-dontwarn javax.annotation.**
-keep class javax.annotation.** { *; }

# Keep Tink crypto library classes
-keep class com.google.crypto.tink.** { *; }
-keepclassmembers class com.google.crypto.tink.** { *; }

# Keep any classes referenced by Tink
-keep class com.google.crypto.tink.proto.** { *; }
-keep class com.google.crypto.tink.aead.** { *; }
-keep class com.google.crypto.tink.KeysetManager { *; }
-keep class com.google.crypto.tink.InsecureSecretKeyAccess { *; }

# Keep metadata for reflection
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes Exceptions



-dontwarn com.google.api.client.http.GenericUrl
-dontwarn com.google.api.client.http.HttpHeaders
-dontwarn com.google.api.client.http.HttpRequest
-dontwarn com.google.api.client.http.HttpRequestFactory
-dontwarn com.google.api.client.http.HttpResponse
-dontwarn com.google.api.client.http.HttpTransport
-dontwarn com.google.api.client.http.javanet.NetHttpTransport$Builder
-dontwarn com.google.api.client.http.javanet.NetHttpTransport
-dontwarn org.joda.time.Instant