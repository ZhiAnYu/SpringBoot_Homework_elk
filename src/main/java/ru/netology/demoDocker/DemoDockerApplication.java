package ru.netology.demoDocker;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@SpringBootApplication
public class DemoDockerApplication {
@Value("${inst.num:1}")
    private int num;

    public static void main(String[] args) {
        SpringApplication.run(DemoDockerApplication.class, args);
    }

    @GetMapping("/")
    public String hello() {
        return "Hello from instance " + num + "Ver.2";
    }

}
