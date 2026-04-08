FROM eclipse-temurin:17.0.6_10-jre AS layers
WORKDIR /application
COPY target/*.jar app.jar
RUN java -Djarmode=tools -jar app.jar extract --layers --destination extracted

FROM eclipse-temurin:17.0.6_10-jre
VOLUME /tmp
RUN useradd -ms /bin/bash spring-user
WORKDIR /application

# Копируем слои (порядок оптимизирован под кэш Docker)
COPY --from=layers /application/extracted/dependencies/ ./
COPY --from=layers /application/extracted/spring-boot-loader/ ./
COPY --from=layers /application/extracted/snapshot-dependencies/ ./
COPY --from=layers /application/extracted/application/ ./

# ⚠️ ВАЖНО: Создаём папку для логов и назначаем права spring-user
# Приложение пишет в logs/app.log (относительный путь → /application/logs/app.log)
# логи пишутся в контейнере и удаляются  вместе с ним
RUN mkdir -p logs && chown spring-user:spring-user logs

# ✅ Фиксим права: spring-user должен иметь доступ к рабочим файлам
RUN chown -R spring-user:spring-user /application

USER spring-user

# ✅ Генерация CDS архива синхронно (убрано "& exit 0")
# Примечание: -Dspring.context.exit=onRefresh работает начиная с Spring Boot 3.2
RUN java -XX:ArchiveClassesAtExit=app.jsa -Dspring.context.exit=onRefresh -jar app.jar

ENV JAVA_CDS_OPTS="-XX:SharedArchiveFile=app.jsa -Xlog:class+load:file=/tmp/classload.log"
ENV JAVA_ERROR_FILE_OPTS="-XX:ErrorFile=/tmp/java_error.log"
ENV JAVA_HEAP_DUMP_OPTS="-XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/tmp"
ENV JAVA_ON_OUT_OF_MEMORY_OPTS="-XX:+ExitOnOutOfMemoryError"
ENV JAVA_NATIVE_MEMORY_TRACKING_OPTS="-XX:NativeMemoryTracking=summary -XX:+UnlockDiagnosticVMOptions -XX:+PrintNMTStatistics"

# ✅ JSON-форма + exec + подстановка переменных. Решает warning и проблемы с сигналами
ENTRYPOINT ["sh", "-c", "exec java $JAVA_HEAP_DUMP_OPTS $JAVA_ON_OUT_OF_MEMORY_OPTS $JAVA_ERROR_FILE_OPTS $JAVA_NATIVE_MEMORY_TRACKING_OPTS $JAVA_CDS_OPTS -jar app.jar"]

# Опционально: явно указываем порт для документации и оркестраторов
EXPOSE 8080