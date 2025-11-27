Projeto WAKE UP
Este é um projeto Flutter que funciona como um gerenciador de tarefas e alarmes. A ideia é ter uma aplicação simples para ajudar a organizar o dia e garantir que as tarefas sejam feitas.

Como Rodar
O projeto foi configurado para rodar de forma otimizada em um Codespace, mantendo a persistência dos dados.

Para iniciar o projeto no Codespace, use o seguinte comando:

flutter run -d web-server --release

Observação: O parâmetro --release garante a melhor performance, e o -d web-server é o que permite a persistência no ambiente do Codespace.

Se você estiver rodando localmente (na sua máquina), o comando padrão do Flutter também funciona:

flutter run

Estrutura
O código está organizado da seguinte forma:
•	lib/screens/: Contém as telas principais (Alarmes, Tarefas, Cronômetro).
•	lib/database/: Lógica de banco de dados usando drift para persistência.
•	lib/models/: Definições dos modelos de dados.

Qualquer dúvida, é só dar uma olhada nos arquivos principais em lib/.
