# Changelog

所有重要的变更都会记录在这个文件中。

格式基于 [Keep a Changelog](https://keepachangelog.com/zh-CN/1.0.0/)，
版本号遵循 [Semantic Versioning](https://semver.org/lang/zh-CN/)。

## [Unreleased]

### Added
- Exa AI 搜索集成配置
- 更完善的 settings.example.json（包含 Opus 快速模式、实验性功能、LSP 插件）
- Settings 配置详细说明文档

### Changed
- 更新 settings.example.json 为实际使用的配置
- 更新 README 添加特色配置说明

## [1.0.0] - 2026-04-20

### Added
- 初始化仓库结构
- 添加 project-analyzer skill v1.0.0
- 添加安装、更新、卸载脚本
- **project-analyzer skill**: 项目分析工具
  - 使用 Haiku 子代理并行分析
  - 自动生成中文技术文档
  - 支持 Mermaid 图表
  - 质量检查和自动修复
  - 支持 Node.js、Python、Go、Java、Rust 项目
  - 分析完成后自动调用 `/init`
- 安装脚本 (`scripts/install.sh`)
- 更新脚本 (`scripts/update.sh`)
- 卸载脚本 (`scripts/uninstall.sh`)
- 项目文档和 README
