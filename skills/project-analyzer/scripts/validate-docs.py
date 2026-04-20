#!/usr/bin/env python3
"""
文档验证脚本

验证生成的文档是否符合规范：
1. 每个文档必须包含 YAML frontmatter
2. frontmatter 必须包含必需字段
3. 日期格式必须正确
4. 每个文档至少包含 1 个 Mermaid 图表
"""

import os
import sys
import re
from pathlib import Path
from datetime import datetime

# 必需的 frontmatter 字段
REQUIRED_FIELDS = ['title', 'description', 'created']

# 可选的 frontmatter 字段
OPTIONAL_FIELDS = ['author', 'version', 'tags']


def validate_frontmatter(content, filepath):
    """验证 YAML frontmatter"""
    errors = []

    # 检查是否有 frontmatter
    if not content.startswith('---\n'):
        errors.append(f"缺少 YAML frontmatter")
        return errors

    # 提取 frontmatter
    parts = content.split('---\n', 2)
    if len(parts) < 3:
        errors.append(f"YAML frontmatter 格式错误")
        return errors

    frontmatter = parts[1]

    # 检查必需字段
    for field in REQUIRED_FIELDS:
        if f'{field}:' not in frontmatter:
            errors.append(f"缺少必需字段: {field}")

    # 验证日期格式
    date_match = re.search(r'created:\s*(\d{4}-\d{2}-\d{2})', frontmatter)
    if date_match:
        try:
            datetime.strptime(date_match.group(1), '%Y-%m-%d')
        except ValueError:
            errors.append(f"日期格式错误: {date_match.group(1)}，应为 YYYY-MM-DD")

    return errors


def validate_mermaid(content, filepath):
    """验证 Mermaid 图表"""
    errors = []

    # 检查是否包含 Mermaid 图表
    mermaid_count = content.count('```mermaid')
    if mermaid_count == 0:
        errors.append(f"缺少 Mermaid 图表（至少需要 1 个）")

    # 检查 Mermaid 代码块是否闭合
    if mermaid_count > 0:
        # 简单检查：每个 ```mermaid 后面应该有对应的 ```
        mermaid_blocks = re.findall(r'```mermaid\n(.*?)```', content, re.DOTALL)
        if len(mermaid_blocks) != mermaid_count:
            errors.append(f"Mermaid 代码块未正确闭合")

    return errors


def validate_chinese(content, filepath):
    """验证中文内容"""
    errors = []

    # 提取正文（去除 frontmatter 和代码块）
    parts = content.split('---\n', 2)
    if len(parts) >= 3:
        body = parts[2]

        # 移除代码块
        body = re.sub(r'```.*?```', '', body, flags=re.DOTALL)

        # 检查是否包含中文
        if not re.search(r'[\u4e00-\u9fff]', body):
            errors.append(f"文档正文缺少中文内容")

    return errors


def validate_document(filepath):
    """验证单个文档"""
    print(f"\n检查: {filepath}")

    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
    except Exception as e:
        print(f"  ❌ 无法读取文件: {e}")
        return False

    errors = []

    # 验证 frontmatter
    errors.extend(validate_frontmatter(content, filepath))

    # 验证 Mermaid 图表
    errors.extend(validate_mermaid(content, filepath))

    # 验证中文内容
    errors.extend(validate_chinese(content, filepath))

    if errors:
        print(f"  ❌ 发现 {len(errors)} 个问题:")
        for error in errors:
            print(f"     - {error}")
        return False
    else:
        print(f"  ✅ 验证通过")
        return True


def main():
    if len(sys.argv) < 2:
        print("用法: python validate-docs.py <docs-directory>")
        sys.exit(1)

    docs_dir = Path(sys.argv[1])

    if not docs_dir.exists():
        print(f"❌ 目录不存在: {docs_dir}")
        sys.exit(1)

    print(f"开始验证文档: {docs_dir}")
    print("=" * 60)

    # 查找所有 .md 文件
    md_files = list(docs_dir.glob('*.md'))

    if not md_files:
        print(f"❌ 未找到任何 .md 文件")
        sys.exit(1)

    print(f"找到 {len(md_files)} 个文档")

    # 验证每个文档
    results = []
    for md_file in sorted(md_files):
        result = validate_document(md_file)
        results.append((md_file.name, result))

    # 输出总结
    print("\n" + "=" * 60)
    print("验证总结:")
    print("=" * 60)

    passed = sum(1 for _, result in results if result)
    failed = len(results) - passed

    print(f"\n总计: {len(results)} 个文档")
    print(f"✅ 通过: {passed}")
    print(f"❌ 失败: {failed}")

    if failed > 0:
        print("\n失败的文档:")
        for filename, result in results:
            if not result:
                print(f"  - {filename}")
        sys.exit(1)
    else:
        print("\n🎉 所有文档验证通过！")
        sys.exit(0)


if __name__ == '__main__':
    main()
