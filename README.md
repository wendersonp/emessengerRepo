## emessengerRepo

## Instruções para obter o certificado SSL 
- Execute o comando no terminal: keytool -genkey -alias tomcat

## Instruções para criar o certificado SSL 
- Obs: o certificado já se encontra no diretório server/src/main/resources com o nome keystore.p12.
- Execute o comando no terminal: keytool -genkey -alias tomcat -storetype PKCS12 -keyalg RSA -keysize 2048 -keystore keystore.p12 - validity 3650

## Instruções para configurar o banco de dados

Acesse o link: https://spring.io/guides/gs/accessing-data-mysql/ para conferir as configurações em detalhes

Em resumo:
- Abra o mysql com privilégio root em um terminal
- Execute a Query 'CREATE DATABASE emessenger_db;' para criar o banco de dados
- Execute a Query 'CREATE USER 'emsgserver'@'%' IDENTIFIED BY 'leds123';' para criar o usuário que acessa o banco
- Execute a Query 'GRANT ALL ON emessenger_db.* TO 'emsgserver'@'%' IDENTIFIED BY 'leds123';' para conceder permissão ao usuário criado para modificar o banco
- Antes da primeira execução do aplicativo, mude o valor do atributo spring.jpa.hibernate.ddl-auto para 'create' em application.properties. Em execuções seguintes, retorne o valor deste atributo para 'none'. 

## Obter Token de acesso

- Requisita um token de acesso ao servidor
- Tipo de Requisição HTTP: POST
- Endereço: /oauth/token
- Escrever o Header com o seguinte parâmetro:
    - Authorization = Basic <base64_encode>
- <base64_encode> é gerado codificando emsgserver:leds123 em base64
- Parâmetros:
    - grant_type = password
    - username = emsgserver
    - password = leds123
- Retorno: .JSON com o token, copiar o atributo access_token
- Em todas as outras requisições, escrever no header o parâmetro:
    -Authorization = <token_type> <access_token>


## Requisições suportadas pelo servidor



### Criar usuário

- Função: Cria uma instancia da entidade usuário no banco de dados
- Tipo de Requisição HTTP: POST
- Endereço: /user/signup
- Parâmetros:
    - name: Nome real do usuário
    - nickname: Identificação única do usuário
    - password: Senha do usuário
- Retorno: String "Signup Success".

### Realizar login de Usuário

- Função: Realiza o login do usuário, com alteração de valor no banco de dados
- Tipo de Requisição HTTP: PUT
- Endereço: /user/login
- Parâmetros:
    - nickname: Identificação única do usuário
    - password: Senha do usuário
- Retorno: Token de acesso se o login for realizado com sucesso, String "Login Error" se o login falhou.

### Recuperar dados de Usuário

- Função: Resgata os dados de um Usuário, dado o nickname
- Tipo de Requisição HTTP: GET
- Endereço: /secured/user/get
- Parâmetros:
    - nickname: Identificação única do usuário
- Retorno: .JSON do usuário requisitado

### Realizar logout de Usuário

- Função: Realiza o logout do usuário, com alteração de valor no banco de dados
- Tipo de Requisição HTTP: PUT
- Endereço: /user/logout
- Parâmetros:
    - nickname: Identificação única do usuário
- Retorno: String "Logout Success", se o logout for feito com exito, ou String "Logout Error", se o logout falhar

### Criar chat

- Função: Cria um chat entre usuários no banco de dados
- Tipo de Requisição HTTP: POST
- Endereço: /secured/chat/create
- Parâmetros:
    - subject: Assunto do chat a criar
    - users_nicknames: lista de identificação dos usuários criados, o anfitrião (o que esta querendo criar o chat) deve ser o primeiro da lista. 
    Ex.: users_nicknames=wendersonp, joaopessoa (wendersonp está criando o chat)
- Retorno: .JSON do chat criado, se este for criado com sucesso, se não, o retorno é nulo

### Lista de Chats

- Função: Resgata a lista de chats em que um usuário esteja participando, ordenadas por data de última atualização
- Tipo de Requisição HTTP: GET
- Endereço: /secured/chat/getlist
- Parâmetros:
    - nickname: Identificação única do usuário
- Retorno: .JSON com lista de chats em que o usuário participa

### Criar mensagem

- Função: Cria uma mensagem associada a um chat e o usuário que a gerou
- Tipo de Requisição HTTP: POST
- Endereço: /secured/message/send
- Parâmetros:
    - sender_nickname: Identificação única do usuário que envia a mensagem
    - chat_id: Número de identificação do chat no banco de dados
    - text_message: Texto conteúdo da mensagem 
- Retorno: .JSON da mensagem criada, se esta for criada com sucesso.

### Lista de mensagens

- Função: Resgata lista de mensagens associadas a um chat, ordenadas por data de envio
- Tipo de Requisição HTTP: GET
- Endereço: /secured/message/getlist
- Parâmetros:
    - nickname: Identificação única do usuário
    - chat_id: Número de identificação do chat no banco de dados
- Retorno: .JSON da lista de mensagens associadas ao chat.

### Adicionar mais Usuarios ao Chat

- Função: Adiciona mais usuários a um determinado chat
- Tipo de Requisição HTTP: PUT
- Endereço: /secured/chat/addusers
- Parâmetros:
    - users_nicknames: Lista de Identificação dos usuários
    - chat_id: Número de identificação do chat no banco de dados
- Retorno: .JSON do chat alterado