# ============================================
# STAGE 1: Build — Compilar con Gradle
# ============================================
FROM gradle:8.8-jdk21 AS build

# Directorio de trabajo dentro del contenedor
WORKDIR /app

# Copiar todo el código fuente al contenedor
COPY . .

# Dar permisos de ejecución al wrapper de Gradle
RUN chmod +x gradlew

# Eliminar gradle.properties (contiene ruta local de JDK de Windows)
RUN rm -f gradle.properties

# Generar el archivo .war (sin ejecutar tests)
RUN ./gradlew bootWar -x test

# ============================================
# STAGE 2: Run — Ejecutar con OpenJDK
# ============================================
FROM openjdk:21-jdk-slim

# Directorio de trabajo
WORKDIR /app

# Copiar el .war generado del stage anterior
COPY --from=build /app/build/libs/discografia-1.war app.war

# Exponer el puerto 8080 (puerto por defecto de Spring Boot)
EXPOSE 8080

# Comando para ejecutar la aplicación
ENTRYPOINT ["java", "-jar", "app.war"]
