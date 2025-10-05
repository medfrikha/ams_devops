# ----------------------------
# Étape 1 : build Maven
# ----------------------------
FROM maven:3.9.2-eclipse-temurin-17 AS build

# Définir le dossier de travail
WORKDIR /app

# Copier les fichiers pom.xml et sources
COPY pom.xml .
COPY src ./src

# Build de l'application et création du JAR
RUN mvn clean package -DskipTests

# ----------------------------
# Étape 2 : image runtime
# ----------------------------
FROM openjdk:17-jdk-slim

# Dossier de travail
WORKDIR /app

# Copier le JAR depuis l'étape build
COPY --from=build /app/target/ams_devops-0.0.1-SNAPSHOT.jar app.jar

# Exposer le port
EXPOSE 8080

# Lancer l'application
ENTRYPOINT ["java", "-jar", "app.jar"]