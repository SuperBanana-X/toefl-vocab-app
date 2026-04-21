# VocabFlow

这是一个用 Streamlit 做面板、用 Excel 做本地数据库的背单词程序。

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
- 输入英文单词后可以选择“快速加入”，立刻保存到 Excel，不等待 AI
- 也可以选择“加入并补全”，当场调用你选择的 AI provider 补全
- 支持“补全最近加入的单词”和“批量补全未完成单词”
- 本地已有同词资料时优先复用缓存，减少 token 消耗
- 所有单词保存到对应单词本的 `words.xlsx`
- Excel 中用 `AI_Status` 标记 AI 补全状态：`pending`、`done`、`failed`
- 复习时根据 `Next_Review` 实时判断是否到期
- 点击“认识/忘记”会更新熟练度和下次复习时间
- “练习”页会集中抽取忘记过至少 1 次的词，并配合音标和例句训练
- “练习”页可以点击“掌握，移出练习”，只退出练习池，不影响正式复习计划
- 复习页、单词本详情和 Excel 会根据遗忘次数自动分颜色显示
- 点击“停止输入，开始复习”时才检查备份
- 如果当前 Excel 和最近备份一致，就不会重复备份
- “单词本详情”页可以查看当前单词本路径、Excel、备份和表格内容
- “单词本详情”页支持按 ID 或英文搜索定位单词，并修改英文拼写和备注

## 遗忘词练习

“练习”页面专门用于训练已经忘记过的词。只要某个单词在正式复习中点过“忘记”，它的 `Wrong_Count` 就会增加，并进入练习池。

练习卡片会显示：

- 英文单词
- 遗忘等级
- 音标
- 英文例句

点击“显示释义”后，会显示中文释义、例句翻译、TOEFL 语境、搭配和记忆提示。练习页不会修改复习计划，只用于集中熟悉错过的词。

如果你觉得某个遗忘词已经练熟，可以点击“掌握，移出练习”。这只会把它从练习池里移出，不会修改 `Mastery`、`Wrong_Count`、`Forget_Level` 或 `Next_Review`，所以它仍然会按照正式复习曲线继续复习。

如果这个词之后在正式复习里又点了“忘记”，它会自动重新进入练习池。

## 复习曲线

正式复习使用一套简化的间隔重复曲线。程序会根据 `Mastery` 和当前时间更新 `Next_Review`：

- 点击“忘记”：5 分钟后复习，`Mastery` 归零
- 认识第 1 次：30 分钟后复习
- 认识第 2 次：12 小时后复习
- 认识第 3 次：1 天后复习
- 认识第 4 次：3 天后复习
- 认识第 5 次：7 天后复习
- 认识第 6 次：15 天后复习
- 认识第 7 次及以上：30 天后复习

练习页的“掌握，移出练习”不会改变这条正式复习曲线。

## 输入与 AI 补全

为了不让 AI 响应速度拖慢背词，可以先用“快速加入”连续输入单词。程序会马上把英文、备注和基础复习字段写入 `words.xlsx`，未补全的单词会标记为 `AI_Status = pending`。

之后可以在“输入新词”页面使用：

- “补全最近加入的单词”：只补全刚刚加入的那个单词。
- “批量补全未完成单词”：一次补全多个 `pending` 或 `failed` 的单词。每成功补全一个，都会立刻保存 Excel。
- “加入并补全”：适合偶尔想马上看到完整解释、音标、例句、搭配和 TOEFL 用法时使用。

如果某次 AI 请求失败，单词不会丢失，会保留在 Excel 中并标记为 `failed`，之后可以继续批量补全。

## 遗忘颜色分级

程序会根据每个单词的 `Wrong_Count` 自动生成 `Forget_Level`，并在三个地方同步显示：

- 复习页面的单词卡
- “单词本详情”页面的表格
- 每个词库里的 `words.xlsx`

颜色和分级规则如下：

- `1 次`：第一次忘记
- `2 次`：重复遗忘
- `3 次及以上`：高频遗忘

如果某个单词还没有忘记记录，会显示为中性颜色，并标记为“目前还没有忘记记录”。

## 修改已有单词

如果发现单词拼写录入错误，可以到“单词本详情”页面修改：

- 直接输入单词 ID，可以精确定位。
- 输入英文片段，可以搜索拼错的单词。
- 如果搜索结果只有一个，程序会自动定位。
- 如果搜索结果有多个，页面会显示匹配列表，把目标 ID 填到左侧即可修改。

保存后会立刻写回当前单词本的 `words.xlsx`。如果英文拼写发生变化，该单词会被标记为 `AI_Status = pending`，后续可以用“批量补全未完成单词”刷新 AI 资料。

## 备份逻辑

程序不会每次启动都备份。只有点击“停止输入，开始复习”时才会检查：

- 如果 `words.xlsx` 和最近备份一致，跳过备份。
- 如果内容不同，创建一份新备份。

## 注意

如果正在用 Excel 打开某个 `words.xlsx`，程序可能无法保存。保存新词或复习结果前，最好先关闭对应 Excel 文件。

## License

This project is licensed under the MIT License.
