#!/bin/sh
set -eu

echo "Starting Ollama..."
ollama serve &
OLLAMA_PID=$!

echo "Waiting for Ollama API on 127.0.0.1:11434..."
until curl -fsS http://127.0.0.1:11434/api/tags >/dev/null 2>&1; do
  sleep 2
done

echo "Ollama API is up."

if ! ollama list | grep -q "qwen3:8b"; then
  echo "Pulling qwen3:8b..."
  ollama pull qwen3:8b
else
  echo "Model already present."
fi

echo "Ready."
wait $OLLAMA_PID
