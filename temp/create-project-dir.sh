#!/bin/bash

# 跨平台项目目录结构创建脚本
# 支持 macOS, Linux, Windows (Git Bash/WSL)
# 使用方法: bash create-project-dir.sh 或 curl -sSL <url> | bash

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 检测操作系统
detect_os() {
    case "$(uname -s)" in
        Darwin*)
            echo "macOS"
            ;;
        Linux*)
            echo "Linux"
            ;;
        CYGWIN*|MINGW*|MSYS*)
            echo "Windows"
            ;;
        *)
            echo "Unknown"
            ;;
    esac
}

# 打印带颜色的消息
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 打印欢迎信息
print_welcome() {
    echo ""
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}   项目目录结构自动创建工具${NC}"
    echo -e "${GREEN}========================================${NC}"
    echo ""
}

# 获取用户输入
get_project_name() {
    local project_name=""
    
    while true; do
        echo -e "${YELLOW}请输入项目名称 (将替换 xxx):${NC}" >&2
        read -p "> " project_name
        
        # 去除首尾空格
        project_name=$(echo "$project_name" | xargs)
        
        # 验证输入
        if [ -z "$project_name" ]; then
            print_error "项目名称不能为空，请重新输入"
            continue
        fi
        
        # 验证是否包含非法字符
        if [[ ! "$project_name" =~ ^[a-zA-Z0-9_-]+$ ]]; then
            print_error "项目名称只能包含字母、数字、下划线和连字符，请重新输入"
            continue
        fi
        
        break
    done
    
    echo "$project_name"
}

# 创建目录结构
create_directory_structure() {
    local project_name=$1
    local base_dir="project_${project_name}"
    
    print_info "开始创建目录结构..."
    
    # 检查目录是否已存在
    if [ -d "$base_dir" ]; then
        print_warning "目录 '$base_dir' 已存在"
        echo -e "${YELLOW}是否要删除并重新创建? (y/N):${NC}" >&2
        read -p "> " confirm
        
        if [[ "$confirm" =~ ^[Yy]$ ]]; then
            print_info "删除现有目录..."
            rm -rf "$base_dir"
        else
            print_error "操作已取消"
            exit 1
        fi
    fi
    
    # 创建主目录
    mkdir -p "$base_dir"
    
    # 创建子目录
    mkdir -p "$base_dir/.luban"
    mkdir -p "$base_dir/gil_${project_name}_api/docs/ai-generates"
    mkdir -p "$base_dir/gil_${project_name}_fe/docs/ai-generates"
    mkdir -p "$base_dir/gil_api_test/docs/ai-generates"
    
    # 创建 README 文件
    create_readme_files "$base_dir" "$project_name"
    
    print_success "目录结构创建成功！"
}

