## emessengerRepo

<<<<<<< HEAD
## Instruções para obter o certificado SSL 
- Execute o comando no terminal: keytool -genkey -alias tomcat
=======
## Instruções para criar o certificado SSL 
- Obs: o certificado já se encontra no diretório server/src/main/resources com o nome keystore.p12.
- Execute o comando no terminal: keytool -genkey -alias tomcat -storetype PKCS12 -keyalg RSA -keysize 2048 -keystore keystore.p12 -validity 3650
>>>>>>> f70d5c5e5b0eab66cb660a837702f16f9d6c949d
- Preencha os campos solicitados.