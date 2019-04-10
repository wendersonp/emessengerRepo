package com.leds.server;

//import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
//import org.springframework.context.annotation.Bean;

@SpringBootApplication
public class DemoApplication {

	public static void main(String[] args) {
		SpringApplication.run(DemoApplication.class, args);
	}

	/*@Bean
	public CommandLineRunner demo(UserRepository repository){
		return (args) -> {
			repository.save(new User("wenderson", "wendell", "123"));
			for (User user : repository.findAll()){
				System.out.println(user.getName());
			}
		};
	}*/

}
