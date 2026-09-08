;;; init-ai.el --- AI config          -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(require-package 'gptel)
(require-package 'agent-shell)

(with-eval-after-load 'gptel
  (gptel-make-privategpt "LMStudio"
    :protocol "http"
    :host "localhost:1234"
    :stream t
    :context t                            ;Use context provided by embeddings
    :sources t                            ;Return information about source documents
    :models '(openai/gpt-oss-20b))

  (gptel-make-ollama "ollama"
    :host "localhost:11434"
    :stream t
    :models '(kimi-k2.5:cloud))

  (defvar my-openrouter-backend
    (gptel-make-openai "OpenRouter"
      :host "openrouter.ai"
      :endpoint "/api/v1/chat/completions"
      :stream t
      :key (getenv "OPENROUTER_API_KEY")
      :models '(openrouter/free
                stepfun/step-3.5-flash:free
                qwen/qwen3-coder:free
                arcee-ai/trinity-large-preview:free
                tngtech/deepseek-r1t2-chimera:free
                z-ai/glm-4.5-air:free
                openai/gpt-oss-120b:free
                openai/gpt-5-codex
                google/gemini-3-flash-preview)))

  (gptel-make-preset "OpenRouter"
                     :backend my-openrouter-backend)

  (setq gptel-model   'openrouter/free
        gptel-backend my-openrouter-backend))


(provide 'init-ai)
;;; init-ai.el ends here
