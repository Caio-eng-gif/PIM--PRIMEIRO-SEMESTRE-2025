# Sistema integrado para gestão de chamados e suporte técnico baseado em IA.



# 🎓 Aprendizado por Projeto Integrador
* UNIP

* 2º / 3º Período - Analise e Desenvolvimento de Sistemas

-----------------------------------------------------------------------------------------------------------------------------------------------------------


## Equipe:


## 👨‍💻 👩‍💻 Integrantes

| Aluno            | Função           | GitHub                                                         | LinkedIn                                              |
| ---------------- | ---------------- | -------------------------------------------------------------- | ----------------------------------------------------- |
|__Caio Costa Santos__   | *Product Owner*  | [![](https://bit.ly/3f9Xo0P)](https://github.com/Caio-eng-gif)| [![](https://bit.ly/2P1ZogM)](https://www.linkedin.com/in/caio-costa-santos-7a7277195/) |
|__Gabriel Souza__  | *Developer Team* | [![](https://bit.ly/3f9Xo0P)](https://github.com/GABRIELWCS)  | [![](https://bit.ly/2P1ZogM)](https://www.linkedin.com/in/gabriel-souza-553224247/) |
|__Lucas Gimenez__ | *Scrum Master* | [![](https://bit.ly/3f9Xo0P)](https://github.com/Lucasmsg97)  | [![](https://bit.ly/2P1ZogM)](https://www.linkedin.com/in/lucas-gimenez-360b0310a/) |
|__Lucas Machado__| *Developer Team* | [![](https://bit.ly/3f9Xo0P)](https://github.com/LucasMachado12) | [![](https://bit.ly/2P1ZogM)](https://www.linkedin.com/in/lucas-machado-31510b32a/) |
|__Pedro Leite__| *Developer Team* | [![](https://bit.ly/3f9Xo0P)](https://github.com/pedroleite44) | [![](https://bit.ly/2P1ZogM)]() 
|__Rodrigo Restelli__| *Developer Team* | [![](https://bit.ly/3f9Xo0P)](https://github.com/RodrigoRestelli) | [![](https://bit.ly/2P1ZogM)]() 


## 👨‍🏫 Disciplinas Integradas:
- Análise de sistemas orientada a objetos
- Banco de dados
- Economia e mercado
- Engenharia de software 2
- Gestão estrátegica de RH
- Lingua brasileira de sinais
- Programação orientada a objetos
- Projeto de interface com o usuário



## 🎯 Objetivo

Realizar o levantamento e análise de requisitos para a criação de um sistema de suporte técnico inteligente, que utilize Inteligência Artificial para triagem inicial, categorização automática de chamados e sugestão de soluções, visando otimizar o tempo de resposta e reduzir a sobrecarga da equipe de TI. A LGPD deve ser aplicada a todos os dados pessoais tratados no sistema. O desenvolvimento ocorrerá no próximo semestre (PIM IV).



## 💬 Descritivo do Projeto - Requisitos do Sistema
**Requisitos Funcionais**
  
Controle de acesso 
- Login para controle de acesso e diferentes níveis de acesso entre técnicos, colaboradores e admnistradores.
  
Abertura de Chamados
- Formulário de abertura com campos personalizáveis (tipo de problema, urgência, setor).
- Opção de anexar arquivos (prints, logs de erro, documentos).
- Categorização automática ou manual (TI, Financeiro, RH, Infraestrutura, etc.).

Classificação e Priorização
- Definição de níveis de prioridade (Urgente, Alta, Média, Baixa).
- Regras automatizadas para priorização (exemplo: chamados de TI que impactam todos os usuários = prioridade máxima).
- SLA (Service Level Agreement) configurável para cada tipo de chamado.

Fluxo de Atendimento
- Painel com fila de chamados organizados por prioridade e setor.
- Atribuição automática ou manual para os atendentes responsáveis.
- Notificações automáticas para solicitantes e responsáveis (e-mail, WhatsApp, sistema interno).
- Atualização do status do chamado (Aberto, Em andamento, Aguardando resposta, Resolvido, Fechado).

Comunicação e Histórico
- Chat interno dentro do chamado para conversas entre solicitante e atendente.
- Registro de todas as interações e atualizações feitas no chamado.
- Possibilidade de reabrir chamados fechados.

  **Requisitos não funcionais**
  
  
Segurança
- Proteção de Dados: Como o sistema pode lidar com dados sensíveis, é necessário garantir que todas as informações sejam criptografadas tanto em trânsito quanto em repouso.
- Autenticação e Autorização: O sistema deve permitir controle de acesso adequado, com autenticação forte e permissões para diferentes perfis de usuários.
- Proteção contra Ataques: O sistema deve ser protegido contra ameaças como ataques DDoS, SQL Injection, e outras vulnerabilidades.

Usabilidade
- Interface de Usuário: O sistema deve possuir uma interface intuitiva e de fácil utilização, permitindo que os operadores ou administradores do sistema usem as funcionalidades sem dificuldades.

Compatibilidade
- Integração com Outros Sistemas: O sistema deve ser capaz de integrar-se facilmente com outros sistemas existentes, como bancos de dados, APIs de terceiros ou plataformas externas.
- Compatibilidade com Navegadores e Dispositivos: Caso o sistema seja acessado via web, ele deve ser compatível com os principais navegadores (Chrome, Firefox, Safari) e dispositivos (desktop, mobile).

Acessibilidade
- O sistema deve ser acessível a pessoas com deficiência, garantindo que todas as funções possam ser realizadas com o uso de tecnologias assistivas, como leitores de tela e navegação por teclado.

Compliance e Regulamentação
- O sistema deve estar em conformidade com as regulamentações e leis locais e internacionais aplicáveis (ex: LGPD no Brasil, GDPR na União Europeia), especialmente no que diz respeito ao armazenamento e tratamento de dados pessoais.


Monitoramento e Auditoria
- O sistema deve ter capacidade de monitoramento constante, para garantir que está funcionando corretamente. Isso inclui a geração de logs de acesso, erros, uso de recursos, etc.
- Auditoria: O sistema deve ser capaz de registrar todas as ações dos usuários, garantindo que qualquer evento relevante possa ser auditado posteriormente.

Treinamento e Capacitação
- A solução de IA integrada no sistema precisa de um processo contínuo de treinamento e atualização dos modelos, para garantir que os algoritmos de triagem sejam precisos e eficientes ao longo do tempo.
- Mecanismos de Feedback: O sistema deve permitir que os operadores forneçam feedback sobre a precisão da triagem, o que pode ser usado para ajustar ou melhorar os modelos.

 **Caso de Uso:**


  
  ![casodeuso](https://github.com/user-attachments/assets/21eda98d-2946-41f0-a674-ac2a2f1f10ed) 



**Diagrama de Classes**




![diagrama de classes](https://github.com/user-attachments/assets/de0c477f-96ca-4010-8057-d1d84b6b623a)




**Diagrama de Sequência**




![diagrama de sequência](https://github.com/user-attachments/assets/e7581795-72f4-4483-8c70-6ed5a919c25d)





**Diagrama ER**



![Diagrama em branco (1)](https://github.com/user-attachments/assets/80e1c2c4-261e-4987-9f0e-49f40be4cceb)




## 🛠️ Ferramentas/Tecnologias
 <img src= "https://github.com/user-attachments/assets/f7f60732-7cef-49c5-ae13-72abda88fc98" alt="GitHub logo" width="50">



 <img src="https://github.com/user-attachments/assets/d1c9c786-cbb7-4e38-be25-9436536908c7" alt="GitHub logo" width="50">


-------------------------------------------------------------------------------------------------------------------------------------------------------------------
# 📝 Product Backlog
[📄 Confira a documentação completa aqui](PRODUCT_BACKLOG_versão_1.0.pdf)

-------------------------------------------------------------------------------------------------------------------------------------------------------------------

# 📝 Sprint Backlog
[📄 Confira a documentação completa aqui](SprintBacklog_versão1.0.pdf)


