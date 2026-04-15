# TOEFL Excel 背单词

这是一个用 Streamlit 做面板、用 Excel 做本地数据库的 TOEFL 背单词小程序。

## 运行

运行方式：

```bash
./run_app.sh
```

`run_app.sh` 会使用当前环境里的 `python3 -m streamlit`，所以别人只要装好依赖就能运行。



## 安装依赖

其他电脑一般执行：

```bash
pip install -r requirements.txt
```


## 配置 DeepSeek

打开 `deepseek_config.py`，填入你的 API Key：

```python
DEEPSEEK_API_KEY = "你的 key"
```

## 数据目录

项目目录固定为：

```text
/Users/stevenchen/Desktop/Voc
```

数据库目录为：

```text
/Users/stevenchen/Desktop/Voc/Voc_Database
```

每个单词本都是一个独立文件夹：

```text
Voc_Database/
└── 默认词库/
    ├── book.json
    ├── words.xlsx
    └── backups/
```

## 功能

- 新建、切换、改名单词本
- 输入英文单词后调用 DeepSeek 补全 TOEFL 向资料
- 本地已有同词资料时优先复用缓存，减少 token 消耗
- 所有单词保存到对应单词本的 `words.xlsx`
- 复习时根据 `Next_Review` 实时判断是否到期
- 点击“认识/忘记”会更新熟练度和下次复习时间
- 点击“停止输入，开始复习”时才检查备份
- 如果当前 Excel 和最近备份一致，就不会重复备份
- “单词本详情”页可以查看当前单词本路径、Excel、备份和表格内容
- “DeepSeek 聊天”页可以直接问 TOEFL 单词、例句、写作表达和口语思路

## DeepSeek 聊天

面板里有一个“DeepSeek 聊天”页面。它会带上当前单词本名称作为上下文，让 DeepSeek 按 TOEFL 备考方式回答。

聊天记录只保存在当前浏览器会话中，不会写入 Excel，也不会修改任何单词本文件。

## 备份逻辑

程序不会每次启动都备份。只有点击“停止输入，开始复习”时才会检查：

- 如果 `words.xlsx` 和最近备份一致，跳过备份。
- 如果内容不同，创建一份新备份。

## 注意

如果你正在用 Excel 打开某个 `words.xlsx`，程序可能无法保存。保存新词或复习结果前，最好先关闭对应 Excel 文件。
