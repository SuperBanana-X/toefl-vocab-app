#!/bin/zsh
cd "$(dirname "$0")" || exit 1
python3 -m streamlit run vocab_app.py
