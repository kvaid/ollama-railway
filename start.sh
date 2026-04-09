#!/bin/sh
set -eu

# Start Ollama in the background
ollama serve &
OLLAMA_PID=$!

# Wait for Ollama API to come up
until curl -fsS http://127.0.0.1:11434/api/tags >/dev/null 2>&1; do
  sleep 2
done

# Pull the model once if it is not already on the mounted volume
if ! ollama list | grep -q "qwen3:8b"; then
  ollama pull qwen3:8b
fi

# Keep container running with Ollama in foreground lifecycle
wait $OLLAMA_PID