# 创建 README 文件
create_readme_files() {
    local base_dir=$1
    local project_name=$2
    
    # 主 README
    cat > "$base_dir/README.md" << EOF
# Project ${project_name}

项目创建时间: $(date '+%Y-%m-%d %H:%M:%S')
操作系统: $(detect_os)

## 目录结构

\`\`\`
project_${project_name}/
├── .luban/                      # Luban 配置目录
├── gil_${project_name}_api/    # 后端 API 目录
│   └── docs/                    # API 文档目录
│       └── ai-generates/        # AI 生成的文档
├── gil_${project_name}_fe/     # 前端项目目录
│   └── docs/                    # 前端文档目录
│       └── ai-generates/        # AI 生成的文档
└── gil_api_test/                # API 测试目录
    └── docs/                    # 测试文档目录
        └── ai-generates/        # AI 生成的文档
\`\`\`

## 说明

- **.luban/**: 存放 Luban 相关配置文件
- **gil_${project_name}_api/**: 后端 API 服务代码
  - **docs/**: API 相关文档
  - **docs/ai-generates/**: AI 自动生成的文档和代码
- **gil_${project_name}_fe/**: 前端应用代码
  - **docs/**: 前端相关文档
  - **docs/ai-generates/**: AI 自动生成的文档和代码
- **gil_api_test/**: API 自动化测试代码
  - **docs/**: 测试相关文档
  - **docs/ai-generates/**: AI 自动生成的测试文档

EOF

    # 各子目录的 README
    echo "# Luban 配置目录" > "$base_dir/.luban/README.md"
    
    # API 目录 README
    cat > "$base_dir/gil_${project_name}_api/README.md" << EOF
# ${project_name} API 服务

## 目录说明

- **docs/**: API 相关文档
- **docs/ai-generates/**: AI 自动生成的文档和代码

EOF

    # 前端目录 README
    cat > "$base_dir/gil_${project_name}_fe/README.md" << EOF
# ${project_name} 前端应用

## 目录说明

- **docs/**: 前端相关文档
- **docs/ai-generates/**: AI 自动生成的文档和代码

EOF

    # 测试目录 README
    cat > "$base_dir/gil_api_test/README.md" << EOF
# API 测试

## 目录说明

- **docs/**: 测试相关文档
- **docs/ai-generates/**: AI 自动生成的测试文档

EOF

    # docs 目录的 README
    echo "# API 文档" > "$base_dir/gil_${project_name}_api/docs/README.md"
    echo "# 前端文档" > "$base_dir/gil_${project_name}_fe/docs/README.md"
    echo "# 测试文档" > "$base_dir/gil_api_test/docs/README.md"
    
    # ai-generates 目录的 README
    echo "# AI 生成的文档和代码" > "$base_dir/gil_${project_name}_api/docs/ai-generates/README.md"
    echo "# AI 生成的文档和代码" > "$base_dir/gil_${project_name}_fe/docs/ai-generates/README.md"
    echo "# AI 生成的测试文档" > "$base_dir/gil_api_test/docs/ai-generates/README.md"
}

# 显示目录树
show_directory_tree() {
    local base_dir=$1
    local project_name=$2
    
    echo ""
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}   创建完成！${NC}"
    echo -e "${GREEN}========================================${NC}"
    echo ""
    
    print_info "项目名称: ${project_name}"
    print_info "操作系统: $(detect_os)"
    print_info "项目路径: $(cd "$base_dir" && pwd)"
    
    echo ""
    echo -e "${BLUE}目录结构:${NC}"
    echo ""
    
    # 使用 tree 命令（如果可用）或手动显示
    if command -v tree &> /dev/null; then
        tree -L 3 "$base_dir"
    else
        echo "project_${project_name}/"
        echo "├── .luban/"
        echo "│   └── README.md"
        echo "├── gil_${project_name}_api/"
        echo "│   ├── README.md"
        echo "│   └── docs/"
        echo "│       ├── README.md"
        echo "│       └── ai-generates/"
        echo "│           └── README.md"
        echo "├── gil_${project_name}_fe/"
        echo "│   ├── README.md"
        echo "│   └── docs/"
        echo "│       ├── README.md"
        echo "│       └── ai-generates/"
        echo "│           └── README.md"
        echo "├── gil_api_test/"
        echo "│   ├── README.md"
        echo "│   └── docs/"
        echo "│       ├── README.md"
        echo "│       └── ai-generates/"
        echo "│           └── README.md"
        echo "└── README.md"
    fi
    
    echo ""
    print_success "所有目录和文件已创建完成！"
    echo ""
    print_info "下一步操作:"
    echo "  1. cd project_${project_name}"
    echo "  2. 开始开发你的项目"
    echo ""
}

# 主函数
main() {
    print_welcome
    
    # 检测操作系统
    local os_type=$(detect_os)
    print_info "检测到操作系统: $os_type"
    echo ""
    
    # 获取项目名称
    local project_name=$(get_project_name)
    echo ""
    
    # 确认信息
    print_info "即将创建项目: project_${project_name}"
    echo -e "${YELLOW}确认创建? (Y/n):${NC}" >&2
    read -p "> " confirm
    
    if [[ "$confirm" =~ ^[Nn]$ ]]; then
        print_error "操作已取消"
        exit 0
    fi
    
    echo ""
    
    # 创建目录结构
    create_directory_structure "$project_name"
    
    # 显示结果
    show_directory_tree "project_${project_name}" "$project_name"
}

# 运行主函数
main
