
---

Termux-zh AI 生成必知要求

1️⃣ 中文命令核心原则

1. 中文动词优先，语义清晰


2. 每个命令只做一件事（单一职责）


3. 不覆盖、不劫持英文命令，保证原系统脚本正常执行


4. 不使用 alias，保证可卸载性


5. 所有增强都是“附加层”，不替代系统层




---

2️⃣ bin 脚本要求

1. 脚本必须以 #!/#!/usr/bin/env bash开头


2. 保留开头颜色变量（GREEN/YELLOW/RED/RESET）


3. 最后一行必须是实际执行命令，方便中英对照生成脚本自动适配


4. 帮助信息（-h/--help）必须单独存在，并描述命令专用示例，示例与最后执行命令匹配


5. 自动化脚本生成命令列表时只抓最后一行，不抓颜色变量、echo/read 或控制结构


6. 支持中文命令全局执行，不依赖特定目录（放在 ~/bin 并在 PATH 优先）

7.bin/ 下所有 bash 脚本必须使用
#!/usr/bin/env bash


---

3️⃣ 状态型命令要求（shell function）

1. 对 shell 状态有影响（如 cd / 返回 / 前台 / 后台 / 退出 / 重载配置）


2. 必须写在 shell/functions.sh 中


3. 安装后通过 source 加载到 shell，保证全局可用


4. 自动生成中英对照表和 COMMANDS.md 时单独列出




---

4️⃣ 自动化文档要求

1. 中英对照表

扫描 bin/ 和 shell/functions.sh

bin/ 取最后一行执行命令，去掉 exec 前缀

shell function 统一标注 “shell function / builtin”

输出 mapping.txt 干净、可直接用于 README



2. 命令列表文档

扫描 bin/ 和 shell/functions.sh

输出 COMMANDS.md

避免重复、空行、注释或颜色信息污染



3. 自动化脚本

自动生成commands.sh → 生成 COMMANDS.md

自动生成中英对照表.sh → 生成 mapping.txt

可重复执行，确保文档与代码一致





---

5️⃣ 帮助信息要求

1. 每个 bin 脚本必须有自己的专属帮助信息


2. 帮助信息中显示命令名和专属用法示例


3. 示例参数与最后执行命令匹配，避免使用通用“文件A 文件B”


4. 可通过一键脚本批量更新所有 bin 脚本帮助




---

6️⃣ 安装/卸载要求

1. 安装脚本 install.sh：

自动将 bin/ 添加到 PATH

source shell/functions.sh

中文命令立即全局可用



2. 卸载脚本 uninstall.sh：

删除 bin/ 中中文命令

移除 shell/functions.sh 加载

清理 .bashrc 中的配置

不影响原有英文命令或脚本





---

7️⃣ 其他维护要求

1. 所有增强命令尽量保持 通用、可扩展、可自定义


2. 新增命令后，必须更新 HELP_MAP（帮助信息）和 mapping.txt


3. 所有脚本和文档保持一致，避免文档滞后或信息冲突


4. 支持后续第三方工具或包管理扩展




---

8⃣️ 中文错误信息（bin-error）体系规范（新增）

1. 总体原则

错误中文化是附加层，不影响原命令行为

只对中文命令生效，英文命令永远保持原样

错误解释 ≠ 错误替换 

原始 stderr 必须完整输出

中文解释作为补充信息追加显示

不修改系统命令，不包装 / 替换系统二进制

不引入性能副作用（仅在出错时解析）

2. bin-error 目录规范

项目根目录下必须存在 bin-error/

一个英文命令对应一个脚本 

例如：rm.sh、mv.sh、grep.sh

命名规则： 英文主命令名.sh 

bin-error 中的脚本只负责： 

调用真实命令

捕获 stderr

解释常见错误

bin-error 本身不直接加入 PATH

3. bin-error 脚本行为规范

必须使用：

BIN="$(command -v <cmd>)" 

禁止写死路径

必须捕获错误：

ERR="$("$BIN" "$@" 2>&1)" CODE=$? 

成功时不做任何多余输出

[ $CODE -eq 0 ] && exit 0 

出错时：

原始错误完整输出到 stderr

再输出中文解释

错误映射使用统一结构：

ERROR_MAP=( "英文错误特征|中文简述|处理建议" ) 

只解释高频、稳定、可判断的错误

不追求穷举

不做模糊猜测

4. bin → bin-error 注入规则

只修改中文命令

只修改最后一个有效 exec 行

注入形式必须为： exec "$(dirname "$0")/../bin-error/<cmd>.sh" "$@" 

禁止写死绝对路径

必须跳过以下特殊命令： 

查命令

帮助

仅当 bin-error 中存在对应脚本时才注入

注入脚本必须支持： 

重复执行

幂等（多次运行不产生副作用）

5. bin-error 覆盖范围要求

bin-error 中的脚本 必须是 bin 中真实存在的命令

不允许“只写 error 脚本但 bin 中无对应中文命令”

必须提供机制检测： 

bin-error 中未被任何 bin 使用的多余脚本

多余脚本： 

只提示

不自动删除

6. 文档与自动化一致性（bin-error 相关）

mapping.txt 是 bin-error 注入的唯一依据

自动化脚本不得： 

猜命令

模糊匹配

硬编码中文名

bin-error 属于运行期增强： 

不参与 COMMANDS.md 的“命令定义”

但可在 README 中说明“支持中文错误提示”

7. 设计边界（明确禁止）

❌ 不做“全局错误拦截器”

❌ 不 hook bash / sh / exec

❌ 不解析 $? 以外的隐式状态

❌ 不试图 100% 翻译所有错误

❌ 不破坏脚本最后一行“真实执行命令”的规范
9⃣️必须适配大部分linux环境