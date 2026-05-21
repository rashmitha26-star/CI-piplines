# Dockerfile for Java Spring Boot Application
# Uses pre-built JAR from CI pipeline

FROM eclipse-temurin:17-jre-alpine

# Security: Run as non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /app

# Copy the pre-built JAR file
COPY target/*.jar app.jar

# Change ownership to non-root user
RUN chown -R appuser:appgroup /app

USER appuser

# Expose port 8080 (Spring Boot default)
EXPOSE 8080

# Health check for Kubernetes/Docker
HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:8080/actuator/health || exit 1

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]

