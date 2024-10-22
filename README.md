# GPT-PROXY

Unified GPT Proxy Service for Multi-Provider Access

### Ruby version **3.3.5**

### Environment variables

In development we use `figaro`
In development, we use `figaro`. You can set up your environment variables in `config/application.yml` based on `config/application.example.yml`.

* **APP_HOST:** localhost:3000
* **HTTPS:** 'false'
* **FARADAY_CAPTURE:** 'false'
* **FARADAY_PUBLISH:** 'false'
* **ALLOW_ALL_CORS_ORIGIN:** 'false'
* **PROVIDER_OLLAMA_URL:** 'http://localhost:11434'

You can replace each base url for each provider with your own by setting `PROVIDER_{PROVIDER_ID}_URL` environment variable.

### Database

```
rails db:create db:migrate db:seed
```

### Testing

  `PARALLEL_WORKERS={number_of_processors} rails test`
  
  `PARALLEL_WORKERS={number_of_processors} guard`

### Tools 
  Chrome extension [Json Formatter](https://chromewebstore.google.com/detail/json-formatter/bcjindcccaagfpapjjmafapmmgkkhgoa?hl=en-US&utm_source=ext_sidebar) is very useful for formatting JSON responses.

### Docker

You can use public docker image `pniemczyk/gpt-proxy` to run the application.

Just run

```
docker run -d -p 3030:80 \
-e RAILS_MASTER_KEY=a291d393cf057d94df12079e6f1cd3aee1f0a696e3616f4f4b7c2e4ad77907f8e7a4c181c12ad74b9a936fcd6f5334854155d131e10281497b90c3536842b21a \
-e SECRET_KEY_BASE=fcb35540572d6da0ac8aacbdfd2a4e6e111f9df78b9189cdd6276cbf7f1d526e \
-e APP_HOST=localhost:3030 \
-e ALLOW_ALL_CORS_ORIGIN=true \
-e RAILS_ENV=production \
--add-host host.docker.internal:host-gateway \
-e PROVIDER_OLLAMA_URL=http://host.docker.internal:11434 \
--name proxy pniemczyk/gpt-proxy
```

There is also option to use database on you host machine just by adding `--mount type=bind,source="$(pwd)/db/production.sqlite3",target=/rails/db/production.sqlite3 \` to the command above.
keep in mind that you need to create production database first directory. You can just do `echo '' > "$(pwd)/db/production.sqlite3"`

Please replace `RAILS_MASTER_KEY` and `SECRET_KEY_BASE` with your own keys.
you can generate `SECRET_KEY_BASE` by `openssl rand -hex 32` and `RAILS_MASTER_KEY` by `bin/rails secret`

## Providers

### Anthropic

* [Homepage](https://www.anthropic.com)
* [Documentation](https://docs.anthropic.com/en/api/getting-started)
* [Models](https://docs.anthropic.com/en/docs/about-claude/models#model-names)
* [API Key](https://console.anthropic.com/settings/keys)

### OpenAI

* [Homepage](https://www.openai.com)
* [Documentation](https://beta.openai.com/docs)
* [Models](https://platform.openai.com/docs/models)
* [API Key](https://platform.openai.com/api-keys)

### Gemini

* [Homepage](https://ai.google.dev/gemini-api)
* [Documentation](https://ai.google.dev/gemini-api/docs)
* [Models](https://ai.google.dev/gemini-api/docs/models/gemini)
* [API Key](https://aistudio.google.com/app/apikey)

### Groq

* [Homepage](https://www.groq.com)
* [Documentation](https://console.groq.com/docs/api-reference#chat-create)
* [Models](https://console.groq.com/docs/models)
* [API Key](https://console.groq.com/keys)

### Ollama

* [Homepage](https://ollama.com)
* [Documentation](https://github.com/ollama/ollama)
* [Models](https://ollama.com/library)
* [Github](https://github.com/ollama/ollama)

*Use models from ollama* `ollama run llama3.2` or `ollama run llama3.1:70b`
