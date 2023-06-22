#FROM openjdk:11
#ARG JAR_FILE=target/*.jar
#COPY ${JAR_FILE} app.jar
#ENTRYPOINT ["java","-jar","/app.jar"]

# Utilizo una imagen base de Maven para compilar la aplicación
FROM maven:3.8.4-openjdk-11 AS build

# Establece el directorio de trabajo dentro del contenedor
WORKDIR /app/

# Copio el archivo pom.xml y descarga las dependencias de Maven
COPY pom.xml .

RUN mvn dependency:go-offline

# Copia el resto del código fuente del proyecto al contenedor
COPY src ./src
# Compila el proyecto y omite la ejecución de las pruebas
RUN mvn clean install -DskipTests
# Utiliza una imagen base de OpenJDK 11 para ejecutar la aplicación
FROM openjdk:11
# Establece el directorio de trabajo dentro del contenedor
WORKDIR /app
# Copia el archivo JAR generado al contenedor
COPY --from=build /app/target/App-de-Prueba.jar app.jar


EXPOSE 8083

CMD ["java", "-jar", "app.jar"]

# ADD target/App-de-Prueba.jar App-de-Prueba.jar
#ENTRYPOINT [ "java", "-jar", "App-de-Prueba.jar" ]

