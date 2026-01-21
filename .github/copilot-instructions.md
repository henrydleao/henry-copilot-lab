# Instruções do Repositório – Engenharia de Dados (PT‑BR)

Estas instruções definem **padrões obrigatórios** para desenvolvimento, revisão de PR e operação neste repositório.  
O **GitHub Copilot* (Code Review e Coding Agent) deve **seguir estas regras** ao sugerir código, revisar PRs e gerar artefatos.

> **Princípio de priorização:** Segurança & Governança → Integridade & Confiabilidade → Manutenibilidade → Performance → Estilo.

---

## 0) Convenções gerais

- **Idioma**: Responder e comentar **em PT‑BR**.
- **Sugestões em PR**: Prefira **diffs mínimos** e **explicações objetivas** com o “porquê”.

---

## 1) Pull Request (PR) – Requisitos Gerais

**Toda PR deve incluir:**
- [ ] **Evidência de funcionamento**: prints e **descrição detalhada** das alterações e do resultado.
- [ ] **Deploy do bundle** validado **sem falhas** (anexar logs e/ou prints quando aplicável).
- [ ] **Branch de destino**: merge para **`HML`** (homologação), salvo exceções claramente **justificadas** no texto da PR.

**Boas práticas de descrição da PR:**
- Contexto (problema/objetivo), escopo, impactos, risco/mitigações, como testar/reproduzir.
- Referências a issues/tickets, quando houver.

---

# 2) Segurança e Governança de Dados

- **Nunca** expor credenciais, tokens ou segredos (em código, YAML ou notebooks).
- **Sempre** usar **SCOPE/secret management** ou mecanismo seguro equivalente.
- Sinalizar:
  - DDL/operções perigosas (ex.: `DELETE` sem `WHERE`).
  - Acesso indevido a catálogos/paths (hardcoded).
  - Vazamento de dados sensíveis (PII/segredos).

**Orientação ao Copilot:** se detectar segredo literal, **recusar** a sugestão e **propor** solução com secrets/variáveis seguras.


---

## 3) Arquitetura e Convenções (Dados & Pastas)

- Fluxo de dados **oficial**: **`bronze → trusted → refined`**.  
  - Camadas **`trusted/refined` devem ser orquestradas via **DLT** (Delta Live Tables).
- Estrutura de diretórios **esperada** (alto nível):
  - `app_file/sql/<nome_arquivo>.sql` (SQL manual de app files)
  - `app_file/schemas/<arquivo>.py` (contratos/validações)
  - `src/dlt/<trusted|refined>/...` (pipelines DLT por camada)
  - `resources/*.pipeline.yml` (pipelines) e `resources/*.job.yml` (jobs)
  - `notebooks/tags_<tabela>.ipynb` (tags/ativos, documentação)

> **Importante:** Detalhes operacionais por linguagem/arquivo estão nos `*.instructions.md` vinculados no topo deste documento.


---


# 4) Metadados & Cabeçalho Obrigatório

Todo arquivo de código relevante deve começar com o seguinte cabeçalho:

```text
# Autor: <Nome>
# Data: <YYYY-MM-DD>
# Projeto: <NomeDoProjeto>
# Camada: <Bronze|Trusted|Refined|Outro>
# Tabela: <nome_da_tabela_ou_N/A>
# Objetivo: <descrição sucinta>
# Versão: <x.y.z>
# Histórico: <resumo das mudanças>
```

O Copilot deve **sugerir** a inclusão do cabeçalho quando ausente.

---

## 5) Ativos (Tabelas, Tags, Metadados, Nomes)

- **Um notebook de tags por tabela**: notebooks/tags_<tabela>.ipynb.
- **Tags mínimas**: 6 em colunas e 2 na tabela.
- **Descrições e metadados**: coerentes e atualizados.
- Nomes: claros e padronizados (evitar siglas opacas, sufixos temporários como tmp_...).

O Copilot deve **alertar** quando:

-- faltarem notebooks de tags ou tags mínimas;
-- nomes estiverem opacos ou fora do padrão;
-- descrições/metadados estiverem ausentes.

---
## 6) Estilo de Revisão (Como o Copilot deve comentar)

1. **Ser específico e acionável** (indicar trechos e sugerir correções com porquê).
2. **Priorizar**: Segurança/Segredos → Integridade dos dados → Pipelines/Jobs → Schema/Contratos → Documentação/Cabeçalho → Nomenclatura.
3. **Sugerir diffs mínimos**: alterações pequenas com impacto objetivo.
4. **Evitar ruído**: não repetir comentários idênticos em várias linhas; sumarizar e apontar padrões.

---

## 7) Checklist Repo‑Wide para toda PR

 Evidências anexadas e **bundle** validado sem erros.
 Branch de destino: **HML** (com justificativa se diferente).
 **Sem segredos hardcoded** (usar secrets/SCOPE).
 **Sem catálogos/paths hardcoded** (parametrização/variáveis).
 **Fluxo bronze → trusted → refined** respeitado; para trusted/refined, **DLT**.
 **Cabeçalho obrigatório** presente em arquivos relevantes.
 **Ativos**: tags_<tabela>.ipynb, 6 tags/coluna e 2 tags/tabela, descrições coerentes.

---

## 8) O que o Copilot não deve sugerir (repo‑wide)

Hardcode de segredos, catálogos ou paths absolutos.
Transformações de trusted/refined fora de DLT.
Arquivos sem cabeçalho obrigatório.
PR sem evidências ou sem validação de bundle.
Criação/alteração de ativos sem tags/descrições mínimas.

---


## 9) Observações Finais

Este arquivo define a constituição do repositório (regras transversais).
Regras detalhadas e operacionais por tipo de arquivo estão nos **.instructions.md** vinculados no topo.
Em caso de conflito entre instruções, prevalece este documento repo‑wide, exceto quando a regra path‑specific explicitamente especializar uma regra geral para aquele contexto.