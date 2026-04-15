# TOEFL Excel 背单词

这是一个用 Streamlit 做面板、用 Excel 做本地数据库的 TOEFL 背单词小程序。

## 运行

第一次下载后，先安装依赖：

```bash
pip install -r requirements.txt
```

然后运行：

```bash
./run_app.sh
```

## 配置 AI API

第一次使用时，复制示例配置：

```bash
cp ai_config.example.py ai_config.py
```

然后打开 `ai_config.py`，选择要用的 AI provider，并填入对应 API Key。

当前支持这些选项：

```python
AI_PROVIDER = "deepseek"                  # DeepSeek
AI_PROVIDER = "openai"                    # OpenAI / ChatGPT API
AI_PROVIDER = "gemini"                    # Google Gemini API
AI_PROVIDER = "custom_openai_compatible"  # 其他 OpenAI-compatible API
```

DeepSeek 示例：

```python
AI_PROVIDER = "deepseek"
DEEPSEEK_API_KEY = "你的 key"
DEEPSEEK_MODEL = "deepseek-chat"
```

OpenAI / ChatGPT API 示例：

```python
AI_PROVIDER = "openai"
OPENAI_API_KEY = "你的 key"
OPENAI_MODEL = "gpt-4.1-mini"
```

Gemini 示例：

```python
AI_PROVIDER = "gemini"
GEMINI_API_KEY = "你的 key"
GEMINI_MODEL = "gemini-2.0-flash"
```

其他 OpenAI-compatible API 示例：

```python
AI_PROVIDER = "custom_openai_compatible"
CUSTOM_OPENAI_COMPATIBLE_API_KEY = "你的 key"
CUSTOM_OPENAI_COMPATIBLE_BASE_URL = "https://你的服务地址/v1"
CUSTOM_OPENAI_COMPATIBLE_MODEL = "模型名"
```


## 数据目录

程序会以当前项目所在文件夹作为项目根目录。也就是说，不管把项目下载到哪里，数据库都会自动创建在项目根目录下：

```text
./Voc_Database
```

每个单词本都是 `Voc_Database/` 下面的一个独立文件夹：

```text
Voc_Database/
└── 默认词库/
    ├── book.json
    ├── words.xlsx
    └── backups/
```


## 功能

- 新建、切换、改名单词本
- 输入英文单词后调用你选择的 AI provider 补全
- 本地已有同词资料时优先复用缓存，减少 token 消耗
- 所有单词保存到对应单词本的 `words.xlsx`
- 复习时根据 `Next_Review` 实时判断是否到期
- 点击“认识/忘记”会更新熟练度和下次复习时间
- 点击“停止输入，开始复习”时才检查备份
- 如果当前 Excel 和最近备份一致，就不会重复备份
- “单词本详情”页可以查看当前单词本路径、Excel、备份和表格内容
- “AI 聊天”页可以直接问 TOEFL 单词、例句、写作表达和口语思路

## AI 聊天

面板里有一个“AI 聊天”页面。它会带上当前单词本名称作为上下文，让当前选择的 AI provider 按 TOEFL 备考方式回答。

聊天记录只保存在当前浏览器会话中，不会写入 Excel，也不会修改任何单词本文件。

## 备份逻辑

程序不会每次启动都备份。只有点击“停止输入，开始复习”时才会检查：

- 如果 `words.xlsx` 和最近备份一致，跳过备份。
- 如果内容不同，创建一份新备份。

## 注意

如果正在用 Excel 打开某个 `words.xlsx`，程序可能无法保存。保存新词或复习结果前，最好先关闭对应 Excel 文件。
