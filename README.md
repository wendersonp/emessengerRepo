## emessengerRepo

## Instruções para criar o certificado SSL 
- Obs: o certificado já se encontra no diretório server/src/main/resources com o nome keystore.p12.
- Execute o comando no terminal: keytool -genkey -alias tomcat -storetype PKCS12 -keyalg RSA -keysize 2048 -keystore keystore.p12 -validity 3650
- Preencha os campos solicitados.