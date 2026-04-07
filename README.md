## Восстановление данных Kibana для проверки
1. Распакуйте архив: `tar -xzf elasticsearch-backup.tar.gz`
2. Запустите стек: `docker compose up -d`
3. Откройте Kibana: http://localhost:5601
4. Index Pattern `app-logs-*` и настройки Discover уже сохранены.
