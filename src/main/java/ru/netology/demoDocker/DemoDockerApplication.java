package ru.netology.demoDocker;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;



@RestController
@SpringBootApplication
public class DemoDockerApplication {
    private static final Logger log = LoggerFactory.getLogger(DemoDockerApplication.class);

@Value("${inst.num:3}")
    private int num;

    public static void main(String[] args) {
        SpringApplication.run(DemoDockerApplication.class, args);
    }

    @GetMapping("/")
    public String hello() {
        log.info("Получен GET запрос на / | instance: {}", num);
        return "Hello from instance " + num + "Ver.2";
    }

}
