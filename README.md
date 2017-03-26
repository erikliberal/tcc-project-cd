# DOCKER

### Lista de comandos ###

#### para construir o build ####
```bash
docker build -q --force-rm=true --rm=true -t [[nome_da_imagem]] .
```

#### para executar o build ####
```bash
docker run -d -p 8153:8153 -p 8154:8154 [[nome_da_imagem]]
```

#### para acessar o servidor ####
```bash
docker exec -it [[id_da_imagem]] bash
```
o id_da_imagem é escrito como resposta do comando de execução, ou é obtido via o comando `docker ps`
