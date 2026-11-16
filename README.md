# Triplines

记录旅行轨迹的 iOS App：航班、火车、自驾等行程画在地球仪或地图上，并点亮去过的地方。

当前是第一阶段：手动添加行程、地球仪/地图切换、到访城市点亮、统计页。

## 目录

- `Triplines/`：Swift 源码（SwiftUI + MapKit + SwiftData，最低 iOS 17）
- `project.yml`：XcodeGen 配置，云端据此生成 Xcode 工程
- `.github/workflows/build.yml`：GitHub Actions 自动编译配置

## 在 Windows 上看效果（不需要开发者账号）

### 1. 推送到 GitHub

1. 在 GitHub 新建一个空仓库（建议先设为 Public，Mac 编译机时长不计费），不要勾选添加 README。
2. 在本文件夹打开终端，执行：

```
git init
git add .
git commit -m "first commit"
git branch -M main
git remote add origin https://github.com/<你的用户名>/<仓库名>.git
git push -u origin main
```

### 2. 下载安装包

1. 打开仓库页面的 Actions 标签，等 "Build iOS" 运行结束（约 5–10 分钟）。
2. 成功：进入这次运行，在页面底部 Artifacts 下载 `Triplines-unsigned-ipa`，解压得到 `Triplines-unsigned.ipa`。
3. 失败：下载 `build-log`，把其中带 `error:` 的行发给 Claude 修复。

### 3. 装到 iPhone

1. 在 Windows 上安装 iTunes（苹果官网版）和 Sideloadly。
2. iPhone 用数据线连接电脑，并点"信任此电脑"。
3. 打开 Sideloadly，把 ipa 拖进去，填入 Apple ID（建议用备用账号），点 Start。
4. iPhone 上：设置 → 通用 → VPN 与设备管理，信任该 Apple ID；设置 → 隐私与安全性 → 打开"开发者模式"（会重启一次）。
5. 打开 Triplines，点"载入示例行程"即可看到效果。

免费 Apple ID 签名的 App 7 天后失效，届时用 Sideloadly 重装一次即可。
